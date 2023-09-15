//
//  KC_Save.h
//  SGIPhoneAPI_4_2_Lion
//
//  Created by Inseong Jeon on 2020/06/26.
//

//  향후 SGA_SaveInterface 대신 사용할 인증서 저장 API
//  현재는 로컬과 키체인 저장 중 키체인만 구현되어 있다.
#ifndef KC_Save_h
#define KC_Save_h

#endif /* KC_Save_h */

#define KC_KEYCHAIN_USER_DN_LIST                   @"KICA_USER_DN_LIST"
#define KC_KEYCHAIN_ROOT_DN_LIST                   @"KICA_ROOT_DN_LIST"
#define KC_KEYCHAIN_CA_DN_LIST                     @"KICA_CA_DN_LIST"

#define KC_IPHONE_USER_HOME                              @"USER"
#define KC_IPHONE_ROOT_HOME                              @"ROOT"
#define KC_IPHONE_CA_HOME                                @"CA"
#define KC_IPHONE_CRL_HOME                               @"CRL"
#define KC_IPHONE_ARL_HOME                               @"ARL"

#define KC_IPHONE_SAVE_NAME_SIGN_CERT                    @"signCert"
#define KC_IPHONE_SAVE_NAME_SIGN_PRIKEY                  @"signPri"
#define KC_IPHONE_SAVE_NAME_KM_CERT                      @"kmCert"
#define KC_IPHONE_SAVE_NAME_KM_PRIKEY                    @"kmPri"
#define KC_IPHONE_SAVE_NAME_CAPUBS                       @"CaPubs"
#define KC_IPHONE_SAVE_NAME_CRL                          @"CRL"
#define KC_IPHONE_SAVE_NAME_ARL                          @"ARL"

#define KC_IPHONE_SAVE_KIND_USER                         1
#define KC_IPHONE_SAVE_KIND_CA                           2
#define KC_IPHONE_SAVE_KIND_ROOT                         3

#define KC_IPHONE_SAVE_TYPE_SIGN_CERT                    1
#define KC_IPHONE_SAVE_TYPE_SIGN_PRIKEY                  2
#define KC_IPHONE_SAVE_TYPE_KM_CERT                      3
#define KC_IPHONE_SAVE_TYPE_KM_PRIKEY                    4
#define KC_IPHONE_SAVE_TYPE_CAPUBS                       5
#define KC_IPHONE_SAVE_TYPE_CRL                          6
#define KC_IPHONE_SAVE_TYPE_ARL                          7


@interface KC_Save : NSObject {
    
}

// 키체인 저장 API. accessGroup이 nil일 경우 기본 액세스 그룹에 저장됨
// 액세스 그룹 예시: @"VGXBFUDRST.com.signgate.SharingKeychain"
/**
 *@brief 키체인에 인증서를 저장한다
 *@param userDN                   [IN] 저장할 인증서의 DN
 *@param signCert               [IN] 인증서의 SignCert
 *@param signPrikey          [IN] 인증서의 SignPrikey
 *@param KMCert                   [IN] 인증서의 KMCert
 *@param KMPrikey               [IN] 인증서의 KMPrikey
 *@param accessGroup        [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)writeUserAllToKeychain: (NSString *)userDN
                   aSignCert : (NSData *)signCert
                 aSignPrikey : (NSData *)signPrikey
                     aKMCert : (NSData *)KMCert
                   aKMPrikey : (NSData *)KMPrikey
                      aGroup : (NSString *)accessGroup;

/**
 *@brief 키체인에 인증서DN을 저장한다
 *@param iKind                   [IN] KC_Save 내에 define 된 User,CA,Root 구분 값
 *@param pcsUserDN          [IN] 인증서의 DN
 *@param accessGroup      [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)writeSaveDNToKeychain: (int)iKind aCertDN : (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;

//키체인 로드 API
/**
 *@brief 키체인에 저장된 인증서를 읽어온다
 *@param pcsDN                           [IN] 읽어올 인증서의 DN
 *@param ppcsSignPrikey       [OUT] 인증서의 SignPrikey
 *@param ppcsSignCert            [OUT] 인증서의 SignCert
 *@param ppcsKMPrikey            [OUT] 인증서의 KMPrikey
 *@param ppcsKMCert                [OUT] 인증서의 KMCert
 *@param accessGroup              [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)readUserAllFromKeychain: (NSString *)pcsDN
                  aSignPrikey : (NSData **)ppcsSignPrikey
                    aSignCert : (NSData **)ppcsSignCert
                    aKMPrikey : (NSData **)ppcsKMPrikey
                      aKMCert : (NSData **)ppcsKMCert
                       aGroup : (NSString *)accessGroup;

/**
 *@brief 키체인에 저장된 DN리스트를 읽어온다
 *@param ppcsDNArray         [IN] DN리스트를 저장한 배열
 *@param accessGroup         [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)readUserDNList: (NSMutableArray **)ppcsDNArray aGroup: (NSString *)accessGroup;

//키체인 삭제 API
/**
 *@brief 키체인에 저장된 인증서를 삭제한다
 *@param pcsUserDN              [IN] 삭제할 인증서의 DN
 *@param accessGroup          [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)deleteUserAllFromKeychain: (NSString *)pcsUserDN aGroup : accessGroup;

/**
 *@brief 키체인에 저장된 DN리스트에서 선택한 DN을 삭제한다
 *@param pcsUserDN              [IN] 인증서 DN
 *@param iKind                       [IN] KC_Save 내에 define 된 User,CA,Root 구분 값
 *@param accessGroup          [IN] 키체인 액세스 그룹명
 *@return integer        0:성공, -1:실패, 그 외:에러코드
 */
+ (int)deleteSaveDNFromKeychain: (NSString *)pcsUserDN aKind : (int)iKind aGroup : (NSString *)accessGroup;


//Internal Functions
+ (int)writeUserSignCertToKeychain: (NSData *)pcsCertData aCertDN:(NSString *)pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)writeUserSignPrikeyToKeychain: (NSData *)pcsPrikeyData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;

+ (int)readUserSignCertFromKeychain: (NSData **)ppcsCertData aCertDN: (NSString *) pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)readUserSignPrikeyFromKeychain: (NSData **)ppcsPrikeyData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)readUserKMCertFromKeychain: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)readUserKMPrikeyFromKeychain: (NSData **)ppcsPrikeyData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)readUserCaPubsFromKeychain: (NSData **)ppcsCaPubs aCertDN : (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;

+ (int)readRootDNList: (NSMutableArray **)ppcsDNArray aGroup: (NSString *)accessGroup;
+ (int)readCADNList: (NSMutableArray **)ppcsDNArray aGroup: (NSString *)accessGroup;

+ (int)writeCRL: (NSData *)pcsCRL aType:(int)iType aDN : pcsDN aGroup : accessGroup;
+ (int)writeRootCertToKeychain: (NSData *)pcsCertData aCertDN:(NSString *)pcsCertDN aGroup : accessGroup;
+ (int)writeCACertToKeychain: (NSData *)pcsCertData aCertDN: (NSString *)pcsCertDN aGroup : accessGroup;

+ (int)readCRL: (NSData **)ppcsData aType:(int)iType aDN : (NSString *)pcsDN aGroup : accessGroup;
+ (int)readRootCertFromKeychain: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;
+ (int)readCACertFromKeychain: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN aGroup : (NSString *)accessGroup;

+ (int)deleteRootCertFromKeychain: (NSString *)pcsCertDN aGroup : accessGroup;
+ (int)deleteCACertFromKeychain: (NSString *)pcsCertDN aGroup : accessGroup;

@end
