/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGSessionHandler.h
 */

#import <Foundation/Foundation.h>

#import "SGMessageHandler.h"

@interface SGSessionHandler : NSObject <SGMessageHandlerDelegate>
{
	NSString *userDN;
	NSString *userID;
	NSString *userPassword;
}

@property (nonatomic, retain) NSString *userDN;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *userPassword;

- (id)initWithID:(NSString *)aUserID
        password:(NSString *)aUserPassword;

- (NSData *)getCertMsg;
- (NSData *)getLoginMsg;

- (BOOL)setSessionData:(NSData *)serverResponseData;
- (BOOL)setUserCert:(NSData *)serverResponseData;
- (BOOL)parsingLoginResult:(NSData *)serverResponseData;

@end
