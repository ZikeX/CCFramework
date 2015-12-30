//
//  CCProgressHUD.h
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

@interface CCProgressHUD : NSObject

/**
 *  @author CC, 2016-12-29
 *  
 *  @brief  显弹窗
 *
 *  @param animated 动画
 */
+ (void)show:(BOOL)animated;

/**
 *  @author CC, 2016-12-29
 *  
 *  @brief  隐藏弹窗
 *
 *  @param animated 动画
 */
+ (void)hide:(BOOL)animated;

/**
 *  @author CC, 2016-12-29
 *  
 *  @brief  隐藏弹窗
 *
 *  @param animated 动画
 *  @param delay    时长
 */
+ (void)hide:(BOOL)animated
  afterDelay:(NSTimeInterval)delay;

/**
 *  @author CC, 2016-12-29
 *  
 *  @brief  提示消息
 *
 *  @param LabelText        标题内容
 *  @param detailsLabelText 详细内容
 */
+ (void)hudMessages:(NSString *)LabelText
   DetailsLabelText:(NSString *)detailsLabelText;

/**
 *  @author CC, 2016-12-29
 *  
 *  @brief  底部提示
 *
 *  @param detailsLabelText 提示内容
 */
+ (void)hudToastMessage:(NSString *)detailsLabelText;

@end