#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.gourav.FocusTimerApp";

/// The "Background" asset catalog color resource.
static NSString * const ACColorNameBackground AC_SWIFT_PRIVATE = @"Background";

/// The "DarkPurple" asset catalog color resource.
static NSString * const ACColorNameDarkPurple AC_SWIFT_PRIVATE = @"DarkPurple";

/// The "Purple" asset catalog color resource.
static NSString * const ACColorNamePurple AC_SWIFT_PRIVATE = @"Purple";

#undef AC_SWIFT_PRIVATE
