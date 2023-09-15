/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGMakeLoginData.h
 */


#import <UIKit/UIKit.h>
#import "SGA_Define.h"

/*!
 * @brief 로그인 데이터 생성, 전송, 결과 확인 인터페이스
 * @param pwd							[IN] 인증서 패스워드
 * @param reqServerCertURL              [IN] 서버용인증서 요청 페이지 주소
 * @param reqLoginPageURL               [IN] 로그인 요청 페이지 주소
 * @param idnStr						[IN] 주민번호(중계서버에 따라서 생략 가능)
 * @param userDN						[IN] 인증서 DN
 * @param loginType						[IN] 로그인 타입 (LOGIN_ASP_BASE64_URLENC, LOGIN_ASP_HEX, LOGIN_JSP_BASE64_URLENC, LOGIN_JSP_HEX)
 * @param customData					[IN] 각 사이트 별 전송할 커스터마이징 데이터
 */
@interface SGMakeLoginData : NSObject
{
	NSString* pwd;
	NSString* reqServerCertURL;
	NSString* reqLoginPageURL;
	NSString* userDN;
	NSString* idnStr;
	NSString* customData;
	NSString* responseMessage;
	
	LOGIN_TYPE loginType;
}

@property ( nonatomic, retain ) NSString* pwd;
@property ( nonatomic, retain ) NSString* reqServerCertURL;
@property ( nonatomic, retain ) NSString* reqLoginPageURL;
@property ( nonatomic, retain ) NSString* userDN;
@property ( nonatomic, retain ) NSString* idnStr;
@property ( nonatomic, retain ) NSString* customData;
@property ( nonatomic, retain ) NSString* responseMessage;
@property ( nonatomic) LOGIN_TYPE loginType;




/*!
 * @brief 객체를 초기화 한다.
 * @return id
 */
- (id)init;


/*!
 * @brief 로그인 서버에 로그인한다.
 * @return YES: 성공, NO: 실패
 */
- (BOOL)loginServer;


/*!
 * @brief 서버에 전송한 로그인 데이터를 가져온다.
 * @return nil이 아니면: 성공, nil: 실패
 */
-(NSMutableDictionary *)getSendParam;


/*!
 * @brief 오류메시지를 리턴한다.
 * @return 스트링 : 성공, nil : 실패
 */
-(NSString *)getErrorMessage;


@end
