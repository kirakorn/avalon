#ifndef AVALON_UTILS_PLATFORM_H
#define AVALON_UTILS_PLATFORM_H

#include <string>
//#include "cocos2d.h"

#define AVALON_PLATFORM_FLAVOR_AMAZON 1
#define AVALON_PLATFORM_FLAVOR_GOOGLE 2
#define AVALON_PLATFORM_FLAVOR_SAMSUNG 3

#ifdef __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_IPHONE_SIMULATOR
        #define AVALON_PLATFORM_IS_IOS 1
    #elif TARGET_OS_IPHONE
        #define AVALON_PLATFORM_IS_IOS 1
    #elif TARGET_OS_MAC
        #define AVALON_PLATFORM_IS_MAC 1
    #else
        // Unsupported platform
    #endif
#elif __ANDROID__
    #define AVALON_PLATFORM_IS_ANDROID 1
#endif //__APPLE__


#ifdef AVALON_PLATFORM_IS_ANDROID
    #ifndef AVALON_PLATFORM_FLAVOR
        #error "You have to define AVALON_PLATFORM_FLAVOR first"
    #elif (AVALON_PLATFORM_FLAVOR != AVALON_PLATFORM_FLAVOR_AMAZON) \
       && (AVALON_PLATFORM_FLAVOR != AVALON_PLATFORM_FLAVOR_GOOGLE) \
       && (AVALON_PLATFORM_FLAVOR != AVALON_PLATFORM_FLAVOR_SAMSUNG)
        #error "Invalid AVALON_PLATFORM_FLAVOR defined"
    #endif
#else
    #define AVALON_PLATFORM_FLAVOR 0
#endif

#define AVALON_PLATFORM_IS_ANDROID_AMAZON  (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_AMAZON))
#define AVALON_PLATFORM_IS_ANDROID_GOOGLE  (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_GOOGLE))
#define AVALON_PLATFORM_IS_ANDROID_SAMSUNG (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_SAMSUNG))

/*
// such preprocessor stuff is always ugly to use and should be avoided at
// all. but sometimes it's a good and/or the only way to go and then it should
// be at least easy to use, easy to read and easy to maintain. this bunch
// of defines should help a lot to reach those goals :)
#define AVALON_PLATFORM_IS_IOS             (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#define AVALON_PLATFORM_IS_ANDROID         (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#define AVALON_PLATFORM_IS_ANDROID_AMAZON  (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_AMAZON))
#define AVALON_PLATFORM_IS_ANDROID_GOOGLE  (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_GOOGLE))
#define AVALON_PLATFORM_IS_ANDROID_SAMSUNG (AVALON_PLATFORM_IS_ANDROID && (AVALON_PLATFORM_FLAVOR == AVALON_PLATFORM_FLAVOR_SAMSUNG))
#define AVALON_PLATFORM_IS_WIN32           (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#define AVALON_PLATFORM_IS_MARMALADE       (CC_TARGET_PLATFORM == CC_PLATFORM_MARMALADE)
#define AVALON_PLATFORM_IS_LINUX           (CC_TARGET_PLATFORM == CC_PLATFORM_LINUX)
#define AVALON_PLATFORM_IS_BADA            (CC_TARGET_PLATFORM == CC_PLATFORM_BADA)
#define AVALON_PLATFORM_IS_BLACKBERRY      (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
#define AVALON_PLATFORM_IS_MAC             (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#define AVALON_PLATFORM_IS_NACL            (CC_TARGET_PLATFORM == CC_PLATFORM_NACL)
#define AVALON_PLATFORM_IS_EMSCRIPTEN      (CC_TARGET_PLATFORM == CC_PLATFORM_EMSCRIPTEN)
#define AVALON_PLATFORM_IS_TIZEN           (CC_TARGET_PLATFORM == CC_PLATFORM_TIZEN)
#define AVALON_PLATFORM_IS_QT5             (CC_TARGET_PLATFORM == CC_PLATFORM_QT5)
*/

namespace avalon {
namespace utils {
namespace platform {

std::string getName();
std::string getFlavor();

} // namespace platform
} // namespace utils
} // namespace avalon

#endif /* AVALON_UTILS_PLATFORM_H */
