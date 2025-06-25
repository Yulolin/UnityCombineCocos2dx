#import "Cocos2dxPlugin_m.h"
#import "cocos2d.h"
#import "UnityInterface.h"

#define TIME_ACCURACY 1000.0

namespace crp {

uint64_t getTouchTimeId(){
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    // 放大到毫秒并取整
    uint64_t idMs = (uint64_t)(ts * TIME_ACCURACY);
    return idMs;
}

void sendTouchBackToUnity(uint64_t touchTimeID, char flag){
    NSSet<UITouch*> *touches = [[TouchCacheManager sharedManager] touchesForTimeID:touchTimeID];
    UIEvent *event =[[TouchCacheManager sharedManager] eventForTimeID:touchTimeID];
    
    switch(flag){
        case 'B':
            UnitySendTouchesBegin(touches, event);break;
        case 'E':
            UnitySendTouchesEnded(touches, event);break;
        case 'C':
            UnitySendTouchesCancelled(touches, event);break;
        case 'M':
            UnitySendTouchesMoved(touches, event);break;
        default:
            printf("回传touch给unity错误");break;
    }
    
}

void sendTouchToCocos_Begin(NSSet* touches, UIEvent* event, CGFloat scaleFactor){
    // 清理一次touch缓存
    [[TouchCacheManager sharedManager] clearCache];
    
    NSArray* touchesArray = [touches allObjects];  // 转成 NSArray
    // 获取时间id，存入Touch缓存
    uint64_t touchTimeID = getTouchTimeId();
    [[TouchCacheManager sharedManager] cacheTouches:touches event:event withTimeID:touchTimeID];
    // 使用cocos的线程
    cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([touchesArray,scaleFactor,touchTimeID](){
        
//        std::thread::id this_id = std::this_thread::get_id();
//        std::cout << "cocos toiuch thread id: " << this_id << std::endl;
//        std::cout << "cocos touch send time id: " << touchTimeID << std::endl;
//        cocos2d::Director::getInstance()->getOpenGLView()->handleTouchesBegin(1, &idlong, &x, &y);
//        UITouch* ids[10] = {0};
        float xs[10] = {0.0f};
        float ys[10] = {0.0f};

        intptr_t idInts[10] = {0}; // 存储转换后的整数指针
        
        int i = 0;
        for (UITouch *touch in touchesArray) {
            if (i >= 10) {
                CCLOG("warning: touches more than 10, should adjust IOS_MAX_TOUCHES_COUNT");
                break;
            }

//            ids[i] = touch;
            // 单个桥接转换（安全）
            idInts[i] = (intptr_t)(__bridge void*)touch;

            xs[i] = [touch locationInView: [touch view]].x * scaleFactor;
            ys[i] = [touch locationInView: [touch view]].y * scaleFactor;
            ++i;
        }

        auto glview = cocos2d::Director::getInstance()->getOpenGLView();
        glview->handleTouchesBegin(i, idInts, xs, ys, touchTimeID);
    });
}

void sendTouchToCocos_Ended(NSSet* touches, UIEvent* event, CGFloat scaleFactor){
    NSArray* touchesArray = [touches allObjects];  // 转成 NSArray
    // 获取时间id，存入Touch缓存
    uint64_t touchTimeID = getTouchTimeId();
    [[TouchCacheManager sharedManager] cacheTouches:touches event:event withTimeID:touchTimeID];
    // 使用cocos的线程
    cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([touchesArray,scaleFactor,touchTimeID](){
        float xs[10] = {0.0f};
        float ys[10] = {0.0f};

        intptr_t idInts[10] = {0}; // 存储转换后的整数指针
        
        int i = 0;
        for (UITouch *touch in touchesArray) {
            if (i >= 10) {
                CCLOG("warning: touches more than 10, should adjust IOS_MAX_TOUCHES_COUNT");
                break;
            }

//            ids[i] = touch;
            // 单个桥接转换（安全）
            idInts[i] = (intptr_t)(__bridge void*)touch;

            xs[i] = [touch locationInView: [touch view]].x * scaleFactor;
            ys[i] = [touch locationInView: [touch view]].y * scaleFactor;
            ++i;
        }

        auto glview = cocos2d::Director::getInstance()->getOpenGLView();
        glview->handleTouchesEnd(i, idInts, xs, ys, touchTimeID);
    });
}

void sendTouchToCocos_Cancelled(NSSet* touches, UIEvent* event, CGFloat scaleFactor){
    NSArray* touchesArray = [touches allObjects];  // 转成 NSArray
    // 获取时间id，存入Touch缓存
    uint64_t touchTimeID = getTouchTimeId();
    [[TouchCacheManager sharedManager] cacheTouches:touches event:event withTimeID:touchTimeID];
    // 使用cocos的线程
    cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([touchesArray,scaleFactor,touchTimeID](){
        float xs[10] = {0.0f};
        float ys[10] = {0.0f};

        intptr_t idInts[10] = {0}; // 存储转换后的整数指针
        
        int i = 0;
        for (UITouch *touch in touchesArray) {
            if (i >= 10) {
                CCLOG("warning: touches more than 10, should adjust IOS_MAX_TOUCHES_COUNT");
                break;
            }

//            ids[i] = touch;
            // 单个桥接转换（安全）
            idInts[i] = (intptr_t)(__bridge void*)touch;

            xs[i] = [touch locationInView: [touch view]].x * scaleFactor;
            ys[i] = [touch locationInView: [touch view]].y * scaleFactor;
            ++i;
        }

        auto glview = cocos2d::Director::getInstance()->getOpenGLView();
        glview->handleTouchesCancel(i, idInts, xs, ys, touchTimeID);
    });
}

void sendTouchToCocos_Moved(NSSet* touches, UIEvent* event, CGFloat scaleFactor){
    NSArray* touchesArray = [touches allObjects];  // 转成 NSArray
    // 获取时间id，存入Touch缓存
    uint64_t touchTimeID = getTouchTimeId();
    [[TouchCacheManager sharedManager] cacheTouches:touches event:event withTimeID:touchTimeID];
    // 使用cocos的线程
    cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([touchesArray,scaleFactor,touchTimeID](){
        intptr_t idInts[10] = {0}; // 存储转换后的整数指针
        float xs[10] = {0.0f};
        float ys[10] = {0.0f};
        float fs[10] = {0.0f};
        float ms[10] = {0.0f};
        
        int i = 0;
        for (UITouch *touch in touchesArray) {
            if (i >= 10) {
                CCLOG("warning: touches more than 10, should adjust IOS_MAX_TOUCHES_COUNT");
                break;
            }
            
            idInts[i] = (intptr_t)(__bridge void*)touch;
            xs[i] = [touch locationInView: [touch view]].x * scaleFactor;
            ys[i] = [touch locationInView: [touch view]].y * scaleFactor;
#if defined(__IPHONE_9_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
            // running on iOS 9.0 or higher version
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
                fs[i] = touch.force;
                ms[i] = touch.maximumPossibleForce;
            }
#endif
            ++i;
        }
        
        auto glview = cocos2d::Director::getInstance()->getOpenGLView();
        glview->handleTouchesMove(i, (intptr_t*)idInts, xs, ys, fs, ms, touchTimeID);
    });
}

}
