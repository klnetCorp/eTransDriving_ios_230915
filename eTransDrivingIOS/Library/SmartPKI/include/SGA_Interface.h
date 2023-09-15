/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_Interface.h
 */


#ifndef __SGA_INTERFACE_H__
#define __SGA_INTERFACE_H__

#import <Foundation/Foundation.h>

#define		SGIP_NAME_CERT_ROOTTRUST			@"RootCA trusted"
#define		SGIP_NAME_CERT_VERSION              @"version"
#define		SGIP_NAME_CERT_SERIAL				@"serial"
#define		SGIP_NAME_CERT_SIGNATUREALGID		@"signatureAlgorthmIdentifier"
#define		SGIP_NAME_CERT_SUBJECT              @"subject"
#define		SGIP_NAME_CERT_ISSUER				@"issuer"
#define		SGIP_NAME_CERT_FROM                 @"from"
#define		SGIP_NAME_CERT_TO					@"to"
#define		SGIP_NAME_CERT_SIGNATURE			@"signature"
#define		SGIP_NAME_CERT_SUBJECTALTNAME		@"subjectAltName"
#define		SGIP_NAME_CERT_KEYUSAGE             @"keyUsage"
#define		SGIP_NAME_CERT_EXTKEYUSAGE			@"extKeyUsage"
#define		SGIP_NAME_CERT_POLICY				@"policy"
#define		SGIP_NAME_CERT_CPSURI				@"cpsUri"
#define		SGIP_NAME_CERT_USERNOTICE			@"userNotice"
#define		SGIP_NAME_CERT_POLICYMAPPING		@"policyMapping"
#define		SGIP_NAME_CERT_AIA                  @"AuthorityInfoAccess"
#define		SGIP_NAME_CERT_BASICCONSTRAINT		@"basicConstraint"
#define		SGIP_NAME_CERT_POLICYCONSTRAINT     @"policyConstraint"
#define		SGIP_NAME_CERT_DISTRIBUTIONPOINTS	@"distributionPoints"
#define		SGIP_NAME_CERT_AUTHORITYKEYID		@"authorityKeyId"
#define		SGIP_NAME_CERT_ISSUERSERIAL         @"issuerSerial"
#define		SGIP_NAME_CERT_SUBJECTKEYID         @"subjectKeyId"
#define		SGIP_NAME_CERT_PUBLICKEY			@"publicKey"
#define		SGIP_NAME_CERT_PUBLICKEYALGO		@"publicKeyAlgo"
#define		SGIP_NAME_CERT_PUBLICKEYSIZE		@"publicKeySize"

#define		SGIP_HAN_NAME_CERT_ROOTTRUST		@"최상위 인증기관 신뢰확인"
#define		SGIP_HAN_NAME_CERT_VERSION			@"버전"
#define		SGIP_HAN_NAME_CERT_SERIAL			@"시리얼 번호"
#define		SGIP_HAN_NAME_CERT_SIGNATUREALGID	@"서명알고리즘"
#define		SGIP_HAN_NAME_CERT_SUBJECT			@"주체자"
#define		SGIP_HAN_NAME_CERT_ISSUER			@"발급자"
#define		SGIP_HAN_NAME_CERT_FROM             @"시작일"
#define		SGIP_HAN_NAME_CERT_TO				@"만료일"
#define		SGIP_HAN_NAME_CERT_SIGNATURE		@"서명"
#define		SGIP_HAN_NAME_CERT_SUBJECTALTNAME	@"주체대체이름"
#define		SGIP_HAN_NAME_CERT_KEYUSAGE         @"키용도"
#define		SGIP_HAN_NAME_CERT_EXTKEYUSAGE		@"확장 키용도"
#define		SGIP_HAN_NAME_CERT_POLICY			@"정책"
#define		SGIP_HAN_NAME_CERT_CPSURI			@"CPS 홈페이지"
#define		SGIP_HAN_NAME_CERT_USERNOTICE		@"사용자 알림"
#define		SGIP_HAN_NAME_CERT_POLICYMAPPING	@"정책 맵핑"
#define		SGIP_HAN_NAME_CERT_AIA              @"기관 정보 액세스"
#define		SGIP_HAN_NAME_CERT_BASICCONSTRAINT	@"기본 제한"
#define		SGIP_HAN_NAME_CERT_POLICYCONSTRAINT	@"정책 제한"
#define		SGIP_HAN_NAME_CERT_DISTRIBUTIONPOINTS	@"CRL분배지점"
#define		SGIP_HAN_NAME_CERT_AUTHORITYKEYID		@"기관키 식별자"
#define		SGIP_HAN_NAME_CERT_ISSUERSERIAL		@"발급자 시리얼 번호"
#define		SGIP_HAN_NAME_CERT_SUBJECTKEYID		@"주체자 식별자"
#define		SGIP_HAN_NAME_CERT_PUBLICKEY			@"공개키"
#define		SGIP_HAN_NAME_CERT_PUBLICKEYALGO		@"공개키 알고리즘"
#define		SGIP_HAN_NAME_CERT_PUBLICKEYSIZE		@"공개키 크기"


@interface SGIP_CertInfo : NSObject {
}

// NSString 속성을 strong 가 아니라 copy로 변경
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *serial;
@property (nonatomic, copy) NSString *signatureAlgId;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *issuer;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *subjectAltName;
@property (nonatomic, copy) NSString *keyUsage;
@property (nonatomic, copy) NSString *extKeyUsage;
@property (nonatomic, copy) NSString *policy;
@property (nonatomic, copy) NSString *cpsUri;
@property (nonatomic, copy) NSString *userNotice;
@property (nonatomic, copy) NSString *policyMapping;
@property (nonatomic, copy) NSString *AIA;
@property (nonatomic, copy) NSString *basicConstraint;
@property (nonatomic, copy) NSString *policyConstraint;
@property (nonatomic, copy) NSString *distributionPoints;
@property (nonatomic, copy) NSString *authorityKeyId;
@property (nonatomic, copy) NSString *issuerSerial;
@property (nonatomic, copy) NSString *subjectKeyId;
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, copy) NSString *publicKeyAlgo;
@property (nonatomic)       int       publicKeySize;


@end


@interface SGIP_TSP_TSResponseSt : NSObject {
}

@property (nonatomic)           int     verify;
@property (nonatomic)           int     hashID; // msg
@property (nonatomic, strong)   NSData* hash;   // msg
@property (nonatomic)           int     serialNumber;
@property (nonatomic)           long    genTime;
@property (nonatomic)           int     accuracyExist;
@property (nonatomic)           int     seconds;// accuracy
@property (nonatomic)           int     millis; // accuracy
@property (nonatomic)           int     micros; // accuracy
@property (nonatomic)           int     nonceExist;
@property (nonatomic)           int     nonce;

@end


@interface SGIP_TSP_TSRequestSt : NSObject

@property (nonatomic)           int     hashID; // msg
@property (nonatomic, strong)   NSData* hash;   // msg
@property (nonatomic)           int     nonceExist;
@property (nonatomic)           int     nonce;
@property (nonatomic)           int     certReq;
//@property (nonatomic, strong)   NSString* userid;   // Exts
//@property (nonatomic, strong)   NSString* passwd;   // Exts
@property (nonatomic, copy)   NSString* userid;   // Exts
@property (nonatomic, copy)   NSString* passwd;   // Exts

@end

#endif
