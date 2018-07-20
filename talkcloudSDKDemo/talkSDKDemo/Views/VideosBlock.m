//
//  VideosBlock.m
//  talkSDKDemo
//
//  Created by MAC-MiNi on 2018/7/6.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "VideosBlock.h"
#import "VideoView.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height
#define kVideoMax 4
@interface VideosBlock()
@property (strong, nonatomic) VideoView *view1;
@property (strong, nonatomic) VideoView *view2;
@property (strong, nonatomic) VideoView *view3;
@property (strong, nonatomic) VideoView *view4;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) TKRoomUser *user;
@property (strong, nonatomic) TKRoomManager *rmg;
@property (strong, nonatomic) NSMutableDictionary *videos; 
@end


@implementation VideosBlock

- (instancetype)initWithFrame:(CGRect)frame rmg:(TKRoomManager *)rmg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.width = frame.size.width;
        self.height = frame.size.height;
        self.rmg = rmg;
        self.videos = [NSMutableDictionary dictionary];
    }
    return self;
}

- (VideoView *)creatVideoViewWith:(TKRoomUser *)user
{
    VideoView *view = [[VideoView alloc] initWithRoomMgr:self.rmg roomUser:user];
    [self.videos setObject:view forKey:user.peerID];
    [self refreshVideo];
    return view;
}


- (void)playVideoWithUser:(TKRoomUser *)user
{
    if (!user) {
        return;
    }
    VideoView *videoView = [self getVideoViewWithPeerID:user.peerID];
    if (![user.peerID isEqualToString:self.rmg.localUser.peerID]) {
        if (!videoView) {
            videoView = [self creatVideoViewWith:user];
        }
        if (videoView.status == TKPlay_Video || videoView.status == TKPlay_Both) {
            return;
        }
        [self.rmg playVideo:user.peerID renderType:TKRenderMode_adaptive window:videoView completion:^(NSError *error) {
            if (error) {
                return ;
            }
            TKPlayStatus status = videoView.status;
            if (status == TKPlay_None) {
                [self addSubview:videoView];
            }
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
            if (status > TKPlay_Audio) {
                [videoView sendSubviewToBack:videoView.imageView];
            }
            videoView.status = status;
            [self refreshVideo];
            [videoView setViewsToFront]; 
        }];
    }
}

- (void)unPlayVideoWithUser:(NSString *)peerID
{
    if ([peerID isEqualToString:_rmg.localUser.peerID]) {
        return;
    }
    __block VideoView *videoView = [self getVideoViewWithPeerID:peerID];
    if (!videoView) {
        return;
    }
    if (videoView.status < TKPlay_Video) {
        return;
    }
    [self.rmg unPlayVideo:peerID completion:^(NSError *error) {
        TKPlayStatus status = videoView.status;
        
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
        videoView.status = status;
        if (status == TKPlay_None) {
            [videoView removeFromSuperview];
            [self.videos removeObjectForKey:peerID];
            videoView = nil;
        } else if (status == TKPlay_Audio) {
            [videoView bringSubviewToFront:videoView.imageView];
        }
        [self refreshVideo];
    }];
}

- (void)playAudioWithUser:(TKRoomUser *)user
{
    if (!user) {
        return;
    }
    VideoView *videoView = [self getVideoViewWithPeerID:user.peerID];
    if (![user.peerID isEqualToString:self.rmg.localUser.peerID]) {
        if (!videoView) {
            videoView = [self creatVideoViewWith:user];
        }
        if (videoView.status == TKPlay_Audio || videoView.status == TKPlay_Both) {
            return;
        }
        [self.rmg playAudio:user.peerID completion:^(NSError *error) {
            TKPlayStatus status = videoView.status;
            if (status == TKPlay_None) {
                [self addSubview:videoView];
            }
            
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
            if (status <= TKPlay_Audio) {
                [videoView bringSubviewToFront:videoView.imageView];
            } else {
                [videoView sendSubviewToBack:videoView.imageView];
            }
            videoView.status = status;
            [self refreshVideo];
            [videoView setViewsToFront];
        }]; 
    }
}
- (void)unPlayAudioWithUser:(NSString *)peerID
{
    if ([peerID isEqualToString:_rmg.localUser.peerID]) {
        return;
    }
    __block VideoView *videoView = [self getVideoViewWithPeerID:peerID];
    if (!videoView) {
        return;
    }
    if (videoView.status == TKPlay_Video || videoView.status == TKPlay_None) {
        return;
    }
    [self.rmg unPlayAudio:peerID completion:^(NSError *error) {
        TKPlayStatus status = videoView.status;
        
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
        videoView.status = status;
        if (status == TKPlay_None) {
            [videoView removeFromSuperview];
            [self.videos removeObjectForKey:peerID];
            videoView = nil;
        } else if(status > TKPlay_Audio) {
            [videoView sendSubviewToBack:videoView.imageView];
        }
        
        [self refreshVideo];
    }];
}
- (void)refreshForPublishState:(TKPublishState)state user:(NSString *)peerID
{
    VideoView *view = [self getVideoViewWithPeerID:peerID];
    if (!view) {
        return;
    }
    switch (state) {
        case TKUser_PublishState_BOTH:
            [view sendSubviewToBack:view.imageView];
            break;
        case TKUser_PublishState_NONE:
            
            break;
        case TKUser_PublishState_AUDIOONLY:
            [view bringSubviewToFront:view.imageView];
            break;
        case TKUser_PublishState_VIDEOONLY:
            [view sendSubviewToBack:view.imageView];
            break;
            
        default:
            break;
    }
}
- (void)layoutSubviews
{
    [self refreshVideo];
}

- (VideoView *)getVideoViewWithPeerID:(NSString *)peerID
{
    if (!peerID || peerID.length == 0) {
        return nil;
    }
    return self.videos[peerID];
}
- (void)refreshVideo
{
    CGFloat gap = 10;
    CGFloat videoW = (self.width - (kVideoMax + 1) * gap) / kVideoMax;
    CGFloat x = gap;
    for (VideoView *view in self.videos.allValues) {
        view.frame = CGRectMake(x, 0, videoW, self.height);
        x += (videoW + gap);
        [self bringSubviewToFront:view];
    }
    
}
@end
