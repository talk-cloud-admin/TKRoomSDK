//
//  RoomController.h
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomController : UIViewController
@property (nonatomic, assign) BOOL autoSubscribe;
@property (copy, nonatomic) NSString *roomid;
@property (copy, nonatomic) NSString *role;
@property (copy, nonatomic) NSString *password;
@end
