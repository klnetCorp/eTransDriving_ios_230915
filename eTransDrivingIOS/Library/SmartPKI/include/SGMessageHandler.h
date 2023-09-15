/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGMessageHandler.h
 */

#import <Foundation/Foundation.h>

@protocol SGMessageHandlerDelegate

- (NSData *)valueForElement:(NSString *)element withAttributes:(NSDictionary *)attributes;

@end

@interface SGMessageHandler : NSObject<NSXMLParserDelegate> {
	id<SGMessageHandlerDelegate> delegate;
}

- (void)setDelegate:(id)anObject;

- (NSData *)getMsgFromRequest:(NSString *)aRequestMsg;

- (NSData *)getMsgFromRequest:(NSString *)aRequestMsg
                           dn:(NSString *)aSelectedDN
                     password:(NSString *)aCertPassword
                          idn:(NSString *)aUserIDN;

- (void)setUserDN:(NSString *)aUserDN;
- (void)setCertPassword:(NSString *)aPassword;
- (void)setUserIDN:(NSString *)aUserIDN;
- (void)setServerKmCert:(NSData *)aServerCert;

@end
