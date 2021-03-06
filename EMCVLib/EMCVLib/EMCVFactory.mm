//
//  EMCVFactory.m
//  EMCVLib
//
//  Created by 郑宇琦 on 2017/4/11.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

#import "EMCVFactory.h"
#import "Static.h"

@implementation EMCVFactory

+ (double)compareHistWithImage:(EMCVBasicImage *)imgA andImage:(EMCVBasicImage *)imgB withMethod:(int)method {
    return compareHist(imgA->_hist, imgB->_hist, method);
}

+ (EMCVBasicImage *)matchTemplateWithImage:(EMCVBasicImage *)img andTempl:(EMCVBasicImage *)templ withMethod:(int)method {
    int cols = img->_mat.cols - templ->_mat.cols + 1;
    int rows = img->_mat.rows - templ->_mat.rows + 1;
    Mat matchResult;
    matchResult.create(cols, rows, CV_32FC1);
    matchTemplate(img->_mat, templ->_mat, matchResult, method);
//    normalize(matchResult, matchResult, 0, 1, NORM_MINMAX, -1, Mat());
    EMCVBasicImage * ret = [[EMCVBasicImage alloc] init];
    matchResult.convertTo(ret->_mat, CV_8U, 255);
    return ret;
}


+ (EMCVBasicImage *)doBackProjectionWithImage:(EMCVBasicImage *)img andTempl:(EMCVBasicImage *)templ {
    int dims = (int)img.channalCount;
    return [self doBackProjectionWithImage:img andTempl:templ withDims:dims];
}

+ (EMCVBasicImage *)doBackProjectionWithImage:(EMCVBasicImage *)img andTempl:(EMCVBasicImage *)templ withDims:(int)dims {
    return [self doBackProjectionWithImage:img andTempl:templ atChannals:kEMCVLibChannalDefault andDims:dims andRanges:kEMCVLibRangesDefault];
}

+ (EMCVBasicImage *)doBackProjectionWithImage:(EMCVBasicImage *)img andTempl:(EMCVBasicImage *)templ atChannals:(int *)channals andDims:(int)dims andRanges:(float **)ranges {
    EMCVBasicImage * backProj = [[EMCVImage alloc] init];
    calcBackProject(&(img->_mat), dims, channals, templ->_hist, backProj->_mat, (const float **)ranges);
    return backProj;
}

+ (EMCVBasicImage *)blendingImage:(EMCVBasicImage *)imgA withImage:(EMCVBasicImage *)imgB useAlpha1:(double)a1 andAlpha2:(double)a2 andGama:(double)gamma {
    EMCVImage * img = [[EMCVImage alloc] init];
    addWeighted(imgA->_mat, a1, imgB->_mat, a2, gamma, img->_mat);
    return img;
}

+ (void)copyImage:(EMCVBasicImage *)src toImage:(EMCVBasicImage *)dst {
    Mat newMat;
    src->_mat.copyTo(newMat);
    dst->_mat = newMat;
}

// NSPoint -> NSValue, [[NSValue, NSValue], [NSValue, NSValue], ...]
+ (NSArray<NSArray<NSValue *> *> *)calOpticalFlowPyrLKWithImage:(EMCVSingleImage *)imgA andImage:(EMCVSingleImage *)imgB useMaxCorners:(int)maxCorners andQLevel:(double)q andMinDistance:(double)minDistance {
    vector<Point2f> cornersA = [imgA goodFeaturesToTrackInCppWithMaxCorners:maxCorners andQLevel:q andMinDistance:minDistance];
    vector<Point2f> cornersB = [imgB goodFeaturesToTrackInCppWithMaxCorners:maxCorners andQLevel:q andMinDistance:minDistance];
    vector<uchar> status;
    vector<float> err;
    calcOpticalFlowPyrLK(imgA->_mat, imgB->_mat, cornersA, cornersB, status, err);
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (int i = 0; i < status.size(); i++) {
        if (status.at(i) != 0 && err.at(i) <= 550) {
            NSPoint p1 = NSMakePoint(cornersA.at(i).x, cornersA.at(i).y);
            NSPoint p2 = NSMakePoint(cornersB.at(i).x, cornersB.at(i).y);
            NSValue * value1 = [NSValue valueWithPoint:p1];
            NSValue * value2 = [NSValue valueWithPoint:p2];
            [result addObject:@[value1, value2]];
        }
    }
    return result;
}

@end
