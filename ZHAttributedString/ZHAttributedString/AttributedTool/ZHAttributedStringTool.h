//
//  ZHAttributedLabelTool.h
//  AutolayOutCell
//
//  Created by zhangbo on 15/11/20.
//  Copyright © 2015年 zhangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZHRichHelpModel.h"
///设置字体属性 字体样式 段落样式 并计算出最终大小
@interface ZHAttributedStringTool : NSObject


/// 基础字体（text）text必须设置   默认字体（font） 默认字体颜色（strColor）
- (id)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)strColor;



///根据range设置字体大小
- (void)addFont:(UIFont *)font range:(NSRange)range;
///根据range设置颜色
- (void)addColor:(UIColor *)color range:(NSRange)range;
///添加单删除线
- (void)addSingleStrikethroughWithColor:(UIColor * )color range:(NSRange)range;
///添加单下划线
- (void)addSingleUnderlineWithColor:(UIColor * )color range:(NSRange)range;
///设置字间距
- (void)addKerningWithSpace:(CGFloat)space;
///设置基线偏移值
- (void)addBaselineOffset:(CGFloat)offset range:(NSRange)range;
///设置凸版印刷体效果
- (void)addEffectLetterpressWithRange:(NSRange)range;
///在某个位置插入图片
- (void)addAttachmentWithImageName:(NSString *)imageName index:(NSInteger)index size:(CGSize)size;
///添加自定义属性，为自定义label（ZHHitLabel）提供服务
- (void)addRichHelpWithType:(ZHRichHelpType)type range:(NSRange)range color:(UIColor *)textColor;



///设置字体行间距
- (void)setLineSpacing:(CGFloat)lineSpacing;
///根据范围设置字体行间距
- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;
///设置换行方式
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode;
///设置首行缩进
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;
///文本对齐方式
- (void)setNSTextAlignment:(NSTextAlignment)alignment;
///段与段之间的间距
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing;



///获取最终大小 请在设置完所有样式之后调用次方法
- (CGSize)getSizeWithMaxWidth:(CGFloat)maxWidth;

///直接计算最终的结果
+ (CGSize)getSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth contentStr:(NSString *)contentStr;

///设置label的属性
- (void)setLabelPropertyWithLabel:(UILabel *)label;

///获取最终的字符串
- (NSAttributedString *)getResultString;

@end
