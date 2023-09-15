/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGTransmitCertServer.h
 */

#import <Foundation/Foundation.h>

/**
 * @brief SecukitNX를 클라이언트로 하는 단말과 중계서버 간 인증서 및 인증코드를 가져오는 인터페이스
 * @param ssn							[IN] 사용자 주민번호 또는 사업자번호
 * @param authCode						[IN] 중계서버에서 부여받은 인증코드
 * @param PWD							[IN] 인증서 패스워드
 * @param serverIP						[IN] 중계서버 IP
 * @param serverPort					[IN] 중계서버 PORT
 * @param sessTime						[IN] 인증서를 전송 받기 위한 최대 시간 (milliSec)
 */
@interface SGTransmitCertServer : NSObject <NSURLSessionDelegate>
{
    NSString* ssn;
    NSString* authCode;
    NSString* PWD;
    NSData* pkcs12;
    int sessTime;
    
    NSString* serverUrl;
    NSString* serverUrlSid;
    NSString* serverUrlImport;
    NSString* serverUrlImportConfirm;
    NSString* serverUrlExport;
    
    NSString* sessionTime;
}

@property (nonatomic, retain) NSString* ssn;
@property (nonatomic, retain) NSString* authCode;
@property (nonatomic, retain) NSString* PWD;
@property (nonatomic, retain) NSString* serverIP;
@property (nonatomic, retain) NSData* pkcs12;
@property (nonatomic) int serverPort;
@property (nonatomic) int sessTime;

@property (nonatomic, strong) NSString* serverUrl;
@property (nonatomic, strong) NSString* serverUrlSid;
@property (nonatomic, strong) NSString* serverUrlImport;
@property (nonatomic, strong) NSString* serverUrlImportConfirm;
@property (nonatomic, strong) NSString* serverUrlExport;

@property (nonatomic, strong) NSString* sessionTime;




/*!
 * @brief default 정보인증 중계서보 정보로 초기화 한다.
 * @return self : 성공, nil : 실패
 */
- (id)init;

/*!
 * @brief 해당 중계서버 아이피와 포트로 초기화 한다.
 * @return self : 성공, nil : 실패
 */
//- (id)initWithRelayServerIP:(NSString *)domain relayServerPort:(NSInteger)port;


/*!
 * @brief 해당 중계서버 주소를 초기화 한다.
 * @return self : 성공, nil : 실패
 */
- (id)initWithRelayServerURL:(NSString*)ServerUrl relayServerSID:(NSString*)sidUrl relayServerImport:(NSString*)importUrl relayServerConfirm:(NSString*)confirmUrl   relayServerExport:(NSString*)exportUrl ;


/*!
 * @brief 중계서버에서 인증코드를 가져와서 authCode에 저장한다.
 * @return YES : 성공, NO : 실패
 */
- (BOOL)getAuthCode;


/*!
 * @brief 중계서버에서 인증서를 가져온다.
 * @return YES : 성공, NO : 실패
 */
- (BOOL)getCertFromServer;


/*!
 * @brief 가져온 인증서를 앱에 저장한다.
 * @return YES : 성공, NO : 실패
 */
- (BOOL)saveCert:(NSData *)certToPKCS12;

/**
 * @brief PKCS#12 형식의 인증서를 키체인에 저장한다.
 * @param certToPKCS12    [IN] 저장할 PKCS#12형식의 인증서, nil 중계서버로 부터 받아온 PKCS#12를 저장한다.
 * @param accessGroup      [IN] 키체인 액세스 그룹명
 * @return YES : 성공, NO : 실패
 */
- (BOOL)saveCertWithKeychain:(NSData *)certToPKCS12 accessGroup:(NSString *)accessGroup;

/**
 * @brief 인증서 가져오기 완료
 * @return YES : 성공, NO : 실패
 */
- (BOOL)successGetCert;


/**
 * @brief 중계서버로 키체인에 저장된 인증서를 내보낸다.
 * @param certDN
 * @param sendAuthCode
 * @param password
 * @return YES : 성공, NO : 실패
 */
- (BOOL)sendCertToServer:(NSString*)certDN sendAuthCode:(NSString*)sendAuthCode certPassword:(NSString*)password;

/**
 * @brief 앱에 저장된 인증서를 가져와서 NSMutableArray에 각 필드를 저장한다.
 * @param certDN                   [IN] 내부에 저장된 인증서의 DN들 중 내보낼 인증서의 DN
 * @param sendAuthCode      [OUT] PC에서 보이는 인증코드
 * @param password               [IN] 인증서의 패스워드
 * @param accessGroup        [IN] 키체인 액세스 그룹명
 * @return YES: 성공, NO: 실패
 */
- (BOOL)sendCertToServerWithKeychain:(NSString*)certDN sendAuthCode:(NSString*)sendAuthCode certPassword:(NSString*)password accessGroup:(NSString *)accessGroup;


/**
 * @brief 오류메시지를 리턴한다.
 * @return 스트링 : 성공, nil : 실패
 */
-(NSString *)getErrorMessage;

/**
 * @brief 중계서버로부터 받은 응답을 파싱하여 NSDictionary * 형태로 반환하는 메서드
 */
-(NSDictionary *) parseRelayResponse : (NSData *) data;

@end
