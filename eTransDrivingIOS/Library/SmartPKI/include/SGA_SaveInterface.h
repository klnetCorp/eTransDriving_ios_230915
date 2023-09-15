/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_SaveInterface.h
 */

#import <Foundation/Foundation.h>

#define SGIP_KICA_HOME						        @"/KICA"
#define SGIP_USER_HOME						        @"/KICA/USER"
#define	SGIP_ROOT_HOME						        @"/KICA/ROOT"
#define	SGIP_CA_HOME						        @"/KICA/CA"
#define SGIP_CRL_HOME						        @"/KICA/CRL"
#define SGIP_ARL_HOME						        @"/KICA/ARL"
        
#define SGIP_SAVE_NAME_SIGN_CERT			        @"signCert.der"
#define SGIP_SVAE_NAME_SIGN_PRIKEY			        @"signPri.key"
#define SGIP_SAVE_NAME_KM_CERT				        @"kmCert.der"
#define SGIP_SVAE_NAME_KM_PRIKEY			        @"kmPri.key"
#define SGIP_SAVE_NAME_CAPUBS				        @"CaPubs"

#define	SGIP_SAVE_KIND_USER					        1
#define	SGIP_SAVE_KIND_CA					        2
#define SGIP_SAVE_KIND_ROOT					        3

#define SGIP_KEYCHAIN_SERVICE_USER_DN_LIST          @"KICA_DN_LIST"
//#define SGIP_SAVE_KEYCHAINSERVICE_USER      @"KICA_CA"
//#define SGIP_SAVE_KEYCHAINSERVICE_USER      @"KICA_ROOT"

#define SGIP_SAVE_TYPE_SIGN_CERT			        1
#define	SGIP_SAVE_TYPE_SIGN_PRIKEY			        2
#define SGIP_SAVE_TYPE_KM_CERT				        3
#define SGIP_SAVE_TYPE_KM_PRIKEY			        4
#define SGIP_SAVE_TYPE_CAPUBS				        5
#define SGIP_SAVE_TYPE_CRL					        6
#define SGIP_SAVE_TYPE_ARL					        7


@interface SGA_SaveInterface : NSObject {
	
}

+ (int)createInitFolder;

// Added by ishan78
+ (int)didHaveKICADirectory;
+ (int)createStoredCertification;
+ (int)removeStoredCertification;

+ (int)writeSaveUserDNToSystem : (NSString *)pcsSerial aCertDN : (NSString *)pcsUserDN;
+ (int)deleteSaveUserDNFromSystem : (NSString *)pcsSerial;

+ (int)writeSaveToKeychain : (NSString *)pcsUserDN
                     aType : (NSString *)pcsType 
                     aData : (NSData *)pcsData;

+ (int)deleteSaveKeychain : (NSString *)pcsUserDN 
                    aType : (NSString *)pcsType;
// Added by ishan78  End

+ (int)writeSave : (int)iKind aType:(int)iType aCert:(NSData *)pcsCertData aCertDN: (NSString *)pcsUserDN;
+ (int)writeCRL : (NSData *)pcsCRL aType:(int)iType aDN : pcsDN;

+ (int)writeUserSignCert: (NSData *)pcsCertData aCertDN:(NSString *)pcsUserDN;
+ (int)writeUserSignPrikey: (NSData *)pcsPrikeyData aCertDN: (NSString *)pcsUserDN;
+ (int)writeUserKMCert: (NSData *)pcsCertData aCertDN:(NSString *)pcsUserDN;
+ (int)writeUserKMPrikey: (NSData *)pcsPrikeyData aCertDN:(NSString *)pcsUserDN;
+ (int)writeUserCaPubs: (NSData *)pcsCaPubs aCertDN:(NSString *)pcsUserDN;

+ (int)writeUserAll : (NSString *)pcsDN
		aSignPrikey :(NSData *)pcsSignPrikey
		  aSignCert : (NSData *)pcsSignCert
		  aKMPrikey : (NSData *)pcsKMPrikey
			aKMCert : (NSData *)pcsKMCert;

+ (int)writeRootCert: (NSData *)pcsCertData aCertDN:(NSString *)pcsCertDN;
+ (int)writeCACert: (NSData *)pcsCertData aCertDN: (NSString *)pcsCertDN;

+ (int)readSave : (NSData **)ppcsData aKind:(int)iKind aType:(int)iType aCertDN: (NSString *)pcsUserDN;
+ (int)readCRL : (NSData **)ppcsData aType:(int)iType aDN : (NSString *)pcsDN;

+ (int)readUserSignCert: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN;
+ (int)readUserSignPrikey: (NSData **)ppcsPrikeyData aCertDN: (NSString *)pcsUserDN;
+ (int)readUserKMCert: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN;
+ (int)readUserKMPrikey: (NSData **)ppcsPrikeyData aCertDN: (NSString *)pcsUserDN;
+ (int)readUserCaPubs: (NSData **)ppcsCaPubs aCertDN : (NSString *)pcsUserDN;

+ (int)readUserAll : (NSString *)pcsDN
	   aSignPrikey : (NSData **)ppcsSignPrikey
		 aSignCert : (NSData **)ppcsSignCert
		 aKMPrikey : (NSData **)ppcsKMPrikey
		   aKMCert : (NSData **)ppcsKMCert;

+ (int)readRootCert: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN;
+ (int)readCACert: (NSData **)ppcsCertData aCertDN: (NSString *)pcsUserDN;

+ (int)readSaveList : (NSMutableArray **)ppcsCertArray aKind:(int)iKind;

+ (int)readUserSignCertList : (NSMutableArray **)ppcsCertArray;
+ (int)readRootCertList : (NSMutableArray **)ppcsCertArray;
+ (int)readCACertList : (NSMutableArray **)ppcsCertArray;

+ (int)readSaveDNList : (NSMutableArray **)ppcsDNArray aKind:(int)iKind;
+ (int)readUserDNList : (NSMutableArray **)ppcsDNArray;
+ (int)readRootDNList : (NSMutableArray **)ppcsDNArray;
+ (int)readCADNList : (NSMutableArray **)ppcsDNArray;

+ (int)deleteSave : (int)iKind aType:(int)iType aUserDN: (NSString *)pcsUserDN;
+ (int)deleteUserSignCert : (NSString *)pcsUserDN;
+ (int)deleteUserKMCert : (NSString *)pcsUserDN;
+ (int)deleteUserSignPrikey : (NSString *)pcsUserDN;
+ (int)deleteUserKMPrikey : (NSString *)pcsUserDN;

+ (int)deleteUserAll : (NSString *)pcsUserDN;

+ (int)deleteRootCert : (NSString *)pcsCertDN;
+ (int)deleteCACert : (NSString *)pcsCertDN;
+ (int)deleteUserCaPubs : (NSString *)pcsCertDN;

@end
