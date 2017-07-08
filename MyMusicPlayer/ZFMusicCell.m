//
//  ZFMusicCell.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFMusicCell.h"
#import "ZFLabel.h"

#define lrcLabelFont [UIFont systemFontOfSize:14.0]

@implementation ZFMusicCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.lrcLabel = [[ZFLabel alloc] init];
        self.lrcLabel.font = lrcLabelFont;
        self.lrcLabel.textAlignment = NSTextAlignmentCenter;
        self.lrcLabel.backgroundColor = [UIColor clearColor];
        self.lrcLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.lrcLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect cellFrame = self.frame;
    self.lrcLabel.frame = CGRectMake((ScreenW - (ScreenW - 50)) *0.5,(cellFrame.size.height - 30) * 0.5, ScreenW - 50, 30);

}


@end
