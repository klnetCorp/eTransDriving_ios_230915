/*****************************************************************************/
/* Copyright (C) 2013-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_UCPIDInterface.h
 */

#import <Foundation/Foundation.h>

#define POLICY_KICA_GENERAL_PERSONAL		@"1.2.410.200004.5.2.1.2"
#define POLICY_CROSSCERT_GENERAL_PERSONAL	@"1.2.410.200004.5.4.1.1"
#define POLICY_YESSIGN_GENERAL_PERSONAL	@"1.2.410.200005.1.1.1"
#define POLICY_COSCOM_GENERAL_PERSONAL	@"1.2.410.200004.5.1.1.5"
#define POLICY_KTNET_GENERAL_PERSONAL		@"1.2.410.200012.1.1.1"

@interface SGA_UCPIDInterface : NSObject
{
	NSString* userDN;
	NSString* password;
}

@property (nonatomic, retain) NSString* userDN;
@property (nonatomic, retain) NSString* password;

-(BOOL)addCertPolicy:(NSString*)pPolicies;
-(char)getUserAgreeFlag:(NSString*)pAgreeFlag;
-(NSString*)getErrMessage;

/**
 * @brief UCPID RequestInfo 메시지를 생성함
*/
-(BOOL)genUCPIDEncodeRequestInfoReq:(NSData **)ppUCPIDReq aAgreement:(NSString *)pAgreement aAgreeFlag1:(NSString *)pAgreeFlag1 aAgreeFlag2:(NSString *)pAgreeFlag2 aIspUrlInfo:(NSString*)pIspUrlInfo aPassword:(NSString*)pwd;


-(NSString *)sendHttpURL:(NSString*)url paramName:(NSString*)pName ucpidData:(NSData*)ucpidMessage;
-(NSString *)sendHttpURL:(NSString*)url paramUcpidMsgName:(NSString*)ucpidMsgName ucpidMessage:(NSData*)ucpidMsg paramSigCertName:(NSString*)sigCertName certificate:(NSData*)cert;
-(NSString *)sendHttpURL:(NSString*)url paramUcpidMsgName:(NSString*)ucpidMsgName ucpidMessage:(NSData*)ucpidMsg paramSigCertName:(NSString*)sigCertName certificate:(NSData*)cert paramPkcs7_signedName:(NSString*)p7_signedName pkcs7_signedMessage:(NSData*)p7_signedMsg;

-(BOOL)genUCPIDEncodeRequestInfo:(NSData **)ppUCPIDReq aAgreement:(NSString*)pAgreement aAgreeFlag:(NSString*)pAgreeFlag aPassword:(NSString*)pwd;
-(BOOL)genPkcs7_signedMessage:(NSData**)ppP7SignedMsg aPlaintext:(NSString*)pPlaintext aPassword:(NSString*)pwd;

/**
 * @brief UCPID PersionInfo 메시지를 생성함
 * @deprecated UCPID version2 변경으로 사용할 수 없음
*/
-(BOOL)genUCPIDEncodePersonInfoReq:(NSData **)ppUCPIDReq aAgreement:(NSString*)pAgreement aAgreeFlag:(NSString*)pAgreeFlag aPassword:(NSString*)pwd allowedAnyPolicies:(BOOL)isAllowedAnyPolicies __attribute__((deprecated("use the genUCPIDEncodeRequestInfoReq instead.")));

/**
 * @brief UCPID PersionInfo 메시지를 생성함
 * @deprecated UCPID version2 변경으로 사용할 수 없음
*/
-(BOOL)genUCPIDEncodePersonInfoReq:(NSData **)ppUCPIDReq aAgreement:(NSString*)pAgreement aAgreeFlag:(NSString*)pAgreeFlag aPassword:(NSString*)pwd __attribute__((deprecated("use the genUCPIDEncodeRequestInfoReq instead.")));

@end
