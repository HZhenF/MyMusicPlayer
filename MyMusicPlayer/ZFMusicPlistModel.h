//
//  ZFMusicPlistModel.h
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/7.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFMusicPlistModel : NSObject
/**歌曲名称*/
@property(nonatomic,strong) NSString *name;
/**歌词名称*/
@property(nonatomic,strong) NSString *lrcName;

/**
 初始化Plist文件

 @return 返回封装好的对象
 */
+(NSMutableArray *)ZFMusicPlistModel;

@end
