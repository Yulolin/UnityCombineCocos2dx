#if PLATFORM_IOS

#import "UnityView.h"
#import "UnityAppController+Rendering.h"
#include "OrientationSupport.h"
#import "Cocos2dxPlugin_m.h"

extern bool _unityAppReady;

@interface UnityView ()
@property (nonatomic, readwrite) ScreenOrientation contentOrientation;
@end

@implementation UnityView (iOS)
- (void)willRotateToOrientation:(UIInterfaceOrientation)toOrientation fromOrientation:(UIInterfaceOrientation)fromOrientation;
{
    // to support the case of interface and unity content orientation being different
    // we will cheat a bit:
    // we will calculate transform between interface orientations and apply it to unity view orientation
    // you can still tweak unity view as you see fit in AppController, but this is what you want in 99% of cases

    ScreenOrientation to    = ConvertToUnityScreenOrientation(toOrientation);
    ScreenOrientation from  = ConvertToUnityScreenOrientation(fromOrientation);

    if (fromOrientation == UIInterfaceOrientationUnknown)
        _curOrientation = to;
    else
        _curOrientation = OrientationAfterTransform(_curOrientation, TransformBetweenOrientations(from, to));

    _viewIsRotating = YES;
}

- (void)didRotate
{
    if (_shouldRecreateView)
    {
        [self recreateRenderingSurface];
    }

    _viewIsRotating = NO;
}

// iOS层发送给unity的触摸事件
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event      {

    if(!crp::isCocosStarted){
        UnitySendTouchesBegin(touches, event);
        return;
    }
    std::thread::id this_id = std::this_thread::get_id();
    std::cout << "ios toiuch thread id: " << this_id << std::endl;
    
    crp::sendTouchToCocos_Begin(touches, event, self.contentScaleFactor);
    
//    UnitySendTouchesBegin(touches, event);
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!crp::isCocosStarted){
        UnitySendTouchesEnded(touches, event);
        return;
    }
    
    crp::sendTouchToCocos_Ended(touches, event, self.contentScaleFactor);
    
//    UnitySendTouchesEnded(touches, event);
}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event  {
    if(!crp::isCocosStarted){
        UnitySendTouchesCancelled(touches, event);
        return;
    }
    
    crp::sendTouchToCocos_Cancelled(touches, event, self.contentScaleFactor);
    
//    UnitySendTouchesCancelled(touches, event);
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event      {
    if(!crp::isCocosStarted){
        UnitySendTouchesMoved(touches, event);
        return;
    }
    
    crp::sendTouchToCocos_Moved(touches, event, self.contentScaleFactor);
    
//    UnitySendTouchesMoved(touches, event);
}

@end

#endif // PLATFORM_IOS
