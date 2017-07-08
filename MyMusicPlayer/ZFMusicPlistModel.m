//
//  ZFMusicPlistModel.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/7.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFMusicPlistModel.h"

@implementation ZFMusicPlistModel

+(NSMutableArray *)ZFMusicPlistModel
{
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFMusic" ofType:@"plist"]];
    NSMutableArray *arrMAll = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        [arrMAll addObject:[ZFMusicPlistModel modelWithDict:dict]];
    }
    return arrMAll;
}

+(ZFMusicPlistModel *)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(ZFMusicPlistModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
