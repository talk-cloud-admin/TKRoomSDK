//
//  TKRoomWhiteBoardNotification.h
//  TKRoomSDK
//
//  Created by MAC-MiNi on 2018/5/30.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#ifndef TKRoomWhiteBoardNotification_h
#define TKRoomWhiteBoardNotification_h

/*=================================TKRoomWhiteBoard Notification====================================//
 *********************如果需要使用TalkCloud教室白班功能，需要监听以下 关于白班相关的通知***********************
 =================================TKRoomWhiteBoard Notification====================================*/

/* key for TKRoomWhiteBoardNotification userInfo*/
/* value is an id*/
FOUNDATION_EXTERN NSString * const TKWhiteBoardNotificationUserInfoKey;


//进入教室，checkRoom相关通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnCheckRoomNotification;
//用户属性改变通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRoomUserPropertyChangedNotification;
//有用户离开通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRoomUserLeavedNotification;
//有用户进入通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRoomUserJoinedNotification;
//大并发房间用户上台通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnBigRoomUserPublishedNotification;
//自己被踢出教室通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnSelfEvictedNotification;
//收到远端pubMsg消息通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRemotePubMsgNotification;
//收到远端delMsg消息的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRemoteDelMsgNotification;
//连接教室的通知
/* key for TKWhiteBoardOnRoomConnectedNotification userInfo*/
/* value is an id*/
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnRoomConnectedCodeKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnRoomConnectedRoomMsgKey;

FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRoomConnectedNotification;
//断开链接的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRoomDisconnectNotification;
//重连服务器次数的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnReconnectingTimesNotification;
//回放总时长的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardReceivePlaybackDurationNotification;
//回放结束的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardPlaybackEndNotification;
//更新回放时间的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardPlaybackUpdateTimeNotification;
//教室文件列表的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardFileListNotification;
//教室消息列表的通知
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnRemoteMsgListAddKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnRemoteMsgListKey;
//
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnRemoteMsgListNotification;
//关于共享媒体视频状态的通知
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnShareMediaStateExtensionIdKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnShareMediaStateKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardOnShareMediaStateExtensionMsgKey;

FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnShareMediaStateNotification;
//更新共享媒体视频播放进度的通知
FOUNDATION_EXTERN NSString * const TKWhiteBoardUpadteMediaStreamDurationKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardUpadteMediaStreamPositionKey;
FOUNDATION_EXTERN NSString * const TKWhiteBoardUpadteMediaStreamPlayingKey;

FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardUpdateMediaStreamNotification;
//收到媒体视频第一帧画面的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardMediaFirstFrameLoadedNotification;
//关于画笔消息列表的通知
FOUNDATION_EXTERN NSNotificationName const TKWhiteBoardOnMsgListNotification;

#endif /* TKRoomWhiteBoardNotification_h */
