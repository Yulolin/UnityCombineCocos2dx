#include "UnityView.h"
#include "UnityAppController.h"
#include "UnityAppController+Rendering.h"
#include "OrientationSupport.h"
#include "Unity/DisplayManager.h"
#include "Unity/UnityMetalSupport.h"
#include "Unity/ObjCRuntime.h"

extern bool _renderingInited;
extern bool _unityAppReady;
extern bool _skipPresent;
extern bool _supportsMSAA;

@implementation UnityView
{
    CGSize _surfaceSize;
}

@synthesize contentOrientation  = _curOrientation;

- (void)onUpdateSurfaceSize:(CGSize)size
{
    _surfaceSize = size;

    CGSize systemRenderSize = CGSizeMake(size.width * self.contentScaleFactor, size.height * self.contentScaleFactor);
    _curOrientation = (ScreenOrientation)UnityReportResizeView(systemRenderSize.width, systemRenderSize.height, _curOrientation);
    ReportSafeAreaChangeForView(self);
}

- (void)boundsUpdated
{
    [self onUpdateSurfaceSize: self.bounds.size];
}

- (void)initImpl:(CGRect)frame scaleFactor:(CGFloat)scale
{
#if !PLATFORM_TVOS
    self.multipleTouchEnabled   = YES;
    self.exclusiveTouch         = YES;
#endif
    self.contentScaleFactor     = scale;
    self.isAccessibilityElement = TRUE;
    self.accessibilityTraits    = UIAccessibilityTraitAllowsDirectInteraction;

#if UNITY_TVOS
    _curOrientation = UNITY_TVOS_ORIENTATION;
#endif

    [self onUpdateSurfaceSize: frame.size];
}

- (id)initWithFrame:(CGRect)frame scaleFactor:(CGFloat)scale;
{
    if ((self = [super initWithFrame: frame]))
        [self initImpl: frame scaleFactor: scale];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame: frame]))
        [self initImpl: frame scaleFactor: 1.0f];
    return self;
}

- (id)initFromMainScreen
{
    CGRect  frame   = [UIScreen mainScreen].bounds;
    CGFloat scale   = UnityScreenScaleFactor([UIScreen mainScreen]);
    if ((self = [super initWithFrame: frame]))
        [self initImpl: frame scaleFactor: scale];
    return self;
}

- (void)layoutSubviews
{
    if (_surfaceSize.width != self.bounds.size.width || _surfaceSize.height != self.bounds.size.height)
        _shouldRecreateView = YES;
    [self onUpdateSurfaceSize: self.bounds.size];

    for (UIView* subView in self.subviews)
    {
        if ([subView respondsToSelector: @selector(onUnityUpdateViewLayout)])
            [subView performSelector: @selector(onUnityUpdateViewLayout)];
    }

    [super layoutSubviews];
}

- (void)safeAreaInsetsDidChange
{
    ReportSafeAreaChangeForView(self);
}

- (void)recreateRenderingSurfaceIfNeeded
{
    float requestedContentScaleFactor = UnityScreenScaleFactor([UIScreen mainScreen]);
    if (abs(requestedContentScaleFactor - self.contentScaleFactor) > FLT_EPSILON)
    {
        self.contentScaleFactor = requestedContentScaleFactor;
        [self onUpdateSurfaceSize: self.bounds.size];
    }

    unsigned requestedW, requestedH;    UnityGetRenderingResolution(&requestedW, &requestedH);
    int requestedMSAA = UnityGetDesiredMSAASampleCount(MSAA_DEFAULT_SAMPLE_COUNT);
    int requestedSRGB = UnityGetSRGBRequested();
    int requestedWideColor = UnityGetWideColorRequested();
    int requestedMemorylessDepth = UnityMetalMemorylessDepth();

    UnityDisplaySurfaceBase* surf = GetMainDisplaySurface();

    if (_shouldRecreateView == YES
        ||  surf->targetW != requestedW || surf->targetH != requestedH
        ||  surf->disableDepthAndStencil != UnityDisableDepthAndStencilBuffers()
        ||  (_supportsMSAA && surf->msaaSamples != requestedMSAA)
        ||  surf->srgb != requestedSRGB
        ||  surf->wideColor != requestedWideColor
        ||  surf->memorylessDepth != requestedMemorylessDepth
    )
    {
        [self recreateRenderingSurface];
    }
}

- (void)recreateRenderingSurface
{
    if (_renderingInited)
    {
        unsigned requestedW, requestedH;
        UnityGetRenderingResolution(&requestedW, &requestedH);

        RenderingSurfaceParams params =
        {
            .msaaSampleCount        = UnityGetDesiredMSAASampleCount(MSAA_DEFAULT_SAMPLE_COUNT),
            .renderW                = (int)requestedW,
            .renderH                = (int)requestedH,
            .srgb                   = UnityGetSRGBRequested(),
            .wideColor              = UnityGetWideColorRequested(),
            .metalFramebufferOnly   = UnityMetalFramebufferOnly(),
            .metalMemorylessDepth   = UnityMetalMemorylessDepth(),
            .disableDepthAndStencil = UnityDisableDepthAndStencilBuffers(),
            .useCVTextureCache      = 0,
        };

        APP_CONTROLLER_RENDER_PLUGIN_METHOD_ARG(onBeforeMainDisplaySurfaceRecreate, &params);
        [GetMainDisplay() recreateSurface: params];

        // actually poke unity about updated back buffer and notify that extents were changed
        UnityReportBackbufferChange(GetMainDisplaySurface()->unityColorBuffer, GetMainDisplaySurface()->unityDepthBuffer);
        APP_CONTROLLER_RENDER_PLUGIN_METHOD(onAfterMainDisplaySurfaceRecreate);

        if (_unityAppReady)
        {
            // seems like ios sometimes got confused about abrupt swap chain destroy
            // draw 2 times to fill both buffers
            // present only once to make sure correct image goes to CA
            // if we are calling this from inside repaint, second draw and present will be done automatically
            _skipPresent = true;
            if (!UnityIsPaused())
            {
                UnityRepaint();
                // we are not inside repaint so we need to draw second time ourselves
                if (_viewIsRotating)
                    UnityRepaint();
            }
            _skipPresent = false;
        }
    }

    _shouldRecreateView = NO;
}

@end

@implementation UnityView (Deprecated)
- (void)recreateGLESSurfaceIfNeeded { [self recreateRenderingSurfaceIfNeeded]; }
- (void)recreateGLESSurface         { [self recreateRenderingSurface]; }
@end

static Class UnityRenderingView_LayerClassGLES(id self_, SEL _cmd)
{
    return [CAEAGLLayer class];
}

static Class UnityRenderingView_LayerClassMTL(id self_, SEL _cmd)
{
    return [[NSBundle bundleWithPath: @"/System/Library/Frameworks/QuartzCore.framework"] classNamed: @"CAMetalLayer"];
}

@implementation UnityRenderingView
+ (Class)layerClass
{
    return nil;
}

+ (void)InitializeForAPI:(UnityRenderingAPI)api
{
    IMP layerClassImpl = 0;
    if (api == apiOpenGLES2 || api == apiOpenGLES3)
        layerClassImpl = (IMP)UnityRenderingView_LayerClassGLES;
    else if (api == apiMetal)
        layerClassImpl = (IMP)UnityRenderingView_LayerClassMTL;

    class_replaceMethod(object_getClass([UnityRenderingView class]), @selector(layerClass), layerClassImpl, UIView_LayerClass_Enc);
}

@end

void ReportSafeAreaChangeForView(UIView* view)
{
    CGRect safeArea = ComputeSafeArea(view);
    UnityReportSafeAreaChange(safeArea.origin.x, safeArea.origin.y,
        safeArea.size.width, safeArea.size.height);

    if (UnityDeviceHasCutout())
    {
        CGSize cutoutSizeRatio = GetCutoutToScreenRatio();

        if (!CGSizeEqualToSize(CGSizeZero, cutoutSizeRatio))
        {
            const float w = ([UIScreen mainScreen].nativeBounds.size.width * cutoutSizeRatio.width);
            const float h = ([UIScreen mainScreen].nativeBounds.size.height * cutoutSizeRatio.height);

            // Apple's cutouts are currently centred on the horizontal, and stuck to the top of the vertical, hence this positioning.
            const float x = (([UIScreen mainScreen].nativeBounds.size.width - w) / 2);
            const float y = ([UIScreen mainScreen].nativeBounds.size.height - h);
            UnityReportDisplayCutouts(&x, &y, &w, &h, 1);
            return;
        }
    }

    UnityReportDisplayCutouts(nullptr, nullptr, nullptr, nullptr, 0);
}

CGRect ComputeSafeArea(UIView* view)
{
    CGSize screenSize = view.bounds.size;
    CGRect screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, tvOS 11.0, *))
        insets = [view safeAreaInsets];

    screenRect.origin.x += insets.left;
    screenRect.origin.y += insets.bottom; // Unity uses bottom left as the origin
    screenRect.size.width -= insets.left + insets.right;
    screenRect.size.height -= insets.top + insets.bottom;

    float scale = view.contentScaleFactor;

    // Truncate safe area size because in some cases (for example when Display zoom is turned on)
    // it might become larger than Screen.width/height which are returned as ints.
    screenRect.origin.x = (unsigned)(screenRect.origin.x * scale);
    screenRect.origin.y = (unsigned)(screenRect.origin.y * scale);
    screenRect.size.width = (unsigned)(screenRect.size.width * scale);
    screenRect.size.height = (unsigned)(screenRect.size.height * scale);
    return screenRect;
}

// Apple does not provide the cutout width and height in points/pixels. They *do* however list the
// size of the cutout and screen in mm for accessory makers. We can use this information to calculate the percentage of the screen is cutout.
// This information can be found here - https://developer.apple.com/accessories/Accessory-Design-Guidelines.pdf
CGSize GetCutoutToScreenRatio()
{
    switch (UnityDeviceGeneration())
    {
        case deviceiPhone13ProMax:
            return CGSizeMake(0.373, 0.036);
        case deviceiPhone13Pro:
        case deviceiPhone13:
            return CGSizeMake(0.4148, 0.0399);
        case deviceiPhone13Mini:
            return CGSizeMake(0.4644, 0.0462);
        case deviceiPhone12ProMax:
            return CGSizeMake(0.4897, 0.0346);
        case deviceiPhone12Pro:
        case deviceiPhone12:
            return CGSizeMake(0.5393, 0.0379);
        case deviceiPhone12Mini:
            return CGSizeMake(0.604, 0.0424);
        case deviceiPhone11ProMax:
            return CGSizeMake(0.5057, 0.0335);
        case deviceiPhone11Pro:
            return CGSizeMake(0.5583, 0.037);
        case deviceiPhone11:
        case deviceiPhoneXR:
            return CGSizeMake(0.5568, 0.0398);
        case deviceiPhoneXSMax:
            return CGSizeMake(0.4884, 0.0333);
        case deviceiPhoneX:
        case deviceiPhoneXS:
            return CGSizeMake(0.5391, 0.0368);
        default:
            NSCAssert(!UnityDeviceHasCutout(), @"Device has a cutout, but no ratio has been added for it.");
            return CGSizeZero;
    }
}
