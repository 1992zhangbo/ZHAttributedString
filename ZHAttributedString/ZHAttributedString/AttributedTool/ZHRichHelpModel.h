//
//  ZHHelpValue.h
//  AutolayOutCell
//
//  Created by zhangbo on 15/11/25.
//  Copyright © 2015年 zhangbo. All rights reserved.
//


#define RichKey @"richTextKey"


#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZHRichHelpTypeNone  = 0,  //啥事不干
    ZHRichHelpTypeLink  = 1,  //链接
    ZHRichHelpTypePhone = 2,  //电话号码
    ZHRichHelpTypeClick = 3,  //点击事件
} ZHRichHelpType;

@interface ZHRichHelpModel : NSObject
///记录目标类型
@property (nonatomic, assign) ZHRichHelpType richHelpType;
///记录目标字符串
@property (nonatomic, strong) NSString * valueStr;
///记录目标范围
@property (nonatomic, assign) NSRange valueRange;
@end
