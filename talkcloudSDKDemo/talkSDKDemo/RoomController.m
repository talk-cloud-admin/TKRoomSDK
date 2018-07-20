//
//  RoomController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import "RoomController.h"
#import <TKRoomSDK/TKRoomSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoView.h"
#import <AudioUnit/AudioUnit.h>
#import "TKVideoLayerView.h"
#import "VideosBlock.h"
#import "TKTableViewCell.h"
#import "MBProgressHUD.h"
#import "ChatView.h"


static NSString *identifier = @"TKTableViewCell";

typedef NS_ENUM(NSInteger, PublishState) {
    PublishState_NONE           = 0,            //没有
    PublishState_AUDIOONLY      = 1,            //只有音频
    PublishState_VIDEOONLY      = 2,            //只有视频
    PublishState_BOTH           = 3,            //都有
    PublishState_NONE_ONSTAGE   = 4,            //音视频都没有但还在台上
};


typedef void (^ButtonAction)(UIButton* button);

@interface TKRoomManager(test)
- (void)setTestServer:(NSString*)ip Port:(NSString*)port;
@end

@interface RoomController() <TKRoomManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) VideoView *publishView;
@property (strong, nonatomic) NSString *myID;
@property (nonatomic, strong) VideoView *playView;
@property (strong, nonatomic) VideosBlock *videoBlock;

@property (nonatomic, strong) TKVideoLayerView *layerView;
@property (nonatomic, strong) NSMutableDictionary* userViews;
@property (nonatomic, strong) NSMutableDictionary* userDic;

@property (nonatomic, strong) TKRoomManager *roomMgr;
@property (nonatomic, strong) NSArray *controlButtons;
@property (nonatomic, strong) NSArray *buttonDescrptions;
@property (nonatomic, copy) NSString *playing;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerCount;
@property (strong, nonatomic) UITableView *showStats;
@property (strong, nonatomic) NSMutableArray *statsArray;
@property (strong, nonatomic) NSArray *funBtnDes;
@property (strong, nonatomic) NSArray *funBtns;
@property (strong, nonatomic) UIView *listView;
@property (nonatomic, strong) UIAlertController *alert;
@property (assign, nonatomic) BOOL isOnlyAuido;

@property (nonatomic, strong) MBProgressHUD *hud;// 菊花
@property (nonatomic, strong) ChatView *chatView;// 聊天视图
@end
/*
 流程 
 
 1. 调用joinRoomWithHost，加入课堂
 2.roomManagerRoomJoined回调，发布自己的音视频changeUserPublish
 3.roomManagerUserPublished ,播放用户视频
 4.roomManagerUserUnPublished,关闭用户视频
 5.roomManagerUserChanged回调，播放可以播放视频的用户
 */

@implementation RoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    _userViews      = [NSMutableDictionary dictionaryWithCapacity:6];
    _userDic        = [NSMutableDictionary dictionaryWithCapacity:6];
    [self createCommonBtn];
    _roomMgr = [TKRoomManager instance];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = (width - 5 * 10) / 4;
    self.videoBlock = [[VideosBlock alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - height - 10, width, height) rmg:self.roomMgr];
    [self.view addSubview:self.videoBlock];
    
    CGFloat y = self.view.frame.size.height - height - 75 - height;
    self.showStats = [[UITableView alloc] initWithFrame:CGRectMake(0, y, width, height) style:UITableViewStylePlain];
    [self.showStats setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.showStats.delegate = self;
    self.showStats.dataSource = self;
    self.showStats.rowHeight = 20;
//    self.showStats.scrollEnabled = NO;
    self.showStats.backgroundColor = [UIColor clearColor];
    [self.showStats registerNib:[UINib nibWithNibName:@"TKTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.showStats];
    
//    [self.showStats reloadData];
    self.statsArray = [NSMutableArray array];

    [self initAVAndinitClass];
    
    [self ControlBtn];
    [self createAlert];
    [self creatTimer];
}

- (void)creatTimer{
    _timerCount = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerFire) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate date]];
}
-(void)timerFire{
    _timerCount++;
    if (_timerCount > 8) {
        //隐藏控制按钮
//        for (UIView* button in _controlButtons) {
//            button.hidden = YES;
//        }
        self.showStats.hidden = YES;
        [_timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)resetTimer{
//    for (UIView* button in _controlButtons) {
//        button.hidden = NO;
//    }
    self.showStats.hidden = NO;
    _timerCount = 0;
    [_timer setFireDate:[NSDate date]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resetTimer];
    
    if (_chatView.hidden == NO) {
        if ([self.funBtns.lastObject isKindOfClass:UIButton.class]) {
            UIButton *btn = (UIButton *)self.funBtns.lastObject;
            btn.selected = NO;
        }
        
        [_chatView hide];
    }
}

- (UIButton *)createCommonBtn
{
    self.funBtnDes = @[
                       @{@"imageNomal":[UIImage imageNamed:@"switchCamera"],
                             @"imageSelect":[UIImage imageNamed:@"switchCamera"],
                             @"block":^(UIButton* button){
                                 //切换摄像头2
                                 if (!button.selected) {
                                     _timerCount = 0;
                                     [_roomMgr selectCameraPosition:YES];
                                 } else {
                                     _timerCount = 0;
                                     [_roomMgr selectCameraPosition:NO];
                                 }
                             }},
                           @{@"imageNomal":[UIImage imageNamed:@"AV"],
                             @"imageSelect":[UIImage imageNamed:@"onlyAudio"],
                             @"block":^(UIButton* button){
                                 //切换纯音频3
                                 if (button.selected) {
                                     _timerCount = 0;
                                     [_roomMgr switchOnlyAudioRoom:YES];
                                 } else {
                                     _timerCount = 0;
                                     [_roomMgr switchOnlyAudioRoom:NO];
                                 }
                             }},
                           @{@"imageNomal":[UIImage imageNamed:@"videoProfile"],
                             @"imageSelect":[UIImage imageNamed:@"videoProfile"],
                             @"block":^(UIButton* button){
                                 //设置分辨率4
                                 UIPopoverPresentationController *popover = _alert.popoverPresentationController;
                                 if (popover) {
                                     popover.sourceView = button;
                                     popover.sourceRect = button.bounds;
                                     popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
                                 }
                                 [self presentViewController:_alert animated:YES completion:nil];
                                
                             }},
                       @{@"imageNomal":[UIImage imageNamed:@"speaker"],
                         @"imageSelect":[UIImage imageNamed:@"receive"],
                         @"block":^(UIButton* button){
                                 //扬声器
                             if (!button.selected) {
                                 _timerCount = 0;
                                 [_roomMgr useLoudSpeaker:YES];
                             } else {
                                 _timerCount = 0;
                                 [_roomMgr useLoudSpeaker:NO];
                             }
                         }},
                       // 聊天界面打开关闭 按钮
                       @{@"imageNomal":[UIImage imageNamed:@"talk_default"],
                         @"imageSelect":[UIImage imageNamed:@"talk_press"],
                         @"block":^(UIButton* button){
                             if (button.selected) {
                                 //                                     _timerCount = 0;
                                 //                                     [_roomMgr publishAudio:nil];
                                 [self.chatView show];
                             }
                             else {
                                 //                                     _timerCount = 0;
                                 //                                     [_roomMgr unPublishAudio:nil];
                                 [self.chatView hide];
                             }
                         }},
                       ];
    
    
    
    NSInteger count = self.funBtnDes.count;
    CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat gap = 10;
    CGFloat x = kWidth - 50 - gap;
    CGFloat y = 50;
    CGFloat width = 50;
    CGFloat height = count * (50 + gap);
    _listView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _listView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_listView];
    
    NSInteger i = 0;
    NSMutableArray *bt = [NSMutableArray arrayWithCapacity:self.funBtnDes.count];
    for (NSDictionary* dic in _funBtnDes) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i *(width + gap), width, width)];
        [button setSelected:false];
        UIImage *imageNomal = [dic objectForKey:@"imageNomal"];
        UIImage *imageSelect = [dic objectForKey:@"imageSelect"];
        [button setImage:imageNomal forState:(UIControlStateNormal)];
        [button setImage:imageSelect forState:(UIControlStateSelected)];
        [button setTag:bt.count];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button addTarget:self action:@selector(listViewBtn:) forControlEvents: UIControlEventTouchUpInside];
        button.hidden = YES;
        [bt addObject:button];
        [self.listView addSubview:button];
        i++;
    }
    self.funBtns = [bt copy];
    return nil;
}
- (void)listViewBtn:(UIButton *)button {
    
    [button setSelected:!button.isSelected];
    ButtonAction block = (ButtonAction)[((NSDictionary*)self.funBtnDes[button.tag]) objectForKey:@"block"];
    block(button);
}
- (void)createAlert
{
    _alert = [UIAlertController alertControllerWithTitle:@"设置分辨率" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alert addAction:cancelAction];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"80X60" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 80;
        videoProfile.height = 60;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"176X132" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 176;
        videoProfile.height = 132;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"320X240" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 320;
        videoProfile.height = 240;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action3];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"640X480" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 640;
        videoProfile.height = 480;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action4];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"1280X720" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 1280;
        videoProfile.height = 720;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action5];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"1920X1080" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TKVideoProfile *videoProfile = [TKVideoProfile new];
        videoProfile.width = 1920;
        videoProfile.height = 1080;
        videoProfile.maxfps = 15;
        [_roomMgr setVideoProfile:videoProfile];
    }];
    [_alert addAction:action6];
}
- (void)viewDidLayoutSubviews {
    
//    [self layoutVideos];
    self.publishView.frame = self.view.bounds;
    
    [self layoutControlBtn];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = (width - 5 * 10) / 4;
    self.videoBlock.frame = CGRectMake(0, self.view.frame.size.height - height - 70, width, height);
}


#pragma mark - 获取摄像头麦克风权限以及初始化课堂
- (void)initAVAndinitClass
{
    [[TKRoomManager instance] registerRoomWhiteBoardDelegate:self andWB:NO];
    NSString *password = @"";
    if (self.password) {
        password = self.password;
    }
    [_roomMgr joinRoomWithHost:@"global.talk-cloud.net" port:80 nickName:@"ios" roomParams:@{@"serial":self.roomid,@"userrole":self.role, @"password" : password,@"autoSubscribeAV" : @(YES)} userParams:nil];
    [_roomMgr setVideoOrientation:UIDeviceOrientationPortrait];
    
}
#pragma mark - 初始化课堂按钮
- (void)ControlBtn{
    
//    [self.view addSubview:self.layerView];
    
    //学生身份。在网页当老师时，（1）教室是自动上课／自动开启音视频时才可以看到其他人。（2）教室是自动开启音视频，此时需要老师点击上课按钮，才可以看到其他人（3）教室没有设置，需要其他人publish自己的视频，才可以看到（前两种情况的本质就是收到其他人publish自己的视频）。
    //老师身份。注意（1）老师只能进入一个。（2）只有其他人publish了自己的视频，才能看到彼此。具体看roomManagerRoomJoined函数（发布自己的音视频）
    //[_roomMgr joinRoomWithHost:@"global.talk-cloud.net" Port:443 NickName:@"ios" Params:@{@"serial":@"933643979",@"userrole":@(0),@"password":@(1)} Properties:nil];
    
    _buttonDescrptions = @[@{@"imageNomal":[UIImage imageNamed:@"cameraoff"],
                             @"imageSelect":[UIImage imageNamed:@"cameraon"],
                             @"block":^(UIButton* button){
                                 if (!button.selected) {
                                     _timerCount = 0;
                                     [_roomMgr publishVideo:nil];
                                 } else {
                                     _timerCount = 0;
                                     [_roomMgr unPublishVideo:nil];
                                 }
                             }},
                           @{@"imageNomal":[UIImage imageNamed:@"mute"],
                             @"imageSelect":[UIImage imageNamed:@"unmute"],
                             @"block":^(UIButton* button){
                                 if (!button.selected) {
                                     _timerCount = 0;
                                     [_roomMgr publishAudio:nil];
                                 } else {
                                     _timerCount = 0;
                                     [_roomMgr unPublishAudio:nil];
                                 }
                             }},
                           @{@"imageNomal":[UIImage imageNamed:@"hangup"],
                             @"imageSelect":[UIImage imageNamed:@"hangup"],
                             @"block":^(UIButton* button){
                                 if (button.selected) {
                                     [_roomMgr leaveRoom:nil];
                                     [TKRoomManager destory];
                                     _roomMgr = nil;
                                 } else {
                                     button.enabled = NO;
                                 }
                             }},
 
                           ];
    
    
    NSMutableArray *bt = [NSMutableArray arrayWithCapacity:_buttonDescrptions.count];
    for (NSDictionary* dic in _buttonDescrptions) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setSelected:false];
        UIImage *imageNomal = [dic objectForKey:@"imageNomal"];
        UIImage *imageSelect = [dic objectForKey:@"imageSelect"];
        [button setImage:imageNomal forState:(UIControlStateNormal)];
        [button setImage:imageSelect forState:(UIControlStateSelected)];
        [button setTag:bt.count];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button addTarget:self action:@selector(toggleButton:) forControlEvents: UIControlEventTouchUpInside];
        
        [bt addObject:button];
        [self.view addSubview:button];
    }
    _controlButtons = [NSArray arrayWithArray:bt]; 
}

// internal functions
- (void)layoutVideos {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_userViews];
    if ([_userViews objectForKey:_roomMgr.localUser.peerID]) {
       
        VideoView *videoView = (VideoView *)_userViews[_roomMgr.localUser.peerID];
        videoView.frame = CGRectMake(self.view.frame.size.width-self.view.frame.size.width/4-20, 20, self.view.frame.size.width/4, self.view.frame.size.width/3);
//        videoView.transform = CGAffineTransformMakeRotation(M_PI_2);
         [dict removeObjectForKey:_roomMgr.localUser.peerID];
    }
        
    for (VideoView *view in [dict allValues]) {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)layoutControlBtn {
    
    self.layerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    CGFloat gap = (self.view.bounds.size.width-50*3)/4;
    CGFloat width = 50;
    CGFloat height = width;
    CGFloat x = gap;
    CGFloat y = self.view.bounds.size.height - height - 10;
    for (UIView* button in _controlButtons) {
        [button setFrame:CGRectMake(x, y, width, height)];
        [self.view bringSubviewToFront:button];
        x += width + gap;
    }
}

#pragma mark 播放（关闭）视频
- (void)setUI2Front
{
    [self.view bringSubviewToFront:self.videoBlock];
    [self.view bringSubviewToFront:self.showStats];
    [self.view bringSubviewToFront:self.listView];
}
- (void)playVideo:(TKRoomUser *)user
{
    if ([user.peerID isEqualToString:_myID]) {
        if (!self.publishView) {
            self.publishView = [[VideoView alloc] initWithRoomMgr:_roomMgr roomUser:user];
            [self.view addSubview:self.publishView];
        }
        if (self.publishView.status == TKPlay_Video || self.publishView.status == TKPlay_Both) {
            return;
        }
        [_roomMgr playVideo:user.peerID renderType:TKRenderMode_adaptive window:self.publishView completion:^(NSError *error) {
            if (error) {
                return ;
            }
            TKPlayStatus status = self.publishView.status;
            
            switch (status) {
                case TKPlay_None:
                    status = TKPlay_Video;
                    break;
                case TKPlay_Audio:
                    status = TKPlay_Both;
                    break;
                default:
                    break;
            }
            self.publishView.status = status;
            if (status > TKPlay_Audio) {
                [self.publishView sendSubviewToBack:self.publishView.imageView];
            }
            [self viewDidLayoutSubviews];
//            [self.view bringSubviewToFront:self.videoBlock];
//            [self.view bringSubviewToFront:self.showStats];
            [self setUI2Front];
        }];
    
    } else {
        [self.videoBlock playVideoWithUser:user];
//        [self.view bringSubviewToFront:self.videoBlock];
//        [self.view bringSubviewToFront:self.showStats];
        [self setUI2Front];
    }
}
- (void)playAudio:(TKRoomUser *)user
{
    if ([user.peerID isEqualToString:_myID]) {
        if (!self.publishView) {
            self.publishView = [[VideoView alloc] initWithRoomMgr:_roomMgr roomUser:user];
            [self.view addSubview:self.publishView];
        }
        if (self.publishView.status == TKPlay_Audio || self.publishView.status == TKPlay_Both) {
            return;
        }
        [_roomMgr playAudio:user.peerID completion:^(NSError *error) {
            TKPlayStatus status = self.publishView.status;
            
            switch (status) {
                case TKPlay_None:
                    status = TKPlay_Audio;
                    break;
                case TKPlay_Video:
                    status = TKPlay_Both;
                    break;
                default:
                    break;
            }
            self.publishView.status = status;
            if (status <= TKPlay_Audio) {
                [self.publishView bringSubviewToFront:self.publishView.imageView];
            } else {
                [self.publishView sendSubviewToBack:self.publishView.imageView];
            }
            [self.publishView setViewsToFront];
            [self viewDidLayoutSubviews];
//            [self.view bringSubviewToFront:self.videoBlock];
            [self setUI2Front];
        }];
    } else {
        [self.videoBlock playAudioWithUser:user];
        [self.view bringSubviewToFront:self.videoBlock];
        [self.view bringSubviewToFront:self.showStats];
    }
}
- (void)unPlayVideo:(NSString *)peerID
{
    if ([peerID isEqualToString:_myID]) {
        if (!self.publishView) {
            return;
        }
        if (self.publishView.status < TKPlay_Video) {
            return;
        }
        [_roomMgr unPlayVideo:peerID completion:^(NSError *error) {
            TKPlayStatus status = self.publishView.status;
            
            switch (status) {
                case TKPlay_Video:
                    status = TKPlay_None;
                    break;
                case TKPlay_Both:
                    status = TKPlay_Audio;
                    break;
                default:
                    break;
            }
            self.publishView.status = status;
            if (status == TKPlay_None) {
                [self.publishView removeFromSuperview];
                self.publishView = nil;
            } else if (status == TKPlay_Audio) {
                [self.publishView bringSubviewToFront:self.publishView.imageView];
            }
            [self.publishView setViewsToFront];
            [self viewDidLayoutSubviews];
        }];
    } else {
        [self.videoBlock unPlayVideoWithUser:peerID];
    }
}
- (void)unPlayAudio:(NSString *)peerID
{
    if ([peerID isEqualToString:_myID]) {
        if (!self.publishView) {
            return;
        }
        if (self.publishView.status == TKPlay_None || self.publishView.status == TKPlay_Video) {
            return;
        }
        [_roomMgr unPlayAudio:peerID completion:^(NSError *error) {
            TKPlayStatus status = self.publishView.status;
            
            switch (status) {
                case TKPlay_Audio:
                    status = TKPlay_None;
                    break;
                case TKPlay_Both:
                    status = TKPlay_Video;
                    break;
                default:
                    break;
            }
            self.publishView.status = status;
            if (status == TKPlay_None) {
                [self.publishView removeFromSuperview];
                self.publishView = nil;
            } else if(status > TKPlay_Audio) {
                [self.publishView sendSubviewToBack:self.publishView.imageView];
            }
            [self viewDidLayoutSubviews];
        }];
    } else {
        [self.videoBlock unPlayAudioWithUser:peerID];
    }
}
- (void)refreshUI{
    if ([_userViews objectForKey:_roomMgr.localUser.peerID]) {
        
        VideoView *videoView = (VideoView *)_userViews[_roomMgr.localUser.peerID];
        [self.view bringSubviewToFront:videoView];
    }
        
}
- (void)tryUnplayVideo:(NSString*)peerID {
    VideoView *view = [_userViews objectForKey:peerID];
    if (view) {
        [_roomMgr unPlayVideo:peerID completion:^(NSError* error){
            if (error) {
                NSLog(@"unPlayVideo error = %@", error);
            }
            VideoView *videoview = [_userViews objectForKey:peerID];
            [videoview removeFromSuperview];
            videoview = nil;
            [_userViews removeObjectForKey:peerID];
            [self viewDidLayoutSubviews];
        }];
        [_roomMgr unPlayAudio:peerID completion:nil];
    }
}

- (void) toggleButton: (UIButton *) button
{
    if (button.tag == 0 && self.isOnlyAuido && _roomMgr.localUser.publishState != 0) {
        return;
    }
    [button setSelected:!button.isSelected];
    ButtonAction block = (ButtonAction)[((NSDictionary*)_buttonDescrptions[button.tag]) objectForKey:@"block"];
    block(button);
}

#pragma mark - roomManager
- (void)roomManagerRoomJoined
{
    //第二步 加入课堂成功 发布自己的音视频
    for (UIButton *btn in self.funBtns) {
        btn.hidden = NO;
    }
    [_roomMgr publishVideo:nil];
    [_roomMgr publishAudio:nil];
    _myID = _roomMgr.localUser.peerID;
}

- (void)roomManagerDidOccuredError:(NSError *)error
{

    [self reportFail:error.code];
    NSString *log = [NSString stringWithFormat:@"💔error💔 code:%ld message:%@",error.code, error.localizedDescription];
    [self.statsArray addObject:log];
    [self resetTimer];
    [self.showStats reloadData];
    if (self.statsArray.count >= 2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.statsArray.count - 1 inSection:0];
        [self.showStats scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)roomManagerDidOccuredWaring:(TKRoomWarningCode)code
{
    if (code == TKRoomWarning_AudioRouteChange_Headphones || code == TKRoomWarning_AudioRouteChange_Bluetooth) {
    }
}
- (void)reportFail:(TKRoomErrorCode)ret
{
    NSString *alertMessage = nil; 
    switch (ret) {
        case 5001://checkroom成功
                alertMessage = @"checkRoom成功";
            return ;
        case TKErrorCode_CheckRoom_ServerOverdue: {//3001  服务器过期
                alertMessage = @"服务器过期";
        }
            break;
        case TKErrorCode_CheckRoom_RoomFreeze: {//3002  公司被冻结
                alertMessage = @"公司被冻结";
        }
            break;
        case TKErrorCode_CheckRoom_RoomDeleteOrOrverdue: //3003  房间被删除或过期
        case TKErrorCode_CheckRoom_RoomNonExistent: {//4007 房间不存在 房间被删除或者过期
                alertMessage = @"房间被删除或者过期";
        }
            break;
        case TKErrorCode_CheckRoom_RequestFailed:
                alertMessage = @"网络请求失败";
            break;
        case TKErrorCode_CheckRoom_PasswordError: {//4008  房间密码错误
                alertMessage = @"房间密码错误";
        }
            break;
            
        case TKErrorCode_CheckRoom_WrongPasswordForRole: {//4012  密码与角色不符
                alertMessage = @"密码与角色不符";
        }
            break;
            
        case TKErrorCode_CheckRoom_RoomNumberOverRun: {//4103  房间人数超限
                alertMessage = @"房间人数超限";
        }
            break;
            
        case TKErrorCode_CheckRoom_NeedPassword: {//4110  该房间需要密码，请输入密码
                alertMessage = @"该房间需要密码，请输入密码";
        }
            break;
            
        case TKErrorCode_CheckRoom_RoomPointOverrun: {//4112  企业点数超限
                alertMessage = @" 企业点数超限";
        }
            break;
        case TKErrorCode_CheckRoom_RoomAuthenError: {//4109
                alertMessage = @"认证错误";
        }
            break;

        default:
            return;
    }
     UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"💔Error💔" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_roomMgr leaveRoom:nil];
        [TKRoomManager destory];
        _roomMgr = nil;
    }];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)roomManagerKickedOut:(NSDictionary *)reason
{
     NSLog(@"roomManagerSelfEvicted");
}
- (void)roomManagerRoomLeft {
    NSLog(@"roomManagerRoomLeft");
    [self dismissViewControllerAnimated:YES completion:^{
        [TKRoomManager destory];
        _roomMgr = nil;
    }];
}

- (void)roomManagerPublishStateWithUserID:(NSString *)peerID publishState:(TKPublishState)state
{
    NSLog(@"roomManagerUserPublished %@", peerID);
    //第三步  播放发布音视频的用户
    TKRoomUser *user = [_roomMgr getRoomUserWithUId:peerID];
    switch (state) {
        case TKUser_PublishState_NONE:
            [self unPlayAudio:peerID];
            [self unPlayVideo:peerID];
            break;
        case TKUser_PublishState_AUDIOONLY:
            [self playAudio:user];
            break;
        case TKUser_PublishState_VIDEOONLY:
            [self playVideo:user];
            break;
        case TKUser_PublishState_BOTH:
            [self playVideo:user];
            [self playAudio:user];
            break; 
        default:
            break;
    }
}

- (void)roomManagerConnected:(dispatch_block_t)completion
{
    
}

- (void)roomManagerUserJoined:(NSString *)peerID inList:(BOOL)inList
{
 
    NSLog(@"roomManagerUserJoined %d %@", inList, peerID);
}

- (void)roomManagerUserLeft:(NSString *)peerID
{
    NSLog(@"roomManagerUserLeft %@", peerID);
}


- (void)roomManagerUserPropertyChanged:(NSString *)peerID
                            properties:(NSDictionary*)properties
                                fromId:(NSString *)fromId
{
   
    TKRoomUser *tRoomUser = [_roomMgr getRoomUserWithUId:peerID];
     NSLog(@"roomManagerUserChanged publishState =%ld properties=%@", tRoomUser.publishState, properties);
    //如果publishState改变，则发布音视频
    if (tRoomUser) {
        if( tRoomUser.publishState >= TKUser_PublishState_AUDIOONLY){
            if (tRoomUser.publishState == TKUser_PublishState_AUDIOONLY) {
                if ([peerID isEqualToString:_roomMgr.localUser.peerID]) {
                    [_publishView bringSubviewToFront:_publishView.imageView];
                    UIButton *btn = _controlButtons[0];
                    btn.selected = YES;
                    UIButton *audio = _controlButtons[1];
                    audio.selected = NO;
                    
                }else{
                    [self.videoBlock refreshForPublishState:TKUser_PublishState_AUDIOONLY user:peerID];
                }
                [self unPlayVideo:peerID];
            } else if(tRoomUser.publishState == TKUser_PublishState_NONE_ONSTAGE){
                if ([peerID isEqualToString:_roomMgr.localUser.peerID]) {
                    [_publishView bringSubviewToFront:_publishView.imageView];
                    UIButton *video = _controlButtons[0];
                    video.selected = YES;
                    UIButton *audio = _controlButtons[1];
                    audio.selected = YES;
                }else{
//                    [_playView bringSubviewToFront:_playView.imageView];
                }
            } else {
                
                if ([peerID isEqualToString:_roomMgr.localUser.peerID]) {
                    if (tRoomUser.publishState == TKUser_PublishState_VIDEOONLY) {
                        UIButton *audio = _controlButtons[1];
                        audio.selected = YES;
                        UIButton *video = _controlButtons[0];
                        video.selected = NO;
                    } else {
                        UIButton *video = _controlButtons[0];
                        video.selected = NO;
                        UIButton *audio = _controlButtons[1];
                        audio.selected = NO;
                    }
                    [_publishView sendSubviewToBack:_publishView.imageView]; 
                }else{
                    [self.videoBlock refreshForPublishState:TKUser_PublishState_BOTH user:peerID];
                }
                [self playVideo:tRoomUser];
            } 
        }
    }
}
#pragma mark 消息
- (void)roomManagerMessageReceived:(NSString *)message
                            fromID:(NSString *)peerID
                         extension:(NSDictionary *)extension
{
    NSString *tDataString = [NSString stringWithFormat:@"%@", message];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString *msg = [tDataDic objectForKey:@"msg"];
    // 刷新聊天
    [self chatView];
    [_chatView receiveMessage:msg peerID:peerID];
    
}

- (void)roomManagerPlaybackMessageReceived:(NSString *)message
                                    fromID:(NSString *)peerID
                                        ts:(NSTimeInterval)ts
                                 extension:(NSDictionary *)extension
{
    
}

- (void)roomManagerOnRemotePubMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID
                                    inList:(BOOL)inlist
                                        ts:(long)ts
{
//    NSLog(@"roomManagerOnRemoteMsg %@ %@ %lu %@", msgID, msgName, ts, data);
    
    
    
}
- (void)roomManagerOnRemoteDelMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID
                                    inList:(BOOL)inlist
                                        ts:(long)ts
{
    if (msgName && [msgName isEqualToString:@"OnlyAudioRoom"]) {
        NSLog(@"roomManagerOnDelRemoteMsg %@ %@ %lu %@", msgID, msgName, ts, data);
        UIButton *btn = self.funBtns[1];
        btn.selected = NO;
    }
}
- (void)roomManagerOnAudioRoomSwitch:(NSString *)fromId onlyAudio:(BOOL)onlyAudio
{
//    _timerCount = 0; 
    self.isOnlyAuido = onlyAudio;
    NSString *log = nil;
    if (onlyAudio) {
        UIButton *btn = self.funBtns[1];
        btn.selected = YES;
        
        if (_roomMgr.localUser.publishState != 0) {
            [_publishView bringSubviewToFront:_publishView.imageView];
            UIButton *button = _controlButtons[0];
            button.selected = YES;
            UIButton *audio = _controlButtons[1];
            audio.selected = NO;
            
            [self unPlayVideo:_myID];
        } else {
            UIButton *button = _controlButtons[0];
            button.selected = YES;
            UIButton *audio = _controlButtons[1];
            audio.selected = YES;
        }
        log = @"💚房间已切换成纯音频房间💚";
    } else {
        log = @"💚房间已切换成音视频房间💚";
    }
    
//    [self.statsArray addObject:log];
//    [self.showStats reloadData];
//    if (self.statsArray.count >= 2) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.statsArray.count - 1 inSection:0];
//        [self.showStats scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview: _hud];
    _hud.label.text = log;
    _hud.mode = MBProgressHUDModeText;
    _hud.minShowTime = 1;

    [_hud showAnimated:YES];

    [_hud hideAnimated:YES afterDelay:1.0];
    
}



#pragma mark meidia
- (void)roomManagerOnShareMediaState:(NSString *)peerId
                               state:(TKMediaState)state
                    extensionMessage:(NSDictionary *)message
{
    
}

- (void)roomManagerUpdateMediaStream:(NSTimeInterval)duration
                                 pos:(NSTimeInterval)pos
                              isPlay:(BOOL)isPlay
{
    
}

- (void)roomManagerMediaLoaded
{
    
}

#pragma mark screen

- (void)roomManagerOnShareScreenState:(NSString *)peerId
                                state:(TKMediaState)state
                     extensionMessage:(NSDictionary *)message
{
    
}

- (void)roomManagerOnShareFileState:(NSString *)peerId
                              state:(TKMediaState)state
                   extensionMessage:(NSDictionary *)message
{
    
}

#pragma mark Playback

- (void)roomManagerReceivePlaybackDuration:(NSTimeInterval)duration{
    
}

- (void)roomManagerPlaybackUpdateTime:(NSTimeInterval)time{
    
}

- (void)roomManagerPlaybackClearAll{
    
}

- (void)roomManagerPlaybackEnd{
    
}
- (void)roomManagerOnAudioStatsReport:(NSString *)peerId stats:(TKAudioStats *)stats
{
//    TKRoomUser *user = [_roomMgr getRoomUserWithUId:peerId];
//
//    NSString *string = [NSString stringWithFormat:@"audio user:%@ bandwidth:%ld lost:%ld total:%ld delay:%ld jitter:%ld netLevel:%ld",user.nickName, (long)stats.bitsPerSecond, (long)stats.packetsLost, (long)stats.totalPackets, (long)stats.currentDelay, (long)stats.jitter, (long)stats.netLevel];
//    [self.statsArray addObject:string];
//    if (self.statsArray.count >= 2) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.statsArray.count - 2 inSection:0];
//        [self.showStats scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    [self.showStats reloadData];
//
}
- (void)roomManagerOnVideoStatsReport:(NSString *)peerId stats:(TKVideoStats *)stats
{
//    TKRoomUser *user = [_roomMgr getRoomUserWithUId:peerId];
//    NSString *string = [NSString stringWithFormat:@"video user:%@ bandwidth:%ld lost:%ld total:%ld delay:%ld netLevel:%ld",user.nickName, (long)stats.bitsPerSecond, (long)stats.packetsLost, (long)stats.totalPackets, (long)stats.currentDelay, (long)stats.netLevel];
//    [self.statsArray addObject:string];
//    if (self.statsArray.count >= 2) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.statsArray.count - 2 inSection:0];
//        [self.showStats scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    [self.showStats reloadData];
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKTableViewCell *cell = [self.showStats dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[TKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.statsArray.count > 0) {
         cell.showLabel.text = [self.statsArray objectAtIndex:indexPath.row];
    } 
    return cell;
}

- (TKVideoLayerView *)layerView{
    if (!_layerView) {
        self.layerView = [[TKVideoLayerView alloc]init];
        [self.view addSubview:self.layerView];
    }
    return _layerView;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - 懒加载 聊天视图
- (ChatView *)chatView {
    if (!_chatView) {
        _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(_listView.frame) + 10,
                                                               self.view.width,
                                                               self.view.height - (CGRectGetMaxY(_listView.frame) + 10))];
        
//        [self.view addSubview: _chatView];
        [[UIApplication sharedApplication].keyWindow addSubview:_chatView];
    }
    
    return _chatView;
}


- (void)dealloc {
    
}

@end
