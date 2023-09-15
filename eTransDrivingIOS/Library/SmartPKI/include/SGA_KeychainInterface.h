/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_KeychainInterface.h
 */

//#import <UIKit/UIKit.h>

/**
 *@brief 키체인에 데이터를 저장한다.
 */
@interface SGA_KeychainInterface : NSObject {
    
}

+ (NSDictionary *)getItemListFromService:(NSString *)pcsServiceName;

+ (NSString *) getItemDataFromKey : (NSString *) pcsType 
                         aService : (NSString *) pcsService
                            error : (NSError **) error;

+ (BOOL) writeItemData : (NSString *) pcsType 
                 aData : (NSString *) pcsData
              aService : (NSString *) pcsService
        updateExisting : (BOOL) updateExisting
                 error : (NSError **) error;

/**
 *@brief 키체인에 저장된 Item을 삭제한다.
 *@param pcsType                   [IN] SignCert.der, SignPrikey.der, KMCert.der, KMPrikey.der
 *@param pcsService             [IN] UserDN
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return BOOL                      [OUT]  성공, 실패 여부 리턴
 */
+ (BOOL) deleteItemFromKey : (NSString *) pcsType 
                  aService : (NSString *) pcsService
                     error : (NSError **) error;


//인증서를 키체인 그룹으로 저장, 읽기하려면 이쪽 API를 사용한다
/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 저장된 모든 유저 DN을 가져온다.
 *@param pcsAccount             [IN] 키체인 그룹의 계정 키값. SMARTPKI_KEYCHAIN_USER_DN_LIST    //고정값이라 함수내부에 박으면 되서 사실 필요없긴한데 다른 서비스를 가져올 수도 있으니 남겨둠
 *@param accessGroup           [IN] 키체인 그룹 명
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return NSDictionary*                 [OUT]  키체인그룹에 저장된 유저 DN 리스트
 */
+ (NSData *)getItemListFromKeychain:(NSString *)pcsAccount aGroup : (NSString *)accessGroup error:(NSError **) error;

/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 저장된 Item을 가져온다.
 *@param pcsAccount             [IN] UserDN
 *@param aKind                        [IN] KC_Save 내에 define 된 User,CA,Root 구분 값
 *@param accessGroup           [IN] 키체인 그룹 명
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return NSString*                 [OUT]  키체인그룹에 저장된 인증서
 */
+ (NSString *) getItemDataFromKeychain : (NSString *) pcsAccount
                                 aKind : (NSString *) aKind
                                aGroup : (NSString *) accessGroup
                                 error : (NSError **) error;

/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 Item을 저장한다.
 *@param pcsAccount            [IN] UserDN
 *@param aKind                       [IN] KC_Save 내에 define 된 User,CA,Root 구분 값
 *@param pcsData                  [IN] Base64 인코딩된 인증서 데이터
 *@param accessGroup         [IN] 키체인 그룹 명
 *@param error                       [IN] 에러코드 발생 후 리턴
 *@return NSString*                [OUT]  키체인그룹에 저장된 인증서
 */
+ (BOOL) writeItemDataToKeychain : (NSString *) pcsAccount
                           aKind : (NSString *) aKind
                           aData : (NSString *) pcsData
                          aGroup : (NSString *) accessGroup
                           error : (NSError **) error;

/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 UserDN을 저장한다.
 *@param pcsAccount             [IN] UserDN
 *@param pcsData                    [IN] Base64 인코딩된 인증서 데이터
 *@param accessGroup           [IN] 키체인 그룹 명
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return NSString*                 [OUT]  키체인그룹에 저장된 인증서
 */
+ (BOOL) writeUserDNToKeychain : (NSString *) pcsAccount
                         aData : (NSString *) pcsData
                        aGroup : (NSString *) accessGroup
                         error : (NSError **) error;

/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 저장된 Item을 삭제한다.
 *@param pcsAccount             [IN] UserDN
 *@param aKind                         [IN] KC_Save 내에 define 된 User,CA,Root 구분 값
 *@param accessGroup           [IN] 키체인 그룹 명
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return BOOL                       [OUT]  성공, 실패 여부 리턴
 */
+ (BOOL) deleteItemFromKeychain : (NSString *) pcsAccount
                          aKind : (NSString *) aKind
                         aGroup : (NSString *) accessGroup
                          error : (NSError **) error;

/**
 *@brief KC_Save를 사용할 경우 사용한다. 키체인그룹에 저장된 UserDN을 삭제한다.
 *@param pcsAccount             [IN] UserDN
 *@param userDN                      [IN] UserDN
 *@param accessGroup           [IN] 키체인 그룹 명
 *@param error                        [IN] 에러코드 발생 후 리턴
 *@return BOOL                       [OUT]  성공, 실패 여부 리턴
 */
+ (BOOL) deleteUserDNFromKeychain : (NSString *) pcsAccount
                              aDN : (NSString *) userDN
                           aGroup : (NSString *) accessGroup
                            error : (NSError **) error;

@end





