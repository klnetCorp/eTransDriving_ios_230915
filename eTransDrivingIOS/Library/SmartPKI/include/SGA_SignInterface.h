/*****************************************************************************/
/* Copyright (C) 2013-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_SignInterface.h
 */

#import <Foundation/Foundation.h>


@interface SGA_SignInterface : NSObject {
	int			disable3G;
}

@property int disable3G;

+ (NSString *) commandCodeRegister;

+ (NSString *) commandCodeLogin;

+ (NSString *) commandCodeSendMoney;

- (int)clientInit : (NSString *)pcsHost 
			aPort : (int)iPort 
		  aPrikey : (NSData *)pcsPrikey 
			aCert : (NSData *)pcsCert;

- (int)sendCert : (NSString *)pcsAuthCode 
		  aCert : (NSData *)pcsCert;

- (int)recvData : (NSData **)ppcsData
		  aCert : (NSData **)ppcsCert
		aEncKey : (NSData **)ppcsEncKey
		  aType : (int *)piType 
	  aAuthCode : (NSString *)pcsAuthCode;

- (int)sendCMSData : (int)iType 
		 aAuthCode : (NSString *)pcsAuthCode 
		  aCMSData : (NSData *)pcsCMSData;

- (int)reset;

- (int)receiveToBeSignedData : (NSString *)pcsAuthCode
					  aPhone : (NSString *)pcsPhone
					aResCode : (NSString **)ppcsResCode
					 aErrMsg : (NSString **)ppcsErrMsg
					aCmdCode : (NSString **)ppcsCmdCode
					aSrvCert : (NSData **)ppcsSrvCert
						aMsg : (NSData **)ppcsMsg;

- (int)sendSignedData : (NSString *)pcsAuthCode
			   aPhone : (NSString *)pcsPhone
			   aPKCS7 : (NSData *)pcsPKCS7
			 aResCode : (NSString **)ppcsResCode
			  aErrMsg : (NSString **)ppcsErrMsg;

@end
