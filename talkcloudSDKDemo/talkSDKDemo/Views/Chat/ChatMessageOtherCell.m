//
//  chatMessageCellTableViewCell.m
//  talkSDKDemo
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "ChatMessageOtherCell.h"
#import "ChatModel.h"

#define ICON_WIDTH 38
#define ICON_MARGIN 6
#define MSG_MARGIN 6
#define MSG_BG_MARGIN 6


@interface ChatMessageOtherCell()

@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UIView  *messageView;
@end



@implementation ChatMessageOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        // 初始化子视图
        [self initLayout];
    }
    
    return self;
}

- (void)initLayout {
    // 头像
    self.portraitView = [[UIImageView alloc] initWithFrame: CGRectMake(12,
                                                                       5,
                                                                       38,
                                                                       38)];
    
    [self.contentView addSubview:self.portraitView];
    
    // 文本框
    self.messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                320,
                                                                20)];
    self.messageLbl.font = [UIFont systemFontOfSize:15.];
    self.messageLbl.textColor = [UIColor colorWithRed:45.0032/255.0 green:41.0033/255.0 blue:41.0033/255.0 alpha:1];
    self.messageLbl.numberOfLines = 0;
    self.messageLbl.textAlignment = NSTextAlignmentLeft;
    
    // 文本框背景
    self.messageView = [[UIView alloc] init];
    self.messageView.backgroundColor = UIColor.whiteColor;
    
    [self.messageView addSubview:self.messageLbl];
    [self.contentView addSubview:self.messageView];
    
}

- (void)layoutSubviews {
    // 头像
    _portraitView.frame = CGRectMake(ICON_MARGIN,
                                     ICON_MARGIN,
                                     ICON_WIDTH,
                                     ICON_WIDTH);
    
    // 文本框
    _messageLbl.frame = CGRectMake(MSG_MARGIN,
                                   MSG_MARGIN,
                                   self.model.msgSize.width,
                                   self.model.msgSize.height);
    
    // 背景
    _messageView.frame = CGRectMake(_portraitView.rightX + ICON_MARGIN,
                                    _portraitView.y + 5,
                                    _messageLbl.width + MSG_MARGIN * 2,
                                    _messageLbl.height + MSG_MARGIN * 2);
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.messageView.bounds
                                               byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight |UIRectCornerTopRight
                                                     cornerRadii:(CGSizeMake(10, 10))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.messageView.bounds;
    
    //设置图形样子
    maskLayer.path = path.CGPath;
    self.messageView.layer.mask = maskLayer;
    
}


- (void)setModel:(ChatModel *)model {
    
    _model = model;
    _messageLbl.text = model.msg;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
