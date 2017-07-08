//
//  MusicLrcScrollView.m
//  MyMusicPlayer
//
//  Created by HZhenF on 2017/7/6.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "MusicLrcScrollView.h"
#import "MusicLrcTool.h"
#import "MusicLrcModel.h"
#import "ZFLabel.h"
#import "ZFMusicCell.h"

#define currentLine [UIFont systemFontOfSize:20]
#define otherLine [UIFont systemFontOfSize:14]

@interface MusicLrcScrollView()<UITableViewDelegate,UITableViewDataSource>
/**解析好的歌词数组*/
@property(nonatomic,strong) NSArray *lrcArray;
/**显示歌词的UITableView*/
@property(nonatomic,strong) UITableView *tableView;
/** 当前播放歌词的下标 */
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation MusicLrcScrollView

#pragma mark - setter方法

-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    //用当前时间和歌词进行匹配
    NSInteger count = self.lrcArray.count;
    for (int i = 0; i < count; i ++) {
        //1.拿到i位置的歌词
        MusicLrcModel *currentLrcLine = self.lrcArray[i];
        
        //2.拿到下一句的歌词
        NSInteger nextIndex = i + 1;
        MusicLrcModel *nextLrcLine = nil;
        if (nextIndex < count) {
            nextLrcLine = self.lrcArray[nextIndex];
        }
        
        //3.用当前的时间和i位置的歌词比较，并且和下一句比较，如果大于i位置的时间，并且小于下一句歌词的时间，那么显示当前的歌词
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            //1.获取需要刷新的行号
            //当前行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            //上一行
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            //2.记录当前行i的行号
            self.currentIndex = i;
            
            //3.刷新当前的行，和上一行
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //4.显示对应的歌词
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            //5.设置外面歌词的Label的显示歌词
            self.lrcLabel.text = currentLrcLine.text;
        }
        //4.根据进度，显示label画多少
        if (self.currentIndex == i) {
            //4.1拿到i的位置的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ZFMusicCell *cell = (ZFMusicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //4.2更新label的进度
            CGFloat progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            cell.lrcLabel.propress = progress;
            
            //4.3设置外面歌词的Label的进度
            self.lrcLabel.propress = progress;
        }
    }
    
}

-(void)setLrcName:(NSString *)lrcName
{
    _lrcName = lrcName;
    
    //下一曲的时候重置下标
    self.currentIndex = 0;
    
    //解析歌词
    self.lrcArray = [MusicLrcTool lrcWithName:lrcName];
    
    [self.tableView reloadData];
}

#pragma mark - 系统方法

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, self.frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = 35;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.tableView registerClass:[ZFMusicCell class] forCellReuseIdentifier:@"ZFCell"];
        [self addSubview:self.tableView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark - UITableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZFMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZFCell"];
    }
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = currentLine;
    }
    else
    {
        cell.lrcLabel.font = otherLine;
        cell.lrcLabel.propress = 0;
    }
    MusicLrcModel *lrcModel = self.lrcArray[indexPath.row];
    cell.lrcLabel.text = lrcModel.text;
    return cell;
}

@end
