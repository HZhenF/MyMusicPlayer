//
//  MusicLrcModel.h
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLrcModel : NSObject
/**当前这句歌词*/
@property(nonatomic,strong) NSString *text;
/**当前这句歌词时间*/
@property(nonatomic,assign) NSTimeInterval time;

/**
 把每一句字符串歌词封装成对象
 
 @param lrcString 字符串歌词
 @return 封装好的对象 
 */
+(MusicLrcModel *)musciLrcModelWithLrcString:(NSString *)lrcString;
-(MusicLrcModel *)initWithLrcString:(NSString *)lrcString;

@end
