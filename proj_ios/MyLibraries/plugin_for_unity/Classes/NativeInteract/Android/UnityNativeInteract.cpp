#include "UnityNativeInteract.h"

static UnityNativeInteract* mUnityNativeInteract = nullptr;

UnityNativeInteract* UnityNativeInteract::getInstance(){
    if(mUnityNativeInteract == nullptr){
        mUnityNativeInteract = new (std::nothrow)UnityNativeInteract();
    }
    return mUnityNativeInteract;
}

void UnityNativeInteract::Init(int eventListenerPriority){
    createEventListener(eventListenerPriority);
}

void UnityMativeInreract::sendMessageToUnity(string gameObjectName, string methodName, string msg){
    std::string gameObject = gameObjectName;
    std::string method = methodName;
    std::string message = msg;

    JNIEnv* env = cocos2d::JniHelper::getEnv();
    // 查找类
    jclass unityPlayerClass = env->FindClass("com/unity3d/player/UnityPlayer");
    if (!unityPlayerClass) {
        cocos2d::log("Failed to find UnityPlayer class");
        return;
    }
    // 查找方法
    jmethodID sendMessageMethod = env->GetStaticMethodID(
        unityPlayerClass,
        "UnitySendMessage",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
    );
    if (!sendMessageMethod) {
        cocos2d::log("Failed to find UnitySendMessage method");
        env->DeleteLocalRef(unityPlayerClass);
        return;
    }
    // 准备参数,参数需要对其进行转换
    jstring jGameObject = env->NewStringUTF(gameObject.c_str());
    jstring jMethod = env->NewStringUTF(method.c_str());
    jstring jMessage = env->NewStringUTF(message.c_str());
    
    // 调用方法
    env->CallStaticVoidMethod(unityPlayerClass, sendMessageMethod, jGameObject, jMethod, jMessage);
    
    // 异常处理
    if (env->ExceptionCheck()) {
        cocos2d::log("JNI Exception during UnitySendMessage");
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    
    // 释放资源
    env->DeleteLocalRef(jGameObject);
    env->DeleteLocalRef(jMethod);
    env->DeleteLocalRef(jMessage);
    env->DeleteLocalRef(unityPlayerClass);
}

void UnityNativeInteract::sendTouchToUnity(float x, float y) {
    JNIEnv* env = cocos2d::JniHelper::getEnv();
    
    // 查找类
    jclass unityPlayerClass = env->FindClass("com/unity3d/player/UnityPlayerActivity");
    if (!unityPlayerClass) {
        cocos2d::log("Failed to find UnityPlayer class");
        return;
    }
    
    // 查找方法
    jmethodID sendMessageMethod = env->GetStaticMethodID(
        unityPlayerClass,
        "sendTouchToUnity",
        "(FF)V"
    );
    
    if (!sendMessageMethod) {
        cocos2d::log("Failed to find UnitySendMessage method");
        env->DeleteLocalRef(unityPlayerClass);
        return;
    }
    
    jfloat jx = x;
    jfloat jy = y;
    // 调用方法
    env->CallStaticVoidMethod(unityPlayerClass, sendMessageMethod, jx, jy);
    
    // 异常处理
    if (env->ExceptionCheck()) {
        cocos2d::log("JNI Exception during UnitySendMessage");
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    
    // 释放资源
    env->DeleteLocalRef(unityPlayerClass);
}

void UnityNativeInteract::createEventListener(int eventListenerPriority){
    // 创建一个触摸事件监听器
    auto listener = cocos2d::EventListenerTouchOneByOne::create();
    cocos2d::log("创建监听器");

    // onTouchBegan 方法判断触摸开始事件
    listener->onTouchBegan = [](cocos2d::Touch* touch, cocos2d::Event* event) -> bool {
        cocos2d::Vec2 touchLocation = touch->getLocation();
        cocos2d::log("Touch began at: (%f, %f)", touchLocation.x, touchLocation.y);

        UnityNativeInteract::getInstance()->sendTouchToUnity(touchLocation.x, touchLocation.y);

        return true;  // 返回 true，表示事件已经被处理
    };

    // 监听移动事件
    listener->onTouchMoved = [](cocos2d::Touch* touch, cocos2d::Event* event) {
        cocos2d::Vec2 touchLocation = touch->getLocation();
        cocos2d::log("Touch moved to: (%f, %f)", touchLocation.x, touchLocation.y);
        UnityNativeInteract::getInstance()->sendTouchToUnity(touchLocation.x,touchLocation.y);
    };
    // 监听触摸释放
    listener->onTouchEnded = [](cocos2d::Touch* touch, cocos2d::Event* event) {
        cocos2d::Vec2 touchLocation = touch->getLocation();
        cocos2d::log("Touch ended at: (%f, %f)", touchLocation.x, touchLocation.y);
        UnityNativeInteract::getInstance()->sendTouchToUnity(touchLocation.x,touchLocation.y);
    };

    // 将监听器添加到事件分发器
    Director::getInstance()->getEventDispatcher()->addEventListenerWithFixedPriority(listener, eventListenerPriority);
}
