//
//  ZFMusicCell.h
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFLabel;

@interface ZFMusicCell : UITableViewCell

/**显示歌词的Label*/
@property(nonatomic,strong) ZFLabel *lrcLabel;

@end
