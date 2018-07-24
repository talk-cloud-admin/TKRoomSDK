//
//  TKRoomManager.h
//  TKRoomSDK
//
//  Created by MAC-MiNi on 2018/3/20.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKRoomDelegate.h"
#import "TKRoomDefines.h"

@class TKRoomUser;
@class TKRoomProperty;
 
NS_ASSUME_NONNULL_BEGIN
@interface TKRoomManager : NSObject
///-----------------------------------
/// @name Properties
///-----------------------------------

/**
 本地用户对象
 */
@property (nonatomic, strong, readonly) TKRoomUser *localUser;

/**
 是否在后台
 */
@property (nonatomic, assign) BOOL inBackground;

///-----------------------------------
/// @name Methods
///-----------------------------------

/**
 单例
 @return TKRoomManager单例
 */
+ (instancetype)instance;

/**
 销毁TKRoomManager单例
 */
+ (void)destory;

/**
 设置打印SDK日志等级
 
 @param level 日志等级
 @param logPath 日志需要写入沙盒的路径; 默认路径为：沙盒Documents/TKLog。日志等级为TKLog_None时，不会写入沙盒。
 */
+ (int)setLogLevel:(TKLogLevel)level logPath:(NSString * _Nullable)logPath;

/**
 设置AppID

 @param appKey appID
 @param optional 房间扩展信息
 */
- (int)initWithAppKey:(NSString *)appKey optional:(NSDictionary * _Nullable)optional;

/**
 设置AppID

 @param appKey appID
 */
- (int)registerAppKey:(NSString *)appKey TK_Deprecated("Will deprecated!!! use - (int)initWithAppKey:optional: replaced");

/**
 更改服务器
 
 @param serverName 更改服务器
 */
- (int)changeCurrentServer:(NSString *)serverName;

/**
 获取服务器列表

 @return NSArray<NSDictionary *>* 实例对象
 */
- (NSArray * _Nullable)getServerList;

/**
 设置TKRoomManagerDelegate 代理
 @param roomDelegate 实现了TKRoomManagerDelegate回调接口的对象
 */
- (int)registerRoomManagerDelegate:(id<TKRoomManagerDelegate> _Nullable)roomDelegate;

/**
 设置TKRoomManagerDelegate 和 白板消息 通知
 
 @param roomDelegate 实现了TKRoomManagerDelegate回调接口的对象
 @param notifyWB 是否需要房间白板通知

 */
- (int)registerRoomWhiteBoardDelegate:(id<TKRoomManagerDelegate> _Nullable)roomDelegate
                                andWB:(BOOL)notifyWB;
/**
 设置TKRoomManagerDelegate 和 白板消息 通知
 
 @param roomDelegate 实现了TKRoomManagerDelegate回调接口的对象
 @param notifyWB 是否需要房间白板通知

 */
- (int)registerRoomManagerPlaybackDelegate:(id<TKRoomManagerDelegate> _Nullable)roomDelegate
                                     andWB:(BOOL)notifyWB;

/**
 设置音视频数据 TKMediaFrameDelegate的代理

 @param mediaDelegate 实现了TKMediaFrameDelegate回调接口的对象
 */
- (int)registerMediaDelegate:(id<TKMediaFrameDelegate> _Nullable)mediaDelegate;
#pragma mark jion

/**
 进入房间
 
 @param host 服务器地址
 @param port 服务器端口
 @param nickname 本地用户的昵称
 @param roomParams Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param userParams  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 @param lowConsume  BOOL格式 是否低功率模式
 */
- (int)joinRoomWithHost:(NSString *)host
                    port:(int)port
                nickName:(NSString *)nickname
              roomParams:(NSDictionary *)roomParams
              userParams:(NSDictionary * _Nullable)userParams
             lowConsume:(BOOL)lowConsume TK_Deprecated("Will deprecated!!! use -(int)joinRoomWithHost:port:nickName:roomParams:userParams: replaced");

/**
 进入房间
 
 @param host 服务器地址
 @param port 服务器端口
 @param nickname 本地用户的昵称
 @param roomParams Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,userid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param userParams  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 */
- (int)joinRoomWithHost:(NSString *)host
                    port:(int)port
                nickName:(NSString *)nickname
              roomParams:(NSDictionary *)roomParams
              userParams:(NSDictionary * _Nullable)userParams;

/**
 进入回放房间
 
 @param host 服务器地址
 @param port 服务器端口
 @param nickname 本地用户的昵称
 @param roomParams Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,userid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param userParams  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 @param lowConsume  BOOL格式 是否低功率模式
 */
- (int)joinPlaybackRoomWithHost:(NSString *)host
                            port:(int)port
                        nickName:(NSString *)nickname
                      roomParams:(NSDictionary *)roomParams
                      userParams:(NSDictionary * _Nullable)userParams
                      lowConsume:(BOOL)lowConsume TK_Deprecated("Will deprecated!!! use -(int)joinPlaybackRoomWithHost:port:nickName:roomParams:userParams: replaced");


/**
 进入回放房间
 
 @param host 服务器地址
 @param port 服务器端口
 @param nickname 本地用户的昵称
 @param roomParams Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param userParams  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 */
- (int)joinPlaybackRoomWithHost:(NSString *)host
                            port:(int)port
                        nickName:(NSString *)nickname
                      roomParams:(NSDictionary *)roomParams
                      userParams:(NSDictionary * _Nullable)userParams;

/**
 离开房间
 
 @param completion 离开房间后的回调
 */
- (int)leaveRoom:(completion_block _Nullable)completion;

/**
 强行离开房间
 
 @param force YES:强行退出 NO:不强行退出
 @param completion 离开房间后的回调
 */
- (int)leaveRoom:(BOOL)force Completion:(completion_block _Nullable)completion;

/**
 获取房间属性
 */
- (TKRoomProperty *)getRoomProperty;
/**
 获取房间配置项
 */
- (TKRoomConfigration *)getRoomConfigration;
/**
 获取房间用户
 @param peerId 用户ID
 @return TKRoomUser
 */
- (TKRoomUser *)getRoomUserWithUId:(NSString *)peerId;

/**
 大规模房间时获取指定用户ID的用户
 在非大规模时使用- (TKRoomUser *)getRoomUserWithUId: 获取房间用户
 @param peerID 指定的用户ID
 @param callback 回调Block
 */
- (int)getRoomUserWithPeerId:(NSString *)peerID callback:(void (^)(TKRoomUser *_Nullable user, NSError *_Nullable error))callback;
/**
 大规模教室时获取房间人数（可根据用户角色获取人数）

 @param role 用户角色
 @param callback 人数的callBack
 */
- (int)getRoomUserNumberWithRole:(NSArray * _Nullable)role search:(NSString * _Nullable)search callback:(void (^)(NSInteger num, NSError *error))callback;

/**
 大规模教室时获取房间用户信息（用户列表）

 @param role 用户角色
 @param start 起始位置
 @param max 需要获取的人数
 @param callback 获取到的用户信息callback
 */
- (int)getRoomUsersWithRole:(NSArray * _Nullable)role startIndex:(NSInteger)start maxNumber:(NSInteger)max search:(NSString * _Nullable)search order:(NSDictionary * _Nullable)order callback:(void (^)(NSArray <TKRoomUser *>* _Nonnull users , NSError *error) )callback;

/**
 设置视频分辨率

 @param profile TKVideoProfile实例对象
 */
- (int)setVideoProfile:(TKVideoProfile *)profile;
/**
 修改某个用户的一个属性
 
 @param peerID 要修改的用户ID
 @param tellWhom 要将此修改通知给谁。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param key 要修改的用户属性名字，可以是您自定义的名字
 @param value 要修改的用户属性，可以是Number、String、NSDictionary或NSArray
 @param completion 完成的回调
 */
- (int)changeUserProperty:(NSString *)peerID
                 tellWhom:(NSString *)tellWhom
                      key:(NSString *)key
                    value:(NSObject *)value
               completion:(completion_block _Nullable)completion;

/**
 修改某个用户的一个属性
 
 @param peerID 要修改的用户ID
 @param tellWhom 要将此修改通知给谁。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 更改的属性 NSDictionary
 @param completion 完成的回调
 */
- (int)changeUserProperty:(NSString *)peerID
                 tellWhom:(NSString *)tellWhom
                     data:(NSDictionary *)data
               completion:(completion_block _Nullable)completion;
/**
 改变指定了角色的用户属性（适用于高并发房间）
 
 @param roles 指定的用户角色的数组
 @param tellWhom 要将此修改通知给谁。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param properties 要修改的属性
 @param completion 完成的回调
 */
- (int)changeUserPropertyByRole:(NSArray *)roles
                       tellWhom:(NSString *)tellWhom
                       property:(NSDictionary *)properties
                     completion:(completion_block _Nullable)completion;

/**
 批量改变指定了用户ID的用户属性（适用于高并发房间）
 
 @param peerIDs 指定了用户ID的用户ID数组
 @param tellWhom 要将此修改通知给谁。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param properties 要修改的属性
 @param completion 完成的回调
 */
- (int)batchChangeUserPropertyByIds:(NSArray <NSString *>*)peerIDs
                           tellWhom:(NSString *)tellWhom
                           property:(NSDictionary *)properties
                         completion:(completion_block _Nullable)completion;
/**
 修改某个用户的音视频发布状态
 
 @param peerID 该用户的peerID，可以是自己的，也可以是其他人的
 @param publishState 0：不发布；1：只发布音频；2：只发布视频；3：发布音视
 @param block 完成的回调
 */
- (int)changeUserPublish:(NSString *)peerID
            publishState:(TKPublishState)publishState
              completion:(completion_block _Nullable)block;

/**
 设置发布音视频 属性

 @param attributes 属性
 @return 错误码
 */
- (int)setAttributes:(NSDictionary *)attributes TK_Deprecated("Will deprecated!!!");
/**
 发布自己的视频
 @param completion 完成的回调
 */
- (int)publishVideo:(completion_block _Nullable)completion;
/**
 停止发布自己的视频
 @param completion 完成的回调
 */
- (int)unPublishVideo:(completion_block _Nullable)completion;
/**
 发布自己的音频
 @param completion 完成的回调
 */
- (int)publishAudio:(completion_block _Nullable)completion;

/**
 停止发布自己的视频
 @param completion 完成的回调
 */
- (int)unPublishAudio:(completion_block _Nullable)completion;
/**
 发送聊天信息功能函数
 @param message 发送的聊天消息文本 , 支持 NSString 、NSDictionary
 @param toID 发送给谁 , NSString  要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param extension 扩展的发送的聊天消息数据,例如：消息类型； 支持 NSString(JSON字符串string) 、NSDictionary
 */
- (int)sendMessage:(NSObject *)message
              toID:(NSString *)toID
     extensionJson:(NSObject * _Nullable)extension;

/**
 发布自定义消息
 
 @param msgName 消息名字
 @param msgID ：消息id
 @param toID 要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param save ：是否保存，详见3.5：自定义信令
 @param completion 完成的回调
 */
- (int)pubMsg:(NSString *)msgName
         msgID:(NSString *)msgID
          toID:(NSString *)toID
          data:(NSObject *)data
          save:(BOOL)save
    completion:(completion_block _Nullable)completion;

//expires ：这个消息，多长时间结束，以秒为单位，是相对时间。一般用于classbegin，给定一个相对时间
- (int)pubMsg:(NSString *)msgName
         msgID:(NSString *)msgID
          toID:(NSString *)toID
          data:(NSObject *)data
          save:(BOOL)save
associatedMsgID:(NSString * _Nullable)associatedMsgID
associatedUserID:(NSString * _Nullable)associatedUserID
       expires:(NSTimeInterval)expires
    completion:(completion_block _Nullable)completion;

//expendData:拓展数据，与msgName同级
- (int)pubMsg:(NSString *)msgName
        msgID:(NSString *)msgID
        toID:(NSString *)toID
        data:(NSObject *)data
        save:(BOOL)save
extensionData:(NSDictionary * _Nullable)extensionData
completion:(completion_block _Nullable)completion;

/**
 删除自定义消息
 @param msgName 消息名字
 @param msgID ：消息id
 @param toID 要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param completion 完成的回调
 */
- (int)delMsg:(NSString *)msgName
        msgID:(NSString *)msgID
         toID:(NSString *)toID
         data:(NSObject *)data
   completion:(completion_block _Nullable)completion;
/**
 对同一个用户，可以调用多次此函数。当传入的view和上次传入的一致时，函数不执行任何操作，直接返回成功；当传入的view和上次传入的不一致时，换用新的view播放该用户的视频
 
 @param peerID 用户Peerid
 @param completion 设置用于播放视频的view的block
 */
- (int)playVideo:(NSString *)peerID
      renderType:(TKRenderMode)renderType
          window:(UIView *)window
      completion:(completion_block _Nullable)completion;
/**
 播放某个用户的音频
 
 @param peerID 用户Peerid
 @param completion 取消播放某个音频后的block
 */
- (int)playAudio:(NSString *)peerID completion:(completion_block _Nullable)completion;

/**
 停止播放某个用户的视频
 
 @param peerID 用户Peerid
 @param completion 取消播放某个视频后的block
 */
- (int)unPlayVideo:(NSString *)peerID completion:(completion_block _Nullable)completion;
/**
 停止播放某个用户的音频
 
 @param peerID 用户Peerid
 @param completion 取消播放某个音频后的block
 */
- (int)unPlayAudio:(NSString *)peerID completion:(completion_block _Nullable)completion;

/**
 发布流媒体
 
 @param mediaPath 文件的url
 @param toID 发布媒体流给谁 @"__all":所有人 @"__none":谁都不发 @"__allExceptSender":除了自己 其他：某个特用户
 @param attributes 参数
 @param completion 发布媒体流后的回调
 */
- (int)startShareMediaFile:(NSString *)mediaPath
                    isVideo:(BOOL)isVideo
                       toID:(NSString *)toID
                 attributes:(NSDictionary *)attributes
                      block:(completion_block _Nullable)completion;

/**
 取消媒体流
 
 @param completion  取消媒体流后的回调
 */
- (int)stopShareMediaFile:(completion_block _Nullable)completion;
/**
 播放媒体流
 
 @param peerId 用户id
 @param completion 播放后的回调
 */
- (int)playMediaFile:(NSString *)peerId
          renderType:(TKRenderMode)renderType
           window:(UIView *)window
          completion:(completion_block _Nullable)completion;
/**
 停止播放媒体流
 
 @param peerId 用户id
 @param completion 播放后的回调
 */
- (int)unPlayMediaFile:(NSString *)peerId completion:(completion_block _Nullable)completion;
/**
 暂停媒体流
 
 @param pause 暂停
 */
- (int)pauseMediaFile:(BOOL)pause;

/**
 设置进度
 
 @param pos 媒体流的位置
 */
- (int)seekMediaFile:(NSTimeInterval)pos;
/**
 设置声音
 
 @param volume 音量 1-10
 */
//todo 
- (int)setRemoteAudioVolume:(CGFloat)volume peerId:(NSString *)peerId type:(TKMediaType)type;
/**
 回放拖动播放滑块
 
 @param positionTime 回放的时间
 */
- (int)seekPlayback:(NSTimeInterval)positionTime;

/**
 停止回放
 */
- (int)pausePlayback;

/**
 开始回放
 */
- (int)playback;

/**
 播放桌面共享
 
 @param peerID 共享桌面的用户id
 @param completion 播放共享桌面后的回调
 */
- (int)playScreen:(NSString *)peerID
       renderType:(TKRenderMode)renderType
        window:(UIView *)window
       completion:(completion_block _Nullable)completion;


/**
 关闭共享桌面
 
 @param peerID 共享桌面的用户id
 @param completion 关闭共享桌面的回调
 */
- (int)unPlayScreen:(NSString *)peerID completion:(completion_block _Nullable)completion;

/**
 播放电影
 
 @param peerID 共享电影文件的用户id
 @param completion 播放电影文件后的回调
 */
- (int)playFile:(NSString *)peerID
     renderType:(TKRenderMode)renderType
         window:(UIView *)window
     completion:(completion_block _Nullable)completion;


/**
 关闭电影
 
 @param peerID 共享电影文件的用户id
 @param completion 关闭共享电影文件的回调
 */
- (int)unPlayFile:(NSString *)peerID completion:(completion_block _Nullable)completion;

/**
 录制用户的视频流
 
 @param peerId 用户id
 @param convert 0 不转换, 1 webm, 2 mp4
 @param completion 回调block，第一个参数为0时，表示成功，非0表示失败；第二个参数为视频路径。
 */
- (int)startRecordUser:(NSString *)peerId
               convert:(NSInteger)convert
            completion:(void (^)(NSInteger ret, NSString *path))completion;

/**
 结束用户的视频流录制
 
 @param peerId 用户id
 @param completion 回调block，参数为0，表示成功；非0表示失败。
 */
- (int)stopRecordUser:(NSString *)peerId completion:(void (^)(NSInteger, NSString *path))completion;

/**
 开始服务器录制
 
 @param recordType 录制类型
 @param convert 录制件数据格式，只有在recordtype = 0与1的情况下起作用。
                0: 表示不转换(mkv格式）
                1：表示webm(recordtype其他值时，固定状态)
                2：表示 mp4
 @param layout 只有在recordtype = 3的情况下起作用。 0：横屏，1：竖屏
 @param expiresabs expiresabs 录制时长
 @param expires expires 录制结束时的时间戳
 @return error code
 */
- (int)startServerRecord:(TKRecordType)recordType convert:(NSInteger)convert layout:(NSInteger)layout expiresabs:(NSInteger)expiresabs expires:(NSInteger)expires;

/**
 停止服务器录制
 */
- (int)stopServerRecord;
/**
 切换纯音频教室
 
 @param isSwitch yes：纯音频教室。no：音视频教室
 */
- (int)switchOnlyAudioRoom:(BOOL)isSwitch;

/**
 将一个用户踢出房间
 
 @param peerID 用户id
 @param reason 原因
 @param completion 完成的回调
 */
- (int)evictUser:(NSString *)peerID evictReason:(NSNumber *)reason completion:(completion_block _Nullable)completion;

/**
 将一个用户踢出房间
 
 @param peerID 该用户的id
 @param completion 完成的回调
 */
- (int)evictUser:(NSString *)peerID completion:(completion_block _Nullable)completion;

/**
 切换本地摄像头
 
 @param isFront  true：使用前置摄像头；false：使用后置摄像头
 */
- (int)selectCameraPosition:(BOOL)isFront;

/**
 当前本地摄像头是否被启用
 
 @return true：摄像头可用；false：摄像头被禁用
 */
- (BOOL)isVideoEnabled;

/**
 设置启用/禁用摄像头
 
 @param enable ：true：启用摄像头；false：禁用摄像头
 */
- (int)enableVideo:(BOOL)enable;

/**
 当前本地麦克风是否被启用
 
 @return ：true：麦克风可用；false：麦克风被静音
 */
- (BOOL)isAudioEnabled;

/**
 自己音频的开启关闭
 
 @param enable YES:开启 NO:关闭
 */
- (int)enableAudio:(BOOL)enable;

/**
 其他人音频的开启关闭
 
 @param enable YES:开启 NO:关闭
 */
- (int)enableOtherAudio:(BOOL)enable;

/**
 是否外放
 
 @param use YES:外放 NO:关闭
 */
- (int)useLoudSpeaker:(BOOL)use;

/**
 禁用本地音频
 
 @param disable 是否禁用
 */
- (int)disableMyAudio:(BOOL)disable;

/**
 禁用本地视频
 
 @param disable 是否禁用
 */
- (int)disableMyVideo:(BOOL)disable;

/**
 设置视频方向
 @param orientation 设备取向
 */
- (int)setVideoOrientation:(UIDeviceOrientation)orientation;

/**
 播放音频文件,只支持播放wav格式(要求Sample rate: 48k, Bits per sample:16kHz)

 @param filePath 文件地址
 @param loop 是否循环播放
 @return 返回一个播放ID
 */
- (int)startPlayAudioFile:(NSString *)filePath loop:(BOOL)loop;

/**
 停止播放音频

 @param channel 播放ID
 */
- (int)stopPlayAudioFile:(int)channel;

@end
NS_ASSUME_NONNULL_END
