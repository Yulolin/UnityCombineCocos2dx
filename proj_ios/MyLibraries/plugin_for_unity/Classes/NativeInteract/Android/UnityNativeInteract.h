#ifndef UnityNativeInteract_h
#define UnityNativeInteract_h

#if defined(__APPLE__)
    #include <TargetConditionals.h>
#endif

#if defined(__APPLE__) && defined(TARGET_OS_MAC) && !TARGET_OS_IPHONE
    // macOS 平台
    //#include "platform/macos/MacPlatform.h"
#elif defined(__APPLE__) && TARGET_OS_IPHONE
    // iOS 平台
    #include "platform/ios/IOSPlatform.h"
#elif defined(__ANDROID__)
    // Android 平台
    #include <jni/JniHelper.h>
    #include <jni.h>
#endif


#include <string>
#include "cocos2d.h"

class UnityNativeInteract{
public:
    static UnityNativeInteract* getInstance();
    // 初始化事件监听器，传入监听器的优先级（默认为最后触发）
    void Init(int eventListenerPriority = INT_MAX);
    // 发送一条消息到Unity,参数：unity的gameobject物体，该物品挂载的脚本的函数名，消息
    void sendMessageToUnity(string gameObjectName, string methodName, string msg);
private:
    // 通过Java发送触摸事件给Unity，传递触摸坐标（暂时未用到）
    void sendTouchToUnity(float x, float y);
    // 创建全局事件监听器，检测未被Cocos层使用的触屏事件
    void createEventListener(int eventListenerPriority);
};

#endif
