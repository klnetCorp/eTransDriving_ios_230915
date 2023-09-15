/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_TelEncInterface.h
 */


#import <Foundation/Foundation.h>

/*!
 * @brief 로그인 연관 기능들이 포함된 클래스
 */
@interface SGA_TelEncInterface:NSObject {
	NSData* cert;
	NSData* random1;
	NSData* random2;
	NSData* skKey;
	NSData* iv;
	NSData* mac;
	
	NSMutableDictionary* sendParam;
}

@property (nonatomic, retain) NSData* cert;
@property (nonatomic, retain) NSMutableDictionary* sendParam;


- (void) addParamName:(NSString* )name
               aValue:(NSString* )value
            aAddParam:(NSString** )addParam;


- (int)getCert:(NSString *)pcsURL;

- (id)init;

- (NSData*)parseFromSeparator:(NSString *)pSeparator
                      aSource:(NSData *)pSourceData
                  aRemainData:(NSData **)pRemainSource;


- (NSData*)genRandom1;

- (NSData*)genRandom2;


- (int)getCert2:(NSString *)pcsURL 
	   aSvrCert:(NSData **)ppcsCert;

- (int)getRsaEncSvrCert:(NSData*)pcsData
			   aEncData:(NSData**)ppEncData;

- (int)getRsaEncSvrCert2:(NSData*)pcsData
				aEncData:(NSData**)ppEncData;

- (int)getRsaEncSvrCert3:(NSData*)pcsData
                   aCert:(NSData*)pcsCert
                aEncData:(NSData**)ppEncData;

- (int)getSymEncrypt:(NSData*)pcsIV
				aKey:(NSData*)pcsKey
               aData:(NSData*)pcsData
                aAlg:(int)nAlgorithm
             aOpMode:(int)nOpMode
			aEncData:(NSData**)ppEncData;

- (int)getSymDecrypt:(NSData*)pcsIV
                aKey:(NSData*)pcsKey
               aData:(NSData*)pcsData
                aAlg:(int)nAlgorithm
             aOpMode:(int)nOpMode
            aEncData:(NSData**)ppDecData;

- (int)verifyIDN:(NSString *)pcsURL
			aIDN:(NSString *)pcsIDN
	   aSignCert:(NSData *)pcsSignCert
		aSignKey:(NSData *)pcsSignKey
		   aRand:(NSData *)pcsRand
		 aResMsg:(NSString **)ppcsMsg;

- (int)verifyIDN2:(NSString *)pcsURL
		aSignCert:(NSData *)pcsSignCert
			aData:(NSData *)pcsEncData 
			aRand:(NSData *)pcsEncRand
		  aCRRand:(NSData *)pcsCRRandom
			aSign:(NSData *)pcsSign
		   aCRKey:(NSData *)pcsEncCRKey
			  aIV:(NSData *)pcsEncIV
            aUDef:(NSString *)pcsUserDefData
		  aResMsg:(NSString **)ppcsMsg;

/*!
 * @brief 입력한 사용자 식별정보(IDN)가 맞는지를 검증한다. (데이터를 Base64로 변환하여 전송)
 * @param pcsURL                    [IN] 로그인 페이지 URL
 * @param aSignCert                 [IN] 서명용 인증서
 * @param aEncryptedIDN             [IN] 비밀키로 암호화 된 사용자 식별정보 (IDN)
 * @param aEncryptedRandomBase64    [IN] 비밀키로 암호화 된 난수 (개인키에서 추출한 난수[Random] -> Base64 인코딩 -> 비밀키 암호화)
 * @param aChallenge                [IN] 챌린지 (= 임의 생성된 16 바이트 난수)
 * @param aSignature                [IN] 챌린지를 사용자의 개인키로 서명한 서명값 (챌린지 -> Base64 인코딩 -> 개인키로 서명)
 * @param aEncryptedSecretKey       [IN] 서버의 공개키로 암호화 된 비밀키
 * @param aEncryptedIV              [IN] 서버의 공개키로 암호화 된 초기값
 * @param aServerResponse           [OUT] 서버 메시지를 전달받을 변수의 포인터
 * @return 0 : 성공, -1 : 실패
 * @deprecated 사이트 지원을 위해 만들어진 함수로 사용을 권장하지 않음
 */
- (int)verifyIDN3:(NSString *)pcsURL
        aSignCert:(NSData *)aSignCert
            aData:(NSData *)aEncryptedIDN
            aRand:(NSData *)aEncryptedRandomBase64
          aCRRand:(NSData *)aChallenge
            aSign:(NSData *)aSignature
           aCRKey:(NSData *)aEncryptedSecretKey
              aIV:(NSData *)aEncryptedIV
          aResMsg:(NSString **)aServerResponse;

- (int)verifyIDNEx:(NSString *)pcsURL
		 aSignCert:(NSData *)pcsSignCert
			 aData:(NSData *)pcsEncData 
			 aRand:(NSData *)pcsEncRand
		   aCRRand:(NSData *)pcsCRRandom
			 aSign:(NSData *)pcsSign
			aCRKey:(NSData *)pcsEncCRKey
			   aIV:(NSData *)pcsEncIV
			 aUDef:(NSString *)pcsUserDefData
		   aResMsg:(NSString **)ppcsMsg;

- (void)verifyIDNEx2:(NSString *)pcsURL
		   aSignCert:(NSData *)aSignCert
			   aData:(NSData *)aEncryptedIDN 
			   aRand:(NSData *)aEncryptedRandomBase64
			 aCRRand:(NSData *)aChallenge
			   aSign:(NSData *)aSignature
			  aCRKey:(NSData *)aEncryptedSecretKey
				 aIV:(NSData *)aEncryptedIV
			   aUDef:(NSString *)pcsUserDefData
			 aResMsg:(NSData **)aServerResponse;

//for XenoMobile Login Process
- (int)verifyIDNForXB:(NSString *)pcsURL
			aSignCert:(NSData *)pcsSignCert
				aData:(NSData *)pcsEncData 
				aRand:(NSData *)pcsEncRand
			  aCRRand:(NSData *)pcsCRRandom
				aSign:(NSData *)pcsSign
			   aCRKey:(NSData *)pcsEncCRKey
				  aIV:(NSData *)pcsEncIV
			  aResMsg:(NSString **)ppcsMsg;

- (int)verifyIDNForXBEx:(NSString *)pcsURL
			  aSignCert:(NSData *)pcsSignCert
				  aData:(NSData *)pcsEncData 
				  aRand:(NSData *)pcsEncRand
				aCRRand:(NSData *)pcsCRRandom
				  aSign:(NSData *)pcsSign
				 aCRKey:(NSData *)pcsEncCRKey
					aIV:(NSData *)pcsEncIV
				  aUDef:(NSString *)pcsUserDefData
				aResMsg:(NSString **)ppcsMsg;

- (int)verifyIDNExForJSP : (NSString *)pcsURL
			   aSignCert : (NSData *)pcsSignCert
				   aData : (NSData *)pcsEncData
				   aRand : (NSData *)pcsEncRand
				 aCRRand : (NSData *)pcsCRRandom
				   aSign : (NSData *)pcsSign
				  aCRKey : (NSData *)pcsEncCRKey
					 aIV : (NSData *)pcsEncIV
				   aUDef : (NSString *)pcsUserDefData
				 aResMsg : (NSString **)ppcsMsg;

- (int)getSessionKeyInfo:(NSString *)pcsSvrKMCertURL 
                aRandom1:(NSData **)ppRandom1 
                aRandom2:(NSData **)ppRandom2 
                   aCRIV:(NSData **)ppCRIV 
             aSessionKey:(NSData **)ppSessionKey 
                 aKMCert:(NSData **)ppSvrKMCert;

-(int) getMACData:(NSData *)pcsRandom
            aData:(NSData *)pcsData
         aMACData:(NSData **)pcsMACData;

-(int) exchangeSessionKey:(NSString *)pcsSvrPageURL
               aEncRandom:(NSData *)pcsEncCRRandom 
                 aEncData:(NSData *)pcsEncDataID 
                  aEncMAC:(NSData *)pcsEncMACData 
                  aResMsg:(NSString **)ppcsMsg;

- (BOOL) VerifyIDN:(NSString *)userIDN
        aVerifyURL:(NSString *)verifyURL
    aServerCertURL:(NSString *)serverCertURL
         aPassword:(NSString *)password
         aUserCert:(NSData *)userCert
          aUserKey:(NSData *)userKey
           aResMsg:(NSString **)ppcsMsg
 aCustomParameters:(NSDictionary *)parameters;

- (void)reset;

@end
