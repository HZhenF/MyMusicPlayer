//
//  MusicLrcScrollView.h
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFLabel;

@interface MusicLrcScrollView : UIScrollView
/**歌词名称*/
@property(nonatomic,strong) NSString *lrcName;
/**歌曲的总时长*/
//@property(nonatomic,assign) NSTimeInterval duration;
/**当前播放的时间*/
@property(nonatomic,assign) NSTimeInterval currentTime;
/**外面歌词Label*/
@property(nonatomic,weak) ZFLabel *lrcLabel;

@end
