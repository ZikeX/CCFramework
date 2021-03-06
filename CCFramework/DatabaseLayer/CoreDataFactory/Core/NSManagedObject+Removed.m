//
//  NSManagedObject+Convenience.m
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

#import "BaseManagedObject.h"
#import "NSManagedObject+Additions.h"
#import "BaseManagedObject+Facade.h"

@implementation NSManagedObject (Removed)

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除所有对象
 */
+ (void)cc_RemovedAll
{
    [self cc_RemovedAllWithContext: [self currentContext]
                        completion: nil];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除所有对象
 *
 *  @param completion 完成回调函数
 */
+ (void)cc_RemovedAll: (void(^)(NSError *error))completion
{
    [self cc_RemovedAllWithContext: [self currentContext]
                        completion: completion];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  根据管理对象删除所有对象
 *
 *  @param context 管理对象
 */
+ (void)cc_RemovedAllInContext: (NSManagedObjectContext *)context
{
    [self cc_RemovedAllInContext: context
                      completion: nil];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  根据管理对象删除所有对象
 *
 *  @param context    管理对象
 *  @param completion 完成回调函数
 */
+ (void)cc_RemovedAllInContext: (NSManagedObjectContext *)context
                    completion: (void(^)(NSError *error))completion
{
    [self cc_RemovedAllWithContext: context
                        completion: completion];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除所所有对象
 *
 *  @param context    管理对象
 *  @param completion 完成回调函数
 */
+ (void)cc_RemovedAllWithContext: (NSManagedObjectContext *)context
                      completion: (void(^)(NSError *error))completion
{
    
    [self saveWithContext: context
         SaveContextBlock: ^(NSManagedObjectContext *currentContext){
        
        NSFetchRequest *request = [self cc_AllRequest];
        [request setReturnsObjectsAsFaults:YES];
        [request setIncludesPropertyValues:NO];
        
        NSError *error = nil;
        NSArray *objsToDelete = [currentContext executeFetchRequest:request error:&error];
        for (id obj in objsToDelete )
            [currentContext deleteObject:obj];
        
    } completion: completion];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除对象
 *
 *  @param conditionID 对象ID
 */
+ (void)cc_RemovedManagedObjectID: (NSManagedObjectID *)conditionID
{
    [self cc_RemovedManagedObjectID:conditionID
                         completion:nil];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除对象
 *
 *  @param conditionID 对象ID
 *  @param completion  完成回调函数
 */
+ (void)cc_RemovedManagedObjectID: (NSManagedObjectID *)conditionID
                       completion: (void(^)(NSError *error))completion
{
    [self saveContext:^(NSManagedObjectContext *currentContext) {
        
        NSFetchRequest *request = [self cc_AllRequest];
        [request setReturnsObjectsAsFaults:YES];
        [request setIncludesPropertyValues:NO];
        
        NSError *error = nil;
        NSArray *objsToDelete = [currentContext executeFetchRequest:request error:&error];
        [objsToDelete enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NSManagedObject *)obj).objectID isEqual:conditionID])
                [currentContext deleteObject:obj];
        }];
        
    } completion:completion];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  删除对象
 *
 *  @param propertyName 属性名
 *  @param value        属性值
 */
+ (void)cc_RemovedProperty: (NSString *)propertyName
                   toValue: (id)value
{
    [self cc_RemovedMultiProperty:@{propertyName:value}];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  多属性删除
 *
 *  @param propertyKeyValues 属性名与值
 */
+ (void)cc_RemovedMultiProperty: (NSDictionary *)propertyKeyValues
{
    [self cc_RemovedMultiProperty: propertyKeyValues
                       completion: nil];
}

/**
 *  @author C C, 2015-10-25
 *
 *  @brief  多属性删除
 *
 *  @param propertyKeyValues 属性名与值
 *  @param completion        完成回调函数
 */
+ (void)cc_RemovedMultiProperty: (NSDictionary *)propertyKeyValues
                     completion: (void(^)(NSError *error))completion
{
    [self saveContext:^(NSManagedObjectContext *currentContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self cc_EntityName]];
        if (propertyKeyValues) {
            NSMutableString *conditions = [NSMutableString string];
            for (NSString *key in propertyKeyValues.allKeys)
                [conditions appendFormat:@"%@ = %@ AND ",key,[propertyKeyValues objectForKey:key]];
            
            NSString *condition = [conditions substringToIndex:conditions.length - 4];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
            fetchRequest.predicate = predicate;
        }
        
        __block NSError *error = nil;
        NSArray *allObjects = [currentContext executeFetchRequest:fetchRequest error:&error];
        [allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [currentContext deleteObject:obj];
        }];
        
    } completion:completion];
}



@end
