//
//  Static.h
//  EMCVLib
//
//  Created by 郑宇琦 on 2017/4/10.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

#import <Foundation/Foundation.h>

static int kEMCVLibColorWhite[] = {255, 255, 255};
static int kEMCVLibColorBlack[] = {0, 0, 0};
static int kEMCVLibColorRed[] = {255, 0, 0};
static int kEMCVLibColorGreen[] = {0, 255, 0};
static int kEMCVLibColorBlue[] = {0, 0, 255};

static float kEMCVLibRangeDefault[] = {0, 255};
static float * kEMCVLibRangesDefault[] = {kEMCVLibRangeDefault, kEMCVLibRangeDefault, kEMCVLibRangeDefault, kEMCVLibRangeDefault};

static int kEMCVLibChannalDefault[] = {0, 1, 2, 3};

static int kEMCVLibVideoWriterFormatMJPG = 1;
static int kEMCVLibVideoWriterFormatFLV1 = 2;
