//
//  ZHHitLabel.h
//  AutolayOutCell
//
//  Created by zhangbo on 15/11/24.
//  Copyright © 2015年 zhangbo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZHRichHelpModel.h"
typedef void(^HitLableTouchBlock)(ZHRichHelpModel * model);
@interface ZHHitLabel : UILabel

@property (nonatomic, copy) HitLableTouchBlock clickBlock;

@end
