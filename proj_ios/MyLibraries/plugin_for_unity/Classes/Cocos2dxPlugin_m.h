//
//  Cocos2dxPlugin.h
//  Cocos2dxPlugin
//
//  Created by red on 2025/6/23.
//

#ifndef Cocos2dxPlugin_m_h
#define Cocos2dxPlugin_m_h

#import <CoreFoundation/CFCGTypes.h>
#import <Foundation/NSSet.h>
#import <UIKit/UITouch.h>
#import <UIKit/UIKit.h>
#import "Cocos2dxPlugin.h"
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/time.h>
#import "TouchCacheManager.h"

@class TouchCacheManager;

// Cocos Render Plugin 插件
namespace crp{

// 获取Touch的毫秒级时间id，时间取当前时间
uint64_t getTouchTimeId();

// 发送事件给cocos
void sendTouchToCocos_Begin(NSSet* touches, UIEvent* event, CGFloat scaleFactor);
void sendTouchToCocos_Ended(NSSet* touches, UIEvent* event, CGFloat scaleFactor);
void sendTouchToCocos_Cancelled(NSSet* touches, UIEvent* event, CGFloat scaleFactor);
void sendTouchToCocos_Moved(NSSet* touches, UIEvent* event, CGFloat scaleFactor);

}

#endif /* Cocos2dxPlugin_h */
