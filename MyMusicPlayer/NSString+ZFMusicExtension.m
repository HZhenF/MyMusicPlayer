//
//  NSString+ZFMusicExtension.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/5.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "NSString+ZFMusicExtension.h"

@implementation NSString (ZFMusicExtension)

+(NSString *)stringFromNSTimeInteval:(NSTimeInterval)time
{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}

@end
