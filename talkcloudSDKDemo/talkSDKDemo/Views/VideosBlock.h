//
//  VideosBlock.h
//  talkSDKDemo
//
//  Created by MAC-MiNi on 2018/7/6.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TKRoomSDK/TKRoomSDK.h>
@class VideoView;

@interface VideosBlock : UIView
- (instancetype)initWithFrame:(CGRect)frame rmg:(TKRoomManager *)rmg;

- (void)playVideoWithUser:(TKRoomUser *)user;
- (void)unPlayVideoWithUser:(NSString *)peerID;
- (void)playAudioWithUser:(TKRoomUser *)user;
- (void)unPlayAudioWithUser:(NSString *)peerID;
- (void)refreshForPublishState:(TKPublishState)state user:(NSString *)peerID;
@end
