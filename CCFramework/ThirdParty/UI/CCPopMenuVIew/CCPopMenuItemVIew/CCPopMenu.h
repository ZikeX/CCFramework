//
//  CCPopMenu.h
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


#import <UIKit/UIKit.h>
#import "CCPopMenuItem.h"

typedef NS_ENUM(NSInteger, CCPopMenuAlignment) {
    CCPopMenuAlignmentLeft,
    CCPopMenuAlignmentCenter,
    CCPopMenuAlignmentRight,
};

typedef void (^PopMenuDidSlectedCompledBlock)(NSInteger index, CCPopMenuItem *menuItem);

@interface CCPopMenu : UIView

- (instancetype)initWithMenus:(NSArray *)menus
                    Alignment:(CCPopMenuAlignment)alignment;

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showMenuAtPoint:(CGPoint)point;

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;

@property(nonatomic, copy) NSMutableArray *menuItems;

/**
 *  是否显示
 */
@property(nonatomic, assign, readonly) BOOL isShowed;

/**
 *  @author CC, 2015-10-16
 *
 *  @brief  菜单背景颜色
 */
@property(nonatomic, copy) UIColor *menuBackgroundColor;

/**
 *  @author CC, 16-04-14
 *
 *  @brief 对准位置
 */
@property(nonatomic, assign) CCPopMenuAlignment CCAlignment;

/**
 *  @author CC, 2015-10-16
 *
 *  @brief  菜单文字颜色
 */
@property(nonatomic, copy) UIColor *menuItemTextColor;

/**
 *  @author CC, 16-07-28
 *
 *  @brief 是否补齐线(默认不补齐)
 */
@property(nonatomic, assign) BOOL paddedSeparator;

/**
 *  @author CC, 16-07-28
 *
 *  @brief 底部线颜色
 */
@property(nonatomic, copy) UIColor *lineColor;

@property(nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidSlectedCompled;

@property(nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidDismissCompled;


@end
