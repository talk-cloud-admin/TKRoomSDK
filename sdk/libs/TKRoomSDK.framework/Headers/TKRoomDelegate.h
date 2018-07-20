//
//  TKRoomDelegate.h
//  TKRoomSDK
//
//  Created by MAC-MiNi on 2018/3/20.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//
#import "TKRoomDefines.h"

#pragma mark - TKRoomManagerDelegate
@protocol TKRoomManagerDelegate<NSObject>

@optional
/**
    成功进入房间
 */
- (void)roomManagerRoomJoined;

/**
    已经离开房间
 */
- (void)roomManagerRoomLeft;

// 发生错误 回调
- (void)roomManagerDidOccuredError:(NSError *)error;
// 发生警告 回调
- (void)roomManagerDidOccuredWaring:(TKRoomWarningCode)code;

/**
    有用户进入房间
    @param peerID 用户ID
    @param inList true：在自己之前进入；false：在自己之后进入
 */
- (void)roomManagerUserJoined:(NSString *)peerID inList:(BOOL)inList;
/**
    有用户离开房间
    @param peerID 用户ID
 */
- (void)roomManagerUserLeft:(NSString *)peerID;
/**
    自己被踢出房间
    @param reason 被踢原因
 */
- (void)roomManagerKickedOut:(NSDictionary *)reason;
/**
    有用户的属性发生了变化
    @param peerID 用户ID
    @param properties 发生变化的属性
    @param fromId 修改用户属性消息的发送方的id
 */
- (void)roomManagerUserPropertyChanged:(NSString *)peerID
                            properties:(NSDictionary*)properties
                                fromId:(NSString *)fromId;

/**
    用户视频状态变化
    @param peerID 用户ID
    @param state 视频发布状态
 */

- (void)roomManagerPublishStateWithUserID:(NSString *)peerID publishState:(TKPublishState)state;
/**
    收到自定义信令 发布消息
    @param msgID 消息id
    @param msgName 消息名字
    @param ts 消息时间戳
    @param data 消息数据，可以是Number、String、NSDictionary或NSArray
    @param fromID  消息发布者的ID
    @param inlist 是否是inlist中的信息
 */
- (void)roomManagerOnRemotePubMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID
                                    inList:(BOOL)inlist
                                        ts:(long)ts;

/**
    收到自定义信令 删去消息
    @param msgID 消息id
    @param msgName 消息名字
    @param ts 消息时间戳
    @param data 消息数据，可以是Number、String、NSDictionary或NSArray
    @param fromID  消息发布者的ID
    @param inlist 是否是inlist中的信息
 */
- (void)roomManagerOnRemoteDelMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID 
                                    inList:(BOOL)inlist
                                        ts:(long)ts;
/**
    收到聊天消息
    @param message 聊天消息内容
    @param peerID 发送者用户ID
    @param extension 消息扩展信息（用户昵称、用户角色等等）
 */
- (void)roomManagerMessageReceived:(NSString *)message
                            fromID:(NSString *)peerID
                         extension:(NSDictionary *)extension;
/**
 视频数据统计
 
 @param peerId 用户ID
 @param stats 数据信息
 */
- (void)roomManagerOnVideoStatsReport:(NSString *)peerId stats:(TKVideoStats *)stats;
/**
 音频数据统计
 
 @param peerId 用户ID
 @param stats 数据信息
 */
- (void)roomManagerOnAudioStatsReport:(NSString *)peerId stats:(TKAudioStats *)stats;
/**
 用户的音频音量大小变化的回调

 @param peeID 用户ID
 @param volume 音量大小（0 - 32670）
 */
- (void)roomManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume;

/**
 纯音频 与音视频 教室切换
 
 @param fromId 用户ID  切换房间模式的用户ID
 @param onlyAudio 是否是纯音频
 */
- (void)roomManagerOnAudioRoomSwitch:(NSString *)fromId onlyAudio:(BOOL)onlyAudio;

/**
    回放时收到聊天消息
    @param message 聊天消息内容
    @param peerID 发送者用户ID
    @param ts 发送消息的时间戳
    @param extension 消息扩展信息（用户昵称、用户角色等等）
 */
- (void)roomManagerPlaybackMessageReceived:(NSString *)message
                                    fromID:(NSString *)peerID
                                        ts:(NSTimeInterval)ts
                                 extension:(NSDictionary *)extension;

/**
    在没有发布或订阅成功之前，发布3次失败或订阅3次失败通知上层有网路问题。
 */
- (void)roomManagerReportNetworkProblem;

/**
    网络环境发生变化，进行提示
 */
- (void)roomManagerReportNetworkChanged;



#pragma mark meidia
/**
    用户媒体流发布状态 变化回调
    @param peerId 用户id
    @param state 0:取消  非0：发布
    @param message 扩展消息
 */
- (void)roomManagerOnShareMediaState:(NSString *)peerId
                               state:(TKMediaState)state
                    extensionMessage:(NSDictionary *)message;

/**
    更新媒体流的信息回调
    @param duration 媒体流当前播放的时间点
    @param pos 媒体流当前的进度
    @param isPlay 播放（YES）暂停（NO）
 */
- (void)roomManagerUpdateMediaStream:(NSTimeInterval)duration
                                 pos:(NSTimeInterval)pos
                              isPlay:(BOOL)isPlay;

/**
    媒体流加载出第一帧画面回调
 */
- (void)roomManagerMediaLoaded;

#pragma mark screen
/**
    用户桌面共享状态 变化回调
    @param peerId 用户id
    @param state 状态0:取消  非0：发布
    @param message 扩展消息
 */
- (void)roomManagerOnShareScreenState:(NSString *)peerId
                                state:(TKMediaState)state
                     extensionMessage:(NSDictionary *)message;

#pragma mark file
/**
    用户电影共享状态 变化回调
    @param peerId 用户id
    @param state 状态0:取消  非0：发布
    @param message 扩展消息
 */
- (void)roomManagerOnShareFileState:(NSString *)peerId
                              state:(TKMediaState)state
                   extensionMessage:(NSDictionary *)message;

#pragma mark playback

/**
    获取到回放总时长的回调
    @param duration 回放的总时长
 */
- (void)roomManagerReceivePlaybackDuration:(NSTimeInterval)duration;

/**
    回放时接收到从服务器发来的回放进度变化
    @param time 变化的时间进度
 */
- (void)roomManagerPlaybackUpdateTime:(NSTimeInterval)time;

/**
    回放时清理
 */
- (void)roomManagerPlaybackClearAll;

/**
    回放播放完毕
 */
- (void)roomManagerPlaybackEnd;

@end

#pragma mark - TKMediaFrameDelegate
@protocol TKMediaFrameDelegate<NSObject>

///******该部分回调函数 均不是线程安全的******///

@optional
/**
 本地采集的音频数据

 @param frame 音频数据
 @param type 采集源
 */
- (void)onCaptureAudioFrame:(TKAudioFrame *)frame sourceType:(TKMediaType)type;
/**
 本地采集的视频数据
 
 @param frame 视频数据
 @param type 采集源
 */
- (void)onCaptureVideoFrame:(TKVideoFrame *)frame sourceType:(TKMediaType)type;

/**
 收到远端音频数据

 @param frame 音频数据
 @param peerId 用户ID
 @param type 采集源
 */
- (void)onRenderAudioFrame:(TKAudioFrame *)frame uid:(NSString *)peerId sourceType:(TKMediaType)type;
/**
 收到远端视频数据
 
 @param frame 视频数据
 @param peerId 用户ID
 @param type 采集源
 */
- (void)onRenderVideoFrame:(TKVideoFrame *)frame uid:(NSString *)peerId sourceType:(TKMediaType)type;
@end



