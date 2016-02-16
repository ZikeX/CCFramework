//
//  CCMessageTableViewController.m
//  CCFramework
//
// Copyright (c) 2015 CC ( http://www.ccskill.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "CCMessageTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CCCameraViewController.h"
#import "CCPhotographyHelper.h"
#import "CCMessageVideoConverPhotoFactory.h"
#import "CCMessageBubbleFactory.h"
#import "CCLocationHelper.h"
#import "CCVoiceRecordHelper.h"
#import "UIScrollView+CCkeyboardControl.h"
#import "UIScrollView+CCExtension.h"
#import "CCVoiceCommonHelper.h"
#import "CCEmotionTextAttachment.h"
#import "UIScrollView+CCRefresh.h"
//#import "CCVoiceRecordHUD.h"
#import "CCVoiceProgressHUD.h"

@interface CCMessageTableViewController () <CCMessageTableViewDelegate>

/**
 *  判断是否用户手指滚动
 */
@property(nonatomic, assign) BOOL isUserScrolling;

/**
 *  记录旧的textView contentSize Heigth
 */
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;

/**
 *  记录键盘的高度，为了适配iPad和iPhone
 */
@property(nonatomic, assign) CGFloat keyboardViewHeight;

@property(nonatomic, assign, readwrite) CCInputViewType textViewInputViewType;

@property(nonatomic, weak, readwrite) CCMessageTableView *messageTableView;
@property(nonatomic, weak, readwrite) CCMessageInputView *messageInputView;
@property(nonatomic, weak, readwrite) CCShareMenuView *shareMenuView;
@property(nonatomic, weak, readwrite) CCEmotionManagerView *emotionManagerView;

@property(nonatomic, strong, readwrite) CCVoiceProgressHUD *voiceRecordHUD;

@property(nonatomic, strong, readonly) CCCameraViewController *camerViewController;

@property(nonatomic, strong) UIView *headerContainerView;
@property(nonatomic, strong) UIActivityIndicatorView *loadMoreActivityIndicatorView;

/**
 *  @author CC, 2015-12-25
 *  
 *  @brief  图文路径
 */
@property(nonatomic, copy) NSArray *teletextPath;

/**
 *  管理本机的摄像和图片库的工具对象
 */
@property(nonatomic, strong) CCPhotographyHelper *photographyHelper;

/**
 *  管理地理位置的工具对象
 */
@property(nonatomic, strong) CCLocationHelper *locationHelper;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) CCVoiceRecordHelper *voiceRecordHelper;

/**
 *  判断是不是超出了录音最大时长
 */
@property(nonatomic) BOOL isMaxTimeStop;

#pragma mark - DataSource Change
/**
 *  改变数据源需要的子线程
 *
 *  @param queue 子线程执行完成的回调block
 */
- (void)exChangeMessageDataSourceQueue:(void (^)())queue;

/**
 *  执行块代码在主线程
 *
 *  @param queue 主线程执行完成回调block
 */
- (void)exMainQueue:(void (^)())queue;

#pragma mark - Previte Method
/**
 *  判断是否允许滚动
 *
 *  @return 返回判断结果
 */
- (BOOL)shouldAllowScroll;

#pragma mark - Life Cycle
/**
 *  配置默认参数
 */
- (void)setup;

/**
 *  初始化显示控件
 */
- (void)initilzer;

#pragma mark - RecorderPath Helper Method
/**
 *  获取录音的路径
 *
 *  @return 返回录音的路径
 */
- (NSString *)obtainRecorderPath;

#pragma mark - UITextView Helper Method
/**
 *  获取某个UITextView对象的content高度
 *
 *  @param textView 被获取的textView对象
 *
 *  @return 返回高度
 */
- (CGFloat)getTextViewContentH:(UITextView *)textView;

#pragma mark - Layout Message Input View Helper Method
/**
 *  动态改变TextView的高度
 *
 *  @param textView 被改变的textView对象
 */
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView;

#pragma mark - Scroll Message TableView Helper Method
/**
 *  根据bottom的数值配置消息列表的内部布局变化
 *
 *  @param bottom 底部的空缺高度
 */
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom;

/**
 *  根据底部高度获取UIEdgeInsets常量
 *
 *  @param bottom 底部高度
 *
 *  @return 返回UIEdgeInsets常量
 */
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom;

#pragma mark - Message Calculate Cell Height
/**
 *  统一计算Cell的高度方法
 *
 *  @param message   被计算目标消息对象
 *  @param indexPath 被计算目标消息所在的位置
 *
 *  @return 返回计算的高度
 */
- (CGFloat)calculateCellHeightWithMessage:(id<CCMessageModel>)message atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Message Send helper Method
/**
 *  根据文本开始发送文本消息
 *
 *  @param text 目标文本
 */
- (void)didSendMessageWithText:(NSString *)text;
/**
 *  根据图片开始发送图片消息
 *
 *  @param photo 目标图片
 */
- (void)didSendMessageWithPhoto:(UIImage *)photo;
/**
 *  根据视频的封面和视频的路径开始发送视频消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的路径
 */
- (void)didSendMessageWithVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath;
/**
 *  根据录音路径开始发送语音消息
 *
 *  @param voicePath        目标语音路径
 *  @param voiceDuration    目标语音时长
 */
- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration;
/**
 *  根据第三方gif表情路径开始发送表情消息
 *
 *  @param emotionPath 目标gif表情路径
 */
- (void)didSendEmotionMessageWithEmotionPath:(NSString *)emotionPath EmotionUrl:(NSString *)emotionUrl;
/**
 *  根据地理位置信息和地理经纬度开始发送地理位置消息
 *
 *  @param geolcations 目标地理信息
 *  @param location    目标地理经纬度
 */
- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolcations location:(CLLocation *)location;

#pragma mark - Voice Recording Helper Method
/**
 *  开始录音
 */
- (void)startRecord;
/**
 *  完成录音
 */
- (void)finishRecorded;
/**
 *  想停止录音
 */
- (void)pauseRecord;
/**
 *  继续录音
 */
- (void)resumeRecord;
/**
 *  取消录音
 */
- (void)cancelRecord;

@end

@implementation CCMessageTableViewController

#pragma mark - DataSource Change

- (void)exChangeMessageDataSourceQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_main_queue(), queue);
}

- (void)addMessage:(CCMessage *)addedMessage
{
    NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
    [messages addObject:addedMessage];
    self.messages = messages;
    [self finishSendMessageWithBubbleMessageType:addedMessage.messageMediaType];
    
    CGFloat heigth = self.messageTableView.frame.size.height;
    CGFloat contentYoffset = self.messageTableView.contentOffsetY;
    CGFloat distanceFromBootom = self.messageTableView.contentSizeHeight - contentYoffset;
    
    BOOL animated = YES;
    if (distanceFromBootom < heigth)
        animated = NO;
    
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:animated];
}

/**
 *  @author CC, 15-09-16
 *
 *  @brief  修改发送消息状态
 *
 *  @param messageData 消息体
 *  @param sendType    消息状态
 *
 *  @since 1.0
 */
- (void)updateMessageData:(CCMessage *)messageData
          MessageSendType:(CCMessageSendType)sendType
{
    NSInteger index = [self.messages indexOfObject:messageData];
    if (index != NSNotFound) {
        CCMessage *message = [self.messages objectAtIndex:index];
        message.messageSendState = sendType;
        [self replaceMessages:messageData
                   Replaceobj:message];
    }
}

/**
 *  @author CC, 2016-01-23
 *  
 *  @brief 替换对象
 *
 *  @param messageData 消息实体
 *  @param newMessage  新消息实体
 */
- (void)replaceMessages:(CCMessage *)messageData
             Replaceobj:(CCMessage *)newMessage

{
    NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
    NSInteger index = [messages indexOfObject:messageData];
    
    if (index != NSNotFound) {
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        [messages replaceObjectAtIndex:index withObject:newMessage];
        
        self.messages = messages;
        [self.messageTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.messages.count)
        return;
    [self.messages removeObjectAtIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:indexPath];
    
    [self.messageTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)insertOldMessages:(NSArray *)oldMessages
               completion:(void (^)())completion
{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.messages];
    for (CCMessage *ms in oldMessages)
        [array insertObject:ms atIndex:0];
    
    self.messages = array;
    if (oldMessages.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldMessages.count inSection:0];
        
        WEAKSELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
                completion();
            
            [weakSelf.messageTableView reloadData];
            [weakSelf.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}

- (void)insertOldMessages:(NSArray *)oldMessages
{
    [self insertOldMessages:oldMessages completion:nil];
}

#pragma mark - Propertys

- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (UIView *)headerContainerView
{
    if (!_headerContainerView) {
        _headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 15)];
        _headerContainerView.backgroundColor = self.messageTableView.backgroundColor;
//        [_headerContainerView addSubview:self.loadMoreActivityIndicatorView];
    }
    return _headerContainerView;
}
- (UIActivityIndicatorView *)loadMoreActivityIndicatorView
{
    if (!_loadMoreActivityIndicatorView) {
        _loadMoreActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadMoreActivityIndicatorView.center = CGPointMake(CGRectGetWidth(_headerContainerView.bounds) / 2.0, CGRectGetHeight(_headerContainerView.bounds) / 2.0);
    }
    return _loadMoreActivityIndicatorView;
}
- (void)setLoadingMoreMessage:(BOOL)loadingMoreMessage
{
    _loadingMoreMessage = loadingMoreMessage;
    if (loadingMoreMessage) {
        [self.loadMoreActivityIndicatorView startAnimating];
    } else {
        [self.loadMoreActivityIndicatorView stopAnimating];
    }
}
- (void)setLoadMoreActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)loadMoreActivityIndicatorViewStyle
{
    _loadMoreActivityIndicatorViewStyle = loadMoreActivityIndicatorViewStyle;
    self.loadMoreActivityIndicatorView.activityIndicatorViewStyle = loadMoreActivityIndicatorViewStyle;
}

- (CCShareMenuView *)shareMenuView
{
    if (!_shareMenuView) {
        CCShareMenuView *shareMenuView = [[CCShareMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        shareMenuView.delegate = self;
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        shareMenuView.shareMenuItems = self.shareMenuItems;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
    [self.view bringSubviewToFront:_shareMenuView];
    return _shareMenuView;
}

- (CCEmotionManagerView *)emotionManagerView
{
    if (!_emotionManagerView) {
        CCEmotionManagerView *emotionManagerView = [[CCEmotionManagerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        emotionManagerView.alpha = 0.0;
        [self.view addSubview:emotionManagerView];
        _emotionManagerView = emotionManagerView;
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}

- (CCVoiceProgressHUD *)voiceRecordHUD
{
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[CCVoiceProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        [_voiceRecordHUD setColor:[UIColor colorWithRed:0 green:0.455 blue:0.756 alpha:1]];
    }
    return _voiceRecordHUD;
}

- (CCPhotographyHelper *)photographyHelper
{
    if (!_photographyHelper) {
        _photographyHelper = [[CCPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (CCLocationHelper *)locationHelper
{
    if (!_locationHelper) {
        _locationHelper = [[CCLocationHelper alloc] init];
    }
    return _locationHelper;
}

- (CCVoiceRecordHelper *)voiceRecordHelper
{
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF;
        _voiceRecordHelper = [[CCVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
            UIButton *holdDown = weakSelf.messageInputView.holdDownButton;
            holdDown.selected = NO;
            holdDown.highlighted = NO;
            weakSelf.isMaxTimeStop = YES;
            
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

#pragma mark - Messages View Controller

- (void)finishSendMessageWithBubbleMessageType:(CCBubbleMessageMediaType)mediaType
{
    switch (mediaType) {
        case CCBubbleMessageMediaTypeText:
        case CCBubbleMessageMediaTypeTeletext: {
            [self.messageInputView.inputTextView setText:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                });
            }
            break;
        }
        case CCBubbleMessageMediaTypePhoto: {
            break;
        }
        case CCBubbleMessageMediaTypeVideo: {
            break;
        }
        case CCBubbleMessageMediaTypeVoice: {
            break;
        }
        case CCBubbleMessageMediaTypeEmotion: {
            break;
        }
        case CCBubbleMessageMediaTypeLocalPosition: {
            break;
        }
        default:
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    _messageTableView.backgroundColor = color;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.messageTableView.backgroundView = nil;
    self.messageTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if (![self shouldAllowScroll])
        return;
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated
{
    if (![self shouldAllowScroll])
        return;
    
    [self.messageTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:position
                                         animated:animated];
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll
{
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)] && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Life Cycle

- (void)setup
{
    // iPhone or iPad keyboard view height set here.
    self.keyboardViewHeight = (isiPad ? 264 : 216);
    _allowsPanToDismissKeyboard = NO;
    _allowsSendVoice = YES;
    _allowsSendMultiMedia = YES;
    _allowsSendFace = YES;
    _inputViewStyle = CCMessageInputViewStyleFlat;
    
    self.delegate = self;
    self.dataSource = self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)initilzer
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 默认设置用户滚动为NO
    _isUserScrolling = NO;
    
    // 初始化message tableView
    CCMessageTableView *messageTableView = [[CCMessageTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    messageTableView.dataSource = self;
    messageTableView.delegate = self;
    messageTableView.touchDelegate = self;
    messageTableView.separatorColor = [UIColor clearColor];
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BOOL shouldLoadMoreMessagesScrollToTop = YES;
    if ([self.delegate respondsToSelector:@selector(shouldLoadMoreMessagesScrollToTop)]) {
        shouldLoadMoreMessagesScrollToTop = [self.delegate shouldLoadMoreMessagesScrollToTop];
    }
    
    if (shouldLoadMoreMessagesScrollToTop) {
        messageTableView.tableHeaderView = self.headerContainerView;
        [messageTableView addHeaderWithTargetIndicatorView:self action:@selector(scrollRefresh)];
    }
    
    [self.view addSubview:messageTableView];
    [self.view sendSubviewToBack:messageTableView];
    _messageTableView = messageTableView;
    
    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight = (self.inputViewStyle == CCMessageInputViewStyleFlat) ? 45.0f : 40.0f;
    [self setTableViewInsetsWithBottomValue:inputViewHeight];
    
    // 设置整体背景颜色
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    
    WEAKSELF;
    if (self.allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.messageTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == CCInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == CCInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.messageTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyboard) {
        if (weakSelf.textViewInputViewType == CCInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.messageInputView.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.messageInputView.frame.origin.y];
                                 if (showKeyboard)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    
    self.messageTableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == CCInputViewTypeText) {
                    weakSelf.shareMenuView.alpha = 0.0;
                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    
    self.messageTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
        
    };
    
    // 初始化输入工具条
    CCMessageInputView *inputView = [[CCMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = self.allowsSendFace;
    inputView.allowsSendVoice = self.allowsSendVoice;
    inputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [self.view bringSubviewToFront:inputView];
    _messageInputView = inputView;
    
    //设置默认高度
    self.previousTextViewContentHeight = inputView.inputTextView.frame.size.height;
    
    // 设置手势滑动，默认添加一个bar的高度值
    self.messageTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}

/**
 *  @author CC, 2015-11-16
 *  
 *  @brief  设置底部工具条
 *
 *  @param bottomToolbarView 工具视图
 */
- (void)setBottomToolbarView:(UIView *)bottomToolbarView
{
    [self.view addSubview:bottomToolbarView];
    [self.view bringSubviewToFront:bottomToolbarView];
    _bottomToolbarView = bottomToolbarView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    [self.messageTableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    [self.messageInputView.inputTextView setEditable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.textViewInputViewType != CCInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
    
    // remove键盘通知或者手势
    [self.messageTableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.messageInputView.inputTextView setEditable:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化消息页面布局
    [self initilzer];
    [[CCMessageBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _messages = nil;
    _delegate = nil;
    _dataSource = nil;
    _messageTableView.delegate = nil;
    _messageTableView.dataSource = nil;
    _messageTableView = nil;
    _messageInputView = nil;
    
    _photographyHelper = nil;
    _locationHelper = nil;
}

#pragma mark - View Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - RecorderPath Helper Method

/**
 *  @author CC, 2015-12-01
 *  
 *  @brief  获取音频文件名
 */
- (NSString *)obtaionVoiceName
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateFormatter stringFromDate:now];
}

/**
 *  @author CC, 2015-12-01
 *  
 *  @brief  获取音频文件路径
 */
- (NSString *)obtainRecorderPath
{
    return [CCVoiceCommonHelper getCacheDirectory];
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView
{
    CGFloat maxHeight = [CCMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    } else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f, inputViewFrame.origin.y - changeInHeight, inputViewFrame.size.width, inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished){
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Message Calculate Cell Height

- (CGFloat)calculateCellHeightWithMessage:(id<CCMessageModel>)message atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:targetMessage:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath targetMessage:message];
    }
    
    cellHeight = [CCMessageTableViewCell calculateCellHeightWithMessage:message displaysTimestamp:displayTimestamp];
    
    return cellHeight;
}

#pragma mark - Message Send helper Method

- (void)didSendMessageWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text
                        fromSender:self.messageSender
                            onDate:[NSDate date]];
    }
}

- (void)didSendMessageWithPhoto:(UIImage *)photo
{
    if ([self.delegate respondsToSelector:@selector(didSendPhoto:fromSender:onDate:)]) {
        [self.delegate didSendPhoto:photo
                         fromSender:self.messageSender
                             onDate:[NSDate date]];
    }
}

- (void)didSendMessageWithVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath
{
    if ([self.delegate respondsToSelector:@selector(didSendVideoConverPhoto:videoPath:fromSender:onDate:)]) {
        [self.delegate didSendVideoConverPhoto:videoConverPhoto
                                     videoPath:videoPath
                                    fromSender:self.messageSender
                                        onDate:[NSDate date]];
    }
}

- (void)didSendMessageWithVoice:(NSString *)voicePath
                  voiceDuration:(NSString *)voiceDuration
{
    if ([self.delegate respondsToSelector:@selector(didSendVoice:voiceDuration:fromSender:onDate:)]) {
        [self.delegate didSendVoice:voicePath
                      voiceDuration:voiceDuration
                         fromSender:self.messageSender
                             onDate:[NSDate date]];
    }
}

/**
 *  @author CC, 2015-12-11
 *  
 *  @brief  发送第三方表情(大)
 *
 *  @param emotionPath 表情路径
 *  @param emotionPath 表情网络路径
 */
- (void)didSendEmotionMessageWithEmotionPath:(NSString *)emotionPath
                                  EmotionUrl:(NSString *)emotionUrl
{
    if ([self.delegate respondsToSelector:@selector(didSendEmotion:EmotionUrl:fromSender:onDate:)]) {
        [self.delegate didSendEmotion:emotionPath
                           EmotionUrl:emotionUrl
                           fromSender:self.messageSender
                               onDate:[NSDate date]];
    }
}

/**
 *  @author CC, 2015-12-11
 *  
 *  @brief  发送第三方表情(小)
 *
 *  @param emotionPath 表情路径
 */
- (void)didSendSmallEmotionMessageWithEmotionPath:(NSString *)emotionPath
                                       EmotionUrl:(NSString *)emotionUrl
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.teletextPath];
    
    NSMutableDictionary *teletextDic = [NSMutableDictionary dictionary];
    [teletextDic setObject:emotionPath forKey:@"path"];
    [teletextDic setObject:emotionUrl forKey:@"url"];
    
    [array addObject:teletextDic];
    
    self.teletextPath = array;
    
    [self insertEmotion:emotionPath];
}

/**
 *  @author CC, 2015-12-24
 *  
 *  @brief  插入小表情
 *
 *  @param emotionPath 表情地址
 */
- (void)insertEmotion:(NSString *)emotionPath
{
    CCEmotionTextAttachment *emojiTextAttachment = [CCEmotionTextAttachment new];
    emojiTextAttachment.emotionPath = emotionPath;
    emojiTextAttachment.emotionSize = CGSizeMake(22, 22);
    
    UIFont *font = self.messageInputView.inputTextView.font;
    
    //Insert emoji image
    [self.messageInputView.inputTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                                                    atIndex:self.messageInputView.inputTextView.selectedRange.location];
    
    //Move selection location
    self.messageInputView.inputTextView.selectedRange = NSMakeRange(self.messageInputView.inputTextView.selectedRange.location + 1, self.messageInputView.inputTextView.selectedRange.length);
    
    NSRange wholeRange = NSMakeRange(0, self.messageInputView.inputTextView.textStorage.length);
    
    [self.messageInputView.inputTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [self.messageInputView.inputTextView.textStorage addAttribute:NSFontAttributeName value:font range:wholeRange];
}

/**
 *  @author CC, 2015-12-25
 *  
 *  @brief  删除表情记录
 */
- (void)didTextDeleteBackward
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.teletextPath];
    if (array.count)
        [array removeObject:array.lastObject];
    
    self.teletextPath = array;
}

- (void)didEmotionStore
{
    if ([self.delegate respondsToSelector:@selector(didEmotionStore)]) {
        [self.delegate didEmotionStore];
    }
}

- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolcations location:(CLLocation *)location
{
    if ([self.delegate respondsToSelector:@selector(didSendGeoLocationsPhoto:geolocations:location:fromSender:onDate:)]) {
        [self.delegate didSendGeoLocationsPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"]
                                   geolocations:geolcations
                                       location:location
                                     fromSender:self.messageSender
                                         onDate:[NSDate date]];
    }
}

#pragma mark - Other Menu View Frame Helper Mehtod

- (void)layoutOtherMenuViewHiden:(BOOL)hide
{
    [self.messageInputView.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.messageInputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            self.messageInputView.frame = inputViewFrame;
        };
        
        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.emotionManagerView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.emotionManagerView.alpha = !hide;
            self.emotionManagerView.frame = otherMenuViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
        };
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case CCInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case CCInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case CCInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case CCInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);
        
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.frame.origin.y];
        
        [self scrollToBottomAnimated:NO];
    } completion:^(BOOL finished) {
        if (hide) {
            self.textViewInputViewType = CCInputViewTypeNormal;
        }
    }];
}

#pragma mark - Voice Recording Helper Method

- (void)prepareRecordWithCompletion:(CCPrepareRecorderCompletion)completion
{
    [self.voiceRecordHelper prepareRecordingWithPath:[self obtaionVoiceName] prepareRecorderCompletion:completion];
}

- (void)startRecord
{
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}

- (void)finishRecorded
{
    WEAKSELF;
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
    }];
}

- (void)pauseRecord
{
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord
{
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord
{
    WEAKSELF;
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - CCMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(CCMessageTextView *)messageInputTextView
{
    self.textViewInputViewType = CCInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(CCMessageTextView *)messageInputTextView
{
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didChangeSendVoiceAction:(BOOL)changed
{
    if (changed) {
        if (self.textViewInputViewType == CCInputViewTypeText)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)didSendTextAction:(NSString *)text
{
    if ([text rangeOfString:OBJECT_REPLACEMENT_CHARACTER].location != NSNotFound) { //图文消息
        if ([self.delegate respondsToSelector:@selector(didSendTeletext:TeletextPath:fromSender:onDate:)]) {
            [self.delegate didSendTeletext:text
                              TeletextPath:self.teletextPath
                                fromSender:self.messageSender
                                    onDate:[NSDate date]];
            self.teletextPath = nil;
        }
    } else { //文本消息
        if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
            [self.delegate didSendText:text
                            fromSender:self.messageSender
                                onDate:[NSDate date]];
        }
    }
}

- (void)didSelectedMultipleMediaAction
{
    self.textViewInputViewType = CCInputViewTypeShareMenu;
    [self layoutOtherMenuViewHiden:NO];
}

- (void)didSendFaceAction:(BOOL)sendFace
{
    if (sendFace) {
        self.textViewInputViewType = CCInputViewTypeEmotion;
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}

- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion
{
    [self prepareRecordWithCompletion:completion];
}

- (void)didStartRecordingVoiceAction
{
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction
{
    [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction
{
    if (self.isMaxTimeStop == NO) {
        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}

- (void)didDragOutsideAction
{
    [self resumeRecord];
}

- (void)didDragInsideAction
{
    [self pauseRecord];
}

#pragma mark - CCShareMenuView Delegate

- (void)didSelecteShareMenuItem:(CCShareMenuItem *)shareMenuItem
                        atIndex:(NSInteger)index
{
    WEAKSELF;
    switch (shareMenuItem.itemType) {
        case CCShareMenuItemTypePhoto: {
            _camerViewController = [[CCCameraViewController alloc] init];
            [_camerViewController startPhotoFileWithViewController:weakSelf complate:^(id request) {
                NSArray *photoAry = request;
                [photoAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [weakSelf didSendMessageWithPhoto:obj];
                }];
            }];
        } break;
        case CCShareMenuItemTypeVideo: {
            _camerViewController = [[CCCameraViewController alloc] init];
            [_camerViewController startCcameraWithViewController:weakSelf complate:^(id request) {
                NSArray *photoAry = request;
                [photoAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [weakSelf didSendMessageWithPhoto:obj];
                }];
            }];
        } break;
        default:
            break;
    }
}

#pragma mark - CCEmotionManagerView Delegate

- (void)didSelecteEmotion:(CCEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath
{
    [self didSendEmotionMessageWithEmotionPath:emotion.emotionConverPhoto
                                    EmotionUrl:emotion.emotionPath];
}

/**
 *  @author CC, 2015-12-11
 *  
 *  @brief  发送小表情
 *
 *  @param emotion   表情对象
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteSmallEmotion:(CCEmotion *)emotion
                   atIndexPath:(NSIndexPath *)indexPath
{
    [self didSendSmallEmotionMessageWithEmotionPath:emotion.emotionConverPhoto
                                         EmotionUrl:emotion.emotionPath];
}

- (void)didStore
{
    [self didEmotionStore];
}

#pragma mark - CCEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers
{
    return 0;
}

- (CCEmotionManager *)emotionManagerForColumn:(NSInteger)column
{
    return nil;
}

- (NSArray *)emotionManagersAtManager
{
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollRefresh
{
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        if ([self.delegate respondsToSelector:@selector(loadMoreMessagesScrollTotop)]) {
            [self.delegate loadMoreMessagesScrollTotop];
        }
    }
}

/**
 *  @author CC, 2015-11-19
 *  
 *  @brief  结束刷新
 */
- (void)headerEndRefreshing
{
    self.loadingMoreMessage = NO;
    [self.messageTableView EndRefreshing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible)
        [menu setMenuVisible:NO animated:YES];
    
    if (self.textViewInputViewType != CCInputViewTypeNormal)
        [self layoutOtherMenuViewHiden:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}

#pragma mark - CCMessageTableViewController toucheDelegate
- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event
{
    if (self.textViewInputViewType != CCInputViewTypeNormal)
        [self layoutOtherMenuViewHiden:YES];
}

#pragma mark - CCMessageTableViewController Delegate

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - CCMessageTableViewController DataSource

- (id<CCMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.row];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id<CCMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    
    // 如果需要定制复杂的业务UI，那么就实现该DataSource方法
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:targetMessage:)]) {
        UITableViewCell *tableViewCell = [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath targetMessage:message];
        return tableViewCell;
    }
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:targetMessage:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath targetMessage:message];
    }
    
    static NSString *cellIdentifier = @"CCMessageTableViewCell";
    
    CCMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!messageTableViewCell) {
        messageTableViewCell = [[CCMessageTableViewCell alloc] initWithMessage:message displaysTimestamp:displayTimestamp reuseIdentifier:cellIdentifier];
        messageTableViewCell.delegate = self;
    }
    
    messageTableViewCell.indexPath = indexPath;
    [messageTableViewCell configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [messageTableViewCell setBackgroundColor:tableView.backgroundColor];
    
    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        [self.delegate configureCell:messageTableViewCell atIndexPath:indexPath];
    }
    messageTableViewCell.backgroundColor = [UIColor clearColor];
    return messageTableViewCell;
}

#pragma mark - Table View Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CCMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    
    CGFloat calculateCellHeight = 0;
    
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:targetMessage:)]) {
        calculateCellHeight = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath targetMessage:message];
        return calculateCellHeight;
    } else {
        calculateCellHeight = [self calculateCellHeightWithMessage:message atIndexPath:indexPath];
    }
    
    return calculateCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    if (tableView.isEditing) {
        id <CCMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
        message.selected = !message.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (self.textViewInputViewType != CCInputViewTypeNormal)
        [self layoutOtherMenuViewHiden:YES];
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Table View Cell Delegate
- (void)multiMediaMessageDidSelectedOnMessage:(id<CCMessageModel>)message
                                  atIndexPath:(NSIndexPath *)indexPath
                       onMessageTableViewCell:(CCMessageTableViewCell *)messageTableViewCell
{
    [self.messageInputView.inputTextView resignFirstResponder];
}

@end
