/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_LDAPInterface.h
 */

#import <Foundation/Foundation.h>

@interface SGA_LDAPInterface : NSObject {
	int				disable3G;
}

@property int disable3G;

- (int)getCore : (NSData **)ppcsCore
		 aHost : (NSString *)pcsHost
		 aPort : (int)iPort
		   aDN : (NSString *)pcsDN
		 aType : (int)iType
	  aTimeout : (int)iTimeout;


- (int)getCRLByHost : (NSData **)ppcsCRL
			  aHost : (NSString *)pcsHost
			  aPort : (int)iPort
				aDN : (NSString *)pcsDN
		   aTimeout : (int)iTimeout;


- (int)getARLByHost : (NSData **)ppcsARL
			  aHost : (NSString *)pcsHost
			  aPort : (int)iPort
				aDN : (NSString *)pcsDN
		   aTimeout : (int)iTimeout;


- (int)getCTLByHost : (NSData **)ppcsCTL
			  aHost : (NSString *)pcsHost
			  aPort : (int)iPort
				aDN : (NSString *)pcsDN
		   aTimeout : (int)iTimeout;


- (int)getCACertByHost : (NSData **)ppcsCert
				 aHost : (NSString *)pcsHost
				 aPort : (int)iPort
				   aDN : (NSString *)pcsDN
			  aTimeout : (int)iTimeout;

- (int)getUserCertByHost : (NSData **)ppcsCert
				   aHost : (NSString *)pcsHost
				   aPort : (int)iPort
					 aDN : (NSString *)pcsDN
				aTimeout : (int)iTimeout;


- (int)getSignCertByHost : (NSData **)ppcsCert
				   aHost : (NSString *)pcsHost
				   aPort : (int)iPort
					 aDN : (NSString *)pcsDN
				aTimeout : (int)iTimeout;

- (int)getCaPubs : (NSData **)ppcsCaPubs
		   aHost : (NSString *)pcsHost
		   aPort : (int)iPort
	   aIssuerDN : (NSString *)pcsIssuerDN;

- (int)getCaPubs2 : (NSData **)ppcsCaPubs
			aHost : (NSString *)pLdapHost
			aPort : (int)iLdapPort
			  aDN : (NSString *)pcsDN;

- (int)getCaPubs2WithKeychain : (NSData **)ppcsCaPubs
                        aHost : (NSString *)pLdapHost
                        aPort : (int)iLdapPort
                          aDN : (NSString *)pcsDN
                  accessGroup : (NSString *)accessGroup;

@end
