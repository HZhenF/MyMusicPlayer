//
//  ViewController.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/5.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ViewController.h"
#import "AssetModel.h"
#import "NSString+ZFMusicExtension.h"
#import "CALayer+PauseAimate.h"
#import "MusicLrcScrollView.h"
#import "ZFLabel.h"
#import "ZFMusicPlistModel.h"

#define lrcLabelFont [UIFont systemFontOfSize:16.0]

@interface ViewController ()<AVAudioPlayerDelegate,UIScrollViewDelegate>

/**保存所有歌曲的数组*/
@property(nonatomic,strong)NSMutableArray *allSongsArrM;
/**加载Plist文件的对象，并把对象存在该数组*/
@property(nonatomic,strong) NSMutableArray *plistSongM;
/**背景图片*/
@property(nonatomic,strong) UIImageView *backgroundImgView;
/**音乐播放器*/
@property(nonatomic,strong) AVAudioPlayer *ZFPlayer;
/**进度条控制UISlider*/
@property(nonatomic,strong) UISlider *ZFSlider;
/**左边时间显示*/
@property(nonatomic,strong) UILabel *leftTime;
/**右边时间显示*/
@property(nonatomic,strong) UILabel *rightTime;
/**播放按钮*/
@property(nonatomic,strong) UIButton *startBtn;
/**时间进度计时器*/
@property(nonatomic,strong) NSTimer *ZFTimer;
/**歌词更新定时器*/
@property(nonatomic,strong) CADisplayLink *ZFlrcTimer;
/**中央旋转图*/
@property(nonatomic,strong) UIImageView *singerImgView;
/**歌曲名*/
@property(nonatomic,strong) UILabel *songName;
/**专辑名*/
@property(nonatomic,strong) UILabel *albumName;
/**歌词ScrollView*/
@property(nonatomic,strong) MusicLrcScrollView *lrcView;
/**当前歌词UILabel*/
@property(nonatomic,strong) ZFLabel *lrcLabel;
/**上一曲按钮*/
@property(nonatomic,strong) UIButton *lastSongBtn;
/**播放歌曲的索引*/
@property(nonatomic,assign) int index;


@end

@implementation ViewController

#pragma mark - 懒加载

-(NSMutableArray *)plistSongM
{
    if (!_plistSongM) {
        _plistSongM = [NSMutableArray array];
    }
    return _plistSongM;
}

-(CADisplayLink *)ZFlrcTimer
{
    if (!_ZFlrcTimer) {
        _ZFlrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
        [_ZFlrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _ZFlrcTimer;
}

-(MusicLrcScrollView *)lrcView
{
    if (!_lrcView) {
        _lrcView = [[MusicLrcScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.albumName.frame) + 10, ScreenW, CGRectGetMinY(self.ZFSlider.frame) - CGRectGetMaxY(self.albumName.frame))];
        _lrcView.showsHorizontalScrollIndicator = NO;
        _lrcView.contentSize = CGSizeMake(ScreenW * 2, 0);
        _lrcView.pagingEnabled = YES;
        _lrcView.delegate = self;
        [self.view addSubview:_lrcView];
    }
    return _lrcView;
}

-(NSMutableArray *)allSongsArrM
{
    if (!_allSongsArrM) {
        _allSongsArrM = [NSMutableArray array];
    }
    return _allSongsArrM;
}

-(NSTimer *)ZFTimer
{
    if (!_ZFTimer) {
        _ZFTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshControls) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.ZFTimer forMode:NSRunLoopCommonModes];
    }
    return _ZFTimer;
}

-(AVAudioPlayer *)ZFPlayer
{
    if (!_ZFPlayer) {
        //设置ZFPlayer
        NSURL *url = [NSURL fileURLWithPath:self.allSongsArrM[self.index]];
        NSError *error = nil;
        _ZFPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!error) {
            _ZFPlayer.volume = 3;
            _ZFPlayer.delegate = self;
            [_ZFPlayer prepareToPlay];
        }
        else
        {
            NSLog(@"error = %@",[error localizedDescription]);
        }
    }
    return _ZFPlayer;
}

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载MP3信息
    [self setupMP3Info];
    //初始化所有控件
    [self initAllControls];
    
    [self firstPlayMusic];
}


/**
 更改状态栏风格

 @return 状态栏
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 初始化信息

/**
 加载MP3信息
 */
-(void)setupMP3Info
{
    NSArray *mp3Array = [NSBundle pathsForResourcesOfType:@"mp3" inDirectory:[[NSBundle mainBundle] resourcePath]];
    for (NSString *filePath in mp3Array) {
        [self.allSongsArrM addObject:filePath];
    }
    self.plistSongM = [ZFMusicPlistModel ZFMusicPlistModel];
}


/**
 初始化所有控件
 */
-(void)initAllControls
{
    [self ZFPlayer];
    
    //获取MP3信息模型
    NSURL *url = [NSURL fileURLWithPath:self.allSongsArrM[self.index]];
    AssetModel *model = [AssetModel AssetModelWithURL:url];
    
    //设置backgroundImgView
    self.backgroundImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.backgroundImgView.image = model.image;
    [self.view addSubview:self.backgroundImgView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar setBarStyle:UIBarStyleBlack];
    [self.backgroundImgView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundImgView);
    }];
    
    //设置ZFSlider
    self.ZFSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300*ratioW, 44*ratioH)];
    self.ZFSlider.center = CGPointMake(ScreenW*0.5, ScreenH*0.85);
    [self.ZFSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    self.ZFSlider.minimumTrackTintColor = [UIColor colorWithRed:241/255.0 green:158/255.0 blue:194/255.0 alpha:1.0f];
    self.ZFSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.ZFSlider.value = 0;
    [self.ZFSlider addTarget:self action:@selector(ZFSliderAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.ZFSlider];
    
    
    double tempX = self.ZFSlider.center.y;
    //UILabel左边时间显示
    self.leftTime = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(self.ZFSlider.frame) - 50*ratioW)*0.5, CGRectGetMinY(self.ZFSlider.frame), 50*ratioW, 50*ratioW)];
    self.leftTime.text = @"00:00";
    self.leftTime.font = [UIFont systemFontOfSize:14.0];
    self.leftTime.textColor = [UIColor whiteColor];
    self.leftTime.textAlignment = NSTextAlignmentCenter;
    CGPoint leftCenter = CGPointMake(self.leftTime.center.x, tempX);
    self.leftTime.center = leftCenter;
    [self.view addSubview:self.leftTime];
    
    
    //UILabel右边时间显示
    self.rightTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ZFSlider.frame), CGRectGetMinY(self.ZFSlider.frame), 50*ratioW, 50*ratioW)];
    self.rightTime.text = @"00:00";
    self.rightTime.font = [UIFont systemFontOfSize:14.0];
    self.rightTime.textColor = [UIColor whiteColor];
    self.rightTime.textAlignment = NSTextAlignmentCenter;
    CGPoint rightCenter = CGPointMake(self.rightTime.center.x, tempX);
    self.rightTime.center = rightCenter;
    [self.view addSubview:self.rightTime];
    
    
    //UIButton播放按钮
    self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMidX(self.ZFSlider.frame) - 64*0.5*ratioW), CGRectGetMaxY(self.ZFSlider.frame), 64*ratioW, 64*ratioW)];
    [self.startBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startBtn];
    
    
    //UIImageView中央旋转图
    self.singerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300*ratioW, 300*ratioW)];
    self.singerImgView.center = CGPointMake(ScreenW * 0.5, ScreenH * 0.4);
    self.singerImgView.layer.cornerRadius = self.singerImgView.bounds.size.width * 0.5;
    self.singerImgView.layer.masksToBounds = YES;
    self.singerImgView.layer.borderWidth = 2.0f;
    self.singerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.singerImgView];
    
    //UILabel歌曲名
    self.songName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200*ratioW, 30*ratioH)];
    self.songName.center = CGPointMake(ScreenW*0.5, ScreenH*0.07);
    self.songName.textColor = [UIColor whiteColor];
    self.songName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.songName.textAlignment = NSTextAlignmentCenter;
    self.songName.text = @"";
    [self.view addSubview:self.songName];
    
    //UILabel专辑名
    self.albumName = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(ScreenW - 200*ratioW), CGRectGetMaxY(self.songName.frame), 200*ratioW, 30*ratioH)];
    self.albumName.textColor = [UIColor whiteColor];
    self.albumName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.albumName.textAlignment = NSTextAlignmentCenter;
    self.albumName.text = @"";
    [self.view addSubview:self.albumName];
    
    //当前歌词UILabel
    self.lrcLabel = [[ZFLabel alloc] initWithFrame:CGRectMake((ScreenW - (ScreenW - 50)) *0.5,CGRectGetHeight(self.lrcView.frame) - 44, ScreenW - 50, 44)];
    self.lrcLabel.text = @"";
    self.lrcLabel.font = lrcLabelFont;
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    self.lrcLabel.backgroundColor = [UIColor clearColor];
    self.lrcLabel.textColor = [UIColor whiteColor];
    [self.lrcView addSubview:self.lrcLabel];
    
    //下一首歌曲按钮
    UIButton *nextSongBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.startBtn.frame) + 30*ratioW, CGRectGetMinY(self.startBtn.frame), CGRectGetWidth(self.startBtn.frame), CGRectGetHeight(self.startBtn.frame))];
    [nextSongBtn setBackgroundImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [nextSongBtn setBackgroundImage:[UIImage imageNamed:@"player_btn_next_highlight"] forState:UIControlStateHighlighted];
    [nextSongBtn addTarget:self action:@selector(nextSongBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextSongBtn];
    
    //上一首歌曲按钮
    self.lastSongBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.startBtn.frame) - 30*ratioW - CGRectGetWidth(self.startBtn.frame), CGRectGetMinY(self.startBtn.frame), CGRectGetWidth(self.startBtn.frame), CGRectGetHeight(self.startBtn.frame))];
    [self.lastSongBtn setBackgroundImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    [self.lastSongBtn setBackgroundImage:[UIImage imageNamed:@"player_btn_pre_highlight"] forState:UIControlStateHighlighted];
    [self.lastSongBtn addTarget:self action:@selector(lastSongBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lastSongBtn];
    
}

#pragma mark - 定时器事件

/**
 歌词定时器事件,更新歌词
 */
-(void)updateLrc
{
    self.lrcView.currentTime = self.ZFPlayer.currentTime;
}

/**
 计时器事件
 */
-(void)refreshControls
{
    self.rightTime.text = [NSString stringFromNSTimeInteval:self.ZFPlayer.duration];
    self.leftTime.text = [NSString stringFromNSTimeInteval:self.ZFPlayer.currentTime];
}


#pragma mark - 按钮、UISlider事件

/**
 上一首歌曲
 */
-(void)lastSongBtnAction
{
    NSLog(@"lastSongBtn");
    //让按钮被选中,才可以继续播放
    self.startBtn.selected = !self.startBtn.selected;
    
    [self inValidControls];
    
    self.index --;
    if (self.index < 0) {
        self.index = (int)(self.allSongsArrM.count - 1);
    }
    
    [self firstPlayMusic];

}

/**
 下一首歌曲
 */
-(void)nextSongBtnAction
{
    //让按钮被选中,才可以继续播放
    self.startBtn.selected = !self.startBtn.selected;
    
    [self inValidControls];
    
    self.index ++;
    if (self.index >= self.allSongsArrM.count) {
        self.index = 0;
    }
    
    [self firstPlayMusic];

}

/**
 播放按钮点击事件
 
 @param sender 按钮本身
 */
-(void)startBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        NSLog(@"被选中");
        [self.startBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
        //开始播放
        [self.ZFPlayer play];
        //开启计时器
        [self ZFTimer];
        //开启歌词计时器
        [self ZFlrcTimer];
        //动画旋转
        if ([self.ZFPlayer isPlaying]) {
            //恢复旋转
            [self.singerImgView.layer resumeAnimate];
        }
        
    }
    else
    {
        NSLog(@"没被选中");
        [self.startBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        if ([self.ZFPlayer isPlaying]) {
            //播放暂停
            [self.ZFPlayer pause];
            [self.singerImgView.layer pauseAnimate];
        }
        //销毁计时器
        if ([self.ZFTimer isValid]) {
            [self.ZFTimer invalidate];
            self.ZFTimer = nil;
        }
        //暂停动画
        [self.singerImgView.layer pauseAnimate];
    }
}


/**
 UISlider进度条拖动事件
 */
-(void)ZFSliderAction
{
    self.ZFPlayer.currentTime = self.ZFSlider.value * self.ZFPlayer.duration;
}

#pragma mark - 复用方法

/**
 让对应控件设置为空
 */
-(void)inValidControls
{
    self.ZFPlayer  = nil;
    self.ZFTimer = nil;
    self.ZFlrcTimer = nil;
    self.ZFlrcTimer = nil;
    
    self.leftTime.text = @"00:00";
    self.rightTime.text = @"00:00";
    self.ZFSlider.value = 0;

    self.lrcLabel.text = @"";
}

/**
 第一次播放当前这首歌
 */
-(void)firstPlayMusic
{
    //设置ZFPlayer
    NSURL *url = [NSURL fileURLWithPath:self.allSongsArrM[self.index]];
    //获取MP3信息模型
    AssetModel *model = [AssetModel AssetModelWithURL:url];
    self.singerImgView.image = model.image;
    self.backgroundImgView.image = model.image;
    self.songName.text = model.songName;
    self.albumName.text = model.artist;
    
    ZFMusicPlistModel *musicPlistMoel = self.plistSongM[self.index];
    self.lrcView.lrcName = musicPlistMoel.lrcName;
    self.lrcView.lrcLabel = self.lrcLabel;
    
    //手动调用一次按钮，开启播放效果
    [self startBtnAction:self.startBtn];
    //中央旋转图开始旋转
    [self startSingerImgViewAnimate];

}

#pragma mark - 动画效果


/**
 中央旋转大图的旋转动画
 */
-(void)startSingerImgViewAnimate
{
    //创建基础动画
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性
    rotation.fromValue = @(0);
    rotation.toValue = @(M_PI * 2);
    rotation.repeatCount = NSIntegerMax;
    rotation.duration = 40;
    [self.singerImgView.layer addAnimation:rotation forKey:nil];
}


/**
 ScrollView拖动事件

 @param scrollView 当前ScrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.获取滑动多少
    CGPoint point = scrollView.contentOffset;
    //2.计算滑动比例
    CGFloat ratio = 1 - point.x / scrollView.bounds.size.width;
    //3.设置view属性
    self.singerImgView.alpha = ratio;
    self.lrcLabel.alpha = ratio;

}


#pragma mark - AVAudioPlayer代理方法

/**
 播放结束自动调用

 @param player 音乐播放器
 @param flag 播放结束标志
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放结束");
    [self nextSongBtnAction];
}

@end
