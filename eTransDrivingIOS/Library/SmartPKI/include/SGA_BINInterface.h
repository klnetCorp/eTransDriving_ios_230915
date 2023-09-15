/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: SGA_BINInterface.h
 */

#import <Foundation/Foundation.h>

#define SGIP_BIN_TYPE_CERT			10
#define SGIP_BIN_TYPE_CRL			11
#define SGIP_BIN_TYPE_RSA_PRIKEY	12
#define SGIP_BIN_TYPE_PKCS7			13

// -----BEGIN (PEM_STRING)-----\n
#define PEM_HEADER_LENGTH			17		
// \n-----END (PEM_STRING)-----
#define PEM_FOOTER_LENGTH			15		

//PEM STRING
#define PEM_STRING					"PRIVACY-ENHANCED MESSAGE" /*!< */
#define X509_OLD_PEM_STRING			"X509 CERTIFICATE" /*!< */
#define X509_PEM_STRING				"CERTIFICATE" /*!< */
#define X509_PAIR_PEM_STRING		"CERTIFICATE PAIR" /*!< */
#define X509_TRUSTED_PEM_STRING		"TRUSTED CERTIFICATE" /*!< */
#define X509_REQ_OLD_PEM_STRING		"NEW CERTIFICATE REQUEST" /*!< */
#define X509_REQ_PEM_STRING			"CERTIFICATE REQUEST" /*!< */
#define X509_CRL_PEM_STRING			"X509 CRL" /*!< */
#define PUBLIC_PEM_STRING			"PUBLIC KEY" /*!< */
#define RSA_PEM_STRING				"RSA PRIVATE KEY" /*!< */
#define RSA_PUBLIC_PEM_STRING		"RSA PUBLIC KEY" /*!< */
#define PKCS7_PEM_STRING			"PKCS7" /*!< */
#define PKCS8_PEM_STRING			"ENCRYPTED PRIVATE KEY" /*!< */
#define PKCS8INF_PEM_STRING			"PRIVATE KEY" /*!< */
#define KCDSA_PEM_STRING			"KCDSA PRIVATE KEY" /*!< */
#define KCDSAPARAMS_PEM_STRING		"KCDSA PARAMETERS" /*!< */

#import "SGA_Define.h"

@interface SGA_BINInterface : NSObject {
	
}

+ (int)encodeHex: (NSString	**) OUT ppcsHexString aSrc: (NSData *) IN pcsSrcData;
+ (int)decodeHex: (NSData **) OUT ppcsDstData aSrc:(NSString *) IN pcsHexString;

+ (int)encodeBase64 : (NSString **) OUT ppcsBase64String aSrc: (NSData *) IN pcsSrcData;
+ (int)decodeBase64 : (NSData **) OUT ppcsDstData aSrc:(NSString *) IN pcsBase64String;

+ (int)encodePEM: (NSString **) OUT ppcsPEMString aType:(int) IN iType aSrc: (NSData *) IN pcsSrcData;
+ (int)decodePEM: (NSData **) OUT ppcsDstData aSrc:(NSString *) IN pcsPEMString;

+ (int) encode_PEM2 : (NSData *) pData 
         aPEMString : (NSString *) pPEMString 
       aEncodedData : (NSString **) pPEMEncData 
              aMode : (int) iMode;

+ (int) decode_PEM2 : (NSData *)pP7PEMEncData 
       aDecodedData : (NSData **)ppP7PEMDecData;

//지정한 Delimeter로 Pem타입 구분자 사용 가능
+ (int)encodePEMEx: (NSString **)ppcsPEMString aType:(int)iType aSrc: (NSData *)pcsSrcData aDelimeter : (NSString *)pcsDelimeter;
+ (int)decodePEMEx: (NSData **)ppcsDstData aSrc:(NSString *)pcsPEMString aDelimeter : (NSString *)pcsDelimeter;

/*
+ (void)printHex: (NSData *)pcsData aName : (NSString *)pcsName;
+ (void)printHex2: (NSData *)pcsData aName : (NSString *)pcsName;
*/

+ (void)printHex: (NSData *) OUT pcsData aName : (NSString *) IN pcsName;
+ (void)printHex2: (NSData *) OUT pcsData aName : (NSString *) IN pcsName;

@end
