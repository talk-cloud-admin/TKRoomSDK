//
//  TKVideoLayerView.m
//  talkSDKDemo
//
//  Created by lyy on 2018/4/11.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "TKVideoLayerView.h"

@interface TKVideoLayerView()

//提示框
@property (nonatomic, strong) UILabel *showPromptLabel;
//@property (nonatomic, strong) UIImageView *showIconView;

@end
@implementation TKVideoLayerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        _showIconView = [[UIImageView alloc]init];
//        [self addSubview:_showIconView];
        
        _showPromptLabel = [[UILabel alloc]init];
        [self addSubview:_showPromptLabel];
    }
    return self;
}
- (void)layoutSubviews{
//    _showIconView.image = [UIImage imageNamed:@"icon_videoClose"];
//    _showIconView.backgroundColor = [UIColor blackColor];
//    _showIconView.contentMode = UIViewContentModeCenter;
//    _showIconView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _showPromptLabel.textColor = [UIColor grayColor];
    _showPromptLabel.text = NSLocalizedString(@"Prompt.show", nil);
//    self.frame.size.height-120
    _showPromptLabel.frame = CGRectMake(20, 20, self.frame.size.height, 30);
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
