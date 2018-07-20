//
//  ChatModel.h
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *peerID;
@property (nonatomic, assign) CGSize msgSize;
@property (nonatomic, assign) BOOL isOneLine;
//@property (nonatomic, strong) NSString *formID;
@end
