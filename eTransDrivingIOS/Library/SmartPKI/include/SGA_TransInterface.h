/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_TransInterface.h
 */

#import <Foundation/Foundation.h>

#define	SGIP_TRANS_SSL			1
#define SGIP_TRANS_OPP			2


@interface SGA_TransInterface : NSObject {
	int			protocolType;
	int			sockFD;
	int			disable3G;
	NSData		*pstKey;
}

@property ( nonatomic, retain ) NSData *pstKey;
@property int sockFD;
@property int disable3G;
@property int protocolType;

- (int)clientInit : (int)iProtocol aHost: (NSString *)pcsHost aPort : (int)iPort aPrikey : (NSData *)pcsPrikey aCert: (NSData *)pcsCert;
- (int)getCert : (NSString *)pcsDN aSSN : (NSString *)pcsSSN;
- (int)getAuth : (NSString **)ppcsAuthCode aPhone : (NSString *)pcsPhone aSSN : (NSString *)pcsSSN;
- (int)getPush : (NSString *)pcsAuthCode aDN : (NSString *)pcsDN aPasswd : (NSString *)pcsPasswd aPKCS12 : (NSData *)pcsPKCS12;
- (int)getRecv : (NSData **)ppcsPKCS12 aPasswd : (NSString **)ppcsPasswd aAuthCode: (NSString *)pcsAuthCode aPhone:(NSString *)pcsPhone aSSN : (NSString *)pcsSSN;

- (int)close;
- (int)reset;

- (int)requestAuthCode : (NSString **)ppcsAuthCode 
				 aTime : (int *)piSessTime 
				  aSSN : (NSString *)pcsSSN
			  aMACAddr : (NSString *)pcsMACAddr
			  aCompany : (NSString *)pcsCompany 
				  aTel : (NSString *)pcsTel;

- (int)requestCertificate : (NSData **)ppcsPKCS12 
				aAuthCode : (NSString *)pcsAuthCode 
				 aMACAddr : (NSString *)pcsMACAddr 
				 aCompany : (NSString *)pcsCompany 
					 aTel : (NSString *)pcsTel;

- (int)sendCertificate : (NSString **)ppcsRepAuthCode 
			 aAuthCode : (NSString *)pcsAuthCode 
				 aSign : (NSData *)pcsSign 
				 aCert : (NSData *)pcsCert 
			   aPKCS12 : (NSData *)pcsPKCS12 
			   aRandom : (NSData *)pcsRandom;

/*
- (int)receiveConfirm : (NSString **)ppcsAuthCode 
				aHash : (NSData *)pcsHash;
*/

@end
