//
//  TouchCacheManager.h
//  Cocos2dxPlugin
//
//  Created by red on 2025/6/24.
//

#ifndef TouchCacheManager_h
#define TouchCacheManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TouchCacheManager : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 缓存字典：key 是时间戳 ID，value 是一个包含 touches 和 event 的 NSDictionary
@property (nonatomic, strong, readonly)
    NSMutableDictionary<NSNumber*, NSSet<UITouch *> *> *touchesCache;
@property (nonatomic, strong, readonly)
    NSMutableDictionary<NSNumber *, UIEvent *> *eventCache;

/// 缓存 touches 和 event
- (void)cacheTouches:(NSSet<UITouch*>*)touches
               event:(UIEvent*)event
        withTimeID:(uint64_t)timeID;

/// 根据 timeID 取回
- (NSSet<UITouch*>*)touchesForTimeID:(uint64_t)timeID;
- (UIEvent*)eventForTimeID:(uint64_t)timeID;

/// 清空所有缓存
- (void)clearCache;

@end

#endif /* TouchCacheManager_h */
