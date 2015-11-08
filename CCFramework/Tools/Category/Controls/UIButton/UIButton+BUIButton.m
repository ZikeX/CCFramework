//
//  UIButton+BUIButton.m
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

#import "UIButton+BUIButton.h"
#import <objc/runtime.h>

static char BUTTONCARRYOBJECTS;

@implementation UIButton (BUIButton)

-(void)setCarryObjects:(id)carryObjects{
    objc_setAssociatedObject(self, &BUTTONCARRYOBJECTS, carryObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)carryObjects{
    return objc_getAssociatedObject(self, &BUTTONCARRYOBJECTS);
}

/**
 *  @author C C, 2015-10-01
 *
 *  @brief  设置标题普通与高亮
 *
 *  @param title 标题
 */
- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

/**
 *  @author C C, 2015-10-01
 *
 *  @brief  设置标题文字颜色普通与高亮
 *
 *  @param color 标题颜色
 */
- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    
    UILabel *title = (UILabel *)[self viewWithTag:9999];
    if ([title isKindOfClass:[UILabel class]])
        title.textColor = color;
}

/**
 *  @author C C, 2015-10-02
 *
 *  @brief  设置文本字体
 *
 *  @param font 字体
 */
- (void)setFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
    UILabel *title = (UILabel *)[self viewWithTag:9999];
    if ([title isKindOfClass:[UILabel class]])
        title.font = font;

}

/**
 *  @author C C, 2015-10-03
 *
 *  @brief  设置按钮不可用
 *
 *  @param enabled <#enabled description#>
 */
-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    UIImageView *imageView = (UIImageView *)[self viewWithTag:8888];
    imageView.alpha = enabled ? 1 : 0.5;
    UILabel *titleLabel = (UILabel *)[self viewWithTag:9999];
    titleLabel.alpha = enabled ? 1 : 0.5;
}

/**
 *  @author C C, 2015-10-03
 *
 *  @brief  设置上图下文的图片与颜色
 *
 *  @param image 图片
 *  @param color 文字颜色
 */
- (void)setButtonUpImageNextTilte:(NSString *)image TitleColor:(UIColor *)color
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:8888];
    imageView.image = [UIImage imageNamed:image];
    UILabel *titleLabel = (UILabel *)[self viewWithTag:9999];
    titleLabel.textColor = color;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  创建按钮
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWith
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [button setExclusiveTouch:YES];
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  标题
 *
 *  @param title 标题
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithTitle:(NSString *)title
{
    UIButton *button = [self buttonWith];
    
    if (![title isEqualToString:@""]) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  点击不会改变
 *
 *  @param title 标题
 *  @param image 背景图片
 *  @param color 字体颜色
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonClickDoesNotChange:(NSString *)title BackgroundImage:(NSString *)image TitleColor:(UIColor *)color
{
    UIButton *button = [self buttonWith];
    if(![image isEqualToString:@""]){
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  设置标题与背景
 *
 *  @param title 标题
 *  @param image 背景图片
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithTitleBackgroundImage:(NSString *)title BackgroundImage:(NSString *)image
{
    UIButton *button = [self buttonWith];
    if(![image isEqualToString:@""]){
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  设置背景图与长按背景图片
 *
 *  @param sImage 背景图片
 *  @param image 长按背景图片
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithFinishedSelectedImage:(NSString *)FinishedSelectedImage withFinishedUnselectedImage:(NSString *)FinishedUnselectedImage
{
    UIButton *button = [self buttonWith];
    if(![FinishedSelectedImage isEqualToString:@""])
        [button setBackgroundImage:[UIImage imageNamed:FinishedSelectedImage] forState:UIControlStateNormal];
    
    if (![FinishedUnselectedImage isEqualToString:@""])
        [button setBackgroundImage:[UIImage imageNamed:FinishedUnselectedImage] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  设置标题与背景
 *
 *  @param title 标题
 *  @param sImage 背景图片
 *  @param image 长按背景图片
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithImage:(NSString *)title FinishedSelectedImage:(NSString *)FinishedSelectedImage WithFinishedUnselectedImage:(NSString *)FinishedUnselectedImage
{
    UIButton *button = [self buttonWith];
    if(![FinishedSelectedImage isEqualToString:@""])
        [button setBackgroundImage:[UIImage imageNamed:FinishedSelectedImage] forState:UIControlStateNormal];
    
    if (![FinishedUnselectedImage isEqualToString:@""])
        [button setBackgroundImage:[UIImage imageNamed:FinishedUnselectedImage] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    
    return button;
}


/**
 *  @author CC, 2015-07-16
 *
 *  @brief  设置背景图片
 *
 *  @param image 背景图片
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithBackgroundImage:(NSString *)image
{
    UIButton *button = [self buttonWith];
    if(![image isEqualToString:@""]){
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  设置背景图片与位置
 *
 *  @param image 背景图片
 *  @param frame 按钮位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithBackgroundImageFrame:(NSString *)image Frame:(CGRect)frame
{
    UIButton *button = [self buttonWith];
    
    if(![image isEqualToString:@""]){
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.frame = frame;
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  左图右文
 *
 *  @param LeftImage 左图片
 *  @param image 背景图片
 *  @param frame 按钮位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithImageTitle:(NSString *)LeftImage Title:(NSString *)title Frame:(CGRect)frame
{
    UIButton *button = [self buttonWith];
    
    button.frame = frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *LeftIcon = [UIImage imageNamed:LeftImage];
    [button setImage:LeftIcon forState:UIControlStateNormal];
    [button setImage:LeftIcon forState:UIControlStateHighlighted];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -(frame.size.width - button.imageView.frame.size.width - button.titleLabel.bounds.size.width - 10), 0,0);
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  上图下文字
 *
 *  @param image 上图片
 *  @param title 标题
 *  @param frame 按钮位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithUpImageNextTilte:(NSString *)image Title:(NSString *)title Frame:(CGRect)frame
{
    UIButton *button = [self buttonWith];
    button.frame = frame;
    
    UIImage *Image = [UIImage imageNamed:image];
    UIImageView *imageView = (UIImageView *)[button viewWithTag:8888];
    if (!imageView) {
        CGFloat x = (frame.size.width - Image.size.width) / 2;
        CGFloat y = (frame.size.height - Image.size.height - 20) / 2;
        CGFloat w = Image.size.width;
        CGFloat h = Image.size.height;
        
        if (Image.size.width > frame.size.width) {
            x = 0;
            w = frame.size.width;
        }
        
        if (Image.size.height > frame.size.height) {
            y = 0;
            h = frame.size.height - 20;
        }
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        
        imageView.tag = 8888;
        [button addSubview:imageView];
    }
    imageView.image = Image;
    
    UILabel *titleLabel = (UILabel *)[button viewWithTag:9999];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height, frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 9999;
        [button addSubview:titleLabel];
    }
    titleLabel.text = title;
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  圆角按钮
 *
 *  @param title 标题
 *  @param frame 按钮位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithFillet:(NSString *)title Frame:(CGRect)frame
{
    UIButton *button = [self buttonWith];
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  圆角按钮
 *
 *  @param image 背景图片
 *  @param title 标题
 *  @param frame 按钮位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithFillet:(NSString *)image Title:(NSString *)title Frame:(CGRect)frame
{
    UIButton *button = [self buttonWith];
    if(![image isEqualToString:@""]){
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    
    return button;
}

/**
 *  @author CC, 2015-07-16
 *
 *  @brief  圆角按钮
 *
 *  @param title 标题
 *  @param frame 按钮位置
 *  @param color 标题字体颜色
 *  @param mode 标题显示位置
 *
 *  @return <#return value description#>
 *
 *  @since 1.0
 */
+(id)buttonWithFillet:(NSString *)title Frame:(CGRect)frame TitleColor:(UIColor *)color Moode:(UIControlContentHorizontalAlignment)mode
{
    UIButton *button = [self buttonWith];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    
    if (mode == UIControlContentHorizontalAlignmentLeft)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.contentHorizontalAlignment = mode;
    
    return button;
}

@end
