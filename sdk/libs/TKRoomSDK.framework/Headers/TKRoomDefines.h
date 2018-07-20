//
//  TKRoomDefines.h
//  TKRoomSDK
//
//  Created by MAC-MiNi on 2018/4/20.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define TK_Deprecated(string) __attribute__((deprecated(string)))
typedef void (^completion_block)(NSError *error);

#
#pragma mark - TKRoomWarningCode 警告码
#
typedef NS_ENUM(NSInteger, TKRoomWarningCode) {
    TKRoomWarning_UnKnow,
    TKRoomWarning_Microphone_NotWorking = 111,         //麦克风不可用
    TKRoomWarning_Micphone_InterruptionBegan,          // the system has interrupted your audio session,the interruption has began
    TKRoomWarning_Micphone_InterruptionEnded,          // the interruption has ended
    TKRoomWarning_AudioRouteChange_Headphones = 121,   //耳机
    TKRoomWarning_AudioRouteChange_BuiltInReceiver,    //听筒模式（手机靠近耳边）
    TKRoomWarning_AudioRouteChange_BuiltInSpeaker,     // 内置扬声器（外放）
    TKRoomWarning_AudioRouteChange_Bluetooth,          // 蓝牙
    
    TKRoomWarning_RequestAccessForVideo_Failed = 131,   //请求获取摄像头失败
    TKRoomWarning_RequestAccessForAudio_Failed = 132,   //请求获取麦克风失败
    
    TKRoomWarning_CheckRoom_Success                = 5001,    //CheckRoom 成功
    TKRoomWarning_ReConnectSocket_ServerChanged    = 5002,   //切换了服务器
};

#
#pragma mark - TKRoomErrorCode 错误码
#
typedef NS_ENUM(NSInteger, TKRoomErrorCode) {
    TKErrorCode_UnKnow = -2,
    TKErrorCode_Internal_Exception = -1,
    TKErrorCode_OK = 0,
    TKErrorCode_Not_Initialized = 101,
    TKErrorCode_Bad_Parameters = 102,
    TKErrorCode_Room_StateError = 103,
    TKErrorCode_Publish_StateError = 104,
    TKErrorCode_Stream_StateError = 105,
    TKErrorCode_Stream_NotFound = 106,
    

    TKErrorCode_Publish_NoAck                    = 401,
    TKErrorCode_Publish_RoomNotExist             = 402,
    TKErrorCode_Publish_RoomMaxVideoLimited      = 403,
    TKErrorCode_Publish_ErizoJs_Timeout          = 404,
    TKErrorCode_Publish_Agent_Timeout            = 405,
    TKErrorCode_Publish_UndefinedRPC_Timeout     = 406,
    TKErrorCode_Publish_AddingInput_Error        = 407,
    TKErrorCode_Publish_DuplicatedExtensionId    = 408,
    TKErrorCode_Publish_Unauthorized             = 409,
    
    TKErrorCode_Subscribe_RoomNotExist           = 501,
    TKErrorCode_Subscribe_StreamNotDefine        = 502,
    TKErrorCode_Subscribe_MediaRPC_Timeout       = 503,
    TKErrorCode_SubscribeStreamFail              = 504,
    
    TKErrorCode_ConnectSocketError               = 601,

    TKErrorCode_JoinRoom_WrongParam    = 701,// join room 参数错误
    
    TKErrorCode_CheckRoom_ServerOverdue          = 3001,    //服务器过期
    TKErrorCode_CheckRoom_RoomFreeze             = 3002,    // 公司被冻结
    TKErrorCode_CheckRoom_RoomDeleteOrOrverdue   = 3003,    //房间被删除或过期
    
    TKErrorCode_CheckRoom_RequestFailed          = 4001,    //CheckRoom 请求失败
    TKErrorCode_GetConfig_RequestFailed          = 4002,    //getconfig 请求失败
    TKErrorCode_CheckRoom_RoomNonExistent        = 4007,    //房间不存在
    
    TKErrorCode_CheckRoom_PasswordError          = 4008,    //房间密码错误
    TKErrorCode_CheckRoom_WrongPasswordForRole   = 4012,    //密码与身份不符
    TKErrorCode_CheckRoom_RoomNumberOverRun      = 4103,    //房间人数超限
    TKErrorCode_CheckRoom_RoomAuthenError        = 4109,    //认证错误
    TKErrorCode_CheckRoom_NeedPassword           = 4110,    //该房间需要密码，请输入密码
    TKErrorCode_CheckRoom_RoomPointOverrun       = 4112,    //企业点数超限
};
#
#pragma mark - TKMediaType 媒体类型
#
typedef NS_ENUM(NSInteger, TKMediaType) {
    TKMediaSourceType_unknow    = -1,
    TKMediaSourceType_camera    = 0,      //视频
    TKMediaSourceType_mic       = 11,
    TKMediaSourceType_file      = 101,    //本地电影共享
    TKMediaSourceType_screen    = 102,    //屏幕共享
    TKMediaSourceType_media     = 103,    //媒体文件 mp4、mp3
};
#
#pragma mark - TKPublishState 发布状态
#
typedef NS_ENUM(NSInteger, TKPublishState) {
    
    TKUser_PublishState_NONE          = 0,          //没有
    TKUser_PublishState_AUDIOONLY,                  //只有音频
    TKUser_PublishState_VIDEOONLY,                  //只有视频
    TKUser_PublishState_BOTH,                       //都有
    TKUser_PublishState_NONE_ONSTAGE                //音视频都没有但还在台上
};
#
#pragma mark - TKMediaState 媒体流发布状态
#
typedef NS_ENUM(NSInteger, TKMediaState) {
    TKMedia_Unpulished = 0,  //未发布
    TKMedia_Pulished = 1,    //发布
};
#
#pragma mark - TKRenderMode 渲染模式
#
typedef NS_ENUM(NSInteger, TKRenderMode) {
    TKRenderMode_fit = 0,  //等比拉伸
    TKRenderMode_adaptive, //等比拉伸，并占满全屏
};
#
#pragma mark - TKLogLevel 日志等级
#
typedef NS_ENUM(NSInteger, TKLogLevel) {
    TKLog_Verbose,  //等级最高，打印所有类型日志
    TKLog_Info,     //打印info、warning、error日志
    TKLog_Warning,  //打印warning、error日志
    TKLog_Error,    //打印error日志
    TKLog_None,     //不打印日志
};
#
#pragma mark - TKUserRoleType 用户角色
#
typedef NS_ENUM(NSInteger, TKUserRoleType) {
    TKUserType_Playback   = -1,   //回放
    TKUserType_Teacher    = 0,    //老师
    TKUserType_Assistant,         //助教
    TKUserType_Student,           //学生
    TKUserType_Live,              //直播
    TKUserType_Patrol             //巡课
};
#
#pragma mark - TKRecordType 录制件类型
#
typedef NS_ENUM(NSInteger, TKRecordType) {
    TKRecordType_RecordFile = 0,    //生成录制件
    TKRecordType_RecordList = 1,    //生成录制列表
    TKRecordType_RecordMp3File = 2, //只生成mp3
    TKRecordType_RecordMaxFile = 3, //同时生产mp3和mp4
};

typedef NS_ENUM(NSInteger, TKNetQuality) {
    TKNetQuality_Excellent = 1, //优
    TKNetQuality_Good,          //良
    TKNetQuality_Accepted,      //中
    TKNetQuality_Bad,           //差
    TKNetQuality_VeryBad,       //极差
    TKNetQuality_Down,
};
#
#pragma mark - TKVideoProfile 视频属性
#
@interface TKVideoProfile : NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger maxfps;
@end

#
#pragma mark - TKAudioFrame 音频数据
#
@interface TKAudioFrame : NSObject

/**
 number of samples in this frame
 */
@property (assign, nonatomic) NSInteger samples;

/**
 number of bytes per sample: 2 for PCM16
 */
@property (assign, nonatomic) NSInteger bytesPerSample;

/**
 number of channels (data are interleaved if stereo)
 */
@property (assign, nonatomic) NSInteger channels;

/**
 sampling rate
 */
@property (assign, nonatomic) NSInteger samplesPerSec;

@property (assign, nonatomic) NSInteger format;

/**
 data buffer
 */
@property (nonatomic) const void *buffer;
@end
#
#pragma mark - TKVideoFrame 视频数据
#
@interface TKVideoFrame : NSObject

/**
 width of video frame
 */
@property (assign, nonatomic) NSInteger width;

/**
 height of video frame
 */
@property (assign, nonatomic) NSInteger height;

/**
 stride of Y data buffer
 */
@property (assign, nonatomic) NSInteger yStride;

/**
 stride of U data buffer
 */
@property (assign, nonatomic) NSInteger uStride;

/**
 stride of V data buffer
 */
@property (assign, nonatomic) NSInteger vStride;

/**
 Y data buffer
 */
@property (nonatomic) const void *yBuffer;

/**
 U data buffer
 */
@property (nonatomic) const void *uBuffer;

/**
 V data buffer
 */
@property (nonatomic) const void *vBuffer;

/**
 rotation of this frame (0, 90, 180, 270)
 */
@property (assign, nonatomic) NSInteger rotation;

@end

#
#pragma mark - TKRoomProperty 房间属性
#
@interface TKRoomProperty : NSObject
@property (nonatomic, copy) NSString *mobilelayout;
@property (nonatomic, copy) NSString *padlayout;
@property (nonatomic, copy) NSString *realpoint;
@property (nonatomic, copy) NSString *realsilentpoint;
    //myself
/**
 自己的用户角色
 */
@property (nonatomic, strong) NSNumber *roomrole;

/**
 自己的ID
 */
@property (nonatomic, copy) NSString *thirdid;
    //room
/**
 公司ID
 */
@property (nonatomic, copy) NSString *companyid;

/**
 房间ID
 */
@property (nonatomic, copy) NSString *roomid;

/**
 房间类型 0:表示一对一教室  非0:表示一多教室
 */
@property (nonatomic, copy) NSString *roomtype;

/**
 房间名称
 */
@property (nonatomic, copy) NSString *roomname;

/**
 房间最大视频数
 */
@property (nonatomic, copy) NSString *maxvideo;
/**
 房间最大音频数
 */
@property (nonatomic, copy) NSString *maxaudio;

@property (nonatomic, strong) NSNumber *videotype;

/**
 房间最大分辨率 视频宽
 */
@property (nonatomic, copy) NSString *videowidth;
/**
 房间最大分辨率 视频高
 */
@property (nonatomic, copy) NSString *videoheight;
/**
 房间最大分辨率 视频fps
 */
@property (nonatomic, copy) NSString *videoframerate;

@property (nonatomic, copy) NSString *begintime;
@property (nonatomic, copy) NSString *newstarttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *newendtime;

/**
 房间文档服务器地址
 */
@property (nonatomic, copy) NSString *ClassDocServerAddr;
/**
 房间文档服务器备份地址
 */
@property (nonatomic, copy) NSString *ClassDocServerAddrBackup;
/**
 当前连接的服务器
 */
@property (nonatomic, copy) NSString *currentServer;
/**
 白板底色
 */
@property (nonatomic, copy) NSString *whiteboardcolor;

/**
 房间配置项
 */
@property (nonatomic, copy) NSString *chairmancontrol;

/**
 自定义奖杯
 */
@property (nonatomic, strong) NSArray *trophy;

/**
 模板id
 */
@property (nonatomic, copy) NSString *tplId;

/**
 皮肤id
 */
@property (nonatomic, copy) NSString *skinId;

/**
 皮肤资源
 */
@property (nonatomic, copy) NSString *skinResource;

@property (copy, nonatomic) NSString *vcodec;

@end

#
#pragma mark - TKRoomConfigration 房间设置的相关配置项
#
//配置项
@interface TKRoomConfigration : NSObject

/**
 自动上课
 */
@property (nonatomic, assign) BOOL autoStartClassFlag;

/**
 课堂结束时自动退出房间
 */
@property (nonatomic, assign) BOOL autoQuitClassWhenClassOverFlag;

/**
 是否允许学生关闭音视频
 */
@property (nonatomic, assign) BOOL allowStudentCloseAV;

/**
 是否隐藏上下课按钮
 */
@property (nonatomic, assign) BOOL hideClassBeginEndButton;

/**
 助教是否可以上台
 */
@property (nonatomic, assign) BOOL assistantCanPublish;

/**
 上课前是否发布视频
 */
@property (nonatomic, assign) BOOL beforeClassPubVideoFlag;

/**
 下课后不允许离开课堂
 */
@property (nonatomic, assign) BOOL forbidLeaveClassFlag;

/**
 自动开启音视频
 */
@property (nonatomic, assign) BOOL autoOpenAudioAndVideoFlag;

/**
 视频标注
 */
@property (nonatomic, assign) BOOL videoWhiteboardFlag;

/**
 MP4播放结束时是否自动关闭MP4播放的视频
 */
@property (nonatomic, assign) BOOL pauseWhenOver;

/**
 文档分类
 */
@property (nonatomic, assign) BOOL documentCategoryFlag;

/**
 按下课时间结束课堂
 */
@property (nonatomic, assign) BOOL endClassTimeFlag;

/**
 分组
 */
@property (nonatomic, assign) BOOL groupFlag;

/**
 自定义白板底色
 */
@property (nonatomic, assign) BOOL whiteboardColorFlag;
 
@end

#
#pragma mark - TKAudioStats 音频统计数据
#
@interface TKAudioStats : NSObject
/**
 带宽 bps
 */
@property (assign, nonatomic) NSInteger bitsPerSecond;
/**
 丢包数
 */
@property (assign, nonatomic) NSInteger packetsLost;

/**
 总包数
 */
@property (assign, nonatomic) NSInteger totalPackets;

/**
 延迟 毫秒
 */
@property (assign, nonatomic) NSInteger currentDelay;

/**
 抖动
 */
@property (assign, nonatomic) NSInteger jitter;

/**
 网络质量
 */
@property (assign, nonatomic) TKNetQuality netLevel;
@end
//丢包率  packetsLost/totalPackets  0~1%优 1%~3% 3%~5%中等 5~10%差  >10%极差
//延迟                              80ms  120ms  300ms  800ms  >800ms
#
#pragma mark - TKVideoStats 视频统计数据
#
@interface TKVideoStats : NSObject

/**
 带宽 bps
 */
@property (assign, nonatomic) NSInteger bitsPerSecond;

/**
 丢包数
 */
@property (assign, nonatomic) NSInteger packetsLost;

/**
 总包数
 */
@property (assign, nonatomic) NSInteger totalPackets;

/**
 延迟
 */
@property (assign, nonatomic) NSInteger currentDelay;

/**
 帧率
 */
@property (assign, nonatomic) NSInteger frameRate;

/**
 视频宽
 */
@property (assign, nonatomic) NSInteger frameWidth;

/**
 视频高
 */
@property (assign, nonatomic) NSInteger frameHeight;
/**
 网络质量
 */
@property (assign, nonatomic) TKNetQuality netLevel;

@end

