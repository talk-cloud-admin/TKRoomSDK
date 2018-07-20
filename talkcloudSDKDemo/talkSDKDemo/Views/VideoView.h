//
//  VideoView.h
//  TalkSDKDemo
//
//  Created by MAC-MiNi on 2018/3/19.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TKRoomSDK/TKRoomSDK.h>


typedef  NS_ENUM(NSInteger,TKPlayStatus) {
    TKPlay_None,
    TKPlay_Audio,
    TKPlay_Video,
    TKPlay_Both,
};

@interface VideoView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TKRoomUser *roomUser;
@property (nonatomic, strong) UIView *contentView;
@property (assign, nonatomic) TKPlayStatus status;

- (instancetype)initWithRoomMgr:(TKRoomManager *)mgr roomUser:(TKRoomUser *)user;
- (void)setVideoBackGroundColor:(UIColor *)color;
- (void)setViewsToFront;
@end
