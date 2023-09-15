/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_APPInterface.h
 */


#import <Foundation/Foundation.h>

#define	SGIP_KICA_APP		@"certmgt"
#define	SGIP_KICA_API_APP	@"certmanager"
#define SGIP_KICA_API_WEB_RET_URL @"www.ccwon.co.kr/test.asp"

#define SGIP_WEBBRWOSER_SVR_CERT_URL @"61.72.247.30:8008/smart/kica_km_cert.asp"
#define SGIP_WEBBRWOSER_SVR_LOGIN_URL @"61.72.247.30:8008/smart/kica_smart_logincheck.asp"

#define	SGIP_APP_REQ_GET_CERT					1000
#define	SGIP_APP_REQ_GET_PFX					1010
#define SGIP_APP_REQ_PUT_CERT					1020
#define	SGIP_APP_REQ_PUT_PFX					1030
#define	SGIP_APP_REQ_CERT_MANAGE				1040
#define SGIP_APP_REQ_GET_GEN_SIGN				1050
#define SGIP_APP_REQ_GET_VERIFY_SIGN			1060
#define SGIP_APP_REQ_GET_GEN_SIGN_ENV			1070
#define SGIP_APP_REQ_GET_VERIFY_SIGN_ENV		1080
#define SGIP_APP_REQ_GET_SIGN_DATA				1090
#define SGIP_APP_REQ_GET_VERIFY_SIGN_DATA		1100
#define SGIP_APP_REQ_GET_ENV_DATA				1110
#define SGIP_APP_REQ_GET_VERIFY_ENV_DATA		1120	
#define SGIP_APP_REQ_GET_WEB_LOGIN				1121	
#define SGIP_APP_REQ_GET_CERT_DN				1122	
#define SGIP_APP_REQ_GET_ANON_SIGN				1123

#define SGIP_APP_RSP_GET_CERT					2000
#define SGIP_APP_RSP_GET_PFX					2010
#define SGIP_APP_RSP_PUT_CERT					2020
#define SGIP_APP_RSP_PUT_PFX					2030
#define SGIP_APP_RSP_CERT_MANAGE				2040
#define SGIP_APP_RSP_PUT_GEN_SIGN				2050
#define SGIP_APP_RSP_GET_GEN_SIGN				2051
#define SGIP_APP_RSP_PUT_VERIFY_SIGN			2060
#define SGIP_APP_RSP_PUT_GEN_SIGN_ENV			2070
#define SGIP_APP_RSP_PUT_VERIFY_SIGN_ENV		2080
#define SGIP_APP_RSP_PUT_SIGN_DATA				2090
#define SGIP_APP_RSP_PUT_VERIFY_SIGN_DATA		2100
#define SGIP_APP_RSP_PUT_ENV_DATA				2110
#define SGIP_APP_RSP_PUT_VERIFY_ENV_DATA		2120	
#define SGIP_APP_RSP_PUT_WEB_LOGIN				2121
#define SGIP_APP_RSP_GET_CERT_DN				2122
#define SGIP_APP_RSP_PUT_ANON_SIGN				2123

#define SGIP_APP_RUN_WEB						3000
#define	SGIP_APP_RUN_WEB_UPDATE_CMP				3001

@interface SG_APP_INFO : NSObject
@property (nonatomic) int iCmd;
@property (nonatomic, copy) NSString *strURL;
@end


/* use ARC
typedef struct _SG_APP_INFO {
	int			iCmd;
	NSString	*strURL;
} SG_APP_INFO;
 */

@interface SGA_APPInterface : NSObject {
	
}

+ (int)parseCmd : (NSString *)pcsURL aArgs : (NSString **)ppcsArgs;

+ (int)parseReqCmd : (NSString *)pcsURL aArgs : (NSString **)ppcsArgs;
+ (int)parseRspCmd : (NSString *)appName aURL : (NSString *)pcsURL aArgs : (NSString **)ppcsArgs;

+ (int)getRetApp : (NSString **)ppcsRetApp aArgs : (NSString *)pcsArg;

#pragma mark -
#pragma mark Response Process (reqGet)

+ (int)requestToApp : (NSString *) pcsToApp 
			 aRetApp: (NSString *) pcsRetApp 
			   aCmd : (int) iCmd 
			  aData : (NSMutableArray *) arrData;

+ (int)responseToApp : (NSString *) pcsToApp 
			 aRetApp : (NSString *) pcsRetApp 
				aCmd : (int) iCmd 
			   aData : (NSMutableArray *) arrData;

+ (int)responseToWebBrowser : (NSString *)pcsToApp 
					 aRetApp: (NSString *)pcsRetApp 
					   aCmd : (int) iCmd 
					  aData : (NSMutableArray *)arrData;

+ (int)reqCertManage : (NSString *)appName;

+ (int)reqCheckApp;

#pragma mark -
#pragma mark Response Process (rspGet)

+ (int)rspGetGenSign : (NSString **)ppcsSign
			   aArgs : (NSString *)pcsArgs;

+ (int)rspGetVerifySign : (NSString **)ppcsSign
				  aArgs : (NSString *)pcsArgs;

+ (int)rspGetSignData : (NSString **)ppcsSign
				aArgs : (NSString *)pcsArgs;

+ (int)rspGetVerifySignData : (NSString **)ppcsSign
					  aArgs : (NSString *)pcsArgs;

+ (int)rspGetEnvData : (NSString **)ppcsBase64SignedEnv
			   aArgs : (NSString *)pcsArgs;

+ (int)rspGetVerifyEnvData : (NSString **)ppcsPlain
					 aArgs : (NSString *)pcsArgs;

+ (int)rspGetGenSignedEnv : (NSString **)ppcsBase64SignedEnv
					aArgs : (NSString *)pcsArgs;

+ (int)rspGetVerifySignedEnv : (NSString **)ppcsPlain
					   aArgs : (NSString *)pcsArgs;

+ (int)rspGetPutCertResult : (NSString **)ppcsResult
					 aArgs : (NSString *)pcsArgs;

+ (int)rspGetPutPfxResult : (NSString **)ppcsResult
					aArgs : (NSString *)pcsArgs;

#pragma mark Response Process (rspPut)

+ (int)rspGetCert : (NSString *)pcsArgs
		aSignCert : (NSString **)ppcsSignCert
		 aSignPri : (NSString **)ppcsSignPrikey
		  aKMCert : (NSString **)ppcsKMCert
		   aKMPri : (NSString **)ppcsKMPrikey;


+ (int)rspGetPfx : (NSString **)ppcsBase64Pfx
		   aArgs : (NSString *)pcsArgs;

+ (int)rspWriteCert : (NSString **)ppcsUserDN 
			aCertDN : (NSString *)pcsArgs;

+ (int)rspReadPFX : (NSString **)ppcsPfx
		  aCertDN : (NSString *)pcsUserDN
		  aPasswd : (NSString *)pcsPasswd;

+ (int)rspReadCert : (NSString *)pcsUserDN
		 aSignCert : (NSString **)ppcsSignCert
		  aSignPri : (NSString **)ppcsSignPrikey
		   aKMCert : (NSString **)ppcsKMCert
			aKMPri : (NSString **)ppcsKMPrikey;

+ (int)rspWritePFX : (NSString *)pcsArgs 
		   pPasswd : (NSString *)pcsPasswd;

#pragma mark Response Process (API Process)
+ (int)rspCertManage;

+ (int)rspGenSign : (NSString **)ppcsBase64Sign 
			aData : (NSString *)pcsArgs 
		  aCertDN : (NSString *)pcsUserDN 
		  aPasswd : (NSString *)pcsPasswd;

+ (int)rspVerifySign : (NSString **)ppcsBase64Result
			   aData : (NSString *)pcsArgs 
			 aCertDN : (NSString *)pcsUserDN;

+ (int)rspGenSignData : (NSString **)ppcsBase64SignData 
				aData : (NSString *)pcsArgs 
			  aCertDN : (NSString *)pcsUserDN 
			  aPasswd : (NSString *)pcsPasswd;

+ (int)rspVerifySignData : (NSString **)ppcsBase64Result 
				   aData : (NSString *)pcsArgs 
				 aCertDN : (NSString *)pcsUserDN;

+ (int)rspEnvData : (NSString **)ppcsBase64EnvData
			aData : (NSString *)pcsArgs
		   aCount : (int)iCount;

+ (int) rspVerifyEnvData : (NSString **)ppcsBase64PlainData 
				   aData : (NSString *)pcsArgs 
				 aCertDN : (NSString *)pcsUserDN 
				 aPasswd : (NSString *)pcsPasswd ;

+ (int) rspSignedAndEnveloped : (NSString **)ppcsBase64SignEnv
						aData : (NSString *)pcsArgs 
					  aCertDN : (NSString *)pcsUserDN 
					  aPasswd : (NSString *)pcsPasswd 
					   aCount : (int)iCount;

+ (int) rspVerifySignedAndEnveloped : (NSString **)ppcsBase64PlainData 
							  aData : (NSString *)pcsArgs 
							aCertDN : (NSString *)pcsUserDN 
							aPasswd : (NSString *)pcsPasswd 
						 aCertCount : (int)iCount;
//JSP
+ (int) rspWebLogin: (NSString **)ppcsBase64Sign
			  aData: (NSString *)pcsArgs
			aCertDN: (NSString *)pcsUserDN 
			aPasswd: (NSString *)pcsPasswd
			   aIDN: (NSString *)pcsUserIDN;

@end
