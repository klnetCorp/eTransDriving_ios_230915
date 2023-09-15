/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_DBInterface.h
 */


#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define SGIP_LOG_TYPE_DAY		1
#define	SGIP_LOG_TYPE_WEEK		2
#define	SGIP_LOG_TYPE_MONTH		3
#define SGIP_LOG_TYPE_3MONTH	4
#define SGIP_LOG_TYPE_YEAR		5

typedef struct _SGIP_Log {
	int					seq;
	char				date[64];
	char				site[256];
	char				usage[64];
	struct _SGIP_Log	*next;
} SGIP_Log;

@interface SGA_DBInterface : NSObject {
	sqlite3			*db;
}

- (int)open : (NSString *)dbName;
- (void)close;

- (int)createLogTable;
- (int)addLog : (SGIP_Log *)log;
- (int)addLog2 : (NSString *)site aUsage : (NSString *)usage;
- (int)delLog : (int)seq;
- (int)getLog : (int)seq aLog : (SGIP_Log *)log;
- (int)countLog : (int)type;

- (int)listLog:(int)type aLogList:(SGIP_Log **)ppstListLog;
+ (void)resetLogList : (SGIP_Log **)ppstLogList;

@end
