/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE:  SGA_LogInterface.h
 */


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SGA_LogInterface : NSObject {
	NSFileHandle	*hFile;
}

- (void) init : (NSString *)pcsFilePath;
- (int) writeLog : (NSString *)pcsLog;

+ (int)writeLog2 : (NSString *)pcsFilePath aLog : (NSString *)pcsLog;
+ (int)writeLog3 : (NSString *)pcsFilePath aName : (NSString *)pcsName aValue : (NSString *)pcsValue;

@end
