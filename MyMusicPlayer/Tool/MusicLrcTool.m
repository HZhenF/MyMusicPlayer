//
//  MusicLrcTool.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "MusicLrcTool.h"
#import "MusicLrcModel.h"

@implementation MusicLrcTool

+(NSMutableArray *)lrcWithName:(NSString *)lrcName
{
    //1.歌词文件路径
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:lrcName ofType:@"lrc"];
    //2.读取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    //3.拿到歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    //4.遍历
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcStr in lrcArray) {
        //过滤
        if ([lrcStr hasPrefix:@"[ti:"] || [lrcStr hasPrefix:@"[ar:"] || [lrcStr hasPrefix:@"[al:"] || ![lrcStr hasPrefix:@"["] || [lrcStr hasPrefix:@"[by:"] || [lrcStr hasPrefix:@"[offset:"]) {
            continue;
        }
        MusicLrcModel *lrcModel = [MusicLrcModel musciLrcModelWithLrcString:lrcStr];
        [tempArray addObject:lrcModel];
    }
    return tempArray;
}

@end
