/*****************************************************************************/
/* Copyright (C) 2011-2017 KICA, Inc.  All rights reserved.                  */
/*****************************************************************************/

/* THIS FILE IS PROPRIETARY MATERIAL OF KICA, INC.
 * AND MAY BE USED ONLY BY DIRECT LICENSEES OF KICA, INC.
 * THIS FILE MAY NOT BE DISTRIBUTED. */

/**
 * FILE: StringDefine.h
 */

#ifndef _AX_STRING_DEFINE_INCLUDED_
#define _AX_STRING_DEFINE_INCLUDED_ 1

#pragma mark SETTING
/////// CONFIG /////////
#define CONFIG_KEY_PASSWORD					@"passwd"
#define CONFIG_KEY_PASSWORD_TIME			@"passwd_time"
#define CONFIG_KEY_APP_PASSWORD_TIME		@"apppasstime"


#pragma mark COMMENT
#define COMMON_JAILEBREAKE_DEVICE_CHECKING	@"안내\r\n\r\n비 정상적인 단말로 구동 하셨습니다. \r\n 본 프로그램은 정상적인 단말에서만 구동이 가능합니다."
#define COMMON_CERT_PASSWORD_CONFIRM_SUCCESS @"인증서 암호확인을 성공하였습니다."
#define COMMON_CERT_PASSWORD_CONFIRM_FAILED	@"인증서 암호확인에 실패하였습니다."
#define COMMON_CERT_FILE_LOAD_FAILED		@"인증서를 불러오는데 실패하였습니다."
#define COMMON_CERT_FILE_WRITE_FAILED		@"인증서를 저장하는데 실패하였습니다."
#define COMMON_CERT_FILE_DELETE_FAILED		@"인증서를 삭제하는데 실패하였습니다."
#define COMMON_CERT_FILE_DELETE             @"선택한 인증서를 삭제하시겠습니까?"
#define	COMMON_CERT_ENCRYPT_SIGNKEY_FAILED	@"인증서의 개인키를 암호화하는데 실패하였습니다."
#define	COMMON_CERT_ENCRYPT_KMKEY_FAILED	@"인증서의 암호키를 암호화하는데 실패하였습니다."
#define	COMMON_CERT_DECRYPT_SIGNKEY_FAILED	@"인증서의 개인키를 복호화하는데 실패하였습니다."
#define	COMMON_CERT_DECRYPT_KMKEY_FAILED	@"인증서의 암호키를 복호화하는데 실패하였습니다."
#define COMMON_CERT_PASSWORD_CONFIRM_ERROR	@"인증서 암호가 일치하지 않습니다."
#define COMMON_CERT_DID_NOT_SELECTED		@"인증서가 선택되지 않았습니다."
#define COMMON_INPUT_PASSWORD_EMPTY			@"인증서 암호를 입력하여 주십시오."
//getCertInfo 에러
#define COMMON_CERT_INFO_READ_FAILED		@"인증서 정보를 읽어오는데 실패하였습니다."
#define	COMMON_PKCS12_EXTRACT_FAILED		@"PFX 형식으로 부터 인증서를 추출하는데 실패하였습니다."
#define	COMMON_VID_VALID_FAILED				@"인증서 유효성 확인이 실패하였습니다."

#define	COMMON_NETWORK_USE3G_DISABLE		@"3G 네트워크 사용을 승인하지 않았습니다."
#define COMMON_NETWORK_ENABLE_FAILED		@"네트워크 연결을 확인하여주십시오."
#define COMMON_NETWORK_VERIFY_INFO			@"1)wi-fi 환경에서는 네트워크의 방화벽 설정에 따라 검증에 실패 할 수 있습니다. 이 경우 3G환경에서 시도해보시기 바랍니다.\n2)네트워크를 통해 상위 인증기관의 인증서를 가져와야 할 경우 시간이 오래 걸릴 수 있습니다.\n\n계속하시겠습니까?"
#define COMMON_CERT_SIGN_FAILED		@"전자서명 생성에 실패하였습니다."
#define COMMON_CERT_P7SIGNED_FAILED		@"PKCS#7 전자서명 메시지 생성에 실패하였습니다."
#define COMMON_CERT_P7SIGNEDENVELOPED_FAILED		@"PKCS#7 SIGNANDENVELOPED 메시지 생성에 실패하였습니다."




#define CERT_RENEW_PASSWORD_EMPTY			@"갱신할 인증서 암호를 입력하여 주십시오."
#define CERT_ISSUE_AUTHCODE_EMPTY			@"참조코드를 입력하세요."
#define	CERT_ISSUE_REFRENCECODE_EMPTY		@"인가코드를 입력하세요."
#define CERT_ISSUE_INPUT_PASSWD_EMPTY		@"발급 인증서를 위한 암호를 입력하여 주십시오."
#define CERT_ISSUE_INPUT_REPASSWD_EMPTY		@"발급 인증서를 위한 암호를 다시한번 입력하여 주십시오."
#define CERT_ISSUE_PASSWD_CONFIRM_FAILED	@"발급 인증서를 위한 암호가 다릅니다."
#define CERT_ISSUE_PASSWD_NOT_VALID			@"안전하지 않은 암호입니다.\n\n1)10자리 이상\n2)3회 이상 반복적인 입력값은 피하시고\n3)영문과 숫자를 조합하세요."
#define CERT_ISSUE_PASSWD_NOT_VALID_CHARACTER    @"암호에는 반드시 특수문자가 한자 이상 포함되어야 합니다."

//TRANS SERVER ERROR MESSAGE BEGIN
#define	TRANS_CERT_CLIENT_INIT_FAILED		@"중계서버 연결에 실패하였습니다."
#define	TRANS_CERT_CLIENT_CLOSE_FAILED		@"중계서버 연결종료에 실패하였습니다."
#define	TRANS_CERT_CLIENT_GETAUTHE_FAILED	@"인증번호 수신에 실패하였습니다."
#define	TRANS_CERT_CLIENT_RECV_FAILED		@"인증서 수신에 실패하였습니다."

#define	TRANS_CERT_SERVER_MSG_1000			@"성공적으로 처리되었습니다."
#define	TRANS_CERT_SERVER_MSG_2001			@"데이터 메시지 수가 잘못되었습니다."
#define	TRANS_CERT_SERVER_MSG_2002			@"데이터 메시지의 내용이 NULL 입니다."
#define	TRANS_CERT_SERVER_MSG_2003			@"잘못된 요청 데이터 입니다."
#define	TRANS_CERT_SERVER_MSG_4001			@"주민번호 또는 사업자 번호를 얻을수 없습니다."
#define	TRANS_CERT_SERVER_MSG_4002			@"잘못된 인증코드 입니다."
#define	TRANS_CERT_SERVER_MSG_4011			@"요청한 인증코드로 전송된 인증서가 없습니다."
#define	TRANS_CERT_SERVER_MSG_4012			@"유효하지 않은 인증서 입니다."
#define	TRANS_CERT_SERVER_MSG_4013			@"인증서 검증중 오류가 발생하였습니다.";
#define	TRANS_CERT_SERVER_MSG_4014			@"신원확인에 실패 하였습니다.";
#define	TRANS_CERT_SERVER_MSG_4020			@"잘못된 확인데이터 입니다.";
#define	TRANS_CERT_SERVER_MSG_4021			@"확인 데이터를 얻을 수 없습니다."
#define	TRANS_CERT_SERVER_MSG_4022			@"확인메시지 처리중 오류가 발생했습니다."
#define	TRANS_CERT_SERVER_MSG_4023			@"전자서명 검증에 실패하였습니다."
#define	TRANS_CERT_SERVER_MSG_9999			@"시스템 오류가 발생하였습니다."
#define	TRANS_CERT_SERVER_MSG_DEFAULT		@"알 수  없는 오류가 발생하였습니다."

#define GETCERT_GETTING_PROCESS_MESSAGE		@"인증번호 가져오기를 진행중입니다."
#define GETCERT_GETTING_CERT_MESSAGE		@"인증서를 가져오는 중입니다."
#define GETCERT_INPUT_PASSWORD				@"인증서 가져오기를 위한 인증서 암호를 입력하여 주십시오."
#define GETCERT_INPUT_PASSWORD_AGAIN		@"인증서 가져오기를 위한 인증서 암호를 다시한번 입력하여 주십시오."
#define GETCERT_INPUT_PASSWORD_NOT_EQUAL	@"입력하신 인증서 암호가 틀립니다. \r\n 비밀번호를 다시확인후 입력하여 주십시오."
#define GETCERT_INPUT_PASSWORD_EMPTY		@"비밀번호를 입력하여 주십시오."
#define GETCERT_OK_MESSAGE					@"정상적으로 인증서를 가져왔습니다."
#define GETCERT_FAILED_MESSAGE				@"인증서를 가져오는데 실패하였습니다."
#define GETCERT_TRANS_GETAUTHCODE_FAILED	@"인증번호를 가져오는데 실패하였습니다."
#define GETCERT_GET_PKCS12_CERT_FAILED		@"중계서버로부터 PFX 인증서를 가져오는데 실패하였습니다."
#define GETCERT_GET_CERT_INFO_FAILED		@"인증서 정보를 가져오는데 실패하였습니다."
#define GETCERT_CERT_AUTHCODE_CHECK_FAILED	@"인증번호를 다시 확인하여주십시오."
#define GETCERT_CERT_GET_DN_FAILED			@"인증서 주체정보(DN)를 가져오는데 실패하였습니다."

#define EXPORTCERT_CAPUBS_CREATE_FAILED		@"인증서(한국정보인증)의 CaPubs 생성에 실패하였습니다."
#define EXPORTCERT_SENDING_PROCESS_MESSAGE	@"인증서 내보내기를 진행중입니다."
#define EXPORTCERT_SEND_PKCS12_CERT_FAILED	@"인증서 내보내기를 위한 PFX 전송에 실패하였습니다."
#define EXPORTCERT_GEN_PKCS12_FAILED		@"인증서 내보내기를 위한 PFX 형식의 인증서 생성에 실패하였습니다."
#define EXPORTCERT_PC_JOB_MESSAGE			@"서버로 인증서 내보내기 성공\r\n\r\nPC에서 주민(사업자)등록번호 입력 후 [인증서 가져오기] 버튼을 클릭해 주세요."
#define EXPORTCERT_PC_JOB_SUCCESS			@"인증서 내보내기를 성공하였습니다."
#define EXPORTCERT_PC_JOB_FAILED			@"인증서 내보내기를 실패하였습니다."
#define EXPORTCERT_INPUT_USERDATA_FAILED	@"주민(사업자)등록번호를 입력하여 주십시오."
#define EXPORTCERT_INPUT_AUTHCODE_EMPTY		@"PC의 인증번호와 동일한 인증번호인지 확인하여 주십시오."
#define EXPORTCERT_INPUT_AUTHCODE_ERROR		@"입력한 인증번호가 일치하지 않습니다. \r\n PC의 인증번호와 동일한 인증번호인지 확인하여 주십시오."

//TRANS SERVER ERROR MESSAGE END

#define CERT_REGIST_USER_INPUT_EMPTY		@"인증서 발급을 위한 주민(사업자)등록번호를 입력하여 주십시오."
#define CERT_REGIST_NOT_AGREE_USER			@"인증서 발급에 동의하지 않았습니다."

#define GETCERT_AREADY_GOT_AUTHCODE			@"이미 인증번호를 받으셨습니다."
#define GETCERT_INFO_SSN_NUM_ERROR			@"주민등록번호 앞 6 자리와 뒤 7 자리의 입력을 다시 확인하여 주십시오."
#define GETCERT_INFO_BBN_NUM_ERROR			@"사업자번호 앞 3 자리 중간 2 자리 뒤 5 자리의 입력을 다시 확인하여 주십시오."

#define GETCERT_INPUT_REF_CODE				@"참조번호를 입력해 주세요."
#define GETCERT_INPUT_AUTH_CODE				@"승인번호를 입력해 주세요."

#define CERT_VERIFY_USER_INPUT_EMPTY		@"신원확인을 위한 주민(사업자)등록번호를 입력하여 주십시오."
#define CERT_VERIFY_USER_DN_EMPTY			@"신원확인을 위한 인증서가 선택되지 않았습니다."
#define CERT_VERIFY_USER_COMPLETE			@"신원확인 검증에 성공하였습니다."
#define CERT_VERIFY_USER_FAILED				@"신원확인 검증에 실패하였습니다."

#define CERT_VERIFY_KEYPAIR_INPUT_EMPTY		@"인증서 키쌍검증을 위한 주민(사업자)등록번호를 입력하여 주십시오."
#define CERT_VERIFY_KEYPAIR_DN_EMPTY		@"인증서 키쌍검증을 위한 인증서가 선택되지 않았습니다."
#define CERT_VERIFY_KEYPAIR_COMPLETE		@"인증서 키쌍 검증에 성공하였습니다."
#define CERT_VERIFY_KEYPAIR_FAILED			@"인증서 키쌍 검증에 실패하였습니다."

#define CERT_CHANGE_PASSWORD_COMPLETE		@"인증서의 비밀번호가 변경되었습니다."
#define CERT_CHANGE_PASSWORD_FAILED			@"인증서 비밀번호 변경에 실패했습니다."
#define CERT_CHANGE_PASSWORD_NOTEQUAL		@"변경할 비밀번호가 일치하지 않습니다."
#define CERT_CHANGE_OLDNEW_PASSWORD_EQUAL	@"변경할 비밀번호와 현재 비밀번호가 같습니다."
#define CERT_CHANGE_NEW_PASSWORD_STATE		@"인증서 암호확인에 성공하였습니다. \r\n\r\n 인증서 암호를 새로운 암호로 변경하시겠습니까?"

#define CERT_DELETE_PASSWORD_CHECK_FAILED	@"인증서 암호검증에 실패하였습니다."
#define CERT_DELETE_PROCESS_FAILED			@"인증서 삭제를 실패하였습니다."
#define CERT_DELETE_PROCESS_COMPLETE		@"인증서 삭제를 성공하였습니다."

#define CERT_PWSAVE_DELETE                  @"인증서 비밀번호 저장을 해제 하시겠습니까?"
#define CERT_PWSAVE_SET_CERT_PW             @"인증서 암호를 먼저 설정하세요."
#define CERT_PWSAVE_CERT_PW_FAILED          @"인증서 비밀번호가 틀립니다."
#define CERT_PWSAVE_PRIVKEY_FAILED          @"개인키를 읽어 올 수 없습니다."

#define ENV_GETVALUE_TRANS_HOST_EMPTY		@"중계서버 호스트를 확인하여 주십시오."
#define ENV_GETVALUE_TRANS_PORT_EMPTY		@"중계서버 포트를 확인하여 주십시오."
#define ENV_GETVALUE_TRANS_OPPSIGNCERT_EMPTY @"암호통신용 인증서가 없습니다."
#define ENV_GETVALUE_TRANS_OPPSIGNKEY_EMPTY @"암호통신용 인증서키가 없습니다."

#define SHOW_FROM_SEND_CERT_SUCCESS			@"쇼인증서로부터 인증서 내보내기를 성공하였습니다."
#define SHOW_FROM_SEND_CERT_FAILED			@"쇼인증서로부터 인증서 내보내기를 실패하였습니다."
#define SHOW_FROM_GET_CERT_SUCCESS			@"쇼인증서로부터 인증서 가져오기를 성공하였습니다."
#define SHOW_FROM_GET_CERT_FAILED			@"쇼인증서로부터 인증서 가져오기를 실패하였습니다."
#define SHOW_FROM_GET_CERT_SAVE_FAILED_PRAM	@"쇼인증서로부터 가져온 인증서를 저장 실패하였습니다.[%d]"

#define KICA_TO_SEND_CERT_FAILED			@"KICA 인증서로 인증서 내보내기를 실패하였습니다."

#define KICA_MSG_KICADOWNLOAD				@"공동인증서비스이용을 위하여 [KICA 인증서 프로그램]이 필요합니다. 이용에 동의하며 프로그램을 다운로드 하시겠습니까?"
#define KICA_MSG_ALREADY_INSTALLED			@"KICA 인증서가 이미 설치 되어 있습니다."

#define SHOW_ARGUMENT_CALL_ERROR			@"쇼인증서 오류가 발생하였습니다.[SHOW MANAGER CALL ERROR]"
#define SHOW_ARGUMENT_NOT_LOAD				@"쇼인증서 오류가 발생하였습니다.[SHOW MANGER DID NOT LOAD]"

#define SHOW_MSG_SHOWDOWNLOAD				@"공동인증서비스이용을 위하여 KT의 [쇼 인증서 프로그램]이 필요합니다. 이용에 동의하며 프로그램을 다운로드 하시겠습니까?"
#define SHOW_MSG_ALREADY_INSTALLED			@"쇼 인증서가 이미 설치 되어 있습니다."

#define CERT_REVOKE_REASON_FAILED			@"폐지사유가 선택되지 않았습니다."

#define COVERFLOW_DESC_REQUEST				@"공동인증서를 발급/재발급 받기 위해 신청서를 제출합니다. PC가 없어도 편리하게!"
#define COVERFLOW_DESC_NEWREQUEST			@"신규 공동인증서가 필요하실 경우 온라인으로 인증서 신청하세요!"
#define COVERFLOW_DESC_ISSUE				@"공동인증서를 발급/재발급 받습니다.\n전자계약,입찰,구매 어디든 공동인증서로!"
#define COVERFLOW_DESC_RENEWREQUEST			@"인증서를 분실하거나 암호를 잊으셨나요? 인증서 재발급 신청을 하세요!"
#define COVERFLOW_DESC_CERTMOVE				@"PC에서 아이폰으로, 아이폰에서 PC로 인증서를 이동시킬 수 있어요!"
#define COVERFLOW_DESC_MANAGE				@"인증서 보기,검증,삭제,키 갱신,키쌍검증.\n여러분의 인증서 관리를 한번에!"
#define COVERFLOW_DESC_REISSUE				@"인증서 만료가 30일도 남지 않았나요?\n사용 중인 인증서 기간을 1년 연장해주세요!"
#define COVERFLOW_DESC_SHOW					@"저장된 인증서를 [SHOW인증서]앱으로 보내거나 다른 인증서를 가져올 수 있어요"
#define COVERFLOW_DESC_KICA					@"저장된 인증서를 [KICA인증서]앱으로 보내거나 다른 인증서를 가져올 수 있어요"
#define COVERFLOW_DESC_REVOKE				@"공동인증서를 더이상 사용하지 않을 경우\n영구히 폐지합니다."
#define COVERFLOW_DESC_COMPANY				@"대한민국 제 1호 공동인증기관!\n한국 정보 인증을 소개합니다."
#define COVERFLOW_DESC_CERTINTRO			@"공동인증서에 대해 궁금한게 있으세요?\n궁금증을 풀어드립니다."
#define COVERFLOW_DESC_CERTSEND				@"스마트폰에 저장된 인증서를 PC로 이동시킬 수 있어요!"
#define COVERFLOW_DESC_CERTSIGN				@"서명이 필요한 모든곳에 한국정보인증이 제공하는 안정한 서명을 이용하세요!."

#define UNIFY_DESC_INVALID_NEW				@"인증서 만료가 %d일 남았습니다. 인증서 신청 메뉴에서 발급 신청을 해주세요."
#define UNIFY_DESC_INVALID_KICA				@"인증서 만료가 %d일 남았습니다. 인증서 갱신 메뉴에서 인증서를 발급 받을 수 있습니다."

#define IOS_LIMIT_NOTIC						@"iOS 기기에서는 지원하지 않는 기능입니다. 불편을 드려 죄송합니다."
#define IOS_LIMIT_MACHINE						@"현재 앱은 iPhone4 이상에서 동작합니다.\n그 이하 단말일 경우 화면 및 기능에 제약이\n있을 수 있습니다."

#define BROWSER_ALERT_ERR					@"에러가 발생하여 웹브라우저로 이동합니다. 작업을 계속하시려면 전환된 웹브라우저에서 접속하셨던 탭을 선택하여 주세요."
#define BROWSER_ALERT_ERR2                  @"인증에 실패하였습니다. 다시 시도해주시거나, 인터넷 연결이 정상적으로 되어있는지 확인해주세요."

#define BROWSER_ALERT_CANCEL				@"입력이 취소 되었습니다. 작업을 계속하시려면 전환된 웹브라우저에서 접속하셨던 탭을 선택하여 주세요."
#define BROWSER_ALERT_COMPLELTE				@"입력을 완료하신 후 전환된 웹브라우저에서 사용중이시던 탭을 선택하여 주세요."
#define BROWSER_ALERT_COMPLELTE2			@"작업을 계속하시려면 전환된 웹브라우저에서 접속하셨던 탭을 선택하여 주세요."


//



//






#pragma mark URL
#define ROOT_CERT_TRUST_LINK				@"http://www.rootca.or.kr/kcac/cert/potency.html"
#define ITUNES_URL						@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=434358764&;mt=8"
#define APPSTORE_URL						@"https://appsto.re/kr/SN84z.i"
#define RND_TRANS_SERVER					0
#define RND_TRANS_SERVER_OPP				0




#define URL_RND_TRANS_SERVER				@"61.72.247.156"

//#define URL_LDAP_SERVER						@"ldap.signgate.com"
//#define URL_SOL_TRANS_SERVER				@"relay.signgate.com"
//#define WEBMASTER_MAIL						@"kica@signgate.com"


#pragma mark DEFINE SETTING

//#define LOCAL
//#define DEV
#define RUN


//-> 전처리 환경설정

/** 로컬 환경*/
#if defined(LOCAL)

#define DEF_RUN_MODE                        @"LOCAL_2_22"

// WebView Main.
#define DEF_KICA_HOME                       @"http://192.168.200.100:8080"
//
#define URL_CMP_SERVER                      @"192.168.220.156"

#define URL_DEMO_SIGN						@"http://kicasign.sg-family.com/smartsign/demo.html"
#define URL_M_SIGNGATE                      @"http://m.signgate.com"

//#define KICASIGN_PLUS_DEFAULT_URL           @"/kicasignplus/app/appMain.sg"
#define KICASIGN_PLUS_DEFAULT_URL           @"/kicasign/app/appMain.sg"

#define KICASIGN_PLUS_APPCERTMNG            @"/kicasignplus/app/appCertMngView.sg"
#define KICASIGN_PLUS_APP_BIOCERT_MAIN      @"/kicasignplus/app/appCertBioMain.sg"

#define KICASIGN_PLUS_APP_BIOCERT           @"kicasignplus_app_biocert"

#define RELAY_SERVER_URL                    @"https://192.168.200.100:8443/web-relay/sign/sign_up.sg"
#define RELAY_SERVER_URL_SID                @"https://192.168.200.100:8443/web-relay/cert/sid.sg"
#define RELAY_SERVER_URL_IMPORT             @"https://192.168.200.100:8443/web-relay/cert/cert_dn.sg"
#define RELAY_SERVER_URL_IMPORT_OK          @"https://192.168.200.100:8443/web-relay/cert/confirm.sg"
#define RELAY_SERVER_URL_EXPORT             @"https://192.168.200.100:8443/web-relay/cert/cert_up.sg"

#define UPDATE_SERVER_URL                   @"https://dev.signgate.com:2443/kicasign_app_util/app_version/KICASignPlus_Version_iOS.dat"

#define KFIDO_POLICY_URL                    @"https://dev.signgate.com:2443/kicasign_app_util/app_filter/KICASignPlus_OID_Filters_iOS.dat"

//#define KFIDO_PUSH_TOKEN_URL                @"https://192.168.200.100:8443/web-relay/bio/sidByWebRequest.sg"

#define KFIDO_FIDO_REGISTRATION_URL         @"https://192.168.200.100:8443/web-relay/bio/registerUser.sg"
#define KFIDO_PUSH_TOKEN_URL                @"https://192.168.200.100:8443/web-relay/bio/appByCodeReq.sg"
#define KFIDO_PUSH_TOKEN_DEL_URL            @"https://192.168.200.100:8443/web-relay/bio/cancelPush.sg"
#define KFIDO_PUSH_TOKEN_SET_URL            @"https://192.168.200.100:8443/web-relay/bio/setConfig.sg"

#define URL_LDAP_SERVER						@"ldap.signgate.com"
#define URL_SOL_TRANS_SERVER				@"relay.signgate.com"
#define WEBMASTER_MAIL						@"kica@signgate.com"





/** 개발 환경*/
#elif defined(DEV)

#define DEF_RUN_MODE                        @"DEV_2_22"
#define DEF_KICA_HOME                       @"https://dev.signgate.com:2443"
#define URL_CMP_SERVER                      @"ca.signgate.com"

#define URL_DEMO_SIGN						@"http://kicasign.sg-family.com/smartsign/demo.html"
#define URL_M_SIGNGATE                      @"http://m.signgate.com"

#define KICASIGN_PLUS_DEFAULT_URL           @"/kicasignplus/app/appMain.sg"
#define KICASIGN_PLUS_APPCERTMNG            @"/kicasignplus/app/appCertMngView.sg"
#define KICASIGN_PLUS_APP_BIOCERT_MAIN      @"/kicasignplus/app/appCertBioMain.sg"

#define KICASIGN_PLUS_APP_BIOCERT           @"kicasignplus_app_biocert"

#define RELAY_SERVER_URL                    @"https://dev.signgate.com/web-relay/sign/sign_up.sg"
#define RELAY_SERVER_URL_SID                @"https://dev.signgate.com/web-relay/cert/sid.sg"
#define RELAY_SERVER_URL_IMPORT             @"https://dev.signgate.com/web-relay/cert/cert_dn.sg"
#define RELAY_SERVER_URL_IMPORT_OK          @"https://dev.signgate.com/web-relay/cert/confirm.sg"
#define RELAY_SERVER_URL_EXPORT             @"https://dev.signgate.com/web-relay/cert/cert_up.sg"

#define UPDATE_SERVER_URL                   @"https://dev.signgate.com:2443/kicasign_app_util/app_version/KICASignPlus_Version_iOS.dat"

#define KFIDO_POLICY_URL                    @"https://dev.signgate.com:2443/kicasign_app_util/app_filter/KICASignPlus_OID_Filters_iOS.dat"

//#define KFIDO_PUSH_TOKEN_URL              @"https://192.168.200.100:8443/web-relay/bio/sidByWebRequest.sg"

#define KFIDO_FIDO_REGISTRATION_URL         @"https://dev.signgate.com/web-relay/bio/registerUser.sg"
#define KFIDO_PUSH_TOKEN_URL                @"https://dev.signgate.com/web-relay/bio/appByCodeReq.sg"
#define KFIDO_PUSH_TOKEN_DEL_URL            @"https://dev.signgate.com/web-relay/bio/cancelPush.sg"
#define KFIDO_PUSH_TOKEN_SET_URL            @"https://dev.signgate.com/web-relay/bio/setConfig.sg"

#define URL_LDAP_SERVER					@"ldap.signgate.com"
#define URL_SOL_TRANS_SERVER				@"relay.signgate.com"
#define WEBMASTER_MAIL					@"kica@signgate.com"




/** 운영 환경*/
#elif defined(RUN)

#define DEF_RUN_MODE                        @"REAL"
#define DEF_KICA_HOME                       @"https://www.signgate.com"
#define URL_CMP_SERVER                      @"ca.signgate.com"

#define URL_DEMO_SIGN						@"http://kicasign.sg-family.com/smartsign/demo.html"
#define URL_M_SIGNGATE                      @"http://m.signgate.com"

#define KICASIGN_PLUS_DEFAULT_URL           @"/kicasignplus/app/appMain.sg"
#define KICASIGN_PLUS_APPCERTMNG            @"/kicasignplus/app/appCertMngView.sg"
#define KICASIGN_PLUS_APP_BIOCERT_MAIN      @"/kicasignplus/app/appCertBioMain.sg"

#define KICASIGN_PLUS_APP_BIOCERT           @"kicasignplus_app_biocert"

#define RELAY_SERVER_URL                    @"https://www.signgate.com/web-relay/sign/sign_up.sg"
#define RELAY_SERVER_URL_SID                @"https://www.signgate.com/web-relay/cert/sid.sg"
#define RELAY_SERVER_URL_IMPORT             @"https://www.signgate.com/web-relay/cert/cert_dn.sg"
#define RELAY_SERVER_URL_IMPORT_OK          @"https://www.signgate.com/web-relay/cert/confirm.sg"
#define RELAY_SERVER_URL_EXPORT             @"https://www.signgate.com/web-relay/cert/cert_up.sg"

#define UPDATE_SERVER_URL                   @"https://www.signgate.com/kicasign_app_util/app_version/KICASignPlus_Version_iOS.dat"

#define KFIDO_POLICY_URL                    @"https://www.signgate.com/kicasign_app_util/app_version/KICASignPlus_OID_Filters_iOS.dat"

#define KFIDO_PUSH_TOKEN_URL               @"https://www.signgate.com/web-relay/bio/sidByWebRequest.sg"

#define KFIDO_FIDO_REGISTRATION_URL         @"https://www.signgate.com/web-relay/bio/registerUser.sg"
#define KFIDO_PUSH_TOKEN_URL                @"https://www.signgate.com/web-relay/bio/appByCodeReq.sg"
#define KFIDO_PUSH_TOKEN_DEL_URL            @"https://www.signgate.com/web-relay/bio/cancelPush.sg"
#define KFIDO_PUSH_TOKEN_SET_URL            @"https://www.signgate.com/web-relay/bio/setConfig.sg"



#define URL_LDAP_SERVER					@"ldap.signgate.com"
#define URL_SOL_TRANS_SERVER				@"relay.signgate.com"
#define WEBMASTER_MAIL					@"kica@signgate.com"




//#define KFIDO_POLICY_URL                    @"http://192.168.200.151:8080/KICASignPlus_OID_Filters_iOS.dat"

//#define KFIDO_PUSH_TOKEN_URL               @"https://192.168.200.100:8443/web-relay/bio/sidByWebRequest.sg"

//#define KFIDO_FIDO_REGISTRATION_URL         @"https://192.168.200.100:8443/web-relay/bio/registerUser.sg"
//#define KFIDO_PUSH_TOKEN_URL                @"https://192.168.200.100:8443/web-relay/bio/appByCodeReq.sg"
//#define KFIDO_PUSH_TOKEN_DEL_URL            @"https://192.168.200.100:8443/web-relay/bio/cancelPush.sg"
//#define KFIDO_PUSH_TOKEN_SET_URL            @"https://192.168.200.100:8443/web-relay/bio/setConfig.sg"

//#define URL_LDAP_SERVER					@"ldap.signgate.com"
//#define URL_SOL_TRANS_SERVER				@"relay.signgate.com"
//#define WEBMASTER_MAIL					@"kica@signgate.com"

#else
#error MODE ERROR

#endif

//<-- 전처리 환경설정


#define OID_KICA_PERSONAL                   @"1.2.410.200004.5.2.1.2"








#if 0

//----- 로컬 환경 -----
//#define DEF_RUN_MODE                         @"LOCAL_2_22"
//#define DEF_KICA_HOME                           @"http://192.168.200.115:8080"
//#define URL_CMP_SERVER						@"192.168.220.156"

//----- 개발 환경 -----
//#define DEF_RUN_MODE                            @"DEV_2_22"
//#define DEF_KICA_HOME                           @"http://192.168.220.94"
//#define URL_CMP_SERVER						@"192.168.220.156"

//----- 개발 환경 -----
//#define DEF_RUN_MODE                            @"DEV_2_22"
//#define DEF_KICA_HOME                           @"https://192.168.200.150:7443"
//#define URL_CMP_SERVER                          @"ca.signgate.com"


//----- 개발 환경 -----
//#define DEF_RUN_MODE                            @"DEV_2_22"
//#define DEF_KICA_HOME                           @"https://dev.signgate.com:2443"
//#define URL_CMP_SERVER                          @"ca.signgate.com"


//----- 운영 환경 ------
//#define DEF_RUN_MODE                            @"REAL"
//#define DEF_KICA_HOME                           @"https://www.signgate.com"
//#define URL_CMP_SERVER                          @"ca.signgate.com"



// real
//
//#define DEF_RUN_MODE                            @"REAL"
//#define DEF_KICA_HOME                           @"https://www.signgate.com"
//#define URL_CMP_SERVER                          @"ca.signgate.com"

//#define DEF_RUN_MODE                            @"DEV_5_12"
//#define DEF_KICA_HOME                           @"https://192.168.200.150:7443"
//#define URL_CMP_SERVER                          @"ca.signgate.com"

//--------------------

// https://dev.signgate.com
//#define RELAY_SERVER_URL                    @"https://192.168.200.150:7443/signgaterelay/sign/sign_up.sg"
//#define TEST_RELAY_SERVER_URL_SID           @"https://192.168.200.150:7443/signgaterelay/cert/sid.sg"
//#define TEST_RELAY_SERVER_URL_IMPORT        @"https://192.168.200.150:7443/signgaterelay/cert/cert_dn.sg"
//#define TEST_RELAY_SERVER_URL_IMPORT_OK     @"https://192.168.200.150:7443/signgaterelay/cert/confirm.sg"
//#define TEST_RELAY_SERVER_URL_EXPORT        @"https://192.168.200.150:7443/signgaterelay/cert/cert_up.sg"

//#define RELAY_SERVER_URL               @"https://www.signgate.com/web-relay/sign/sign_up.sg"

//#define RELAY_SERVER_URL_SID           @"https://www.signgate.com/web-relay/cert/sid.sg"
//#define RELAY_SERVER_URL_IMPORT        @"https://www.signgate.com/web-relay/cert/cert_dn.sg"
//#define RELAY_SERVER_URL_IMPORT_OK     @"https://www.signgate.com/web-relay/cert/confirm.sg"
//#define RELAY_SERVER_URL_EXPORT        @"https://www.signgate.com/web-relay/cert/cert_up.sg"
////

//#define KICASIGN_PLUS_DEFAULT_URL           @"/kicasignplus/app/appMain.sg"
//#define KICASIGN_PLUS_APPCERTMNG            @"/kicasignplus/app/appCertMngView.sg"

////
//#define RELAY_SERVER_URL                    @"https://192.168.200.150:7443/web-relay/sign/sign_up.sg"
//#define RELAY_SERVER_URL_SID           @"https://192.168.200.150:7443/web-relay/cert/sid.sg"
//#define RELAY_SERVER_URL_IMPORT        @"https://192.168.200.150:7443/web-relay/cert/cert_dn.sg"
//#define RELAY_SERVER_URL_IMPORT_OK     @"https://192.168.200.150:7443/web-relay/cert/confirm.sg"
//#define RELAY_SERVER_URL_EXPORT        @"https://192.168.200.150:7443/web-relay/cert/cert_up.sg"
////

//#define UPDATE_SERVER_URL                   @"https://www.signgate.com/kicasign_app_util/app_version/KICASignPlus_Version_iOS.dat"
//#define UPDATE_SERVER_URL                   @"http://192.168.200.151:8080/KICASignPlus_Version_iOS.dat"

//#define RELAY_SERVER_URL                    @"https://dev.signgate.com/web-relay/sign/sign_up.sg"
//#define TEST_RELAY_SERVER_URL_SID           @"https://dev.signgate.com/web-relay/cert/sid.sg"
//#define TEST_RELAY_SERVER_URL_IMPORT        @"https://dev.signgate.com/web-relay/cert/cert_dn.sg"
//#define TEST_RELAY_SERVER_URL_IMPORT_OK     @"https://dev.signgate.com/web-relay/cert/confirm.sg"
//#define TEST_RELAY_SERVER_URL_EXPORT        @"https://dev.signgate.com/web-relay/cert/cert_up.sg"

#endif



#pragma   mark PORT
#define	PORT_CMP							4502
#define PORT_RND_TRANS_SSL					9000

//#define URL_DEMO_SIGN						@"http://kicasign.sg-family.com/smartsign/demo.html"
//#define URL_M_SIGNGATE                      @"http://m.signgate.com"
#define PORT_SOL_TRANS_SSL					443 // kica웹사인
//#define PORT_SOL_TRANS_SSL				    9013    // 공동인증서앱

#define PORT_LDAP							389

#define DEFAULT_PHONE_NUMBER				@"000000000"
#define DEFAULT_SSN_NUMBER					@"1234561234563"

// ======= 이미지 이름 정의
#define IMG_DEFAULT							@"Default_main.png"
#define IMG_MAIN_BG							@"bg.png"
#define IMG_DEFAULT_BG						@"bg_default.png"
#define IMG_MAIN_BG_2X						@"bg@2x.3png"
#define IMG_MAIN_MENU_BG					@"bg_main.png"

#pragma mark BUILD
#define UPDATEAPPSTOREDATE					2012.01.05
#define	APPSTORE_VERSION					@"1.0.0.1"
#define REVISION_AUTHMONACO					807
#define REVISION_API						1396
#define REVISION_DLG						1397
#define REVISION_KICAWEBSIGN				1398
#define UPDATEAPPSTOREDATE					2012.01.05

#endif	// _AX_STRING_DEFINE_INCLUDED_


#define def_CERTMAXA @"cn=KISA RootCA 1,ou=Korea Certification Authority Central,o=KISA,c=KR 의 해쉬값:\n0272:6829:3E5F:5D17:AAA4:B3C3:E636:1E1F:9257:5EAA"
#define def_CERTMAXA_TEXT @"최상위 인증기관을 신뢰할 수 있습니다.\n0272:6829:3E5F:5D17:AAA4:B3C3:E636:1E1F:9257:5EAA\n인증서 발급 신청시 받으신 신청서 하단의 검증키 또는 RootCA의 신뢰 확인 페이지의 해쉬값과 일치하는지 확인 하시고 만약 일치하지 않는 경우 해당 등록기관에 문의 바랍니다.\nRootCA 신뢰 확인 URL : http://www.rootca.or.kr/kcac/cert/potency.html"
#define def_INVALIDCERT @"인증서가 만료되었거나 아직 유효하지 않습니다."
