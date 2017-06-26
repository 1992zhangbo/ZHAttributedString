//
//  ZHAttributedLabelTool.m
//  AutolayOutCell
//
//  Created by zhangbo on 15/11/20.
//  Copyright © 2015年 zhangbo. All rights reserved.
//


#import "ZHAttributedStringTool.h"
@interface ZHAttributedStringTool ()
///文字段落样式
@property (nonatomic, strong) NSMutableParagraphStyle * desParagraphStyle;
///基础字符串
@property (nonatomic, strong) NSString * baseText;
///最终字符串
@property (nonatomic, copy) NSMutableAttributedString *attributedText;


@end



@implementation ZHAttributedStringTool

/// 基础字体（text）text必须设置   默认字体（font） 默认字体颜色（strColor）
- (id)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)strColor
{
    if (self = [super init]) {
        
        self.baseText = text;
        
        if (self.baseText.length == 0) {
            self.baseText = @"请设置字体";
        }
        
        UIFont * normalFont = font;
        //如果没有设置font 默认是17号字体
        if (!normalFont) {
            normalFont = [UIFont systemFontOfSize:17];
        }

        UIColor * normalColor = strColor;
        //默认颜色
        if (!normalColor) {
            normalColor = [UIColor blackColor];
        }
        

        [self addFont:normalFont range:NSMakeRange(0, self.baseText.length)];
        [self addColor:normalColor range:NSMakeRange(0, self.baseText.length)];
    }
    return self;
}

#pragma mrak - NSMutableAttributedString

///根据range设置颜色
- (void)addColor:(UIColor *)color range:(NSRange)range
{
    if (range.length > self.attributedText.length) {
        return;
    }
    [self.attributedText addAttribute:NSForegroundColorAttributeName value:color range:range];
}

///添加自定义属性，为自定义label（ZHHitLabel）提供服务
- (void)addRichHelpWithType:(ZHRichHelpType)type range:(NSRange)range color:(UIColor *)textColor
{
    if (range.length > self.attributedText.length) {
        return;
    }
    if (textColor) {
        [self addColor:textColor range:range];
    }
    
    
    ZHRichHelpModel * model = [[ZHRichHelpModel alloc] init];
    model.richHelpType = type;
    model.valueRange = range;
    model.valueStr = [self.attributedText.string substringWithRange:range];
    [self.attributedText addAttribute:RichKey value:model range:range];
    
}

///根据range设置字体大小
- (void)addFont:(UIFont*)font range:(NSRange)range
{
    if (range.length > self.attributedText.length || !font) {
        return;
    }
    [self.attributedText addAttribute:NSFontAttributeName value:font range:range];
}


///设置字间距
- (void)addKerningWithSpace:(CGFloat)space
{
    [self.attributedText addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:space] range:NSMakeRange(0, 10)];
    
}

///添加单删除线
- (void)addSingleStrikethroughWithColor:(UIColor * )color range:(NSRange)range
{
    [self.attributedText addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    if (color) {
        [self.attributedText addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    }
    
}

///添加单下划线
-(void)addSingleUnderlineWithColor:(UIColor * )color range:(NSRange)range
{
    [self.attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    if (color) {
        [self.attributedText addAttribute:NSUnderlineColorAttributeName value:color range:range];
    }
}

///设置基线偏移值
- (void)addBaselineOffset:(CGFloat)offset range:(NSRange)range
{
    [self.attributedText addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:offset] range:range];
}

///设置凸版印刷体效果
- (void)addEffectLetterpressWithRange:(NSRange)range
{
    [self.attributedText addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:range];
}

///在某个位置插入图片
- (void)addAttachmentWithImageName:(NSString *)imageName index:(NSInteger)index size:(CGSize)size
{
    UIImage * image = [UIImage imageNamed:imageName];
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        attachment.bounds = CGRectMake(0, 0, 20, 20);
    }
    else
    {
        attachment.bounds = CGRectMake(0, 0, size.width, size.height);
    }
    NSAttributedString * attibutedString = [NSAttributedString attributedStringWithAttachment:attachment];
    [self.attributedText insertAttributedString:attibutedString atIndex:index];
}



///获取最终字符串
- (NSAttributedString *)attributedText
{
    if (_attributedText.length > 0) {
        return _attributedText;
    }
    _attributedText = [[NSMutableAttributedString alloc] initWithString:self.baseText];
    return _attributedText;
}


#pragma mark - NSMutableParagraphStyle

///设置字体行间距
- (void)setLineSpacing:(CGFloat)lineSpacing
{
    self.desParagraphStyle.lineSpacing = lineSpacing;
    
}

///根据范围设置字体行间距
- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [self.attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

///设置换行方式
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    self.desParagraphStyle.lineBreakMode = lineBreakMode;
}

///设置首行缩进
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent
{
    self.desParagraphStyle.firstLineHeadIndent = firstLineHeadIndent;
}
//文本对齐方式
- (void)setNSTextAlignment:(NSTextAlignment)alignment
{
    self.desParagraphStyle.alignment = alignment;
}
//段与段之间的间距
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing
{
    self.desParagraphStyle.paragraphSpacing = paragraphSpacing;
}





///返回字体段落样式
- (NSMutableParagraphStyle *)desParagraphStyle
{
    if (_desParagraphStyle) {
        return _desParagraphStyle;
    }
    
    _desParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    //把字体样式添加到可变字符串中
     [self.attributedText addAttribute:NSParagraphStyleAttributeName value:_desParagraphStyle range:NSMakeRange(0, [self.attributedText length])];
    return _desParagraphStyle;
}

#pragma mark - CGSize
///获取最终大小
- (CGSize)getSizeWithMaxWidth:(CGFloat)maxWidth
{
    CGRect rect = [self.attributedText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    //容错误差 可去掉
    rect.size.height += 0.5;
    return rect.size;
}

/**
 *  直接计算最终的结果
 *
 *  @param font       文字大小
 *  @param maxWidth   最大宽度
 *  @param contentStr 当前的str
 *
 *  @return 返回尺寸
 */
+ (CGSize)getSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth contentStr:(NSString *)contentStr
{
    if (contentStr.length == 0) {
        return CGSizeZero;
    }
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attributedStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contentStr.length)];
    
    CGRect rect = [attributedStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    rect.size.height += 0.5;
    return rect.size;
}




#pragma mark - UI
///设置label的属性
- (void)setLabelPropertyWithLabel:(UILabel *)label
{
    label.attributedText = self.attributedText;
    
}
/**
 *  获取最终的字符串
 *
 */
- (NSAttributedString *)getResultString
{
    return self.attributedText;
}







@end
