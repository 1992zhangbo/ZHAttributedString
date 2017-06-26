//
//  ZHHitLabel.m
//  AutolayOutCell
//
//  Created by zhangbo on 15/11/24.
//  Copyright © 2015年 zhangbo. All rights reserved.
//  https://github.com/molon/MLLabel



#import "ZHHitLabel.h"
#import "ZHAttributedStringTool.h"
@interface ZHHitLabel ()
@property (nonatomic, strong) NSTextStorage * textStorge;
@property (nonatomic, strong) NSTextContainer * textContainer;
@property (nonatomic, strong) NSLayoutManager * layoutManager;


///记录原始字符串
@property (nonatomic, copy) NSAttributedString * lastAttributedString;

///存储所有自定义的属性 存储所有的自定义富文本
@property (nonatomic, strong) NSMutableArray * helpValueArray;
///当前选中的富文本模型类
@property (nonatomic, strong) ZHRichHelpModel * richModel;

@end

@implementation ZHHitLabel

#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self normalInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self normalInit];
    }
    return self;
}

- (void)normalInit
{
    //初始化TextKit属性
    [self.textStorge addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    self.userInteractionEnabled = YES;
    
    //label
    if ([super attributedText]) {
        self.attributedText = [super attributedText];
    }
    else
    {
        self.text = [super text];
    }
    
    [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"attributedText"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"attributedText"]) {
        
        //健壮性代码
        id old = change[NSKeyValueChangeOldKey];
        id new = change[NSKeyValueChangeNewKey];
        if ([old isEqual:new]||(!old&&!new)) {
            return;
        }
        
        self.lastAttributedString = self.attributedText;
        //废除视图原本内容的size
        [self.textStorge setAttributedString:self.attributedText];
        
        //重置TextKit属性 因为重新设置了字符串
        self.textContainer = nil;
        self.layoutManager = nil;
        [self.textStorge addLayoutManager:self.layoutManager];
        [self.layoutManager addTextContainer:self.textContainer];

    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}




#pragma mark - Setter
- (void)setLastAttributedString:(NSAttributedString *)lastAttributedString
{
    if (_lastAttributedString != lastAttributedString) {
        _lastAttributedString = lastAttributedString;
        [self getHelpValueArrayWithAttributedString:_lastAttributedString];
    }
}

#pragma mark - set 修改container size相关
- (void)resizeTextContainerSize
{
    if (_textContainer) {
        _textContainer.size = self.bounds.size;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeTextContainerSize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeTextContainerSize];
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    [self resizeTextContainerSize];
    [self invalidateIntrinsicContentSize];
}


#pragma mark - CustomMethod

///绘制背景颜色 根据触摸的状态 以及范围
- (void)drawBackgroundColorWithState:(BOOL)isEnd withRange:(NSRange)range
{
    NSMutableAttributedString * mutableStr = [self.lastAttributedString mutableCopy];
    if (!isEnd) {
        [mutableStr addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:239/255.0 green:253/255.0 blue:1 alpha:1] range:range];
    }
    else
    {
        [mutableStr removeAttribute:NSBackgroundColorAttributeName range:range];
    }
    
    self.attributedText = mutableStr;
    
}


///获取自定义属性数组
- (void)getHelpValueArrayWithAttributedString:(NSAttributedString *)string
{
    __weak typeof(self) weakSelf = self;
    [self.helpValueArray removeAllObjects];
    [string enumerateAttribute:RichKey inRange:NSMakeRange(0, _lastAttributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[ZHRichHelpModel class]]) {
            [weakSelf.helpValueArray addObject:value];
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point
          withEvent:(UIEvent *)event
{
    if (![self touchStrAtPoint:point] || !self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return [super hitTest:point withEvent:event];
    }
    
    return self;
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.richModel = [self touchStrAtPoint:touchPoint];
    if (!self.richModel) {
        [super touchesBegan:touches withEvent:event];
    }
    else
    {
        [self drawBackgroundColorWithState:NO withRange:self.richModel.valueRange];
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.richModel) {
        UITouch * touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        ZHRichHelpModel * moveRichModel = [self touchStrAtPoint:touchPoint];
        if (self.richModel != moveRichModel) {
            [self drawBackgroundColorWithState:YES withRange:self.richModel.valueRange];
            self.richModel = nil;
        }
    }
    else
    {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.richModel) {
        if (self.clickBlock) {
            self.clickBlock(self.richModel);
        }
        [self drawBackgroundColorWithState:YES withRange:self.richModel.valueRange];
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.richModel) {
        [self drawBackgroundColorWithState:YES withRange:self.richModel.valueRange];
        self.richModel = nil;
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - CGSize CGRect CGPoint
- (ZHRichHelpModel *)touchStrAtPoint:(CGPoint)location
{
    
    CGPoint textOffset;
    //在执行usedRectForTextContainer之前最好还是执行下glyphRangeForTextContainer relayout
    [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self textOffsetWithTextSize:[self.layoutManager usedRectForTextContainer:self.textContainer].size];
    
    //location转换成在textContainer的绘制区域的坐标
    location.x -= textOffset.x;
    location.y -= textOffset.y;
    
    
    //返回触摸区域的字形  如果location的区域没字形，可能返回的是最近的字形index，所以需要再找到这个字形所处于的rect来确认
    NSUInteger glyphIndex = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:self.textContainer];
    if (!CGRectContainsPoint(glyphRect, location)) {
        return nil;
    }
    
    for (ZHRichHelpModel * model in self.helpValueArray) {
        if (NSLocationInRange(glyphIndex, model.valueRange)) {
            return model;
        }
    }
    
    
//    NSAttributedString * dic = [self.lastAttributedString attributedSubstringFromRange:NSMakeRange(glyphIndex, 1)];
    return nil;
}

//这个计算出来的是绘制起点
- (CGPoint)textOffsetWithTextSize:(CGSize)textSize
{
    CGPoint textOffset = CGPointZero;
    //根据insets和默认垂直居中来计算出偏移
    textOffset.x = 0;
    CGFloat paddingHeight = (_textContainer.size.height - textSize.height) / 2.0f;
    textOffset.y = paddingHeight+ 0;
    
    return textOffset;
}


#pragma mark - Getter
- (NSMutableArray *)helpValueArray
{
    if (!_helpValueArray) {
        _helpValueArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _helpValueArray;
}
//NSTextStorage。主要用来存储文本的字符和相关属性，是NSMutableAttributedString的子类。此外，当NSTextStorage中的字符或属性发生改变时，会通知NSLayoutManager，进而做到文本内容的显示更新。
- (NSTextStorage *)textStorge
{
    if (!_textStorge) {
        _textStorge = [[NSTextStorage alloc] init];
    }
    return _textStorge;
}
//NSLayoutManager。该类负责对文字进行编辑排版处理，将存储在NSTextStorage中的数据转换为可以在视图控件中显示的文本内容，并把字符编码映射到对应的字形上，然后将字形排版到NSTextContainer定义的区域中。
- (NSLayoutManager *)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
        _layoutManager.allowsNonContiguousLayout = NO;
    }
    return _layoutManager;
}



//定义了文本可以排版的区域。默认情况下是矩形区域，如果是其他形状的区域，需要通过子类化NSTextContainer来创建。
- (NSTextContainer *)textContainer
{
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.lineFragmentPadding = 0.0f;
        _textContainer.size = self.frame.size;
    }
    return _textContainer;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
