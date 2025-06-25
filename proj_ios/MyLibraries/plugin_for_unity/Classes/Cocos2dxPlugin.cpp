// Example low level rendering Unity plugin
#include "Cocos2dxPlugin.h"
#import "cocos2d.h"
#import "AppDelegate.h"

namespace crp {
// 屏幕的宽高
float width = 0;
float height = 0;

int isCocosStarted = 0;

void setScreenSize(float screenWidth, float screenHeight){
    width = screenWidth;
    height = screenHeight;
    // 设置cocos的大小
    if(isCocosStarted==2){
        // 在cocos线程设置
        cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([]{
            cocos2d::Director::getInstance()->getOpenGLView()->setFrameSize(width, height);
        });
    }
}

#pragma mark - Cocos AppDelegate事件处理
void CocosApplicationDidEnterBackground(){
    if(isCocosStarted){
        cocos2d::Application::getInstance()->applicationDidEnterBackground();
    }
}
void CocosApplicationWillEnterForeground(){
    if(isCocosStarted){
        cocos2d::Application::getInstance()->applicationWillEnterForeground();
    }
}

#pragma mark - Cocos Touch事件监听
void createTouchListener(int listenerPriority){
    // 创建一个触摸事件监听器
    auto listener = cocos2d::EventListenerTouchOneByOne::create();
    cocos2d::log("创建监听器");
    
    // onTouchBegan 方法判断触摸开始事件
    listener->onTouchBegan = [](cocos2d::Touch* touch, cocos2d::Event* event) -> bool {
        cocos2d::Vec2 touchLocation = touch->getLocation();
//        cocos2d::log("Touch began at: (%f, %f)", touchLocation.x, touchLocation.y);
        
        sendTouchBackToUnity(event->touchTimeID, 'B');
        return true;  // 返回 true，表示事件已经被处理
    };

    // 监听移动事件
    listener->onTouchMoved = [](cocos2d::Touch* touch, cocos2d::Event* event) {
        cocos2d::Vec2 touchLocation = touch->getLocation();
//        cocos2d::log("Touch moved to: (%f, %f)", touchLocation.x, touchLocation.y);

        sendTouchBackToUnity(event->touchTimeID, 'M');
    };
    // 监听触摸释放
    listener->onTouchEnded = [](cocos2d::Touch* touch, cocos2d::Event* event) {
//        cocos2d::Vec2 touchLocation = touch->getLocation();
//        cocos2d::log("Touch ended at: (%f, %f)", touchLocation.x, touchLocation.y);

        sendTouchBackToUnity(event->touchTimeID, 'E');
    };
    listener->onTouchCancelled= [](cocos2d::Touch* touch, cocos2d::Event* event) {
        cocos2d::Vec2 touchLocation = touch->getLocation();
//        cocos2d::log("Touch ended at: (%f, %f)", touchLocation.x, touchLocation.y);

        sendTouchBackToUnity(event->touchTimeID, 'C');
    };

    // 将监听器添加到事件分发器
    cocos2d::Director::getInstance()->getEventDispatcher()->addEventListenerWithFixedPriority(listener, listenerPriority);
}

#pragma mark - unity Interface Plugin处理

static float g_Time;

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API SetTimeFromUnity (float t) { g_Time = t; }

// --------------------------------------------------------------------------
// SetTextureFromUnity, an example function we export which is called by one of the scripts.

static void* g_TextureHandle = NULL;
static int   g_TextureWidth  = 0;
static int   g_TextureHeight = 0;

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API SetTextureFromUnity(void* textureHandle, int w, int h)
{
    // A script calls this at initialization time; just remember the texture pointer here.
    // Will update texture pixels each frame from the plugin rendering event (texture update
    // needs to happen on the rendering thread).
    g_TextureHandle = textureHandle;
    g_TextureWidth = w;
    g_TextureHeight = h;
}

// --------------------------------------------------------------------------
// UnitySetInterfaces

static void UNITY_INTERFACE_API OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType);

static IUnityInterfaces* s_UnityInterfaces = NULL;
static IUnityGraphics* s_Graphics = NULL;

extern "C" void	UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API UnityPluginLoad(IUnityInterfaces* unityInterfaces)
{
    s_UnityInterfaces = unityInterfaces;
    s_Graphics = s_UnityInterfaces->Get<IUnityGraphics>();
    s_Graphics->RegisterDeviceEventCallback(OnGraphicsDeviceEvent);
    
#if SUPPORT_VULKAN
    if (s_Graphics->GetRenderer() == kUnityGfxRendererNull)
    {
        extern void RenderAPI_Vulkan_OnPluginLoad(IUnityInterfaces*);
        RenderAPI_Vulkan_OnPluginLoad(unityInterfaces);
    }
#endif // SUPPORT_VULKAN
    
    // Run OnGraphicsDeviceEvent(initialize) manually on plugin load
    OnGraphicsDeviceEvent(kUnityGfxDeviceEventInitialize);
}

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API UnityPluginUnload()
{
    s_Graphics->UnregisterDeviceEventCallback(OnGraphicsDeviceEvent);
}

// --------------------------------------------------------------------------
// GraphicsDeviceEvent


static RenderAPI* s_CurrentAPI = NULL;
static UnityGfxRenderer s_DeviceType = kUnityGfxRendererNull;


static void UNITY_INTERFACE_API OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType)
{
    // Create graphics API implementation upon initialization
    if (eventType == kUnityGfxDeviceEventInitialize)
    {
        assert(s_CurrentAPI == NULL);
        s_DeviceType = s_Graphics->GetRenderer();
        s_CurrentAPI = CreateRenderAPI(s_DeviceType);
    }
    
    // Let the implementation process the device related events
    if (s_CurrentAPI)
    {
        s_CurrentAPI->ProcessDeviceEvent(eventType, s_UnityInterfaces);
    }
    
    // Cleanup graphics API implementation upon shutdown
    if (eventType == kUnityGfxDeviceEventShutdown)
    {
        delete s_CurrentAPI;
        s_CurrentAPI = NULL;
        s_DeviceType = kUnityGfxRendererNull;
    }
}

// --------------------------------------------------------------------------
// OnRenderEvent
// This will be called for GL.IssuePluginEvent script calls; eventID will
// be the integer passed to IssuePluginEvent. In this example, we just ignore
// that value.

static void DrawCocos()
{
    // 第一次先创建
    if(isCocosStarted==1){
        AppDelegate *pAppDelegate = new AppDelegate();
        auto director = cocos2d::Director::getInstance();
        auto glview = director->getOpenGLView();
        if (!glview)
        {
            
            cocos2d::GLViewImpl* glview2 = cocos2d::GLViewImpl::create("IOS app");
            
            glview2->setFrameSize(width, height);
            director->setOpenGLView(glview2);
            
            cocos2d::Application::getInstance()->run();
        }
        isCocosStarted = 2;
    }

    cocos2d::Director::getInstance()->mainLoop();
}

static void drawToPluginTexture()
{
    s_CurrentAPI->drawToPluginTexture();
}

static void drawToRenderTexture()
{
    s_CurrentAPI->drawToRenderTexture();
}

static void UNITY_INTERFACE_API OnRenderEvent(int eventID)
{
//    // 获取当前线程的 std::thread::id
//    std::thread::id this_id = std::this_thread::get_id();
//    // 直接输出（实现会把 id 格式化成可读字符串）
//    std::cout << "RenderEvent thread id: " << this_id << std::endl;
    // Unknown / unsupported graphics device type? Do nothing
    if (s_CurrentAPI == NULL)
        return;
    
    if (eventID == 1)
    {
        drawToRenderTexture();
        DrawCocos();
    }
    
    if (eventID == 2)
    {
        drawToPluginTexture();
    }
    
}

// --------------------------------------------------------------------------
// GetRenderEventFunc, an example function we export which is used to get a rendering event callback function.
extern "C" UnityRenderingEvent UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API GetRenderEventFunc()
{
    return OnRenderEvent;
}

// --------------------------------------------------------------------------
// DX12 plugin specific
// --------------------------------------------------------------------------

extern "C" UNITY_INTERFACE_EXPORT void* UNITY_INTERFACE_API GetRenderTexture()
{
    return s_CurrentAPI->getRenderTexture();
}

extern "C" UNITY_INTERFACE_EXPORT void UNITY_INTERFACE_API SetRenderTexture(UnityRenderBuffer rb)
{
    s_CurrentAPI->setRenderTextureResource(rb);
}

extern "C" UNITY_INTERFACE_EXPORT bool UNITY_INTERFACE_API IsSwapChainAvailable()
{
    return s_CurrentAPI->isSwapChainAvailable();
}

extern "C" UNITY_INTERFACE_EXPORT unsigned int UNITY_INTERFACE_API GetPresentFlags()
{
    return s_CurrentAPI->getPresentFlags();
}

extern "C" UNITY_INTERFACE_EXPORT unsigned int UNITY_INTERFACE_API GetSyncInterval()
{
    return s_CurrentAPI->getSyncInterval();
}

extern "C" UNITY_INTERFACE_EXPORT unsigned int UNITY_INTERFACE_API GetBackBufferWidth()
{
    return s_CurrentAPI->getBackbufferHeight();
}

extern "C" UNITY_INTERFACE_EXPORT unsigned int UNITY_INTERFACE_API GetBackBufferHeight()
{
    return s_CurrentAPI->getBackbufferWidth();
}

extern "C" UNITY_INTERFACE_EXPORT void UNITY_INTERFACE_API CocosEngine_Start(int width, int height)
{
    
//    if(isCocosStarted){
//        return;
//    }
    if(isCocosStarted==0)
        isCocosStarted = 1;
    //
    // 获取当前线程的 std::thread::id
    std::thread::id this_id = std::this_thread::get_id();
    // 直接输出（实现会把 id 格式化成可读字符串）
    std::cout << "Native thread id: " << this_id << std::endl;
    
    //    AppDelegate *pAppDelegate = new AppDelegate();
    //    auto director = cocos2d::Director::getInstance();
    //    auto glview = director->getOpenGLView();
    //    if (!glview)
    //    {
    //        glview = cocos2d::GLViewImpl::create("IOS app");
    //        glview->setFrameSize(width, height);
    //        director->setOpenGLView(glview);
    //
    //        cocos2d::Application::getInstance()->run();
    //    }
}
}
