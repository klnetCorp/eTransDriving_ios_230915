/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGData.h
 */

#import <Foundation/Foundation.h>

#import "SG2Api_Bin.h"

@interface SGData : NSObject {
	
	CFStringEncodings encoding;
	
	unsigned char * data;
	unsigned long size;
	
	// native c type
	char * base64_utf8;
	char * pem_utf8;
	char * hex_utf8;
	BIN * bin;
	
	// cocoa type
	NSString * base64;
	NSString * base64_urlencoded;
	NSString * pem;
	NSString * pem_urlencoded;
	NSString * hex;
	NSString * string;
	NSString * string_urlencoded;
	NSData * ns_data;
}

@property (nonatomic, readonly) unsigned char * data;
@property (nonatomic, readonly) unsigned long size;

- (id) init;
- (id) initWithData:(const unsigned char *)aData size:(unsigned int)aSize;
- (id) initWithBase64UTF8String:(const char *)aBase64;
- (id) initWithHexUTF8String:(const char *)aHex;
- (id) initWithBIN:(const BIN *)aBin;
- (id) initWithBase64:(NSString *)aBase64;
- (id) initWithHex:(NSString *)aHex;
- (id) initWithString:(NSString *)aString;
- (id) initWithNSData:(NSData *)aNSData;

+ (SGData *) dataWithData:(const unsigned char *)aData size:(unsigned int)aSize;
+ (SGData *) dataWithBase64UTF8String:(const char *)aBase64;
+ (SGData *) dataWithHexUTF8String:(const char *)aHex;
+ (SGData *) dataWithBIN:(const BIN *)aBin;
+ (SGData *) dataWithBase64:(NSString *)aBase64;
+ (SGData *) dataWithHex:(NSString *)aHex;
+ (SGData *) dataWithString:(NSString *)aString;
+ (SGData *) dataWithNSData:(NSData *)aNSData;

- (BOOL) setData:(const unsigned char *)aData size:(unsigned long)aSize;

- (BOOL) isEqual:(id)object;

- (const char *) toBase64UTF8String;
- (const char *) toPemUTF8String:(int)pemType;
- (const char *) toHexUTF8String;
- (const BIN *) toBIN;
- (NSString *) toBase64;
- (NSString *) toBase64URLEncoded;
- (NSString *) toPem:(int)pemType;
- (NSString *) toPemURLEncoded:(int)pemType;
- (NSString *) toHex;
- (NSString *) toString;
- (NSString *) toStringURLEncoded;
- (NSData *) toNSData;

@end
