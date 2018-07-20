# TKRoomSDK
TalkCloud SDK 简介
北京拓课网络科技有限公司由国内顶尖的音视频通讯专家创立，致力于用可靠的音视频技术服务在线教育产业。公司基于新一代通信协议标准打造的拓课云课堂，真正做到全平台互通，轻松实现国际间实时互动教学直播，丰富的API接口及SDK,可帮助机构更快速的接入原有业务系统，并且可以根据业务场景，定制开发相应的功能。
TalkCloud SDK for iOS 是专为iOS平台研发，基于WebRTC协议架构的。拓课云产品具有良好的普适性，支持全终端、全平台接入，从手机、PAD到PC、MAC，从iOS、Android到Windows，都可以运行拓课云产品，而强大的无客户端的网页式交互能力，更是最大程度上方便了数量众多、设备复杂、环境复杂、应用水平较低的学生群体。让他们可以无需安装、快速上手，让应用的学习成本、操作成本几乎为零，也让运营者的推广和教育变得更加便利。    
针对移动设备CPU处理能力不高，影响音视频并发效率的状况，拓课云进行了针对性的GPU 技术优化，提高了移动设备的音视频并发能力，降低了CPU 占用和电力消耗。


### 1、集成TalkCloud SDK for iOS
#### 1.1、Cocoapods安装
```pod 'TKRoomSDK', '~> 0.0.1'```
#### 1.2、工程设置
1. Build Settings: 
- Build Settings -> Linking -> Other Linker Flags -> -all_load
- Build Settings -> Build Options -> Enable Bitcode -> NO
- Build Settings -> Build Options -> Alway Embed Swift Standard Libraries -> YES


2. Build Phases:
- Build Phases->Copy FIles->Destination->选择为Frameworks
- Build Phases->CopyFiles->name->添加 TKRoomSDK.framework

3. Info：
- info.plist -> Privacy - Camera Usage Description  -> 主人需要您的同意，才能访问相机；
- info.plist -> Privacy - Microphone Usage Description -> 主人需要您的同意，才能使用麦克风；
- info.plist -> Privacy - Photo Library Usage Description -> 主人需要您的同意，才能访问相册；
- info.plist -> Privacy - Bluetooth Peripheral Usage Description -> 主人需要您的同意，才能使用蓝牙；
4. 设置App后台运行模式，如需要可以设置如下：
- Capablities->Background Modes->设置成ON->勾选 Audio,AirPlay,and Picture in Picture


#### 2 用法
具体用法，参考工程内“TalkCloudSDK_iOS接口文档”

#### 3 FAQ
1、Q：SDK支持哪些CPU版本？
A：TalkCould iOS SDK目前可以支持arm64、armv7、i386、x86_64；

2、Q：SDK是静态库还是动态库？
A：TalkCould iOS SDK是动态库；

3、Q:    SDK最低支持iOS版本？
A： SDK最低支持到iOS 8.0。





