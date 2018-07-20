//
//  ChatToolView.m
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "ChatToolView.h"
#import <TKRoomSDK/TKRoomSDK.h>

#define SEND_BTN_WIDTH 40

@interface ChatToolView()


@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation ChatToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame: frame];
    if (self) {
        
        // 输入框
        _inputTF = [[UITextField alloc] init];
        
        _inputTF.placeholder = @"按回车键发送您的消息";
        _inputTF.font = [UIFont systemFontOfSize:13.];
        _inputTF.textColor = [UIColor colorWithRed:45.0032/255.0 green:41.0033/255.0 blue:41.0033/255.0 alpha:1];
        _inputTF.layer.cornerRadius = SEND_BTN_WIDTH / 2;
        _inputTF.layer.masksToBounds = YES;
        _inputTF.layer.borderWidth = 0.5;
        
        //设置左边视图的宽度
        _inputTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
        _inputTF.leftViewMode = UITextFieldViewModeAlways;
        
        _inputTF.layer.borderColor = [UIColor colorWithRed:207/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
        [self addSubview:_inputTF];
        
        // 发送按钮
        _sendBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview:_sendBtn];
    }
    return self;
}
- (void)layoutSubviews {
    _inputTF.frame = CGRectMake(12,
                                12,
                                ScreenW - SEND_BTN_WIDTH - 12 - 8*2,
                                SEND_BTN_WIDTH);
    
    _sendBtn.frame = CGRectMake(_inputTF.rightX + 8,
                                _inputTF.y,
                                SEND_BTN_WIDTH,
                                SEND_BTN_WIDTH);
    
}
- (void)sendBtnAction {
    
    if (_inputTF.text.length > 0 ) {
        
        
        [[TKRoomManager instance] sendMessage:_inputTF.text
                                         toID:@"__all"
                                extensionJson:@{@"type":@0}];
        _inputTF.text = @"";
    }
}
@end
