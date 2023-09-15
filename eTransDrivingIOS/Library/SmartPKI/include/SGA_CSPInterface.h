/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE:  SGA_CSPInterface.h
 */

#import <Foundation/Foundation.h>
#import "SGA_Interface.h"

/**
 * @brief 암호모듈을 사용한 PKI 기능
 */
@interface SGA_CSPInterface : NSObject {
	
};

+ (int)genKeyPair:(int)iSize aPubKey: (NSData **)ppcsPubKey aPrivKey:(NSData **)ppcsPrivKey;
+ (int)genKeyPairInfo:(int)iSize aPubKey: (NSData **)ppcsPubKey aPrivKey:(NSData **)ppcsPrivKey;
+ (int)getPubKey:(NSData **)ppcsPubKey aCert: (NSData *)pcsCert;
+ (int)verifySign:(NSData *)pcsSign aData: (NSData *)pcsData aCert: (NSData *)pcsCert aSignID:(int)iSignID;
+ (int)computeSign:(NSData **)ppcsSign aData: (NSData *)pcsData aPrikey: (NSData *)pcsPrikey aSignID: (int)iSignID;
+ (int)computeSignByHash:(NSData **)ppcsSign aData: (NSData *)pcsData aPrikey: (NSData *)pcsPrikey aSignID: (int)iSignID;

/**
 *@brief 인증서 정보를 추출한다.
 *@param pstCertInfo    [OUT] 추출된 인증서 정보
 *@param pcsCert        [IN] 인증서
 *@return integer       0:성공, -1:실패, 그 외:에러코드
 */
+ (int)getCertInfo : (SGIP_CertInfo *)pstCertInfo aCert : (NSData *)pcsCert;


+ (int)genRandom: (int)iSize aRandom: (NSData **)ppcsRandom;
+ (int)genHash: (int)iHashID aData: (NSData *)pcsData aHash: (NSData **)ppcsHash;
+ (int)genMAC: (int)iMacID aData: (NSData *)pcsData aKey: (NSData *)pcsKey aMAC : (NSData **)ppcsMAC;
+ (int)verifyMAC : (int)iMacID aData: (NSData *)pcsData aKey: (NSData *)pcsKey aMAC : (NSData *)pcsMAC;
+ (int)genVID : (int)iHashID aIDN : (NSString *)pcsIDN aRandom : (NSData *)pcsRandom aVID : (NSData **)ppcsVID;
+ (int)verifyVID : (NSData *)pcsCert aRandom : (NSData *)pcsRandom aSSN : (NSString *)pcsSSN;

/**
 *@brief PKCS8, PKCS5 암호화된 개인키를 PKCS1형태의 개인키를 만든다.
 *@param ppcsPrikey     [OUT] PKCS1 형태의 추출된 개인키 (동적할당)
 *@param ppcsRandom     [OUT] 추출된 개인키의 랜덤값(R) (동적할당)
 *@param pcsPass        [IN] 암호화에 사용한 패스워드
 *@param pcsEncPriKey   [IN] PKCS5, PKCS8 형태의 암호화된 개인키
 *@return integer       0:성공, -1:실패, 그 외:에러코드
 */
+ (int)decryptPrivateKey : (NSData **)ppcsPrikey 
				 aRandom : (NSData **)ppcsRandom 
				   aPass : (NSString *)pcsPass 
				 aEncKey : (NSData *)pcsEncPriKey;

/**
 *@brief PKCS1형태의 개인키를 PKCS5, PKCS8 형태의 암호화를 한다.
 *@param ppcsEncPriKey  [OUT] PKCS5, PKCS8 형태로 생성된 암호화된 개인키 (동적할당)
 *@param iEncAlg        [IN] 개인키 암호화에 사용할 알고리즘 (SGIP_PBES_TYPE_PBES1WithSHA1SEED_CBC)
 *@param pcsPrikey      [IN] PKCS1 형태의 개인키
 *@param pcsPass        [IN] 개인키를 암호화에 사용할 패스워드
 *@param pcsRand        [IN] 개인키를 암호화에 입력 되어지는 랜던값(R)
 *@return integer       0:성공, -1:실패, 그 외:에러코드
 */
+ (int)encryptPrivateKey : (NSData **)ppcsEncPriKey 
				 aEncAlg : (int)iEncAlg 
				 aPrikey : (NSData *)pcsPrikey 
				   aPass : (NSString *)pcsPass 
				   aRand : (NSData *)pcsRand;

+ (int)symEncrypt : (int)iAlg 
		  aOpMode : (int)iOpMode 
			 aOpt : (int)iOpt
			  aIV : (NSData *)pcsIV 
			 aKey : (NSData *)pcsKey 
			aData : (NSData *)pcsData 
		 aEncData : (NSData **)ppcsEncData;

+ (int)symDecrypt : (int)iAlg 
		  aOpMode : (int)iOpMode 
			 aOpt : (int)iOpt 
			  aIV : (NSData *)pcsIV
			 aKey : (NSData *)pcsKey 
			aData : (NSData *)pcsData 
		 aDecData : (NSData **)ppcsDecData;

+ (int)rsaEncrypt : (NSData *)pcsData aCert : (NSData *)pcsCert aOpt : (int)iOpt aEncData : (NSData **)ppcsEncData;

+ (int)rsaDecrypt : (NSData *)pcsEncData aPrikey : (NSData *)pcsPrikey aOpt : (int)iOpt aDecData : (NSData **)ppcsDecData;

+ (int)rsaEncrypt2 : (NSData *)pcsData aPrikey : (NSData *)pcsPrikey aOpt : (int)iOpt aEncData : (NSData **)ppcsEncData;

+ (int)rsaDecrypt2 : (NSData *)pcsEncData aCert : (NSData *)pcsCert aOpt : (int)iOpt aDecData : (NSData **)ppcsDecData;

/**
 *@brief PKCS#7 SignedData 생성한다.
 *@param ppcsSignedData [OUT]생성 되어진 PKCS#7 SignedData
 *@param iSignID        [IN]전자서명 ID
 *@param iCertCount     [IN]전자서명할 인증서의 개수, iOS/macOS는 1만 가능
 *@param pcsSignCert    [IN]전자서명할 인증서
 *@param pcsSignPrikey  [IN]전자서명할 개인키
 *@param pcsData        [IN]PKCS#7 signedData 를 생성하기 위한 데이터 원문
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)genSignedData : (NSData **)ppcsSignedData
			 aSignID : (int)iSignID 
		  aCertCount : (int)iCertCount
		   aSignCert : (NSData *)pcsSignCert
		 aSignPrikey : (NSData *)pcsSignPrikey
               aData : (NSData *)pcsData;

+ (int)genSignedData : (NSData **)ppcsSignedData
			 aSignID : (int)iSignID
		  aCertCount : (int)iCertCount
		     aPubKey : (NSData *)pcsPubKey
		 aSignPrikey : (NSData *)pcsSignPrikey
			   aData : (NSData *)pcsData;

+ (int)addSignedData : (NSData **)ppcsAddedSignedData 
			 aSignID : (int)iSignID 
		   aSignCert : (NSData *)pcsSignCert 
		 aSignPrikey : (NSData *)pcsSignPrikey 
		 aSignedData : (NSData *)pcsSignedData;

/**
 *@brief PKCS#7 SignedData Detached 생성한F다.
 *@version 2020.04.01
 *@param ppcsSignedData [OUT]EWS의 Detached와 동일하게 생성 되어진 PKCS#7 SignedData Detached
 *@param iSignID        [IN]전자서명 ID
 *@param iCertCount     [IN]전자서명할 인증서의 개수, iOS/macOS는 1만 가능
 *@param pcsSignCert    [IN]전자서명할 인증서
 *@param pcsSignPrikey  [IN]전자서명할 개인키
 *@param pcsData        [IN]PKCS#7 signedData Detached 를 생성하기 위한 데이터 원문
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)genSignedDataDetachedEWS : (NSData **)ppcsSignedDataDetached
                  aCertCount : (int)iCertCount
                   aSignCert : (NSData *)pcsSignCert
                 aSignPrikey : (NSData *)pcsSignPrikey
                        aData : (NSData *)pcsData;

/**
 *@brief PKCS#7 SignedData의 서명을 검증하고, 원문을 추출한다.
 *@param ppcsSrcData     [OUT]추출된 원문 데이터
 *@param pcsSignedMsg    [IN]PKCS#7 signedData
 *@param pcsSignCert     [IN]PKCS#7 signedData 생성시에 사용된 서명용 인증서
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)verifySignedData : (NSData **)ppcsSrcData
             aSignedMsg : (NSData *)pcsSignedMsg 
              aSignCert : (NSData *)pcsSignCert;

/*
+ (int)verifySignedData : (NSData **)ppcsSrcData
			 aSignedMsg : (NSData *)pcsSignedMsg
			    aPubKey : (NSData *)pcsPubKey;
*/
+ (int)verifySignedData2 : (NSData **)ppcsSrcData
			  aPubKey : (NSData *)pcsPubKey
			  aCertCount : (int*) piCertCount
			  aSignedMsg : (NSData *)pcsSignedMsg;

+ (int)verifySignedData2 : (NSData **)ppcsSrcData
              aSignCerts : (NSMutableArray **)pcsSignCerts
              aSignTimes : (NSMutableArray **)pcsSignTimes
              aCertCount : (int*) piCertCount
              aSignedMsg : (NSData *)pcsSignedMsg;

+ (int)developedData : (NSData **)ppcsDevelopedMsg 
	   aEnvelopedMsg : (NSData *)pcsEnvelopedMsg 
			   aCert : (NSData *)pcsCert 
			 aPrikey : (NSData *)pcsPrikey;

+ (int)developedData : (NSData **)ppcsDevelopedMsg
	   aEnvelopedMsg : (NSData *)pcsEnvelopedMsg
			 aPubKey : (NSData *)pcsPubKey
			 aPrikey : (NSData *)pcsPrikey;

+ (int)envelopedData : (NSData **)ppcsEnvelopedMsg 
		   aPlainMsg : (NSData *)pcsPlainMsg 
		  aCertCount : (int)iCertCount 
			   aCert : (NSData *)pcsCert;

+ (int)envelopedData : (NSData **)ppcsEnvelopedMsg
		   aPlainMsg : (NSData *)pcsPlainMsg
			 aPubKey : (NSData *)pcsPubKey;

+ (int)signedAndEnvelopedData : (NSData **)ppcsSignedAndEnvelopedData 
					aPlainMsg : (NSData *)pcsPlainMsg 
				   aCertCount : (int)iCertCount 
				  aSignPrikey : (NSData *)pcsSignPrikey
					aSignCert :(NSData *)pcsSignCert
					  aKMCert : (NSData *)pcsKMCert;

+ (int)verifySignedAndEnvelopedData : (NSData **)ppcsPlainMsg 
			aSignedAndEnvelopedData : (NSData *)pcsSignedAndEnvelopedData 
						 aCertCount : (int)iCertCount 
						  aKMPrikey : (NSData *)pcsKMPrikey 
							aKMCert : (NSData *)pcsKMCert;

+ (int)generatePKCS12 : (NSData **)ppcsPKCS12
			  aPasswd : (NSString *)pcsPasswd
		  aSignPrikey : (NSData *)pcsSignPrikey
			aSignCert : (NSData *)pcsSignCert
			aKMPrikey : (NSData *)pcsKMPrikey
			  aKMCert : (NSData *)pcsKMCert
			  aRandom : (NSData *)pcsRandom
				 aCRL : (NSData *)pcsCRL
			  aCaPubs : (NSData *)pcsCaPubs;

+ (int)extractPKCS12 : (NSData **)ppcsSignPrikey
		   aSignCert : (NSData **)ppcsSignCert
		   aKMPrikey : (NSData **)ppcsKMPrikey
			 aKMCert : (NSData **)ppcsKMCert
			 aRandom : (NSData **)ppcsRandom
				aCRL : (NSData **)ppcsCRL
			 aCaPubs : (NSData **)ppcsCaPubs
			 aPasswd : (NSString *)pcsPasswd
			 aPKCS12 : (NSData *)pcsPKCS12;

+ (int)encodeCaPubs : (NSData **)ppcsCaPubs aCACert : (NSData *)pcsCACert aRootCert : (NSData *)pcsRootCert;
+ (int)decodeCaPubs : (NSData **)ppcsCACert aRootCert : (NSData **)ppcsRootCert aCaPubs : (NSData *)pcsCaPubs;

/**
 *@brief 로컬 데이터로 저장된 인증서의 비밀번호를 변경한다.
 *@param prePassword          [IN] 기존 비밀번호
 *@param postPassword        [IN] 변경할 비밀번호
 *@param selectDN                [IN] 선택한 인증서의 DN
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)changePassword : (NSString *) prePassword aPostPassword : (NSString *) postPassword aCertInfo : (NSString *) selectDN;

/**
 *@brief 키체인에 저장된 인증서의 비밀번호를 변경한다
 *@param prePassword          [IN] 기존 비밀번호
 *@param postPassword        [IN] 변경할 비밀번호
 *@param selectDN                [IN] 선택한 인증서의 DN
 *@param accessGroup          [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)changePasswordWithKeychain : (NSString *) prePassword
                    aPostPassword : (NSString *) postPassword
                        aCertInfo : (NSString *) selectDN
                      accessGroup : (NSString *) accessGroup;
@end
