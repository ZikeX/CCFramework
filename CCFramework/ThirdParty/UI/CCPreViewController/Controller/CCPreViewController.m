//
//  CCPreViewController.m
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

#import "CCPreViewController.h"
#import "CCPreConnection.h"
#import "CCPreviewItem.h"
#import <CommonCrypto/CommonDigest.h>


static NSString *CCMD5StringFromNSString(NSString *string)
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *result = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", (int)(digest[i])];
    }
    return [result copy];
}

static NSString *CCLocalFilePathForURL(NSURL *URL)
{
    NSString *fileExtension = [URL pathExtension];
    NSString *hashedURLString = CCMD5StringFromNSString([URL absoluteString]);
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"com.cc.RemoteQuickLook"];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        BOOL isDirectoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                                            withIntermediateDirectories:YES
                                                                             attributes:nil
                                                                                  error:&error];
        if (!isDirectoryCreated) {
            NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException
                                                             reason:@"Failed to crate cache directory"
                                                           userInfo:@{NSUnderlyingErrorKey : error}];
            @throw exception;
        }
    }
    NSString *temporaryFilePath = [[cacheDirectory stringByAppendingPathComponent:hashedURLString] stringByAppendingPathExtension:fileExtension];
    return temporaryFilePath;
}


@interface CCPreViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonatomic, weak) id<QLPreviewControllerDataSource> actualDataSource;

@end

@implementation CCPreViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    // Get the ToolBar
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[UIToolbar class]]) {
            obj.hidden = YES;
        }
    }];
    
    [self.navigationController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[UIToolbar class]]) {
            obj.hidden = YES;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray *rights = [self.navigationItem.rightBarButtonItems mutableCopy];
    if (rights.count > 1) {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = [rights objectAtIndex:1];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.navigationController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[UIToolbar class]]) {
            obj.hidden = YES;
        }
    }];
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return self.previewItems.count;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    CCPreviewItem *previewItemCopy = [self.previewItems objectAtIndex:index];
    
    NSURL *originalURL = previewItemCopy.previewItemURL;
    if (!originalURL || [originalURL isFileURL])
        return previewItemCopy;
    
    // If it's a remote file, check cache
    NSString *localFilePath = CCLocalFilePathForURL(originalURL);
    previewItemCopy.previewItemURL = [NSURL fileURLWithPath:localFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
        return previewItemCopy;
    
    // If it's not a local file, put a placeholder instead
    __block NSInteger capturedIndex = index;
    NSURLRequest *request = [NSURLRequest requestWithURL:originalURL];
    
    CCPreConnection *connection = [[CCPreConnection alloc] initWithRequest:request];
    connection.filepath = localFilePath;
    [connection setCompletionBlockWithSuccess:^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            // FIXME: Sometime remote preview item isn't getting updated
            // When pan gesture isn't finished so that two preview items can be seen at the same time upcomming item isn't getting updated, fixes are very welcome!
            if (controller.currentPreviewItemIndex == capturedIndex)
                [controller refreshCurrentPreviewItem];
        });
    }failure:^(NSError *error) {
        if ([self.cc_delegate respondsToSelector:@selector(cc_previewController:failedToLoadRemotePreviewItem:withError:)]) {
            [self.cc_delegate cc_previewController:self
                     failedToLoadRemotePreviewItem:previewItemCopy
                                         withError:error];
        }
    }];
    
    return previewItemCopy;
}

#pragma mark - Properties

- (void)setPreviewItems:(NSArray<CCPreviewItem *> *)previewItems
{
    _previewItems = previewItems;
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
