//
//  ZFLabel.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFLabel.h"

@implementation ZFLabel

-(void)setPropress:(CGFloat)propress
{
    _propress = propress;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //1.获取需要画的区域
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.propress, self.bounds.size.height);
    
    //2.设置颜色
    [[UIColor colorWithRed:241/255.0 green:158/255.0 blue:194/255.0 alpha:1.0f] set];
    
    //3.添加区域
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
