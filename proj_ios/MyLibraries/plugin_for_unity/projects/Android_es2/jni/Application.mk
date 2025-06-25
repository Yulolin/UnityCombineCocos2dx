APP_STL := c++_static

APP_CPPFLAGS := -frtti -DCC_ENABLE_CHIPMUNK_INTEGRATION=0 -std=c++14 -fsigned-char -Wno-implicit-const-int-float-conversion
APP_LDFLAGS := -latomic

APP_ABI := armeabi-v7a  arm64-v8a


ifeq ($(NDK_DEBUG),1)
  APP_CPPFLAGS += -DCOCOS2D_DEBUG=1
  APP_OPTIM := debug
  ##redwise新增宏
  APP_CPPFLAGS += -DAK_PLUGINS
else
  APP_CPPFLAGS += -DNDEBUG
  APP_OPTIM := release
  ##redwise新增宏
  APP_CPPFLAGS += -DAK_PLUGINS -DAK_OPTIMIZED
endif
APP_ALLOW_MISSING_DEPS=true

