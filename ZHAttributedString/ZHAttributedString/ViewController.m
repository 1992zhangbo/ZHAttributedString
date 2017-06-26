//
//  ViewController.m
//  ZHAttributedString
//
//  Created by 张博 on 17/3/24.
//  Copyright © 2017年 zhangbo. All rights reserved.
//

#import "ViewController.h"
#import "ZHRichText.h"
@interface ViewController ()

///只用于文案的展示
@property (nonatomic, strong) UILabel * showLabel;

///拥有点击事件的label
@property (nonatomic, strong) ZHHitLabel * touchLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    //具有点击事件的label
    self.touchLabel = [[ZHHitLabel alloc]initWithFrame:CGRectMake(10, 50, screenWidth - 20, 80)];
    self.touchLabel.numberOfLines = 0;
    [self.view addSubview:self.touchLabel];
    
    //请点击文案"强调情节"。。。
    self.touchLabel.clickBlock = ^(ZHRichHelpModel * model)
    {
        NSLog(@"label点击事件，目标文案：%@, 目标范围：%@",model.valueStr,NSStringFromRange(model.valueRange));
    };
    
    //默认展示的label
    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, screenWidth - 20, 60)];
    self.showLabel.numberOfLines = 0;
    [self.view addSubview:self.showLabel];
    
    //展示的文案
    NSString * content = @"故事：文学体裁的一种，侧重于事件发展过程的描述。\n强调情节的生动性和连贯性，较适于口头讲述。已经发生事。或者想象故事。故事一般都和原始人类的生产生活有密切关系，他们迫切地希望认识自然，于是便以自身为依据，想象天地万物都和人一样，有着生命和意志。";
    
    //工具类创建
    ZHAttributedStringTool * attributedTool = [[ZHAttributedStringTool alloc] initWithText:content font:[UIFont systemFontOfSize:16] color:[self colorWithHexString:@"333333" alpha:1]];
    
    //设置文字属性
    //设置字体大小
    [attributedTool addFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, 2)];
    //设置文字颜色
    [attributedTool addColor:[self colorWithHexString:@"AC2F2F" alpha:1] range:NSMakeRange(3, 4)];
    //设置删除线
    [attributedTool addSingleStrikethroughWithColor:[self colorWithHexString:@"666666" alpha:1] range:NSMakeRange(11, 12)];
    //设置行间距
    [attributedTool setLineSpacing:6];
    [attributedTool setParagraphSpacing:14];
    //设置基线偏移
    [attributedTool addBaselineOffset:4 range:NSMakeRange(0, 1)];
    //插入图片
    [attributedTool addAttachmentWithImageName:@"icon" index:3 size:CGSizeMake(40, 40)];
    [attributedTool addAttachmentWithImageName:@"icon" index:3 size:CGSizeMake(15, 15)];

    /** 设置点击事件 只有ZHHitLabel可以点击 **/
    [attributedTool addRichHelpWithType:ZHRichHelpTypeClick range:NSMakeRange(39, 10) color:[self colorWithHexString:@"F41C1C" alpha:1]];
    
    //赋值到label
    [attributedTool setLabelPropertyWithLabel:self.showLabel];
    [attributedTool setLabelPropertyWithLabel:self.touchLabel];
    
    //计算size
    CGSize contentSize = [attributedTool getSizeWithMaxWidth:screenWidth - 20];
    
    //重新设置坐标
    [self setView:self.touchLabel Y:50 height:contentSize.height];
    [self setView:self.showLabel Y:CGRectGetMaxY(self.touchLabel.frame) + 40 height:contentSize.height];
    
}



///无关代码，请忽略
- (void)setView:(UIView *)view Y:(CGFloat)Y height:(CGFloat)height
{
    view.frame = CGRectMake(view.frame.origin.x, Y, view.frame.size.width, height);
}


///无关代码，请忽略
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
