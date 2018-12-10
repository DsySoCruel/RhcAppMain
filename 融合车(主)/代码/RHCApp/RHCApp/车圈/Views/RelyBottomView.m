//
//  RelyBottomView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "RelyBottomView.h"
#import "XPlaceholderTextView.h"


@interface RelyBottomView ()
//详情里的bottomView
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) XPlaceholderTextView *placeholderTextView;
@property (nonatomic, strong) UIButton *commentButton;//评论
//表情条
@property (nonatomic, strong) NSMutableDictionary *dicType;//用于存储@用户的相关信息
//键盘是不是真的收回（区分切换表情中的假收回）
@property (nonatomic, assign) BOOL isReallyHide;
//评论按钮点击执行评论列表执行的位置
@property (nonatomic, assign) BOOL isNeedTop;
@end

@implementation RelyBottomView

- (instancetype)initDetailBottomView{
    if (self = [super init]) {
        //新加入
        [self newsetupUI];
        [self registerNotification];
        [self setUpData];
    }
    return self;
}

- (void)newsetupUI{
    self.backgroundColor = RGB(0xffffff);
    //line
    self.topLineView = [UIView new];
    self.topLineView.backgroundColor = RGB(0xCBDCFF);
    [self addSubview:self.topLineView];
    //用户图像
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.cornerRadius = 15;
    self.iconImageView.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        YXDUserInfoModel *mdoel = [YXDUserInfoStore sharedInstance].userModel;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:mdoel.headimg] placeholderImage:IMAGECACHE(@"zhan_head")];
    }else{
        self.iconImageView.image = IMAGECACHE(@"zhan_head");
    }
    
    //输入框
    self.placeholderTextView = [XPlaceholderTextView new];
    self.placeholderTextView.placeholder = @"说点什么吧~";
    [self addSubview:self.placeholderTextView];
    WeakObj(self)
    self.placeholderTextView.returnKeySendBlock = ^{
        [Weakself startComment];
    };
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:IMAGECACHE(@"chequan_6") forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = SFONT(14);
    self.commentButton.layer.cornerRadius = 3;
    [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commentButton];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset = 0;
        make.height.offset = 0.5;
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 10;
        make.width.height.offset = 30;
    }];
    
    [self.placeholderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10 + 30 + 10 ;
        make.right.offset = - 60;
        make.bottom.offset = - 7.5;
        make.top.equalTo(self.mas_top).offset = 7.5;
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = -10;
        make.width.height.offset = 40;
    }];
}

- (void)commentButtonAction:(UIButton *)sender{
    [self startComment];
}

- (void)registerNotification{
    
}
- (void)setUpData{
    self.dicType  = [[NSMutableDictionary alloc]init];

}

- (void)startComment{
    if (!self.placeholderTextView.text.length) {
        [MBHUDHelper showError:@"请输入内容"];
        [self.placeholderTextView resetTextView];
        return;
    }
    //开始评论    
    if (self.requsetType == CommentRequestTypeCircle) {
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"content"] = self.placeholderTextView.text;
        parames[@"postId"] = self.mainId;
        if ([YXDUserInfoStore sharedInstance].loginStatus) {
            YXDUserInfoModel *mdoel = [YXDUserInfoStore sharedInstance].userModel;
            parames[@"token"] = mdoel.token;
//            parames[@"token"] = @"d613cd2f42e9a637c4597c0402b228f669186d0bbc03822515d3ae56babdac27";
        }
        //    parames[@"replyUserId"] = @"";
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_AddComment parameters:parames successed:^(id json) {
            if (json) {
                if (Weakself.requestCompletionBlock) {
                    Weakself.requestCompletionBlock();
                    [Weakself.placeholderTextView resetTextView];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
    
    
 
}

//1.键盘弹起
- (void)keyBoardWillShow{
    self.placeholderTextView.maxNumLabel.hidden = NO;
//    self.toolView.hidden = NO;
//    if (self.commentType == CommentViewTypeComment) {
//        [self.placeholderTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.offset = -90;
//        }];
//        self.shareButton.hidden = YES;
//        self.zanButton.hidden = YES;
//        self.commentButton.hidden = YES;
//        self.sendButton.hidden = NO;
//
//        if (isEmpty(self.commentModel)) {
//            [self.sendButton setTitle:@"发布" forState:UIControlStateNormal];
//            self.placeholderTextView.placeholder = @"优质评论将会被优先展示...";
//        }else{
//            [self.sendButton setTitle:@"回复" forState:UIControlStateNormal];
//            self.placeholderTextView.placeholder = [NSString stringWithFormat:@"回复%@:",self.commentModel.user.realName];
//        }
//    }
}
//2.键盘收回
- (void)keyBoardWillHide{
    self.placeholderTextView.maxNumLabel.hidden = YES;
//    self.toolView.hidden = YES;
//    if (self.commentType == CommentViewTypeComment) {
//
//        if (self.requsetType == CommentRequestTypeVideo) {
//            [self.placeholderTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.offset = - 50;
//            }];
//            self.shareButton.hidden = NO;
//
//        }else{
//            [self.placeholderTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.offset = - 115;
//            }];
//            self.zanButton.hidden = NO;
//            self.commentButton.hidden = NO;
//            self.shareButton.hidden = YES;
//        }
//
//        self.sendButton.hidden = YES;
//        self.placeholderTextView.placeholder = @"我有话想说...";
//
//        if (!isEmpty(self.commentModel) && self.isReallyHide && isEmpty(self.placeholderTextView.text)) {//回复别人状态 并且 不是切换键盘状态 回收键盘同时清除回复人信息
//            self.commentModel = nil;
//        }
//    }
    
    if (self.isReallyHide) {//真实的退出键盘状态 恢复键盘样式为键盘
        self.placeholderTextView.textView.inputView = nil;
//        self.emojiButton.selected = NO;
//        self.inputViewType = InputViewTypeKeyboard;
    }
    self.isReallyHide = YES;//很重要 重新设定键盘的再次弹出样式
}

@end
