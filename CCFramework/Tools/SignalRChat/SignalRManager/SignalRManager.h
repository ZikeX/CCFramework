//
//  SignalRManager.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConnectionStatus) {
    /** 连接中 */
    ConnectionStatusConnecting,
    /** 已连接 */
    ConnectionStatusConnected,
    /** 重新链接 */
    ConnectionStatusReconnecting,
    /** 已断开 */
    ConnectionStatusDisconnected
};

@interface SignalRManager : NSObject

/**
 *  @author CC, 2015-12-23
 *
 *  @brief  链接状态
 */
@property(nonatomic, assign) ConnectionStatus state;

/**
 *  @author CC, 2015-08-15
 *
 *  @brief  单例实例
 *
 *  @return 创建对象
 *
 *  @since 1.0
 */
+ (id)sharedInstance;

/**
 *  @author CC, 15-09-09
 *
 *  @brief  获取Signalr服务地址
 *
 *  @return 返回当前服务地址
 *
 *  @since 1.0
 */
- (NSString *)SignalRServiceAddress;

/**
 *  @author CC, 15-09-09
 *
 *  @brief  获取Signalr端口号
 *
 *  @return 返回当前服务端口号
 *
 *  @since 1.0
 */
- (NSString *)SignalRProxyPort;

/**
 *  @author CC, 15-09-09
 *
 *  @brief  添加监听服务
 *
 *  @since 1.0
 */
- (void)addNotification;

/**
 *  @author CC, 2015-12-02
 *
 *  @brief  注册设备
 */
- (void)registerDevice;

/**
 *  @author CC, 15-09-14
 *
 *  @brief  启动连接服务
 *
 *  @since 1.0
 */
- (void)startLink;

/**
 *  @author CC, 16-08-31
 *
 *  @brief 检测启动
 *         检测连接状态，判断是否启动
 */
- (void)detectStart;

/**
 *  @author CC, 2015-11-05
 *
 *  @brief  停止链接
 */
- (void)stopLink;

#pragma mark -_- 事件处理

/**
 *  @author CC, 15-09-17
 *
 *  @brief  注册响应事件回调
 *
 *  @param responseEventName 响应事件名称
 *  @param eventCallback     响应事件
 *
 *  @since 1.0
 */
- (void)registerNotice:(NSString *)responseEventName
              Selector:(id)selectorSelf
         ResponseEvent:(SEL)eventCallback;

/**
 *  @author CC, 2015-11-11
 *
 *  @brief  发送调用
 *
 *  @param eventName 事件名称
 *  @param args      参数
 */
- (void)sendInvoke:(NSString *)eventName
          withArgs:(id)args, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark - 回调函数
/**
 *  @author CC, 2016-01-07
 *
 *  @brief  重新链接成功
 */
- (void)connectionWillReconnectSuccess;

/**
 *  @author CC, 15-09-18
 *
 *  @brief  重新链接服务
 *
 *  @since 1.0
 */
- (void)connectionWillReconnect;

/**
 *  @author CC, 15-09-18
 *
 *  @brief  链接关闭
 *
 *  @since 1.0
 */
- (void)connectionDidClose;

/**
 *  @author CC, 15-09-18
 *
 *  @brief  链接错误
 *
 *  @param error 错误实体
 *
 *  @since 1.0
 */
-(void)connectionReceiveError:(NSError *)error;

@end
