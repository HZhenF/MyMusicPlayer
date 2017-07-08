//
//  AssetModel.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/5.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "AssetModel.h"

@implementation AssetModel

+(AssetModel *)AssetModelWithURL:(NSURL *)url
{
    return [[self alloc] initAssetWithURL:url];
}


-(AssetModel *)initAssetWithURL:(NSURL *)url
{
        AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
        for (NSString *format in [mp3Asset availableMetadataFormats]) {
            for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
                if ([metadataItem.commonKey isEqual:@"artwork"]) {
                    //提取图片
                    self.image = [UIImage imageWithData:(NSData *)metadataItem.value];
                }
                else if ([metadataItem.commonKey isEqualToString:@"title"])
                {
                    //提取歌曲名
                    self.songName = (NSString *)metadataItem.value;
                }
                else if ([metadataItem.commonKey isEqualToString:@"artist"])
                {
                    //提取歌手
                    self.artist = (NSString *)metadataItem.value;
                }
                else if ([metadataItem.commonKey isEqualToString:@"albumName"])
                {
                    //提取专辑名称
                    self.albumName = (NSString *)metadataItem.value;
                }
            }
        }
    return self;
}

@end
