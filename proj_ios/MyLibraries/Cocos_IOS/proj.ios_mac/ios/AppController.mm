
#import "AppController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppController
// 合成窗口属性
@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

-(void)launch:(UnityAppController*)unityAppController{
//    AppDelegate* s_sharedApplication= new AppDelegate();
    // 获取cocos2d-x单例应用实例
    cocos2d::Application *app = cocos2d::Application::getInstance();
    
//------------!!!!!!!!!!!!!!-----------------
    // 步骤1: 初始化OpenGL上下文属性
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();

//    // 步骤3: 创建并配置根视图控制器
//    _viewController = [[RootViewController alloc]init];
//    _viewController.wantsFullScreenLayout = YES;
//    _viewController = unityAppController.rootViewController;
    
    // 获取Unity的OpenGL ES上下文
//    EAGLContext* unityContext = _UnityAppController.unityContext;
    EAGLContext* unityContext = [EAGLContext currentContext];
    
    // 1. 先拿到屏幕尺寸
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat quarterWidth  = CGRectGetWidth(screenBounds)  / 2.0f;
    CGFloat quarterHeight = CGRectGetHeight(screenBounds) / 2.0f;
    // 2. 定义一个四分之一屏幕大小的 frame（可根据需求调整 origin）
    CGRect quarterFrame = CGRectMake(0, 0, quarterWidth, quarterHeight);
    // Initialize the CCEAGLView
    CCEAGLView *cocosView = [CCEAGLView viewWithFrame: quarterFrame
                                         pixelFormat:kEAGLColorFormatRGBA8
                                         depthFormat: 0
                                  preserveBackbuffer: NO
                                          sharegroup: unityContext.sharegroup
                                       multiSampling:NO
                                     numberOfSamples:0
    ];
    
    // Enable or disable multiple touches
    [cocosView setMultipleTouchEnabled:NO];

//    cocosView.opaque = NO;
//    cocosView.backgroundColor = [UIColor clearColor];
    
//    _viewController.view = cocosView;
    
    // 步骤2: 获取unity主窗口
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIViewController *root = win.rootViewController;
//    window = unityAppController.window;
//    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [win addSubview:cocosView];
//    [window addSubview:cocosView];
//    [window bringSubviewToFront:cocosView];

//    // 步骤4: 根据iOS版本设置根控制器
//    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
//    {
//        // warning: addSubView doesn't work on iOS6
//        [window addSubview: _viewController.view];
//    }
//    else
//    {
//        // use this method on ios6
//        [window setRootViewController:_viewController];
//    }
    
    // 显示主窗口
//    [window makeKeyAndVisible];
    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    // 步骤5: 创建OpenGL视图并与控制器关联
    cocos2d::Director *director = cocos2d::Director::getInstance();
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)cocosView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    // 2. 设定 Clear Color
//    director->setClearColor(cocos2d::ccc4f(1,0,0,1));
    // 关键：设置 OpenGL 清除颜色为透明
    
    // 禁用Cocos2d-x中的深度测试
//    cocos2d::Director::getInstance()->setDepthTest(false);
    
    //run the cocos2d-x game scene
    app->run();
}
// 应用启动完成回调
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // 获取cocos2d-x单例应用实例
//    cocos2d::Application *app = cocos2d::Application::getInstance();
//    
//    // 步骤1: 初始化OpenGL上下文属性
////    app->initGLContextAttrs();
//    cocos2d::GLViewImpl::convertAttrs();
//
//    // 步骤2: 创建主窗口
//    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
//
//    // 步骤3: 创建并配置根视图控制器
//    _viewController = [[RootViewController alloc]init];
//    _viewController.wantsFullScreenLayout = YES;
//    
//
//    // 步骤4: 根据iOS版本设置根控制器
//    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
//    {
//        // warning: addSubView doesn't work on iOS6
//        [window addSubview: _viewController.view];
//    }
//    else
//    {
//        // use this method on ios6
//        [window setRootViewController:_viewController];
//    }
//    // 显示主窗口
//    [window makeKeyAndVisible];
//    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:true];
//    
//    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
//    // 步骤5: 创建OpenGL视图并与控制器关联
//    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)_viewController.view);
//    cocos2d::Director::getInstance()->setOpenGLView(glview);
//    
//    //run the cocos2d-x game scene
//    app->run();

    return YES;
}

// 应用即将进入非活动状态（如来电中断）
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->pause(); */
}
// 应用重新激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->resume(); */
}
// 应用进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    // 触发cocos2d-x的进入后台事件
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}
// 应用即将回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}
// 应用即将终止
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management
// 内存警告处理
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

// 非ARC环境下的内存清理
#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [window release];
    [_viewController release];
    [super dealloc];
}
#endif


@end
