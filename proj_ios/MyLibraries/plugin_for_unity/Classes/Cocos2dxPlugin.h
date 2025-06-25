//
//  Cocos2dxPlugin.h
//  Cocos2dxPlugin
//
//  Created by red on 2025/6/23.
//

#ifndef Cocos2dxPlugin_h
#define Cocos2dxPlugin_h

#include "PlatformBase.h"
#include "RenderAPI.h"

#include <assert.h>
#include <math.h>
#include <vector>
#include <iostream>
#include <thread>


// Cocos Render Plugin 插件
namespace crp{
// 屏幕宽高
extern float width;
extern float height;
// cocos启动标志，0：未启动，1：已发送启动命令，2：已启动
extern int isCocosStarted;
// 启动coocs
extern "C" UNITY_INTERFACE_EXPORT void UNITY_INTERFACE_API CocosEngine_Start(int width, int height);
// 发送touch给unity
void sendTouchBackToUnity(uint64_t touchTimeID, char flag);
// 屏幕大小调整
extern void setScreenSize(float screenWidth, float screenHeight);

#pragma mark - Cocos AppDelegate事件处理
void CocosApplicationDidEnterBackground();
void CocosApplicationWillEnterForeground();

// 创建全局事件监听器，用于检测没被cocos吃掉的touch
void createTouchListener(int listenerPriority = INT_MAX);

}


#endif /* Cocos2dxPlugin_h */
