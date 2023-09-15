/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_ConfigInterface.h
 */

#import <Foundation/Foundation.h>

#define	SGIP_DEFAULT_CONFIG_NAME		@"kica_cfg.plist"

@interface SGA_ConfigInterface : NSObject {
	NSString				*configName;
	NSMutableDictionary		*configDict;
}

@property ( nonatomic, retain ) NSString *configName;
@property ( nonatomic, retain ) NSMutableDictionary *configDict;

- (NSString *)configFilePath;
- (int) envInit;
- (int) envSave;
- (NSString *)getValue : (NSString *)pcsName;
- (int) getValueInt : (NSString *)pcsName;
- (int)setValue: (NSString *)pcsName aValue : (NSString *)pcsValue;
- (int)setValueInt: (NSString *)pcsName aValue : (int)iValue;
- (void)removeValue: (NSString *)pcsName;
- (void) envPrint;
- (long) count;

@end
