/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGGetCertServer.h
 */


#import <Foundation/Foundation.h>

/*!
 * @brief 단말과 중계서버 간 인증서 및 인증코드를 가져오는 인터페이스 
 * @param ssn							[IN] 사용자 주민번호 또는 사업자번호
 * @param authCode						[IN] 중계서버에서 부여받은 인증코드
 * @param PWD							[IN] 인증서 패스워드
 * @param serverIP						[IN] 중계서버 IP
 * @param serverPort					[IN] 중계서버 PORT
 * @param sessTime						[IN] 인증서를 전송 받기 위한 최대 시간 (milliSec)
 */
@interface SGGetCertServer : NSObject
{
	NSString* ssn;
	NSString* authCode;
	NSString* PWD;
	NSString* serverIP;
	NSInteger serverPort;
	int sessTime;
}

@property (nonatomic, retain) NSString* ssn;
@property (nonatomic, retain) NSString* authCode;
@property (nonatomic, retain) NSString* PWD;
@property (nonatomic, retain) NSString* serverIP;
@property (nonatomic) NSInteger serverPort;
@property (nonatomic) int sessTime;


/*!
 * @brief default 정보인증 중계서보 정보로 초기화 한다.
 * @return self : 성공, nil : 실패
 */
- (id)init;

/*!
 * @brief 해당 중계서버 아이피와 포트로 초기화 한다.
 * @return self : 성공, nil : 실패
 */
- (id)initWithRelayServerIP:(NSString *)domain relayServerPort:(NSInteger)port;

/*!
 * @brief 중계서버에서 인증코드를 가져와서 authCode에 저장한다.
 * @return YES : 성공, NO : 실패
 */
- (BOOL)getAuthCode;

/*!
 * @brief 중계서버에서 인증서를 가져와서 앱에 저장한다. 저장시 내부적으로 saveCert() 호출
 * @return YES : 성공, NO : 실패
 */
- (BOOL)getCertFromServer;

/*!
 * @brief 오류메시지를 리턴한다.
 * @return 스트링 : 성공, nil : 실패
 */
-(NSString *)getErrorMessage;


@end
