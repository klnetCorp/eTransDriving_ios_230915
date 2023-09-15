/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_EtcInterface.h
 */

#import <Foundation/Foundation.h>
//#import "SGA_Interface.h"

@class SGIP_CertInfo;

@interface SGA_EtcInterface : NSObject {
	
}
+ (void)messageAlert : (NSString *)msg;
+ (void)resetCertInfo : (SGIP_CertInfo *)pstCertInfo;
+ (void)encodeUTF8 : (const char *)sMsg aUTF8 : (NSString **)ppcsUTF8;
+ (void)decodeUTF8 : (NSString *)pcsUTF8 aKSC : (NSString **)ppcsKSC;
+ (time_t) getStr2Time : (NSString *)pcsStrTime;
+ (BOOL)isValidPasswd : (NSString *)pcsPasswd;
+ (int)parseURI : (NSString *)pcsURI aHost : (NSString **)ppcsHost aPort : (int *)piPort aDN : (NSString **)ppcsDN;
+ (NSString *)getCAName : (NSString *)pcsDN;
+ (NSString *)getLdapHost : (NSString *)pcsDN;
+ (int) getCaPubs : (NSData *)pcsSignCert aCaPubs : (NSData **)ppcsCaPubs;
+ (NSString *) hanName : (NSString *)pcsName;
+ (BOOL)isHackedDevice;
+ (NSString *)getStarString : (int)iLen;
+ (NSString *)getUserName : (NSString *)pcsDN;
+ (BOOL)isTrustedRoot : (NSString *)pcsHash;
+ (int) getPolicyGroup : (NSString*) policyOID;
+ (NSString*) getPolicyString : (NSString*) policyOID;
+ (NSString *)URLDecodedString : (NSString*) pcsString;
+ (NSString *)URLEncodedString : (NSString*) pcsString;
+ (BOOL)compareCertPolicy : (NSString*) wildPoilcyOID aSrc : (NSString*) srcPoilcyOID;
+ (NSData *)getSubDataBytes:(NSData *)pcsSource withRange:(NSRange)range;
+ (int) NSDataToNSString :(NSData*)inData aString : (NSString**)ppOutString;
+ (int) NSStringToNSData :(NSString*)inStr aData : (NSData**)ppOutData;
+ (NSData *)getDataFromURL:(NSString *)aURL withRequest:(NSData *)aRequest;
+ (NSString *)regexReplace:(NSString *)expression toThis:(NSString *)replaceText inString:(NSString *)originalString;

@end
