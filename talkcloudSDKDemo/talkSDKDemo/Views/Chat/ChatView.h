//
//  ChatView.h
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//  聊天界面

#import <UIKit/UIKit.h>

@interface ChatView : UIView

@property (nonatomic, assign, readonly) BOOL isHide;

- (void)show;
- (void)hide;

- (void)receiveMessage:(NSString *)msg peerID:(NSString *)peerID;

@end
