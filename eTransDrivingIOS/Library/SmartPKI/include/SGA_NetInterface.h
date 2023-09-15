/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_NetInterface.h
 */

#import <Foundation/Foundation.h>


@interface SGA_NetInterface : NSObject {
	
}

+ (BOOL)isNetworkEnable;
+ (BOOL)isWifiStatus;
+ (BOOL)is3GStatus;
+ (BOOL)isConnectEanble : (NSString *)pcsHost aPort : (int)iPort;
+ (BOOL)getMACAddr : (NSString **)ppcsMAC;

@end
