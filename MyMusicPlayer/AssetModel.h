//
//  AssetModel.h
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/5.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AssetModel : NSObject

/**图片*/
@property(nonatomic,strong) UIImage *image;
/**歌曲名*/
@property(nonatomic,strong) NSString *songName;
/**歌手*/
@property(nonatomic,strong) NSString *artist;
/**专辑名称*/
@property(nonatomic,strong) NSString *albumName;


/**
 初始化歌曲的信息,包括歌曲的图片、歌曲名、歌手、专辑名称信息

 @param url 歌曲的url路径
 @return 初始化好的对象
 */
+(AssetModel *)AssetModelWithURL:(NSURL *)url;
-(AssetModel *)initAssetWithURL:(NSURL *)url;

@end
