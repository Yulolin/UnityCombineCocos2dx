//
//  TouchCacheManager.m
//  Cocos2dxPlugin_a
//
//  Created by red on 2025/6/24.
//

#import "TouchCacheManager.h"

@implementation TouchCacheManager
// 单例
+ (instancetype)sharedManager {
    static TouchCacheManager *mgr;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mgr = [[TouchCacheManager alloc] init];
        mgr->_touchesCache = [NSMutableDictionary dictionary];
        mgr->_eventCache = [NSMutableDictionary dictionary];
    });
    return mgr;
}
// 缓存Touch
- (void)cacheTouches:(NSSet<UITouch*>*)touches
               event:(UIEvent*)event
        withTimeID:(uint64_t)timeID
{
    NSNumber *key = @(timeID);
    if (touches) self.touchesCache[key] = touches;
    if (event)   self.eventCache[key] = event;
}
// 通过时间id获取touch
- (NSSet<UITouch*>*)touchesForTimeID:(uint64_t)timeID {
    NSNumber *key = @(timeID);
    NSSet *touches = self.touchesCache[key];
    [self.touchesCache removeObjectForKey:key];
    return touches;
}
// 通过时间id获取event
- (UIEvent*)eventForTimeID:(uint64_t)timeID {
    NSNumber *key = @(timeID);
    UIEvent *event = self.eventCache[key];
    [self.eventCache removeObjectForKey:key];
    return event;
}

- (void)clearCache {
    [self.touchesCache removeAllObjects];
    [self.eventCache removeAllObjects];
}

@end
