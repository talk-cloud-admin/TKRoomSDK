#  SDK版本更新说明
版本号：2.2.8
时间：2018.07.20

1、修改TKRoomManager 接口函数

    1.1、修改 - (int)setLogLevel:(TKLogLevel)level logPath:(NSString *)logPath;完善将日志写入沙盒功能。默认路径为：沙盒Documents/TKLog
    1.2、添加 - (int)initWithAppKey:(NSString *)appKey optional:(NSDictionary * _Nullable)optional; 设置appID以及设置房间扩展信息。
    即将废弃 - (int)registerAppKey:(NSString *)appKey;接口。

版本号：2.2.7
时间：2018.07.17

1、添加sdk工具类TKUtils

    1.1、+ (NSInteger)getCPUCores; 获取cpu核数
    1.2、+ (NSString *)getCPUType; 获取cpu类型
    1.3、+ (NSString *)getCPUUsage;获取cpu使用率
    1.4、+ (NSUInteger)getTotalMemory; 获取总物理内存
    1.5、+ (NSUInteger)getResidentMemory; 获取当前App内存使用
2、添加TKRoomManagerDelegate回调函数

    2.1添加 纯音频 与音视频 教室切换的回调
    - (void)roomManagerOnAudioRoomSwitch:(NSString *)fromId onlyAudio:(BOOL)onlyAudio;


版本号：2.2.6
时间：2018.07.13
1、添加TKRoomManagerDelegate回调函数

    1.1、添加视频数据统计回调  
        - (void)roomManagerOnVideoStatsReport:(NSString *)peerId stats:(TKVideoStats *)stats;
    1.2、添加音频数据统计回调
        - (void)roomManagerOnAudioStatsReport:(NSString *)peerId stats:(TKAudioStats *)stats;

版本号：2.2.5
时间：2018.07.05
1、修改TKRoomManager 接口函数

    1.1、添加 - (int)setLogLevel:(TKLogLevel)level logPath:(NSString *)logPath;设置sdk日志打印等级和写入沙盒文件
2、修复bug

    2.1、修复SDK请求 摄像头 和 麦克风 授权，以及授权失败的回调，- (void)roomManagerDidOccuredWaring:(TKRoomWarningCode)code; code码参照TKRoomWarningCode中TKRoomWarning_RequestAccessForVideo_Failed和TKRoomWarning_RequestAccessForAudio_Failed；授权失败亦可进入房间。
    2.2、修复测试bug。


版本号：2.2.4
时间：2018.06.25
1、添加音视频数据回调函数代理 protocol：TKMediaFrameDelegate

    - (void)onCaptureAudioFrame:(TKAudioFrame *)frame sourceType:(TKMediaType)type;

    - (void)onCaptureVideoFrame:(TKVideoFrame *)frame sourceType:(TKMediaType)type;

    - (void)onRenderAudioFrame:(TKAudioFrame *)frame uid:(NSString *)peerId sourceType:(TKMediaType)type;

    - (void)onRenderVideoFrame:(TKVideoFrame *)frame uid:(NSString *)peerId sourceType:(TKMediaType)type;
    接口详情说明见，TKRoomDelegate.h 头文件注释；

2、修改TKRoomManagerDelegate回调接口

    2.1 删去TKRoomManagerDelegate代理回调 - (void)roomManagerRoomJoined(NSError *error)接口中error参数，更新后接口为 - (void)roomManagerRoomJoined;
    2.2 添加 - (void)roomManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume;关于音频音量的实时回调接口；

3、修改TKRoomManager 接口函数

    3.1 修改 - (int)registerRoomWhiteBoardDelegate:(id<TKRoomManagerDelegate> _Nullable)roomDelegate andWB:(BOOL)notifyWB;
    关于修改白板代理设置参数说明：
    如需要接受白板消息，notifyWB设置为YES，并且监听TKRoomWhiteBoardNotification.h头文件中的白板相关的通知；
    否则可以设置notifyWB为NO，并且不会收到TKRoomWhiteBoardNotification相关的白板消息通知；
    
    3.2 添加 - (int)registerMediaDelegate:(id<TKMediaFrameDelegate> _Nullable)mediaDelegate;
    设置音视频数据回调的代理；
    
    3.3 添加 - (int)setVideoOrientation:(UIDeviceOrientation)orientation; 设置视频采集方向；

    3.4 添加 - (int)registerAppKey:(NSString *)appKey;设置AppID，留以后扩展使用；
    3.5 修复插入耳机进房间，音频可以切换到耳机模式；
    3.6 修改 - (int)enableAudio:(BOOL)enable;接口不能关闭自己音频问题；
    
4、SDK添加支持模拟器调试，可以支持armv7、arm64、i386、x86_64 。

版本号：2.2.0
时间：历史版本
