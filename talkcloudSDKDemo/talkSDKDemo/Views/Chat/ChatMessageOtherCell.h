//
//  chatMessageCellTableViewCell.h
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;

@interface ChatMessageOtherCell : UITableViewCell


@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) ChatModel *model;

@end
