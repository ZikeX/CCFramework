//
//  BaseViewModel.h
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


#import <Foundation/Foundation.h>
#import "CCHTTPRequest.h"
#import "Config.h"

@interface BaseViewModel : NSObject

/**
 *  @author CC, 2015-10-22
 *
 *  @brief  请求成功回调函数
 */
@property (nonatomic, copy) Completion returnBlock;

/**
 *  @author CC, 2015-10-22
 *
 *  @brief  请求错误回调函数
 */
@property (nonatomic, copy) ErrorCodeBlock errorBlock;

/**
 *  @author CC, 2015-10-22
 *
 *  @brief  请求故障回调函数
 */
@property (nonatomic, copy) FailureBlock failureBlock;


/**
 *  @author CC, 15-08-20
 *
 *  @brief  检测链接服务器网络是否畅通
 *
 *  @param netConnectBlock  网络状态回调
 *  @param requestURLString 服务器网络地址
 *
 *  @since 1.0
 */
- (void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock
                        RequestURLString: (NSString *) requestURLString;

/**
 *  @author CC, 15-08-20
 *
 *  @brief  传入交互的Block块
 *
 *  @param returnBlock   完成响应回调
 *  @param errorBlock    错误响应函数
 *  @param faiilureBlock 超时或者请求失败响应函数
 *
 *  @since <#1.0#>
 */
- (void) responseWithBlock: (Completion) returnBlock
            WithErrorBlock: (ErrorCodeBlock) errorBlock
          WithFailureBlock: (FailureBlock)failureBlock;

/**
 *  @author CC, 15-08-20
 *
 *  @brief  获取数据
 *
 *  @since 1.0
 */
- (void) fetchDataSource;

@end
