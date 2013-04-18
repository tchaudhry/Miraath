//
//  FWIOSVersions.h
//  FWCommon
//
//  Created by Fabio Gallonetto on 14/07/2010.
//  Copyright 2010 Future Workshops. All rights reserved.
//

#ifndef FW_INLINE
#define FW_INLINE extern inline
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_0
  #define kCFCoreFoundationVersionNumber_iPhoneOS_2_0 478.23
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_1
  #define kCFCoreFoundationVersionNumber_iPhoneOS_2_1 478.26
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_2
  #define kCFCoreFoundationVersionNumber_iPhoneOS_2_2 478.29
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_0
  #define kCFCoreFoundationVersionNumber_iPhoneOS_3_0 478.47
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_1
  #define kCFCoreFoundationVersionNumber_iPhoneOS_3_1 478.52
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
  #define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_4_0
  #define kCFCoreFoundationVersionNumber_iOS_4_0 550.32
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 674.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
  #define IF_IOS3_2_OR_GREATER(...) if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2) { __VA_ARGS__ }
#else
  #define IF_IOS3_2_OR_GREATER(...) do { } while (0)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
  #define IF_IOS4_OR_GREATER(...) if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) { __VA_ARGS__ }
#else
  #define IF_IOS4_OR_GREATER(...) do { } while (0)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#define IF_IOS5_OR_GREATER(...) if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) { __VA_ARGS__ }
#else
#define IF_IOS5_OR_GREATER(...) do { } while (0)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#define IF_IOS6_OR_GREATER(...) if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) { __VA_ARGS__ }
#else
#define IF_IOS6_OR_GREATER(...) do { } while (0)
#endif

#pragma mark -
#pragma mark Platform Detection

FOUNDATION_STATIC_INLINE BOOL FW_isIOS4()
{
    IF_IOS4_OR_GREATER (return YES;);
    return NO;
}

FOUNDATION_STATIC_INLINE BOOL FW_isIOS5()
{
    IF_IOS5_OR_GREATER (return YES;);
    return NO;
}

FOUNDATION_STATIC_INLINE BOOL FW_isIOS6()
{
    IF_IOS6_OR_GREATER (return YES;);
    return NO;
}

FOUNDATION_STATIC_INLINE BOOL FW_isIPad()
{
	IF_IOS3_2_OR_GREATER (
						  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
							  return YES;
						  }
						  );
	return NO;
}

