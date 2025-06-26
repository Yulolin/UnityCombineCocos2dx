using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using UnityEngine.Rendering;
using System.Threading;

public class Cocos2dxPlugin : MonoBehaviour
{

    IEnumerator Start()
    {
        Application.targetFrameRate = 60;
        //CreateTextureAndPassToPlugin();
        yield return StartCoroutine("CallPluginAtEndOfFrames");
    }

    private IEnumerator CallPluginAtEndOfFrames()
    {
        while (true)
        {
            // Wait until all frame rendering is done
            yield return new WaitForEndOfFrame();

            // Issue a plugin event with arbitrary integer identifier.
            // The plugin can distinguish between different
            // things it needs to do based on this ID.
            // On some backends the choice of eventID matters e.g on DX12 where
            // eventID == 1 means the plugin callback will be called from the render thread
            // and eventID == 2 means the callback is called from the submission thread
            GL.IssuePluginEvent(GetRenderEventFunc(), 1);
        }
    }
    
        private void Update()
    {
        if (Input.touchCount > 0)
        {
            var touch = Input.GetTouch(0);
            float x = touch.position.x;
            float y = Screen.height - touch.position.y;
            //if (touch.phase == TouchPhase.Began)
            //{
            //    this._cocos_nativeTouchesBegin(0, x, y);
            //}
            //else if(touch.phase == TouchPhase.Moved)
            //{
            //    this._cocos_nativeTouchesMove(0, x, y);
            //}
            //else if (touch.phase == TouchPhase.Ended)
            //{
            //    this._cocos_nativeTouchesEnd(0, x, y);
            //}
            //else if (touch.phase == TouchPhase.Canceled)
            //{
            //    this._cocos_nativeTouchesCancel(0, x, y);
            //}

        }
    }

    // 启动Cocos渲染画面
    public void onClickEngineStart()
    {
#if PLATFORM_ANDROID && !UNITY_EDITOR
        _cocos_nativeInit();
        CocosEngine_Start(Screen.width, Screen.height);

        _Cocos2dxRenderer_JavaClass = new AndroidJavaClass("org.cocos2dx.lib.Cocos2dxRenderer");

#elif PLATFORM_IOS 
        CocosEngine_Start(Screen.width, Screen.height);
#endif
    }

#region iOS Native函数

#if (PLATFORM_IOS || PLATFORM_TVOS || PLATFORM_BRATWURST || PLATFORM_SWITCH) 
    [DllImport("__Internal")]
    private static extern IntPtr GetRenderEventFunc();

    [DllImport("__Internal")]
    private static extern void CocosEngine_Start(int width, int height);
#endif

#endregion

#region Android Native函数

#if PLATFORM_ANDROID 
    const string _cocosGameLibName = "MyGame";

    private AndroidJavaClass _Cocos2dxRenderer_JavaClass = null;

    [DllImport(_cocosGameLibName)]
    private static extern IntPtr GetRenderEventFunc();

    [DllImport(_cocosGameLibName)]
    private static extern void CocosEngine_Start(int width, int height);

    // 发送给Cocos传递触摸事件
    public void sendTouchToCocos(string paramsStr)
    {
        string[] parts = paramsStr.Split(':');
        char type = char.Parse(parts[0]);
        float x = float.Parse(parts[1]);
        float y = float.Parse(parts[2]);
        Debug.Log(paramsStr + "::" + type + " x:" + x + "y:" + y);
        switch (type)
        {
            case 'B':
                _cocos_nativeTouchesBegin(0, x, y);
                break;
            case 'E':
                _cocos_nativeTouchesEnd(0, x, y);
                break;
            case 'M':
                _cocos_nativeTouchesMove(0, x, y);
                break;
            case 'C':
                _cocos_nativeTouchesCancel(0, x, y);
                break;
        }
    }

    // 初始化Android
    private static void _cocos_nativeInit()
    {
        AndroidJavaClass javaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayerActivity");
        javaClass.CallStatic("cocosEngine_Create");
    }

    public void _cocos_nativeTouchesBegin(int touchId, float x, float y)
    {
        if (null == _Cocos2dxRenderer_JavaClass)
        {
            return;
        }
        _Cocos2dxRenderer_JavaClass.CallStatic("nativeTouchesBegin", touchId, x, y);
    }
    public void _cocos_nativeTouchesEnd(int touchId, float x, float y)
    {
        if (null == _Cocos2dxRenderer_JavaClass)
        {
            return;
        }
        _Cocos2dxRenderer_JavaClass.CallStatic("nativeTouchesEnd", touchId, x, y);
    }
    public void _cocos_nativeTouchesMove(int touchId, float x, float y)
    {
        if (null == _Cocos2dxRenderer_JavaClass)
        {
            return;
        }
        int[] touchs = { touchId };
        float[] xs = { x };
        float[] ys = { y };
        _Cocos2dxRenderer_JavaClass.CallStatic("nativeTouchesMove", touchs, xs, ys);
    }
    public void _cocos_nativeTouchesCancel(int touchId, float x, float y)
    {
        if (null == _Cocos2dxRenderer_JavaClass)
        {
            return;
        }
        int[] touchs = { touchId };
        float[] xs = { x };
        float[] ys = { y };
        _Cocos2dxRenderer_JavaClass.CallStatic("nativeTouchesCancel", touchs, xs, ys);
    }
    
#endif

#endregion

}