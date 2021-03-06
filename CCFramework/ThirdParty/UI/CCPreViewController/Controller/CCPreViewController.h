//
//  CCPreViewController.h
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

#import <QuickLook/QuickLook.h>


@class CCPreViewController,CCPreviewItem;

@protocol CCPreviewControllerDelegate <NSObject>
@optional

/**
 *  @author CC, 16-08-25
 *
 *  @brief 通知无法当前项无法加载
 *
 *  @param controller  当前控制器
 *  @param previewItem 当前显示项
 *  @param error       错误消息
 */
- (void)cc_previewController:(CCPreViewController *)controller failedToLoadRemotePreviewItem:(CCPreviewItem *)previewItem withError:(NSError *)error;

@end

@interface CCPreViewController : QLPreviewController

@property(nonatomic, strong) NSArray<CCPreviewItem *> *previewItems;

@property(weak) id<CCPreviewControllerDelegate> cc_delegate;

@end
