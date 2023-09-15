/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_PVDInterface.h
 */

#import <Foundation/Foundation.h>

#define SGIP_PVD_ERR_INVALID_INPUT			37001
#define	SGIP_PVD_ERR_INVALID_SIGNATURE		37002
#define SGIP_PVD_ERR_INVALID_TIME			37003
#define SGIP_PVD_ERR_INVALID_ISSUER			37004
#define SGIP_PVD_ERR_INVALID_FIELD			37005
#define SGIP_PVD_ERR_REVOKED_CERT			37006

@interface SGA_PVDInterface : NSObject {
	
}

+ (int) checkValidRootCert : (NSData *)pcsCert aTime:(time_t)now_t;
+ (int) checkValidCACert : (NSData *)pcsCACert aCAIssuer : (NSData *)pcsCAIssuerCert aTime: (time_t)now_t;
+ (int) checkValidCert : (NSData *)pcsCert aIssuer: (NSData *)pcsCACert aTime: (time_t)now_t;
+ (int) isRevoked : (NSData *)pcsCert aCRL : (NSData *)pcsCRL aTime: (time_t)now_t;

+ (int) checkValidCRL : (NSData *)pcsCRL aCRLIssuer : (NSData *)pcsCRLIssuerCert aTime: (time_t)now_t;

+ (int) validCert : (NSData *)pcsCert
		  aCACert : (NSData *)pcsCACert
		aRootCert : (NSData *)pcsRootCert
			 aCRL : (NSData *)pcsCRL
			 aARL : (NSData *)pcsARL
			aTime : (time_t)now_t;

+ (int) validCertAndInfo:(NSData *)pcsCert 
				 aCACert:(NSData *)pcsCACert 
			   aRootCert:(NSData *)pcsRootCert 
					aCRL:(NSData *)pcsCRL 
					aARL:(NSData *)pcsARL 
				   aTime:(time_t)now_t
			 aRevokeDate:(NSString **)ppcsRevokeDate
		   aRevokeReason:(NSString **)ppcsRevokeReason;

@end
