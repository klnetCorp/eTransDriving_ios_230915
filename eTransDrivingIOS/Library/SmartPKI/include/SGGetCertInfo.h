/*****************************************************************************/
/* Copyright (C) 2012-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGGetCertInfo.h
 */


#import <Foundation/Foundation.h>

/*!
 * @brief 인증서 각 필드를 추출하는 인터페이스
 * @param certCount                 [OUT] 인증서의 개수
 */
@interface SGGetCertInfo : NSObject
{
	NSInteger certCount;
}

@property (nonatomic) NSInteger certCount;
/*!
 * @brief 앱에 저장된 인증서를 가져와서 내부에 저장한다.   
 * @return self
 */
-(id)initWithSavedStorageCert;

/**
 *@brief 키체인에 저장된 인증서를 가져와서 내부에 저장한다
 *@param accessGroup      [IN] 키체인 액세스 그룹명
 *@return self
 */
- (id)initWithSavedStorageCertWithKeychain:(NSString *)accessGroup;

/**
 * @brief 앱에 저장된 인증서를 가져와서 NSMutableArray에 각 필드를 저장한다.
 * @param sequence [IN] 인증서 저장 순서 = 인증서 로드 순서
 * @param certMutableDic [OUT] 인증서 정보(NSMutableDictionary_키:certDN(인증서DN), certCN(사용자명), certIssuer(발급기관), certToDate(만료일), certUsage(용도))
 * @return YES: 성공, NO: 실패
 */
-(BOOL)parseCertWithSavedSequence:(NSInteger)sequence 
						 getValue:(NSMutableDictionary **)certMutableDic;

/**
 * @brief 앱에 저장된 인증서를 가져와서 NSMutableArray에 각 필드를 저장한다.
 * @param sequence                  [IN] 인증서 저장 순서 = 인증서 로드 순서
 * @param certMutableDic     [OUT] 인증서 정보(NSMutableDictionary_키:certDN(인증서DN), certCN(사용자명), certIssuer(발급기관), certToDate(만료일), certUsage(용도))
 * @return YES: 성공, NO: 실패
 */
- (BOOL)parseCertWithSavedSequenceWithKeychain:(NSInteger)sequence
getValue:(NSMutableDictionary **)certMutableDic;

/*!
 * @brief 해당 인증서를 이용해 인증서 각 필드 값을 프로퍼티에 할당한다. 
 * @return 오류메시지: 성공, nil: 실패
 */
-(NSString *)getErrorMessage;

@end
