LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := plugin_for_unity_static
LOCAL_MODULE_FILENAME := plugin_for_unity
LOCAL_ARM_MODE := arm

LOCAL_SRC_FILES := source/RenderAPI.cpp \
                   source/Cocos2dxPlugin.cpp \
                   source/RenderAPI_OpenGLES2.cpp \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/source \

LOCAL_STATIC_LIBRARIES := cocos2dx_internal_static

include $(BUILD_STATIC_LIBRARY)