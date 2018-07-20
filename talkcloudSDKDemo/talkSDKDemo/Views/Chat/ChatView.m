//
//  ChatView.m
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "ChatView.h"
#import "Masonry.h"
#import "ChatMessageOtherCell.h"
#import "ChatMessageMECell.h"
#import "ChatToolView.h"
#import "ChatModel.h"
#import "NSString+sizeHeight.h"
#import <TKRoomSDK/TKRoomSDK.h>

#define INPUT_VIEW_HEIGHT 60 // 底部输入视图高度
static NSString * const otherCellID = @"ChatMessageOtherCell";
static NSString * const meCellID = @"ChatMessageMeCell";

@interface ChatView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatListTV;
@property (nonatomic, strong) ChatToolView *toolView;
@property (nonatomic, strong) NSMutableArray<ChatModel *> *dataSource;
@property (nonatomic, assign) CGFloat viewY;
@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, assign) CGFloat kbHeight;

@end



@implementation ChatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _viewY = frame.origin.y;
        
        self.y = ScreenH;
        
        // 聊天列表
        _chatListTV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _chatListTV.delegate = self;
        _chatListTV.dataSource = self;
        _chatListTV.y = 0;
        _chatListTV.height = _chatListTV.height - INPUT_VIEW_HEIGHT;
        _chatListTV.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.86];
        _chatListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatListTV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_chatListTV registerClass:[ChatMessageOtherCell class] forCellReuseIdentifier:otherCellID];
        [_chatListTV registerClass:[ChatMessageMECell class] forCellReuseIdentifier:meCellID];
        [self addSubview: _chatListTV];
        
        // 工具条
        _toolView = [[ChatToolView alloc] initWithFrame:CGRectMake(0,
                                                                   _chatListTV.bottomY,
                                                                   self.width,
                                                                   INPUT_VIEW_HEIGHT)];
        _toolView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_toolView];
        
        
        
        
        // 键盘通知
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                        
                                                          NSValue *aValue = note.userInfo[UIKeyboardFrameEndUserInfoKey];
                                                          _kbHeight = [aValue CGRectValue].size.height;
                                                          
                                                          float durationTime = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                          
                                                          [UIView animateWithDuration: durationTime  animations:^{
                                                              
                                                              self.y = ScreenH - _kbHeight - self.height;
                                                          }];
                                                          
                                                      }];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {

                                                          float durationTime = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                          [UIView animateWithDuration: durationTime  animations:^{
                                                              
                                                              self.y = ScreenH - self.height;
                                                          }];
                                                          
                                                      }];
    }
    return self;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatModel *model = self.dataSource[indexPath.row];
    
    // 自己发送的消息
    if ([model.peerID isEqualToString:[TKRoomManager instance].localUser.peerID]) {
        ChatMessageMECell *cell = [tableView dequeueReusableCellWithIdentifier:meCellID forIndexPath:indexPath];
        
        cell.portraitView.image = [UIImage imageNamed:@"portrait"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        ChatMessageOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
        
        cell.portraitView.image = [UIImage imageNamed:@"portrait"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource[indexPath.row].isOneLine) {
        return 45.;
    }
    else {
        
        return self.dataSource[indexPath.row].msgSize.height + 20.;
    }
}

- (void)show {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.y = _viewY;
        [self.chatListTV reloadData];
    }];
    
    _isHide = NO;
}
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = ScreenH;
    }];
    [_toolView endEditing:YES];
    _isHide = YES;
}

- (void)receiveMessage:(NSString *)msg peerID:(NSString *)peerID{
    
    ChatModel *model = [ChatModel new];
    model.peerID = peerID;
    model.msg = msg;
    
    CGSize lblSize = CGSizeMake(_chatListTV.width - (12 + 38 + 6 + 12), MAXFLOAT);
    UIFont *font = [UIFont systemFontOfSize:15.];
    CGFloat lineSpace = 0.;
    
    // 如果只有一行
    if (![msg isMoreThanOneLineWithSize:lblSize
                                   font:font
                           lineSpaceing:lineSpace]) {
        
        model.isOneLine = YES;
        model.msgSize = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
                                             font:font
                                      lineSpacing:lineSpace];
    }
    else {
        model.isOneLine = NO;
        model.msgSize = [msg boundingRectWithSize:lblSize
                                             font:font
                                      lineSpacing:lineSpace];
        
    }
    
    [self.dataSource addObject: model];
    if (!self.isHide) {
        [_chatListTV reloadData];
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow: _dataSource.count - 1  inSection:0];
        [self.chatListTV scrollToRowAtIndexPath: ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
