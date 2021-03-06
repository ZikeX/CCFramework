//
//  UIDevice+Additions.m
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

#import "UIDevice+Additions.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/processor_info.h>
#import <Security/Security.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define DEVICE_HARDWARE_BETTER_THAN(i) [[UIDevice currentDevice] isCurrentDeviceHardwareBetterThan:i]

#define DEVICE_HAS_RETINA_DISPLAY (fabs([UIScreen mainScreen].scale - 2.0) <= fabs([UIScreen mainScreen].scale - 2.0) * DBL_EPSILON)
#define IS_IOS7_OR_LATER (((double)(DEVICE_IOS_VERSION)-7.0) > -((double)(DEVICE_IOS_VERSION)-7.0) * DBL_EPSILON)
#define NSStringAdd568hIfIphone4inch(str) [NSString stringWithFormat:[UIDevice currentDevice].isIphoneWith4inchDisplay ? @"%@-568h" : @"%@", str]

#define IS_IPHONE_5 [[UIScreen mainScreen] applicationFrame].size.height == 568

@implementation UIDevice (Additions)

#pragma mark -
#pragma mark :. Hardware

- (NSString *)hardwareString
{
    int name[] = {CTL_HW, HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);
    
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

/* This is another way of gtting the system info
 * For this you have to #import <sys/utsname.h>
 */

/*
 NSString* machineName
 {
 struct utsname systemInfo;
 uname(&systemInfo);
 return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
 }
 */

- (Hardware)hardware
{
    NSString *hardware = [self hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"]) return IPHONE_2G;
    if ([hardware isEqualToString:@"iPhone1,2"]) return IPHONE_3G;
    if ([hardware isEqualToString:@"iPhone2,1"]) return IPHONE_3GS;
    if ([hardware isEqualToString:@"iPhone3,1"]) return IPHONE_4;
    if ([hardware isEqualToString:@"iPhone3,2"]) return IPHONE_4;
    if ([hardware isEqualToString:@"iPhone3,3"]) return IPHONE_4_CDMA;
    if ([hardware isEqualToString:@"iPhone4,1"]) return IPHONE_4S;
    if ([hardware isEqualToString:@"iPhone5,1"]) return IPHONE_5;
    if ([hardware isEqualToString:@"iPhone5,2"]) return IPHONE_5_CDMA_GSM;
    if ([hardware isEqualToString:@"iPhone5,3"]) return IPHONE_5C;
    if ([hardware isEqualToString:@"iPhone5,4"]) return IPHONE_5C_CDMA_GSM;
    if ([hardware isEqualToString:@"iPhone6,1"]) return IPHONE_5S;
    if ([hardware isEqualToString:@"iPhone6,2"]) return IPHONE_5S_CDMA_GSM;
    
    if ([hardware isEqualToString:@"iPhone7,1"]) return IPHONE_6_PLUS;
    if ([hardware isEqualToString:@"iPhone7,2"]) return IPHONE_6;
    
    if ([hardware isEqualToString:@"iPod1,1"]) return IPOD_TOUCH_1G;
    if ([hardware isEqualToString:@"iPod2,1"]) return IPOD_TOUCH_2G;
    if ([hardware isEqualToString:@"iPod3,1"]) return IPOD_TOUCH_3G;
    if ([hardware isEqualToString:@"iPod4,1"]) return IPOD_TOUCH_4G;
    if ([hardware isEqualToString:@"iPod5,1"]) return IPOD_TOUCH_5G;
    
    if ([hardware isEqualToString:@"iPad1,1"]) return IPAD;
    if ([hardware isEqualToString:@"iPad1,2"]) return IPAD_3G;
    if ([hardware isEqualToString:@"iPad2,1"]) return IPAD_2_WIFI;
    if ([hardware isEqualToString:@"iPad2,2"]) return IPAD_2;
    if ([hardware isEqualToString:@"iPad2,3"]) return IPAD_2_CDMA;
    if ([hardware isEqualToString:@"iPad2,4"]) return IPAD_2;
    if ([hardware isEqualToString:@"iPad2,5"]) return IPAD_MINI_WIFI;
    if ([hardware isEqualToString:@"iPad2,6"]) return IPAD_MINI;
    if ([hardware isEqualToString:@"iPad2,7"]) return IPAD_MINI_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad3,1"]) return IPAD_3_WIFI;
    if ([hardware isEqualToString:@"iPad3,2"]) return IPAD_3_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad3,3"]) return IPAD_3;
    if ([hardware isEqualToString:@"iPad3,4"]) return IPAD_4_WIFI;
    if ([hardware isEqualToString:@"iPad3,5"]) return IPAD_4;
    if ([hardware isEqualToString:@"iPad3,6"]) return IPAD_4_GSM_CDMA;
    if ([hardware isEqualToString:@"iPad4,1"]) return IPAD_AIR_WIFI;
    if ([hardware isEqualToString:@"iPad4,2"]) return IPAD_AIR_WIFI_GSM;
    if ([hardware isEqualToString:@"iPad4,3"]) return IPAD_AIR_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad4,4"]) return IPAD_MINI_RETINA_WIFI;
    if ([hardware isEqualToString:@"iPad4,5"]) return IPAD_MINI_RETINA_WIFI_CDMA;
    
    
    if ([hardware isEqualToString:@"i386"]) return SIMULATOR;
    if ([hardware isEqualToString:@"x86_64"]) return SIMULATOR;
    return NOT_AVAILABLE;
}

- (NSString *)hardwareDescription
{
    NSString *hardware = [self hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (GSM)";
    if ([hardware isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (GSM Rev. A)";
    if ([hardware isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (CDMA)";
    if ([hardware isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([hardware isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (Global)";
    if ([hardware isEqualToString:@"iPhone5,3"]) return @"iPhone 5C (GSM)";
    if ([hardware isEqualToString:@"iPhone5,4"]) return @"iPhone 5C (Global)";
    if ([hardware isEqualToString:@"iPhone6,1"]) return @"iPhone 5S (GSM)";
    if ([hardware isEqualToString:@"iPhone6,2"]) return @"iPhone 5S (Global)";
    
    if ([hardware isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([hardware isEqualToString:@"iPod1,1"]) return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"]) return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"]) return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"]) return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";
    
    if ([hardware isEqualToString:@"iPad1,1"]) return @"iPad (WiFi)";
    if ([hardware isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    if ([hardware isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([hardware isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([hardware isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([hardware isEqualToString:@"iPad2,4"]) return @"iPad 2 (WiFi Rev. A)";
    if ([hardware isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([hardware isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([hardware isEqualToString:@"iPad2,7"]) return @"iPad Mini (CDMA)";
    if ([hardware isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,2"]) return @"iPad 3 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,3"]) return @"iPad 3 (Global)";
    if ([hardware isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,5"]) return @"iPad 4 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,6"]) return @"iPad 4 (Global)";
    if ([hardware isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([hardware isEqualToString:@"iPad4,2"]) return @"iPad Air (WiFi+GSM)";
    if ([hardware isEqualToString:@"iPad4,3"]) return @"iPad Air (WiFi+CDMA)";
    if ([hardware isEqualToString:@"iPad4,4"]) return @"iPad Mini Retina (WiFi)";
    if ([hardware isEqualToString:@"iPad4,5"]) return @"iPad Mini Retina (WiFi+CDMA)";
    if ([hardware isEqualToString:@"i386"]) return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"]) return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    return nil;
}

- (NSString *)hardwareSimpleDescription
{
    NSString *hardware = [self hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";     // (A1203)
    if ([hardware isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";     // (A1241/A1324)
    if ([hardware isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";    // (A1303/A1325)
    if ([hardware isEqualToString:@"iPhone3,1"]) return @"iPhone 4";      // (A1332)
    if ([hardware isEqualToString:@"iPhone3,2"]) return @"iPhone 4";      // (A1332)
    if ([hardware isEqualToString:@"iPhone3,3"]) return @"iPhone 4";      // (A1349)
    if ([hardware isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";     // (A1387/A1431)
    if ([hardware isEqualToString:@"iPhone5,1"]) return @"iPhone 5";      // (A1428)
    if ([hardware isEqualToString:@"iPhone5,2"]) return @"iPhone 5";      // (A1429/A1442)
    if ([hardware isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";     // (A1456/A1532)
    if ([hardware isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";     // (A1507/A1516/A1526/A1529)
    if ([hardware isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";     // (A1453/A1533)
    if ([hardware isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";     // (A1457/A1518/A1528/A1530)
    if ([hardware isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus"; // (A1522/A1524)
    if ([hardware isEqualToString:@"iPhone7,2"]) return @"iPhone 6";      // (A1549/A1586)
    if ([hardware isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([hardware isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([hardware isEqualToString:@"iPhone8,3"]) return @"iPhone SE";
    if ([hardware isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([hardware isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([hardware isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([hardware isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G"; // (A1213)
    if ([hardware isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G"; // (A1288)
    if ([hardware isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G"; // (A1318)
    if ([hardware isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G"; // (A1367)
    if ([hardware isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G"; // (A1421/A1509)
    
    if ([hardware isEqualToString:@"iPad1,1"]) return @"iPad 1G"; // (A1219/A1337)
    
    if ([hardware isEqualToString:@"iPad2,1"]) return @"iPad 2";       // (A1395)
    if ([hardware isEqualToString:@"iPad2,2"]) return @"iPad 2";       // (A1396)
    if ([hardware isEqualToString:@"iPad2,3"]) return @"iPad 2";       // (A1397)
    if ([hardware isEqualToString:@"iPad2,4"]) return @"iPad 2";       // (A1395+New Chip)
    if ([hardware isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G"; // (A1432)
    if ([hardware isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G"; // (A1454)
    if ([hardware isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G"; // (A1455)
    
    if ([hardware isEqualToString:@"iPad3,1"]) return @"iPad 3"; // (A1416)
    if ([hardware isEqualToString:@"iPad3,2"]) return @"iPad 3"; // (A1403)
    if ([hardware isEqualToString:@"iPad3,3"]) return @"iPad 3"; // (A1430)
    if ([hardware isEqualToString:@"iPad3,4"]) return @"iPad 4"; // (A1458)
    if ([hardware isEqualToString:@"iPad3,5"]) return @"iPad 4"; // (A1459)
    if ([hardware isEqualToString:@"iPad3,6"]) return @"iPad 4"; // (A1460)
    
    if ([hardware isEqualToString:@"iPad4,1"]) return @"iPad Air";     // (A1474)
    if ([hardware isEqualToString:@"iPad4,2"]) return @"iPad Air";     // (A1475)
    if ([hardware isEqualToString:@"iPad4,3"]) return @"iPad Air";     // (A1476)
    if ([hardware isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G"; // (A1489)
    if ([hardware isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G"; // (A1490)
    if ([hardware isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G"; // (A1491)
    
    if ([hardware isEqualToString:@"i386"]) return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"]) return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    
    return nil;
}


- (float)hardwareNumber:(Hardware)hardware
{
    switch (hardware) {
        case IPHONE_2G:
            return 1.1f;
        case IPHONE_3G:
            return 1.2f;
        case IPHONE_3GS:
            return 2.1f;
        case IPHONE_4:
            return 3.1f;
        case IPHONE_4_CDMA:
            return 3.3f;
        case IPHONE_4S:
            return 4.1f;
        case IPHONE_5:
            return 5.1f;
        case IPHONE_5_CDMA_GSM:
            return 5.2f;
        case IPHONE_5C:
            return 5.3f;
        case IPHONE_5C_CDMA_GSM:
            return 5.4f;
        case IPHONE_5S:
            return 6.1f;
        case IPHONE_5S_CDMA_GSM:
            return 6.2f;
            
        case IPHONE_6:
            return 7.2f;
        case IPHONE_6_PLUS:
            return 7.1f;
            
        case IPOD_TOUCH_1G:
            return 1.1f;
        case IPOD_TOUCH_2G:
            return 2.1f;
        case IPOD_TOUCH_3G:
            return 3.1f;
        case IPOD_TOUCH_4G:
            return 4.1f;
        case IPOD_TOUCH_5G:
            return 5.1f;
            
        case IPAD:
            return 1.1f;
        case IPAD_3G:
            return 1.2f;
        case IPAD_2_WIFI:
            return 2.1f;
        case IPAD_2:
            return 2.2f;
        case IPAD_2_CDMA:
            return 2.3f;
        case IPAD_MINI_WIFI:
            return 2.5f;
        case IPAD_MINI:
            return 2.6f;
        case IPAD_MINI_WIFI_CDMA:
            return 2.7f;
        case IPAD_3_WIFI:
            return 3.1f;
        case IPAD_3_WIFI_CDMA:
            return 3.2f;
        case IPAD_3:
            return 3.3f;
        case IPAD_4_WIFI:
            return 3.4f;
        case IPAD_4:
            return 3.5f;
        case IPAD_4_GSM_CDMA:
            return 3.6f;
        case IPAD_AIR_WIFI:
            return 4.1f;
        case IPAD_AIR_WIFI_GSM:
            return 4.2f;
        case IPAD_AIR_WIFI_CDMA:
            return 4.3f;
        case IPAD_MINI_RETINA_WIFI:
            return 4.4f;
        case IPAD_MINI_RETINA_WIFI_CDMA:
            return 4.5f;
            
        case SIMULATOR:
            return 100.0f;
        case NOT_AVAILABLE:
            return 200.0f;
    }
    return 200.0f; //Device is not available
}

- (BOOL)isCurrentDeviceHardwareBetterThan:(Hardware)hardware
{
    float otherHardware = [self hardwareNumber:hardware];
    float currentHardware = [self hardwareNumber:[self hardware]];
    return currentHardware >= otherHardware;
}

- (CGSize)backCameraStillImageResolutionInPixels
{
    switch ([self hardware]) {
        case IPHONE_2G:
        case IPHONE_3G:
            return CGSizeMake(1600, 1200);
            break;
        case IPHONE_3GS:
            return CGSizeMake(2048, 1536);
            break;
        case IPHONE_4:
        case IPHONE_4_CDMA:
        case IPAD_3_WIFI:
        case IPAD_3_WIFI_CDMA:
        case IPAD_3:
        case IPAD_4_WIFI:
        case IPAD_4:
        case IPAD_4_GSM_CDMA:
            return CGSizeMake(2592, 1936);
            break;
        case IPHONE_4S:
        case IPHONE_5:
        case IPHONE_5_CDMA_GSM:
        case IPHONE_5C:
        case IPHONE_5C_CDMA_GSM:
            return CGSizeMake(3264, 2448);
            break;
            
        case IPOD_TOUCH_4G:
            return CGSizeMake(960, 720);
            break;
        case IPOD_TOUCH_5G:
            return CGSizeMake(2440, 1605);
            break;
            
        case IPAD_2_WIFI:
        case IPAD_2:
        case IPAD_2_CDMA:
            return CGSizeMake(872, 720);
            break;
            
        case IPAD_MINI_WIFI:
        case IPAD_MINI:
        case IPAD_MINI_WIFI_CDMA:
            return CGSizeMake(1820, 1304);
            break;
        default:
            NSLog(@"We have no resolution for your device's camera listed in this category. Please, make photo with back camera of your device, get its resolution in pixels (via Preview Cmd+I for example) and add a comment to this repository on GitHub.com in format Device = Hpx x Wpx.");
            NSLog(@"Your device is: %@", [self hardwareDescription]);
            break;
    }
    return CGSizeZero;
}

- (BOOL)isIphoneWith4inchDisplay
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        double height = [[UIScreen mainScreen] bounds].size.height;
        if (fabs(height - 568.0f) < DBL_EPSILON) {
            return YES;
        }
    }
    return NO;
}


+ (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
#pragma mark :. sysctl utils

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark :. memory information
+ (NSUInteger)cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger)ramSize
{
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)cpuNumber
{
    return [self getSysInfo:HW_NCPU];
}


+ (NSUInteger)totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)freeMemoryBytes
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

#pragma mark :. disk information

+ (long long)freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if (statfs("/private/var", &buf) >= 0) {
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

+ (long long)totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if (statfs("/private/var", &buf) >= 0) {
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

#pragma mark -
#pragma mark :. PasscodeStatus


NSString *const UIDevicePasscodeKeychainService = @"UIDevice-PasscodeStatus_KeychainService";
NSString *const UIDevicePasscodeKeychainAccount = @"UIDevice-PasscodeStatus_KeychainAccount";

- (BOOL)passcodeStatusSupported
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
#ifdef __IPHONE_8_0
    return (&kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly != NULL);
#else
    return NO;
#endif
}

- (CCPasscodeStatus)passcodeStatus
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"-[%@ %@] - not supported in simulator", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return CCPasscodeStatusUnknown;
#endif
    
#ifdef __IPHONE_8_0
    if (&kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly != NULL) {
        
        static NSData *password = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            password = [NSKeyedArchiver archivedDataWithRootObject:NSStringFromSelector(_cmd)];
        });
        
        NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                (__bridge id)
                                kSecAttrService : UIDevicePasscodeKeychainService,
                                (__bridge id)
                                kSecAttrAccount : UIDevicePasscodeKeychainAccount,
                                (__bridge id)
                                kSecReturnData : @YES,
                                };
        
        CFErrorRef sacError = NULL;
        SecAccessControlRef sacObject;
        sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, kNilOptions, &sacError);
        
        // unable to create the access control item.
        if (sacObject == NULL || sacError != NULL) {
            return CCPasscodeStatusUnknown;
        }
        
        
        NSMutableDictionary *setQuery = [query mutableCopy];
        [setQuery setObject:password forKey:(__bridge id)kSecValueData];
        [setQuery setObject:(__bridge id)sacObject forKey:(__bridge id)kSecAttrAccessControl];
        
        OSStatus status;
        status = SecItemAdd((__bridge CFDictionaryRef)setQuery, NULL);
        
        // if it failed to add the item.
        if (status == errSecDecode) {
            return CCPasscodeStatusDisabled;
        }
        
        status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
        
        // it managed to retrieve data successfully
        if (status == errSecSuccess) {
            return CCPasscodeStatusEnabled;
        }
        
        // not sure what happened, returning unknown
        return CCPasscodeStatusUnknown;
        
    } else {
        return CCPasscodeStatusUnknown;
    }
#else
    return LNPasscodeStatusUnknown;
#endif
}

@end
