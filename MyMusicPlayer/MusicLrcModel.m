//
//  MusicLrcModel.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "MusicLrcModel.h"

@implementation MusicLrcModel

+(MusicLrcModel *)musciLrcModelWithLrcString:(NSString *)lrcString
{
    return [[self alloc] initWithLrcString:lrcString];
}

-(MusicLrcModel *)initWithLrcString:(NSString *)lrcString
{
    if (self = [super init]) {
        NSArray *lrcArray = [lrcString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        NSString *timeString = lrcArray[0];
        self.time = [self timeStringWithString:[timeString substringFromIndex:1]];
    }
    return self;
}

-(NSTimeInterval)timeStringWithString:(NSString *)timeString
{
    NSInteger minute = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger second = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger millisecond = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return (minute * 60 + second + millisecond * 0.01);
}

@end
