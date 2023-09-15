//
//  MainViewController.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/08.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "MainViewController.h"
#import <WebKit/WebKit.h>
#import "TMapTapi.h"
#import <KakaoNavi/KakaoNavi.h>
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CallKit/CallKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "DataSet.h"
#import "Preference.h"
#import "ComUtil.h"
#import "AVCamCameraViewController.h"
#import "CloudVisionViewController.h"
#import "WebViewContainerViewController.h"
#import "SignViewController.h"
#import "GpsInfo.h"
#import "PacketController.h"
#import "EtransLocationManager.h"
#import "ReportServiceManager.h"
#import "NSString+Encrypt.h"
#import "MinewBeaconManager.h"
#import "SpeechHelper.h"
#import "PopWebViewController.h"

#import "SGA_NetInterface.h"
#import "SGTransmitCertServer.h"
#import "SGTransmitCertServer.h"
#import "SGGetCertInfo.h"
#import "SGGetCertInfo.h"
#import "SGA_SaveInterface.h"
#import "SGA_CSPInterface.h"
#import "StringDefine.h"
#import "SGMakeLoginData.h"
#import "SGA_BINInterface.h"
#import "KC_Save.h"

#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@import Firebase;

#define isFcLogging true
#define TMAP_API_KEY @"l7xx8a69806ee60e4e918076f67014bdcfe8"

enum REQUEST_TYPE {
    CONTAINER_NO_FROM_CAMERA_REQUEST,
    CONTAINER_NO_FROM_GALLERY_REQUEST,
    SEAL_NO_FROM_CAMERA_REQUEST,
    SEAL_NO_FROM_GALLERY_REQUEST,
    CAR_BIZ_CD_FROM_GALLERY_REQUEST,
    BIZ_CD_FROM_GALLERY_REQUEST,
    HANDLER_SEARCH_SALE_LIST,
    MULTI_CONTAINER_NO_FROM_CAMERA_REQUEST,
    MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST,
    UPLOADFILE_FROM_CAMERA_REQUEST,
    UPLOADFILE_FROM_GALLERY_REQUEST,
    UPLOADFILE_FROM_FILE_REQUEST
};

@interface MainViewController ()<WKNavigationDelegate, WKUIDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TMapTapiDelegate, NSStreamDelegate, CXCallObserverDelegate, CBCentralManagerDelegate, UIDocumentInteractionControllerDelegate, UIDocumentPickerDelegate>
{
    BOOL _isLoginPage;
    BOOL _isMianPage;
    BOOL _isKeyboard;
    Preference *_preference;
    WKWebView *_webViewtemp;
    enum REQUEST_TYPE _request_type;
    
    CLLocationManager *_locationManager;
    
    NSDate *_lastTimestamp;
    NSDate *_lastTimestamp2;
    NSString *_urlForNavi;
    
    PacketController *mClsPacketController;
    
    NSString *scanedBeacon;
    
    CLBeaconRegion *_myBeaconRegion;
    CBPeripheralManager *_peripheralManager;
    NSDictionary *myBeaconData;
    CLBeaconRegion *_myBeaconRegion2;
    
    NSMutableArray *_multiContainerImageArray;
    NSInteger _maxImageCount;
    
    CXCallObserver *_callObserver;
    BOOL _bIsCalling;
    
    CBCentralManager * _cManager;
    BOOL _bIsDostartinit;
    
    BOOL keychainSwitch;
    NSString* accessGroup;

    SGGetCertInfo *_certInfo;
    NSInteger _selectRow;

}
@property(strong, nonatomic) WKWebView * webView;
@property(strong, nonatomic) UIImageView * iv_intro;

@property NSArray *sortedBeaconArray;

@property (nonatomic, strong) SGTransmitCertServer *transmitCertServerObj;
@property (nonatomic, retain) UIDocumentInteractionController *doic;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lastTimestamp = [NSDate date];
    _lastTimestamp2 = [NSDate date];
    
    _preference = [[Preference alloc] init];
    //[_preference setAuthPhoneNo:@"01023427113"];
    
    NSString *sSignHash = [self md5:CONNECTION_URL];
    NSString *getHash = [self sendDataToServer];
    
    BOOL rootingCheck = [self checkRooting];
    [DataSet sharedDataSet].isMode = IS_MODE;
    [DataSet sharedDataSet].connectUrl = CONNECTION_URL;
    
    if ([[DataSet sharedDataSet].isMode isEqualToString:@"D"]) {
        //개발 테스트용은 앱스토어 배포가 아니므로 무조건 통과시킨다.
       getHash = sSignHash;
    }
    
    if(!rootingCheck) {
        NSString *msg = [NSString stringWithFormat:@"루팅된 단말기 입니다. \n개인정보 유출의 위험성이 있으므로 \n프로그램을 종료합니다."];
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            exit(0);
                                   }];
        [alert addAction:okAction];
        [alert addAction:okAction];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        });
    }
    

    if(![sSignHash isEqualToString:getHash]) {
    
        NSString *msg = [NSString stringWithFormat:@"프로그램 무결성에 위배됩니다. \nAppStore 내에서 \n 설치하시기 바랍니다."];
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            exit(0);
                                   }];
        [alert addAction:okAction];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        });
    }
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [_webView setNavigationDelegate:self];
    [_webView setUIDelegate:self];
    [self.view addSubview:_webView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _iv_intro = [[UIImageView alloc] initWithFrame:screenRect];
    [_iv_intro setImage:[UIImage imageNamed:@"launcher"]];
    [_iv_intro setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_iv_intro];
    
    if ([ComUtil checkJailBreak]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"알림" message:@"탈옥이 감지 되었습니다. 앱을 종료합니다." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            exit(0);
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self gotoLoginPage];
    
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    [noti addObserver:self selector:@selector(conNoToServer:) name:@"conNoToServer" object:nil];
    [noti addObserver:self selector:@selector(sendSignImage:) name:@"sendSignImage" object:nil];
    [noti addObserver:self selector:@selector(goPush:) name:@"goPush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(pushCheck)
        name:UIApplicationDidBecomeActiveNotification
      object:nil];
    
//    [[EtransLocationManager sharedInstance] startLocationManager];                 //asmyoung
    _locationManager = [EtransLocationManager sharedInstance].locationManager;
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager setAllowsBackgroundLocationUpdates:YES];
        //[_locationManager setDistanceFilter:kCLDistanceFilterNone];
        //[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager startUpdatingLocation];
    }
    
    _multiContainerImageArray = [NSMutableArray new];
    _maxImageCount = 0;
    
    _callObserver = [[CXCallObserver alloc] init];
    [_callObserver setDelegate:self queue:nil];
//
//    [SpeechHelper speakString:@"안녕하세요. 테스트입니다." withCompletion:^{
//
//    }];
    
    _cManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    [self centralManagerDidUpdateState:_cManager];
    
    

    keychainSwitch = NO;    //키체인 사용여부
    accessGroup = @"24K3FWZV2S.kr.co.klnet.ios.SharingCert";

    self.transmitCertServerObj = [[SGTransmitCertServer alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *firstLogin = [_preference getFirstLogin];
    if ([firstLogin isEqualToString:@"Y"]) {
        NSString *str = @"[필수적 접근 권한]\n*인터넷 : 인터넷을 이용한 이트랜스드라이빙 서비스 접근\n*저장공간 : 단말기 내 프로그램 설치 및 업데이트 그리고 씰사진 업로드 또는 명세서 저장 등의 업무 파일 보관\n*전화 : 고객센터로 바로 전화 연결 또는 사용자 계정 생성 및 확인을 위한 권한\n*연락처 : 사용자가 생성한 계정을 확인, 차량정보 불러오기, 계산서 발급을 위한 이메일 정보 획득을 위한 권한\n*카메라 : 컨테이너 번호 인식, 씰 사진 업로드 서비스 업무에 필요한 사진 촬영을 위한 권한\n*위치정보 : 앱이 종료되었거나 사용 중이 아닐때도 위치데이터를 수집하여 터미널 출발알림 서비스, 인수도증(전자슬립) 수신 등의 서비스를 사용 설정 하기 위한 권한\n\n[선택적 접근 권한]\n*블루투스 : 터미널 근접 시 위치기반 혜택 제공을 위한 권한\n*푸시알림 : 코피노, 인수도증, 공지사항 등의 정보 제공을 위한 PUSH 알림 서비스\n\n*위 항목은 이트랜스 드라이빙 실행에 필요한 항목이며 권한이 거부되면 이트랜스 드라이빙을 정상적으로 사용하실 수 없습니다.\n\n*회원가입 시 입력된 휴대폰번호와 차량번호는 회원관리 및 서비스 응대를 위해 이트랜스에 저장되어 관리됩니다.";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"접근 권한" message:str preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [_preference setFirstLogin:@"N"];
    }
    
    [[ReportServiceManager sharedInstance] startReportService];
    [[EtransLocationManager sharedInstance] startBeaconScan];
    
//    [TMapTapi setSKTMapAuthenticationWithDelegate:self apiKey:TMAP_API_KEY];

    
//    // 목적지 생성
//    KNVLocation *destination = [KNVLocation locationWithName:@"카카오판교오피스"
//                                                            x:@(127.1087)
//                                                            y:@(37.40206)];
//
//    // WGS84 좌표타입 옵션 설정
//    KNVOptions *options = [KNVOptions options];
//    options.coordType = KNVCoordTypeWGS84;
//
//    KNVParams *params = [KNVParams paramWithDestination:destination options:options];
//
//    // 목적지 공유 실행
//    [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams:params completion:^(NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"failed share - error: %@", error);
//        }
//        else {
//            NSLog(@"successs share!");
//        }
//    }];
    
    
//    [self kakaoRecommend];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoLoginPage {
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?method=mainForm&jppDeviceId=%@&isLbsStartYN=%@&deviceMobileNo=%@", CONNECTION_URL, LOGIN_PATH,[ComUtil getDeviceId],[_preference getLbsStartYn],[_preference getAuthPhoneNo]]]];
    //NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CONNECTION_URL, LOGIN_PATH]]];

    [_webView loadRequest:request];
}

- (void)gotoPushRedirectPage:(NSString *)params {
    /*
    NSString *strUrl = [NSString stringWithFormat:@"%@%@%@", CONNECTION_URL, PUSH_REDIRECT_PATH, params];
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
     */
    
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"pushLink_common('%@','%@','%@','%@','%@','%@','%@','%@')", [DataSet sharedDataSet].push_seq, [DataSet sharedDataSet].push_doc_gubun, [DataSet sharedDataSet].push_type, [DataSet sharedDataSet].push_title, [DataSet sharedDataSet].push_body, [DataSet sharedDataSet].push_param, [_preference getCreationPeroid], [_preference getReportPeroid] ] completionHandler:nil];
    
    [DataSet sharedDataSet].push_title = @"";
    [DataSet sharedDataSet].push_body = @"";
    [DataSet sharedDataSet].push_type = @"";
    [DataSet sharedDataSet].push_seq = @"";
    [DataSet sharedDataSet].push_doc_gubun = @"";
    [DataSet sharedDataSet].push_param = @"";
    
    
}

- (void)closeAllModal {
    UIViewController* vc = self;

    while (vc) {
        UIViewController* temp = vc.presentingViewController;
        if (!temp.presentedViewController) {
            [vc dismissViewControllerAnimated:YES completion:^{}];
            break;
        }
        vc =  temp;
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"1. didCommitNavigation");
}
 
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"2. didFinishNavigation");
    
    [_iv_intro removeFromSuperview];
    
    NSString *urlString = webView.URL.absoluteString;
    
    if ([urlString containsString:PUSH_REDIRECT_PATH]) {
        
        NSString *script = [NSString stringWithFormat:@"pushLink('%@', '%@', '%@', '%@', '%@', '%@')", [DataSet sharedDataSet].push_seq, [DataSet sharedDataSet].push_doc_gubun, [DataSet sharedDataSet].push_type, [DataSet sharedDataSet].push_title, [DataSet sharedDataSet].push_body, [DataSet sharedDataSet].push_param];
        [webView evaluateJavaScript:script completionHandler:nil];
        
        [DataSet sharedDataSet].push_title = @"";
        [DataSet sharedDataSet].push_body = @"";
        [DataSet sharedDataSet].push_type = @"";
        [DataSet sharedDataSet].push_seq = @"";
        [DataSet sharedDataSet].push_doc_gubun = @"";
        [DataSet sharedDataSet].push_param = @"";
    } else if ([urlString containsString:MAIN_PATH]) {
//        NSString *seq = [DataSet sharedDataSet].push_seq;
//
//        if (seq != nil && seq.length > 0) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"알림" message:[DataSet sharedDataSet].push_body preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                NSString *script = [NSString stringWithFormat:@"goPush('%@')", [DataSet sharedDataSet].push_seq];
//                [webView evaluateJavaScript:script completionHandler:nil];
//
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:okAction];
//            [alert addAction:cancelAction];
//
//            [self presentViewController:alert animated:YES completion:nil];
//        }
    }
    
}
 
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"3. didFailNavigation === %@", error.localizedDescription);
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"navigationAction ==== %@", navigationAction.request.URL.absoluteString);
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"http"]) {
//    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https"]) {
        if ([navigationAction.request.URL.absoluteString hasSuffix:@"loginOut.do"]) {
            [self doLogout];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if([navigationAction.request.URL.absoluteString hasPrefix:@"tel"]) {
        NSURL *url = [NSURL URLWithString:navigationAction.request.URL.absoluteString];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        [self processUrlScheme:navigationAction.request.URL.absoluteString];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    if (!self.presentedViewController) {
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        completionHandler();
    }
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (navigationAction.targetFrame == nil) {
        _webViewtemp = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webViewtemp.UIDelegate = self;
        _webViewtemp.navigationDelegate = self;
        [self.view addSubview:_webViewtemp];
        return _webViewtemp;
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    [_webViewtemp removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[ReportServiceManager sharedInstance] stopReportService];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)processUrlScheme:(NSString *)url {
    BOOL processed = YES;
    
    if (![url hasPrefix:@"hybridapp://"]) return NO;

#if DEBUG
    NSLog(@"url scheme[%@]", url);
#endif
    
    if ([url containsString:@"hybridapp://initparam"]) {
        [self processInitParam:url];
    } else if ([url containsString:@"hybridapp://authkey="]) {
        [self urlSchemeLogin:url];
    } else if ([url containsString:@"hybridapp://loginOut"]) {
        [self doLogout];
    } else if ([url containsString:@"hybridapp://naviSet"]) {
        //네비게이션 변경됨. 01:티맵, 02:카카오맵
        [self urlSchemeNaviSet:url];
    } else if ([url containsString:@"hybridapp://clipboard"]) {
        //공유하기 클립보드에 복사됨
        [self copyToClipboard];
    } else if ([url containsString:@"hybridapp://kakaoShare"]) {
        //카카오 공유하기 선택됨
        [self kakaoRecommend];
    } else if ([url containsString:@"hybridapp://userimagesetting"]) {
       //설정: 차량등록증/사업자등록증/서명이미지 등록
        NSString *setting = [self getQueryString:url tag:@"userimagesetting"];
        [self urlSchemeImageSetting:setting];
    } else if ([url containsString:@"hybridapp://viewUrl"]) {
       //위수탁증 보기
        [self urlSchemeViewUrl:url];
    } else if ([url containsString:@"hybridapp://setAddress"]) {
        [self urlSchemeSetAddress];
    } else if ([url containsString:@"hybridapp://setAuthPhoneNo"]) {
           [self urlSchemeSetAuthPhoneNo:url];
    } else if ([url containsString:@"hybridapp://method"]) {
       
       NSString *method = [self getQueryString:url tag:@"method"];
       
       if ([method isEqualToString:@"takeSealImage"]) {
           //씰번호 촬영
           [self chooseSealSource];
       } else if ([method isEqualToString:@"takeCntrNo"]) {
           //컨번호 촬영
           NSString *photoType = [self getQueryString:url tag:@"photoType"];
           [self takePhotoContainerNumber:@"camera" photoType:photoType];
       } else if ([method isEqualToString:@"main"]) {
           //서브페이지에서 메인으로 이동할때 호출됨.
           _isMianPage = YES;
           [_preference setLoggedIn:@"Y"];
       } else if ([method isEqualToString:@"setaddr"]) {
           //도착지 설정
           [self urlSchemeSetAddr:url];
       } else if ([method isEqualToString:@"canceladdr"]) {
           //도착지 설정 취소
           [self urlSchemeCancelAddr:url];
       } else if ([method isEqualToString:@"setstatus"]) {
           //위치저장
           [self urlSchemeSetStatus:url];
       } else if ([method isEqualToString:@"setstatusdetail"]) {
           //상세
           [self urlSchemeSetStatusDetail:url];
       } else if ([method isEqualToString:@"wii"]) {
           //명세서 보기
           [self urlSchemeWii:url];
       } else if ([method isEqualToString:@"dostartinit"]) {
           //출발지 알림
           [self urlSchemeDoStartInit:url];
       } else if ([method isEqualToString:@"navistart"]) {
           //출발지 알림
           [self urlSchemeNaviStart:url];
       } else if ([method isEqualToString:@"takeReuseImage"]) {
           //복화사진 전송
           [self chooseMultiSealSource:url];
       } else if ([method isEqualToString:@"startGpsService"]) {  // asmyoung
           //gps 서비스 시작
           [self startGpsService];
       } else if ([method isEqualToString:@"stopGpsService"]) {   // asmyoung
           //gps 서비스 중지
           [self stopGpsService];
       } else if ([method isEqualToString:@"settingLocatcion"]) {   // asmyoung
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
       } else if ([method isEqualToString:@"popView"]) {   // asmyoung
           NSString *loadUrl = [self getQueryString:url tag:@"loadUrl"];
           NSString *loadTitle = [self getQueryString:url tag:@"loadTitle"];
           
           NSArray *split = [loadUrl componentsSeparatedByString:@"//"];
           
           if(split.count > 0 && ![split[0] containsString:@":"]) {
               if([split[0] isEqualToString:@"https"] || [split[0] isEqualToString:@"http"]) {
                   loadUrl = [NSString stringWithFormat:@"%@://%@", split[0], split[1]];
               }
           }
           
           //NSString *loadUrl = @"https://m.naver.com";
           //NSString *loadTitle = @"네이버";
           PopWebViewController *popWebViewController = [[PopWebViewController alloc] init];
           if (@available(iOS 13.0, *)) {
               popWebViewController.modalPresentationStyle = UIModalPresentationFullScreen;
           }
           popWebViewController.loadUrl = loadUrl;
           popWebViewController.loadTitle = loadTitle;
           [self presentViewController:popWebViewController animated:YES completion:nil];
       } else if ([method isEqualToString:@"getDeviceInfo"]) {   // asmyoung
           [self getDeviceInfo];
       } else if ([method isEqualToString:@"getUploadFile"]) {
           //씰번호 촬영
           [self chooseUploadSource];
       }
        
    } else if ([url containsString:@"hybridapp://callphone"]) {
        //hybridapp://callphone=33
        NSString *callphone = [self getQueryString:url tag:@"callphone"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", callphone]];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else if ([url containsString:@"hybridapp://pki"]) {
        NSString *sss = [url substringFromIndex:[[NSString stringWithFormat:@"hybridapp://"] length] ];
        
        NSArray *split = [sss componentsSeparatedByString:@"?"];
        
        NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
        
        if (split.count > 1)
        {
            NSArray *nvs = [[split objectAtIndex:1] componentsSeparatedByString:@"&"];
            
            for (int i = 0; i < nvs.count; i++)
            {
                NSString *nv = [nvs objectAtIndex:i];
                NSArray *nvsplit = [nv componentsSeparatedByString:@"="];
                
                NSString *name = [nvsplit objectAtIndex:0];
                NSString *value = [nvsplit objectAtIndex:1];
                
                [map setObject:value forKey:name];
            }
        }
        NSString* cmd = [map objectForKey:@"cmd"];
        if  ([cmd isEqualToString:@"getCertAuthCode"]) {
            //인증서 가져오기 인증코드 조회
            [self getCertAuthCode];
        }
        else if  ([cmd isEqualToString:@"certImport"]) {
            //인증서 가져오기
            NSString* authCode = [map objectForKey:@"authCode"];
            NSString* passwdStr = [map objectForKey:@"passwd"];

            passwdStr = [passwdStr stringByRemovingPercentEncoding];
            NSLog(@"%@", passwdStr);
            
            [self certImport:authCode passwd:passwdStr];
        }
        else if  ([cmd isEqualToString:@"getCertList"]) {
            //인증서 목록
            [self getCertList];
        }
        else if  ([cmd isEqualToString:@"getCertInfo"]) {
            //인증서 상세정보
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            
            [self getCertInfo:dnName];
        }
        else if  ([cmd isEqualToString:@"makeSignDataLogin"]) {
            //전자서명 생성
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            NSString* passwd = [map objectForKey:@"passwd"];
            passwd = [passwd stringByRemovingPercentEncoding];

            [self makeSignDataLogin:dnName passwd:passwd];
        }
        else if  ([cmd isEqualToString:@"makeSignDataPKCS7"]) {
            //전자서명 생성
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            NSString* data = [map objectForKey:@"oData"];
            data = [data stringByRemovingPercentEncoding];
            NSString* passwd = [map objectForKey:@"passwd"];
            passwd = [passwd stringByRemovingPercentEncoding];

            [self makeSignDataPKCS7:dnName data:data passwd:passwd];
        }
        else if  ([cmd isEqualToString:@"makeSignDataX509"]) {
            //전자서명 생성
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            NSString* digest = [map objectForKey:@"digest"];
            digest = [digest stringByRemovingPercentEncoding];
            NSString* passwd = [map objectForKey:@"passwd"];
            passwd = [passwd stringByRemovingPercentEncoding];
            NSString* pcsSSN = [map objectForKey:@"pcsSSN"];
            pcsSSN = [pcsSSN stringByRemovingPercentEncoding];

            [self makeSignDataX509:dnName digest:digest passwd:passwd pcsSSN:pcsSSN];
        }
        else if  ([cmd isEqualToString:@"changeCertPassword"]) {
            //인증서 비밀번호 변경
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            NSString* p = [map objectForKey:@"p"];
            p = [p stringByRemovingPercentEncoding];
            NSString* n1 = [map objectForKey:@"n1"];
            n1 = [n1 stringByRemovingPercentEncoding];
            NSString* n2 = [map objectForKey:@"n2"];
            n2 = [n2 stringByRemovingPercentEncoding];

            [self changeCertPassword:dnName p:p n1:n1 n2:n2];
        }
        else if  ([cmd isEqualToString:@"certExport"]) {
            //인증서 내보내기
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            NSString* authCode = [map objectForKey:@"authCode"];
            NSString* passwd = [map objectForKey:@"passwd"];
            passwd = [passwd stringByRemovingPercentEncoding];

            [self certExport:dnName authcode:authCode passwd:passwd];
        }
        else if  ([cmd isEqualToString:@"deleteCert"]) {
            //인증서 삭제
            NSString* dnName = [map objectForKey:@"dnName"];
            dnName = [dnName stringByRemovingPercentEncoding];
            NSLog(@"%@", dnName);
            
            NSString* passwd = [map objectForKey:@"passwd"];
            passwd = [passwd stringByRemovingPercentEncoding];

            [self deleteCert:dnName passwd:passwd];
        }
        
    } else if ([url containsString:@"hybridapp://download"]) {
        
        //hybridapp://download?url=http://...
        NSString *sss = [url substringFromIndex:[[NSString stringWithFormat:@"hybridapp://"] length] ];
        
        NSArray *split = [sss componentsSeparatedByString:@"?"];
        
        NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
        
        if (split.count > 1)
        {
            NSArray *nvs = [[split objectAtIndex:1] componentsSeparatedByString:@"&"];
            
            for (int i = 0; i < nvs.count; i++)
            {
                NSString *nv = [nvs objectAtIndex:i];
                NSArray *nvsplit = [nv componentsSeparatedByString:@"="];
                
                NSString *name = [nvsplit objectAtIndex:0];
                NSString *value = [nvsplit objectAtIndex:1];
                
                [map setObject:value forKey:name];
            }
        }
        NSString* download_url = [map objectForKey:@"url"];
        download_url = [download_url stringByRemovingPercentEncoding];
            
        [self download:download_url];
        
    }
    
    
    return processed;
}


#pragma mark - Schema Link Process Functions For Webview

- (NSString *)getQueryString:(NSString *)url tag:(NSString *)tag {
    NSString *strResult = @"";
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *url2 = [url stringByReplacingOccurrencesOfString:@"hybridapp://" withString:@""];
    NSArray *urlComponents = [url2 componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = @"";
        NSString *value = @"";
        
        if (pairComponents.count == 2) {
            key = [pairComponents[0] stringByRemovingPercentEncoding];
            value = [pairComponents[1] stringByRemovingPercentEncoding];
        } else if (pairComponents.count == 3) {
            key = [pairComponents[0] stringByRemovingPercentEncoding];
            value = [NSString stringWithFormat:@"%@=%@", pairComponents[1], pairComponents[2]];
        }
        
        [queryStringDictionary setObject:value forKey:key];
    }
    
    if ([queryStringDictionary objectForKey:tag]) {
        strResult = [queryStringDictionary objectForKey:tag];
    }
    
//    NSArray * queryItems = [[[NSURLComponents alloc] initWithString:url] queryItems];
//
//    for (NSURLQueryItem *item in queryItems) {
//        if ([tag isEqualToString:item.name]) {
//            strResult = item.value;
//            break;
//        }
//    }
    
    return strResult;
}

- (NSString *)removeUrlPath:(NSString *)url {
    NSArray *params = [url componentsSeparatedByString:@"?"];
    if (params.count == 2) {
        return params[1];
    }
    return url;
}


- (void)processInitParam:(NSString *)url {
    NSString *webVer = [self getQueryString:url tag:@"webVer"];
    NSString *isAutoLogin = [_preference getAutoLogin];
    NSString *authKey = [_preference getAuthKey];
    NSString *mobileNo = [_preference getAuthPhoneNo];//@"01023427113"; //
    
    //smartest 로컬기기 강제 번호 부여, 운영반영시 반드시 주석처리
    //mobileNo = @"01023427113";
    //[_preference setAuthPhoneNo:@"01023427113"]; [_preference getAuthPhoneNo];//
    //여기까지 주석
    
    NSString *osVer = [ComUtil getOSVer];
    NSString *model = [ComUtil getPhoneModel];
    NSString *appVer = [ComUtil getAppVer];
    NSString *mac_addr = [ComUtil getMacAddress];
    
    [DataSet sharedDataSet].g_fcUserId = mobileNo;
    
    //자동로그인일 경우, 1.authkey 를 읽어들인 후 로그인
    NSString *initparam = @"";
    
    if(mobileNo==nil || [mobileNo isEqualToString:@""]) {
        //ios인 경우 phoneNo없으므로 휴대폰인증화면 로딩
        //[_webView evaluateJavaScript:@"javascript:membershipRegister('')" completionHandler:nil];
        [_webView evaluateJavaScript:@"javascript:needPhoneAuthenticate();" completionHandler:nil];
        return;
    }
    
    if ([isAutoLogin isEqualToString:@"Y"] && ![authKey isEqualToString:@""]) {
        initparam = [NSString stringWithFormat:@"initparam_new('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", mobileNo, authKey, isAutoLogin, osVer, model, appVer, mac_addr, @"", osVer, [ComUtil getDownGB], [_preference getAgreeType], [_preference getGpsAgreeYn], mobileNo, [_preference getFirstLogin], @"", [ComUtil getDeviceId]];
        

    } else {
        //일반 로그인
        initparam = [NSString stringWithFormat:@"initparam_new('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", mobileNo, @"", @"N", osVer, model, appVer, mac_addr, @"", osVer, [ComUtil getDownGB], [_preference getAgreeType], [_preference getGpsAgreeYn], mobileNo, [_preference getFirstLogin], @"", [ComUtil getDeviceId]];

    }
    
    [_webView evaluateJavaScript:initparam completionHandler:^(NSString *result, NSError *error){
        NSLog(@"evaluateJavaScript Error %@", error);
        NSLog(@"evaluateJavaScript Result %@", result);
    }];
}

- (void)urlSchemeLogin:(NSString *)url {
    //2020.5.18 로그인 완료되면, 자동로그인 여부와 authkey값이 전달된다
    [_preference setLoggedIn:@"Y"];
    
    //TO-DO 로그인이 완료되면 위치정보 보고용 서비스 시작
    
    NSString *webVer = [self getQueryString:url tag:@"webVer"];
    //webVer = @"1.1";
    
    NSString *carrierCd = [self getQueryString:url tag:@"carrierCd"];
    NSString *collectTerm = [self getQueryString:url tag:@"collectTerm"];
    NSString *sendTerm = [self getQueryString:url tag:@"sendTerm"];
    NSString *restFlag = [self getQueryString:url tag:@"restFlag"];
    NSString *chassisNo = [self getQueryString:url tag:@"chassisNo"];
    NSString *carCd = [self getQueryString:url tag:@"carCd"];
    NSString *ttsSet = [self getQueryString:url tag:@"ttsSet"];
    
    [_preference setCarCd:carCd];
    [_preference setVehicleId:carCd];
    [_preference setCarrierId:carrierCd];
    [_preference setReportPeroid:sendTerm];
    [_preference setCreationPeroid:collectTerm];
    [_preference setRestFlag:restFlag];
    [_preference setChassisNo:chassisNo];
    [_preference setTTS:ttsSet];
    
    NSString *isAutoLogin = [self getQueryString:url tag:@"isAutoLogin"];
    
    NSString *authKey = @"";
    
    if (isAutoLogin != nil) {
        [_preference setAutoLogin:isAutoLogin];
        authKey = [self getQueryString:url tag:@"authkey"];
        
        if ([isAutoLogin isEqualToString:@"Y"]) {
            if (authKey != nil && authKey.length > 0) {
                [_preference setAuthKey:authKey];
            }
        } else {
            [_preference setAuthKey:@""];
        }
    } else {
        [_preference setAutoLogin:@""];
        [_preference setAuthKey:@""];
    }
    
    if (webVer != nil && webVer.length > 0) {
        NSString *pushToken = [_preference getPushToken];
        
        [_webView evaluateJavaScript:@"setJPPMobileAppId('ETDRIVING')" completionHandler:nil];
        [_webView evaluateJavaScript:@"setJPPDeviceOs('fcm_and')" completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPDeviceId('%@')", [ComUtil getDeviceId]] completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPToken('%@')", pushToken] completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPUserId('%@')", [DataSet sharedDataSet].g_fcUserId] completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPPushUrl('%@')", PUSH_URL] completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPModelName('%@')", [ComUtil getPhoneModel]] completionHandler:nil];
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"setJPPDeviceOsVersion('%@')", [ComUtil getOSVer]] completionHandler:nil];
        [_webView evaluateJavaScript:@"setPush('Y')" completionHandler:nil];
    } else {
        [_webView evaluateJavaScript:@"goMain()" completionHandler:nil];
    }
    
    [self pushCheck];
}

- (void)urlSchemeSetAuthPhoneNo:(NSString *)url {
    //2020.5.18 로그인 완료되면, 자동로그인 여부와 authkey값이 전달된다
    NSString *url2 = [url stringByReplacingOccurrencesOfString:@"hybridapp://setAuthPhoneNo?" withString:@""];
    
    NSString *phoneNo = [self getQueryString:url2 tag:@"phoneNo"];
    [_preference setAuthPhoneNo:phoneNo];
    
    [self gotoLoginPage];
}

- (void)takePhotoContainerNumber:(NSString *)photoForm photoType:(NSString *)photoType {
    
    if([photoType isEqualToString:@"2"]) {
        if ([photoForm isEqualToString:@"camera"]) {
            
            AVCamCameraViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"AVCamCameraViewController"];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
            
        } else if ([photoForm isEqualToString:@"gallery"]) {
            
        }
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;

        if ([photoForm isEqualToString:@"camera"]) {
            _request_type = CONTAINER_NO_FROM_CAMERA_REQUEST;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if ([photoForm isEqualToString:@"gallary"]) {

        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)chooseSealSource {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"씰번호 선택" message:@"수단을 선택해주세요." preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoSealNumber:@"camera"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoSealNumber:@"gallary"];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)chooseMultiSealSource:(NSString *)url {
    NSString *maxcount = [self getQueryString:url tag:@"maxcount"];
    _maxImageCount = maxcount.integerValue;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"사진 선택" message:@"수단을 선택해주세요." preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoSealNumber:@"camera_multi"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoSealNumber:@"gallary_multi"];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)takePhotoSealNumber:(NSString *)type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    if ([type isEqualToString:@"camera"]) {
        _request_type = SEAL_NO_FROM_CAMERA_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([type isEqualToString:@"gallary"]) {
        _request_type = SEAL_NO_FROM_GALLERY_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([type isEqualToString:@"camera_multi"]) {
        _request_type = MULTI_CONTAINER_NO_FROM_CAMERA_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([type isEqualToString:@"gallary_multi"]) {
        _request_type = MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)sealNoToServer:(UIImage *)image from:(enum REQUEST_TYPE)from {
    @try {
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64];
        
//        CLLocationManager *locationManager = [EtransLocationManager sharedInstance].locationManager;
//        CGFloat x = locationManager.location.coordinate.latitude;
//        CGFloat y = locationManager.location.coordinate.longitude;
        NSString *script = @"";
        if([CLLocationManager locationServicesEnabled]) {
            if (_locationManager == nil) {
                _locationManager = [[CLLocationManager alloc] init];
            }
                _locationManager.delegate = self;
            CLLocation *location = [_locationManager location];
            [_locationManager startUpdatingLocation];
            CGFloat x = location.coordinate.latitude;
            CGFloat y = location.coordinate.longitude;
            script = [NSString stringWithFormat:@"addSealImage_loc('%@', '%f', '%f', 'G')", imageParam, y, x];
        } else {
            script = [NSString stringWithFormat:@"addSealImage_loc('%@', 'x', 'x', 'G')", imageParam];
        }
        
        
        if (from == SEAL_NO_FROM_GALLERY_REQUEST) {
            script = [NSString stringWithFormat:@"addSealImage_loc('%@', '', '', 'G')", imageParam];
        }
        
        [_webView evaluateJavaScript:script completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"addSealImage_loc('', '', '', '')" completionHandler:nil];
    }
}

- (void)multiContainerNoToServer:(UIImage *)image from:(enum REQUEST_TYPE)from {
    @try {
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64];
        
        if (_multiContainerImageArray.count < _maxImageCount) {
            [_multiContainerImageArray addObject:imageParam];
        }
        
//        CLLocationManager *locationManager = [EtransLocationManager sharedInstance].locationManager;
//        CGFloat x = locationManager.location.coordinate.latitude;
//        CGFloat y = locationManager.location.coordinate.longitude;
        
        NSString *script = @"";
        
        if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
            script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@')", imageParam];
        } else {
            
            if([CLLocationManager locationServicesEnabled]) {
                if (_locationManager == nil) {
                    _locationManager = [[CLLocationManager alloc] init];
                }
                    _locationManager.delegate = self;
                CLLocation *location = [_locationManager location];
                [_locationManager startUpdatingLocation];
                CGFloat x = location.coordinate.latitude;
                CGFloat y = location.coordinate.longitude;
                script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@')", y, x, imageParam];
            } else {
                script = [NSString stringWithFormat:@"addReuseImage_loc('x', 'x', 'G', '%@')", imageParam];
            }
            
            
        }
        /*
        switch (_multiContainerImageArray.count) {
            case 1:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@')", _multiContainerImageArray[0]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@')", x, y, _multiContainerImageArray[0]];
                }
                break;
            case 2:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@', '%@')", _multiContainerImageArray[0], _multiContainerImageArray[1]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@', '%@')", x, y, _multiContainerImageArray[0], _multiContainerImageArray[1]];
                }
                break;
            case 3:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@', '%@', '%@')", _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@', '%@', '%@')", x, y, _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2]];
                }
                break;
            case 4:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@', '%@', '%@', '%@')", _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@', '%@', '%@', '%@')", x, y, _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3]];
                }
                break;
            case 5:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@', '%@', '%@', '%@', '%@')", _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3], _multiContainerImageArray[4]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@', '%@', '%@', '%@', '%@')", x, y, _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3], _multiContainerImageArray[4]];
                }
                break;
            case 6:
                if (from == MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST) {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('', '', 'G', '%@', '%@', '%@', '%@', '%@', '%@')", _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3], _multiContainerImageArray[4], _multiContainerImageArray[5]];
                } else {
                    script = [NSString stringWithFormat:@"addReuseImage_loc('%f', '%f', 'G', '%@', '%@', '%@', '%@', '%@', '%@')", x, y, _multiContainerImageArray[0], _multiContainerImageArray[1], _multiContainerImageArray[2], _multiContainerImageArray[3], _multiContainerImageArray[4], _multiContainerImageArray[5]];
                }
                break;
            default:
                break;
        }
        */
        [_webView evaluateJavaScript:script completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"addReuseImage_loc('', '', '', '')" completionHandler:nil];
    }
}

- (void)imageDataToServer:(UIImage *)image dataType:(NSString *)dataType {
    @try {
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64];
        
        NSString *script = [NSString stringWithFormat:@"dataUpdate('%@', '%@')", dataType, imageParam];
        [_webView evaluateJavaScript:script completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"dataUpdate('%@', '%@')", dataType, @"{}"] completionHandler:nil];
    }
}

- (void)sendSignImage:(NSNotification *)notification {
    
    UIImage *image = [notification.userInfo objectForKey:@"signImage"];
    NSString *dataType = @"sign";
    
    @try {
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpeg;base64,", base64];
        
        NSString *script = [NSString stringWithFormat:@"dataUpdate('%@', '%@')", dataType, imageParam];
        [_webView evaluateJavaScript:script completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"dataUpdate('%@', '%@')", dataType, @"{}"] completionHandler:nil];
    }
}

- (void)copyToClipboard {
    //http://play.google.com/store/apps/details?id=kr.co.klnet.aos.etransdriving
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"https://apps.apple.com/kr/app/%EC%9D%B4%ED%8A%B8%EB%9E%9C%EC%8A%A4-%EB%93%9C%EB%9D%BC%EC%9D%B4%EB%B9%99-etrans-driving/id1528668982";
    
    [ComUtil showAlert:self title:@"알림" message:@"URL 복사가 완료되었습니다."];
}

- (void)urlSchemeWii:(NSString *)urlscheme {
    //hybridapp://method=wii&accountGrpCd=18&billNo=B180829217352&orgReadStatus=1&carCd=%EC%84%9C%EC%9A%B880%EA%B0%803366&adjustDtView=2018-08-29&carrierNm=%EC%9A%B4%EC%86%A1%EC%82%AC_C1
    NSString *accountGrpCd = [self getQueryString:urlscheme tag:@"accountGrpCd"];
    NSString *billNo = [self getQueryString:urlscheme tag:@"billNo"];
    NSString *orgReadStatus = [self getQueryString:urlscheme tag:@"orgReadStatus"];
    NSString *carCd = [self getQueryString:urlscheme tag:@"carCd"];
    NSString *adjustDtView = [self getQueryString:urlscheme tag:@"adjustDtView"];
    NSString *carrierNm = [self getQueryString:urlscheme tag:@"carrierNm"];
    
    NSString *str = [adjustDtView stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str1 = [str substringWithRange:NSMakeRange(2, 2)];
    NSString *str2 = [str substringWithRange:NSMakeRange(4, 2)];
    NSString *str3 = [carCd substringFromIndex:carrierNm.length - 4];
    
    NSString *fileNm = [NSString stringWithFormat:@"%@-%@_%@_%@", str1, str2, str3, carrierNm];
    //NSString *url = [NSString stringWithFormat:@"%@/mi330U/etruckbank/jsp/", DOC_CONNECTION_URL];
    NSString *url = [NSString stringWithFormat:@"%@/etdriving/dispatch/", CONNECTION_URL];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:url forKey:@"url"];
    [dic setValue:orgReadStatus forKey:@"supplierReadStatus"];
    [dic setValue:orgReadStatus forKey:@"orgReadStatus"];
    [dic setValue:billNo forKey:@"billNo"];
    [dic setValue:accountGrpCd forKey:@"accountGrpCd"];
    [dic setValue:carCd forKey:@"carCd"];
    [dic setValue:@"reportMobilePayPrint" forKey:@"reportNm"];
    [dic setValue:fileNm forKey:@"fileNm"];
    [dic setValue:adjustDtView forKey:@"adjustDtView"];
    
    WebViewContainerViewController *webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewContainerViewController"];
    if (webViewController) {
        webViewController.webViewURL = [ComUtil makeReportUrl:dic];
        webViewController.webViewFilePath = [ComUtil nullConvert:[dic valueForKey:@"filePath"]];
        webViewController.webViewFileNm = [ComUtil nullConvert:[dic valueForKey:@"fileNm"]];
//        [webViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:webViewController animated:YES completion:nil];
        
        //startActivityForResult(i, HANDLER_SEARCH_SALE_LIST);
    }
}

- (void)urlSchemeViewUrl:(NSString *)url {
    //"hybridapp://viewUrl=/mi330U/etruckbank/jsp/reportWiSutakPrint.jsp?dispatchNo='200608566696'"
    NSString *viewUrl = [self getQueryString:url tag:@"viewUrl"];
    if (viewUrl != nil && viewUrl.length > 0) {
        NSString *params = [self removeUrlPath:viewUrl];
        NSString *dispatchNo = [self getQueryString:params tag:@"dispatchNo"];
        dispatchNo = [dispatchNo stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [ComUtil setOnWisutakView:self viewUrl:viewUrl fileName:dispatchNo];
    }
}

- (void)urlSchemeNaviSet:(NSString *)url {
    NSString *naviType = [self getQueryString:url tag:@"naviSet"];
    [_preference setNavigationType:naviType];
}

- (void)urlSchemeImageSetting:(NSString *)setting {
    if ([@"car" isEqualToString:setting]) {
        [self requestGalleryImage:CAR_BIZ_CD_FROM_GALLERY_REQUEST];
    } else if ([@"biz" isEqualToString:setting]) {
        [self requestGalleryImage:BIZ_CD_FROM_GALLERY_REQUEST];
    } else if ([@"sign" isEqualToString:setting]) {
        SignViewController *signViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignViewController"];
        [signViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:signViewController animated:YES completion:nil];
    }
}

- (void)requestGalleryImage:(enum REQUEST_TYPE)requestType {
    _request_type = requestType;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (void)doLogout {
    //TO-DO 서비스 중지
    
    [_preference setLoggedIn:@"N"];
    [_preference setAuthKey:@""];
    [_preference setAutoLogin:@"N"];
    
}

- (void)urlSchemeSetAddress {
    if([CLLocationManager locationServicesEnabled]) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
        }
            _locationManager.delegate = self;
        CLLocation *location = [_locationManager location];
        [_locationManager startUpdatingLocation];
        NSString *script = [NSString stringWithFormat:@"getAddress('%f', '%f')", location.coordinate.longitude, location.coordinate.latitude];
        [self.webView evaluateJavaScript:script completionHandler: nil];
    } else {
        NSString *script = [NSString stringWithFormat:@"getAddress('x', 'x')"];
        [self.webView evaluateJavaScript:script completionHandler: nil];
    }
}

- (void)urlSchemeSetAddr:(NSString *)url {
    NSString *idx = [self getQueryString:url tag:@"idx"];
    NSString *addrType = [self getQueryString:url tag:@"addrType"];
    
    CLLocation *location = [_locationManager location];
    NSString *script = [NSString stringWithFormat:@"setAddr('%@', '%@', '%f', '%f', '%@')", addrType, idx, location.coordinate.longitude, location.coordinate.latitude, @"G"];
    [self.webView evaluateJavaScript:script completionHandler: nil];
}

- (void)urlSchemeCancelAddr:(NSString *)url {
    NSString *idx = [self getQueryString:url tag:@"idx"];
    NSString *addrType = [self getQueryString:url tag:@"addrType"];
    
    CLLocation *location = [_locationManager location];
    NSString *script = [NSString stringWithFormat:@"cancelAddr('%@', '%@', '%f', '%f', '%@')", addrType, idx, location.coordinate.longitude, location.coordinate.latitude, @"G"];
    [self.webView evaluateJavaScript:script completionHandler: nil];
}

- (void)urlSchemeSetStatus:(NSString *)url {
    NSString *idx = [self getQueryString:url tag:@"idx"];
    
    CLLocation *location = [_locationManager location];
    NSString *script = [NSString stringWithFormat:@"setStatus('%@', '%f', '%f', '%@')", idx, location.coordinate.longitude, location.coordinate.latitude, @"gps"];
    [self.webView evaluateJavaScript:script completionHandler: nil];
}

- (void)urlSchemeSetStatusDetail:(NSString *)url {
    CLLocation *location = [_locationManager location];
    NSString *script = [NSString stringWithFormat:@"setStatusDetail('%f', '%f', '%@')", location.coordinate.longitude, location.coordinate.latitude, @"G"];
    [self.webView evaluateJavaScript:script completionHandler: nil];
}

- (void)urlSchemeDoStartInit:(NSString *)url {
    NSString *type = [self getQueryString:url tag:@"type"];
    NSString *bluetooth = [self getQueryString:url tag:@"bluetooth"];
    
    CLLocation *location = [_locationManager location];
    
    NSString *script = @"";
    if ([@"start" isEqualToString:type]) {
        script = [NSString stringWithFormat:@"fn_doStart('%f', '%f', '%@')", location.coordinate.longitude, location.coordinate.latitude, @"G"];
    } else if ([@"end" isEqualToString:type]) {
        script = [NSString stringWithFormat:@"fn_doEnd('%f', '%f', '%@')", location.coordinate.longitude, location.coordinate.latitude, @"G"];
    }
    
    [self.webView evaluateJavaScript:script completionHandler: nil];
    
    if (bluetooth != nil && [bluetooth isEqualToString:@"Y"]) {
        
        _bIsDostartinit = YES;
        
//        BluetoothState state = [MinewBeaconManager sharedInstance].bluetoothState;
        
        if ([EtransLocationManager sharedInstance].isOnBluetooth == NO) {
            [[CBCentralManager alloc] initWithDelegate:self
                                                                               queue:dispatch_get_main_queue()
                                                                             options:
                                           [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                                       forKey:CBCentralManagerOptionShowPowerAlertKey]];
            
            return;
        }
        
        CBManagerAuthorization a = _cManager.authorization;
        
        if (a == CBManagerAuthorizationDenied) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"] options:@{} completionHandler:nil];
            
            return;
        } else if (a == CBManagerAuthorizationRestricted) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"] options:@{} completionHandler:nil];
            
            return;
        } else if (a == CBManagerAuthorizationNotDetermined) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"] options:@{} completionHandler:nil];
            
            return;
        } else if (a == CBManagerAuthorizationAllowedAlways) {
            
        }
    }
    
}


- (void)urlSchemeNaviStart:(NSString *)url {
    
    _urlForNavi = url;
    
    NSString *x = [self getQueryString:_urlForNavi tag:@"wgs84X"];
    NSString *y = [self getQueryString:_urlForNavi tag:@"wgs84Y"];
    NSString *goalName = @"목적지";
    
    if ([@"01" isEqualToString:[_preference getNavigationType]]) {
        
        [TMapTapi setSKTMapAuthenticationWithDelegate:self apiKey:TMAP_API_KEY];
        
    } else {
        
        if ([KNVNaviLauncher sharedLauncher].canOpenKakaoNavi) {
            // WGS84 좌표타입 옵션 설정
            KNVOptions *options = [KNVOptions options];
            options.coordType = KNVCoordTypeWGS84;
            
            KNVLocation *destination = [KNVLocation locationWithName:goalName
                                                                   x:[NSNumber numberWithDouble:x.doubleValue]
                                                                   y:[NSNumber numberWithDouble:y.doubleValue]];
            KNVParams *params = [KNVParams paramWithDestination:destination options:options];
            
            [[KNVNaviLauncher sharedLauncher] navigateWithParams:params completion:^(NSError * error){
                NSLog(@"KNVNaviLauncher Error : %@", error.localizedDescription);
            }];
        } else {
            NSURL *url = [KNVNaviLauncher appStoreURL];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
    }
}

- (void)kakaoRecommend {
//    NSString *str = [NSString stringWithFormat:@"http://www.etruckbank.co.kr/apk/acon.jsp?app=%@",[[_preference getAuthPhoneNo] encryptWithKey:@"abcdefghijklmnop"]];
    NSString *str = @"https://apps.apple.com/kr/app/이트랜스-드라이빙-etrans-driving/id1528668982";
//    str = [str stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet];
//    [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:[NSURL URLWithString:str] success:nil failure:nil];
//    NSString *sendUrl = [NSString stringWithFormat:@"kakaolink://sendurl?msg=%@&url=%@&appid=%@&appver=%@&appname=%@&encoding=UTF-8", str, @"스마트폰 어플에서 제공하는 코피노결과 자동 조회를 추천합니다. 아래의 주소를 클릭하시고, 설치 후 사용하세요.", @"kr.co.klnet.ios.etransdriving", @"1.0", @"이트럭드라이빙"];
    
//    KMTTemplate *template = [KMTTextTemplate textTemplateWithBuilderBlock:^(KMTTextTemplateBuilder * _Nonnull textTemplateBuilder) {
//
//        // text
//        textTemplateBuilder.text = @"스마트폰 어플에서 제공하는 코피노결과 자동 조회를 추천합니다. 아래의 주소를 클릭하시고, 설치 후 사용하세요.";
//
//        // link
//        KMTLinkObject* linkObject = [self getKMTLinkObject:str];
//        textTemplateBuilder.link = linkObject;
//
//        // buttons
//        [self addButtonsArray:@[@{@"title":@"설치하기", @"link":str}] templateBuilder:textTemplateBuilder];
//
//        // buttonTitle
//        textTemplateBuilder.buttonTitle = @"이트럭드라이빙";
//
//    }];
    
    KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {

        // 콘텐츠
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"이트럭드라이빙";
            contentBuilder.imageURL = [NSURL URLWithString:@""];
            contentBuilder.desc = @"스마트폰 어플에서 제공하는 코피노결과 자동 조회를 추천합니다. 아래의 주소를 클릭하시고, 설치 후 사용하세요.";
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:str];
            }];
        }];

        // 버튼
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"설치하기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:str];
            }];
        }]];
    }];
//
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary *warningMsg, NSDictionary *argumentMsg){
        // 성공
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
    } failure:^(NSError *error){
        // 실패
        NSLog(@"error: %@", error);
    }];
    
}

- (void)addButtonsArray:(NSArray *)object templateBuilder:(NSObject *)templateBuilder {
    if(object == NULL){
        return;
    }
    NSArray* buttons = object;
    if([buttons count] < 1){
        return;
    }
    
    for (int i=0; i<[buttons count]; i++) {
        KMTButtonObject* feedButtonObject = [self getKMTButtonObject:buttons[i]];
        if(feedButtonObject != NULL){
            if ([templateBuilder isKindOfClass:[KMTFeedTemplateBuilder class]]){
                [((KMTFeedTemplateBuilder*)templateBuilder) addButton: feedButtonObject];
            }else if ([templateBuilder isKindOfClass:[KMTListTemplateBuilder class]]){
                [((KMTListTemplateBuilder*)templateBuilder) addButton: feedButtonObject];
            }else if ([templateBuilder isKindOfClass:[KMTCommerceTemplateBuilder class]]){
                [((KMTCommerceTemplateBuilder*)templateBuilder) addButton: feedButtonObject];
            }else if ([templateBuilder isKindOfClass:[KMTLocationTemplateBuilder class]]){
                [((KMTLocationTemplateBuilder*)templateBuilder) addButton: feedButtonObject];
            }else if ([templateBuilder isKindOfClass:[KMTTextTemplateBuilder class]]){
                [((KMTTextTemplateBuilder*)templateBuilder) addButton: feedButtonObject];
            }
        }
    }
}

- (KMTButtonObject *)getKMTButtonObject:(NSDictionary *)object {
    if(object == NULL){
        return NULL;
    }
    return [KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
        buttonBuilder.title = object[@"title"];
        KMTLinkObject* linkObject = [self getKMTLinkObject:object[@"link"]];
        if(linkObject != NULL){
            buttonBuilder.link = linkObject;
        }
    }];
}
- (KMTLinkObject *)getKMTLinkObject:(NSString *)url {
    if(url == NULL){
        return NULL;
    }
    return [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
        NSString *webURL = url;
        NSString *mobileWebURL = url;
        NSString *androidExecutionParams = nil;
        NSString *iosExecutionParams = nil;
        if(webURL != NULL){
            linkBuilder.webURL = [NSURL URLWithString:webURL];
        }
        if(mobileWebURL != NULL){
            linkBuilder.mobileWebURL = [NSURL URLWithString:mobileWebURL];
        }
        if(androidExecutionParams != NULL){
            linkBuilder.androidExecutionParams = androidExecutionParams;
        }
        if(iosExecutionParams != NULL){
            linkBuilder.iosExecutionParams = iosExecutionParams;
        }
    }];
}

//asmyoung
-(void)startGpsService {
    @try {
        if([CLLocationManager locationServicesEnabled]) {
            [[ReportServiceManager sharedInstance] startReportService];
            [[EtransLocationManager sharedInstance] startBeaconScan];
            [[EtransLocationManager sharedInstance] startLocationManager];
            [_webView evaluateJavaScript:@"javascript:startGpsResult('Y');" completionHandler:nil];
        } else {
            [_webView evaluateJavaScript:@"javascript:startGpsResult('N');" completionHandler:nil];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"알림" message:@"위치 서비스를 사용할 수 없습니다. 환경설정을 확인하시기 바랍니다." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                [self->_webView evaluateJavaScript:@"javascript:startGpsResult('N');" completionHandler:nil];
//            }];
//            [alert addAction:okAction];
//            [self presentViewController:alert animated:YES completion:nil];
        }
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"javascript:startGpsResult('N');" completionHandler:nil];
    }
}

//asmyoung
-(void)stopGpsService {
    @try {
        [[ReportServiceManager sharedInstance] stopReportService];
        [[EtransLocationManager sharedInstance] stopBeaconScan];
        [[EtransLocationManager sharedInstance] stopLocationManager];
        [self->_webView evaluateJavaScript:@"javascript:stopGpsResult('Y');" completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"javascript:stopGpsResult('N');" completionHandler:nil];
    }
}

-(void)getDeviceInfo {
    @try {

        NSString *deviceId = [ComUtil getDeviceId];
        NSString *version = [ComUtil getOSVer];
        NSString *autoLoginYn = [_preference getAutoLogin];

        NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
        [ret setObject:deviceId forKey:@"deviceId"];
        [ret setObject:version forKey:@"version"];
        [ret setObject:autoLoginYn forKey:@"autoLoginYn"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getDeviceInfoCallback('%@');", jsonString] completionHandler:nil];
                
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"javascript:fn_getDeviceInfoCallbackFail('오류가 발생하였습니다.');" completionHandler:nil];
    }
}


- (void)getCertAuthCode {
    
    if([self.transmitCertServerObj getAuthCode] == NO)
    {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertAuthCodeCallbackFail('%@');", [self.transmitCertServerObj getErrorMessage]] completionHandler:nil];

        //fn_getCertAuthCodeCallback
        
        return;
    }
    
    // 성공
    NSString* authcode = [self.transmitCertServerObj authCode];
    NSLog(@"AuthCode %@\n", authcode);
    
    NSRange range;
    range.length = 4;
    range.location = 0;
    
    NSString* num1 = [authcode substringWithRange:range];
    
    range.location = 4;
    NSString* num2 = [authcode substringWithRange:range];
    
    range.location = 8;
    NSString* num3 = [authcode substringWithRange:range];
    
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertAuthCodeCallback('%@', '%@', '%@');", num1, num2, num3] completionHandler:nil];
}

- (void)certImport:(NSString*)authCode passwd:(NSString*)passwdStr {
    BOOL bRes = [self.transmitCertServerObj getCertFromServer];
    if (bRes == YES)
    {
        //성공
    }
    else
    {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certImportCallbackFail('%@');", @"PC에서 인증서 내보내기가 완료되지 않았습니다. STEP1~4 진행 후 비밀번호를 입력해주세요."] completionHandler:nil];
        return;
    }
    
    // 암호를 대입한다.
    BOOL isSuccess = YES;
    self.transmitCertServerObj.PWD = passwdStr;
    
    if(keychainSwitch) {
        isSuccess = [self.transmitCertServerObj saveCertWithKeychain:self.transmitCertServerObj.pkcs12 accessGroup:accessGroup];
    }
    else {
        isSuccess = [self.transmitCertServerObj saveCert:self.transmitCertServerObj.pkcs12];
    }
    
    if (isSuccess)
    {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certImportCallback('%@');", @"인증서 복사에 성공하였습니다."] completionHandler:nil];
            
    }
    else
    {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certImportCallbackFail('%@');", @"인증서 비밀번호가 올바르지 않습니다. 확인하고 다시 입력해주세요."] completionHandler:nil];
    }
}

- (void)getCertList {
    _selectRow = -1;
    
    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertListCallbackFail('%@');", @"현재 등록된 인증서가 없습니다. 인증서 가져오기 메뉴에서 인증서를 등록 후 사용하세요."] completionHandler:nil];
    } else {
        
        NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
        NSMutableArray* jlist = [[NSMutableArray alloc] init];

        for (int i = 0; i < [_certInfo certCount]; i++) {
            NSInteger row = i;
            
            NSMutableDictionary* tempCertInfo = nil;
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:row getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:row getValue:&tempCertInfo];
            }
            
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item setObject:[tempCertInfo objectForKey:@"certCN"] forKey:@"name"];
            [item setObject:[tempCertInfo objectForKey:@"certDN"] forKey:@"dnName"];
            [item setObject:[tempCertInfo objectForKey:@"certIssuer"] forKey:@"certOrg"];
            [item setObject:[tempCertInfo objectForKey:@"certToDate"] forKey:@"lastDate"];
            NSString* certPolicy = (NSString*)[tempCertInfo objectForKey:@"certPolicy"];
            NSString* certUsage = [self getCertUsage:certPolicy];
            [item setObject:certUsage forKey:@"usageToName"];
            [item setObject:certPolicy forKey:@"oid"];
            [jlist addObject:item];
        }
        [ret setObject:jlist forKey:@"certList"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertListCallback('%@');", jsonString] completionHandler:nil];
        
    }
    
}

- (NSString*) getCertUsage:(NSString*)certOID {
    if ([certOID isEqualToString:@"1.2.410.200004.5.2.1.1"] == YES
        || [certOID isEqualToString:@"1.2.410.200004.5.1.1.7"] == YES
        || [certOID isEqualToString:@"1.2.410.200005.1.1.5"] == YES
        || [certOID isEqualToString:@"1.2.410.200004.5.4.1.2"] == YES
        || [certOID isEqualToString:@"1.2.410.200012.1.1.3"] == YES ) {
        return @"사업자(범용)";
    } else if ([certOID isEqualToString:@"1.2.410.200004.5.2.1.2"] == YES
           || [certOID isEqualToString:@"1.2.410.200004.5.1.1.5"] == YES
           || [certOID isEqualToString:@"1.2.410.200005.1.1.1"] == YES
           || [certOID isEqualToString:@"1.2.410.200004.5.4.1.1"] == YES
           || [certOID isEqualToString:@"1.2.410.200012.1.1.1"] == YES ) {
        return @"개인(범용)";
    } else {
        return @"용도제한";
    }
}

- (void)getCertInfo:(NSString*) dnName {
    _selectRow = -1;
    
    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertInfoCallbackFail('%@');", @"현재 등록된 인증서가 없습니다. 인증서 가져오기 메뉴에서 인증서를 등록 후 사용하세요."] completionHandler:nil];
    } else {
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];

        for (int i = 0; i < [_certInfo certCount]; i++) {
            NSInteger row = i;
            
            NSMutableDictionary* tempCertInfo = nil;
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:row getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:row getValue:&tempCertInfo];
            }
            
            if ([dnName isEqualToString:[tempCertInfo objectForKey:@"certDN"]]) {
                [item setObject:[tempCertInfo objectForKey:@"certCN"] forKey:@"name"];
                [item setObject:[tempCertInfo objectForKey:@"certDN"] forKey:@"dnName"];
                [item setObject:[tempCertInfo objectForKey:@"certIssuer"] forKey:@"certOrg"];
                [item setObject:[tempCertInfo objectForKey:@"certToDate"] forKey:@"lastDate"];
                NSString* certPolicy = (NSString*)[tempCertInfo objectForKey:@"certPolicy"];
                NSString* certUsage = [self getCertUsage:certPolicy];
                [item setObject:certUsage forKey:@"usageToName"];
                [item setObject:certPolicy forKey:@"oid"];
                
                
                break;
            }
        }
        if ([item objectForKey:@"lastDate"] != nil) {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertInfoCallback('%@');", jsonString] completionHandler:nil];

        } else {
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getCertInfoCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];

        }
        
    }
    
}

- (void)makeSignDataLogin:(NSString*) dnName passwd:(NSString*)passwd {
    _selectRow = -1;
    
    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];
    } else {
        
        int iRes = 0;
        NSString* msg = nil;

        NSString *selectDN = dnName;
        
        // 1. 인증서 존재
        NSData *signKey = nil;
        NSData *signCert = nil;
        NSData *kmKey =nil;
        NSData *kmCert = nil;
        
        if(keychainSwitch) {
            iRes = [KC_Save readUserAllFromKeychain:selectDN
                                        aSignPrikey:&signKey
                                          aSignCert:&signCert
                                          aKMPrikey:&kmKey
                                            aKMCert:&kmCert
                                             aGroup:accessGroup];
        }
        else {
            iRes = [SGA_SaveInterface readUserAll:selectDN
                                      aSignPrikey:&signKey
                                        aSignCert:&signCert
                                        aKMPrikey:&kmKey
                                          aKMCert:&kmCert];
        }
        
        if(iRes !=0 /*|| signKey.length <= 0 || signCert.length <= 0*/)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"저장된 인증서 읽어오기 실패",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        // 2. 인증서 암호  확인
        NSData* decSignKey = nil;
        NSData* random = nil; // 사용안함
        
        iRes = [SGA_CSPInterface decryptPrivateKey:&decSignKey
                                           aRandom:&random
                                             aPass:passwd
                                           aEncKey:signKey];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"패스워드가 일치하지 않거나, 개인키 파일이 깨졌습니다.",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        // 3. 전자서명
        NSString *plainText = @"원문 !@#$";
        
        NSData* signature  = nil;
        
        int iSignID = SGIP_SIGNID_SHA256WithRSA; //SGIP_SIGNID_SHA1WithRSA
        iRes = [SGA_CSPInterface computeSign:&signature aData:[plainText dataUsingEncoding:NSUTF8StringEncoding] aPrikey:decSignKey aSignID:iSignID];
        
        //NSLog(@"test333 : signature : %@ | iSignID : %@ | decSignKey : %@", signature, iSignID, decSignKey);
        
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"전자서명 생성 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        NSString* signatureBase64 = nil;
        iRes = [SGA_BINInterface encodeBase64:&signatureBase64 aSrc:signature];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"인코딩 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
        [item setObject:signatureBase64 forKey:@"signResult"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

        NSLog(@"%@", jsonString);
        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataLoginCallback('%@');", jsonString] completionHandler:nil];
        
    }
    
}

- (void)makeSignDataPKCS7:(NSString*) dnName data:(NSString*)data passwd:(NSString*)passwd {
    _selectRow = -1;
    
    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7CallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];
    } else {
        
        int iRes = 0;
        NSString* msg = nil;

        NSString *selectDN = dnName;
        
        // 1. 인증서 존재
        NSData *signKey = nil;
        NSData *signCert = nil;
        NSData *kmKey =nil;
        NSData *kmCert = nil;
        
        if(keychainSwitch) {
            iRes = [KC_Save readUserAllFromKeychain:selectDN
                                        aSignPrikey:&signKey
                                          aSignCert:&signCert
                                          aKMPrikey:&kmKey
                                            aKMCert:&kmCert
                                             aGroup:accessGroup];
        }
        else {
            iRes = [SGA_SaveInterface readUserAll:selectDN
                                      aSignPrikey:&signKey
                                        aSignCert:&signCert
                                        aKMPrikey:&kmKey
                                          aKMCert:&kmCert];
        }
        
        if(iRes !=0 /*|| signKey.length <= 0 || signCert.length <= 0*/)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"저장된 인증서 읽어오기 실패",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        // 2. 인증서 암호  확인
        NSData* decSignKey = nil;
        NSData* random = nil; // 사용안함
        
        iRes = [SGA_CSPInterface decryptPrivateKey:&decSignKey
                                           aRandom:&random
                                             aPass:passwd
                                           aEncKey:signKey];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"패스워드가 일치하지 않거나, 개인키 파일이 깨졌습니다.",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }

        // 3. PKCS7 전자서명
        NSString *plainText = data;

        NSData* cms_signedData = nil;
        
        int iSignID = SGIP_SIGNID_SHA256WithRSA;
        iRes = [SGA_CSPInterface genSignedData : &cms_signedData
                                         aSignID : iSignID
                                      aCertCount : 1
                                       aSignCert : signCert
                                     aSignPrikey : decSignKey
                                           aData : [plainText dataUsingEncoding:NSUTF8StringEncoding]];
        
        if( iRes != 0 )
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"전자서명 생성 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        NSString* signatureBase64 = nil;
        iRes = [SGA_BINInterface encodeBase64:&signatureBase64 aSrc:cms_signedData];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"인코딩 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }

        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
        [item setObject:signatureBase64 forKey:@"signResult"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

        NSLog(@"%@", jsonString);
        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataPKCS7Callback('%@');", jsonString] completionHandler:nil];
        
    }
    
}

- (void)makeSignDataX509:(NSString*) dnName digest:(NSString*)digest passwd:(NSString*)passwd pcsSSN:(NSString*)pcsSSN {
    _selectRow = -1;
    
    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];
    } else {
        
        int iRes = 0;
        NSString* msg = nil;

        NSString *selectDN = dnName;
        
        // 1. 인증서 존재
        NSData *signKey = nil;
        NSData *signCert = nil;
        NSData *kmKey =nil;
        NSData *kmCert = nil;
        
        if(keychainSwitch) {
            iRes = [KC_Save readUserAllFromKeychain:selectDN
                                        aSignPrikey:&signKey
                                          aSignCert:&signCert
                                          aKMPrikey:&kmKey
                                            aKMCert:&kmCert
                                             aGroup:accessGroup];
        }
        else {
            iRes = [SGA_SaveInterface readUserAll:selectDN
                                      aSignPrikey:&signKey
                                        aSignCert:&signCert
                                        aKMPrikey:&kmKey
                                          aKMCert:&kmCert];
        }
        
        if(iRes !=0 /*|| signKey.length <= 0 || signCert.length <= 0*/)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"저장된 인증서 읽어오기 실패",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        // 2. 인증서 암호  확인
        NSData* decSignKey = nil;
        NSData* random = nil; // 사용안함
        
        iRes = [SGA_CSPInterface decryptPrivateKey:&decSignKey
                                           aRandom:&random
                                             aPass:passwd
                                           aEncKey:signKey];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(%d)",@"패스워드가 일치하지 않거나, 개인키 파일이 깨졌습니다.",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        //인증서 본인확인
        iRes = [SGA_CSPInterface verifyVID:signCert aRandom:random aSSN:pcsSSN];
        if(iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@",@"신원검증에 실패하였습니다. 주민등록번호 혹은 사업자번호가 올바르게 입력되었는지 확인하십시오."];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }

        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];

        // 3. Digest 생성
        //        NSData* oData = [data dataUsingEncoding:NSUTF8StringEncoding];
        //        NSData* digestHash = nil;
        //        iRes = [SGA_CSPInterface genHash:SGIP_HASHID_SHA256 aData:oData aHash:&digestHash];
        //        if(iRes !=0)
        //        {
        //            msg = [NSString stringWithFormat:@"%@(%d)",@"Digest 생성 중 오류가 발생하였습니다.",iRes];
        //            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
        //            return;
        //        }
        //
        //        NSString* digestBase64 = nil;
        //        iRes = [SGA_BINInterface encodeBase64:&digestBase64 aSrc:digestHash];
        //        if (iRes != 0)
        //        {
        //            msg = [NSString stringWithFormat:@"%@(res:%d)",@"인코딩 실패!",iRes];
        //            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
        //            return;
        //        }
        //        [item setObject:digestBase64 forKey:@"digestValue"];

                [item setObject:digest forKey:@"digestValue"];
               
        // 4. 전자서명
        //난수생성
        NSData *challenge = nil;
        iRes = [SGA_CSPInterface genRandom:16 aRandom:&challenge];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"난수 생성 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }

        NSString *plainText = [NSString stringWithFormat:@"<ds:SignedInfo xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256\"></ds:SignatureMethod><ds:Reference URI=\"\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"></ds:Transform><ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\"><ds:XPath>not(self::*[name()='TaxInvoice'] | ancestor-or-self::*[name()='ExchangedDocument'] | ancestor-or-self::ds:Signature)</ds:XPath></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"></ds:DigestMethod><ds:DigestValue>%@</ds:DigestValue></ds:Reference></ds:SignedInfo>", digest];

        NSData* cms_signedData = nil;

        int iSignID = SGIP_SIGNID_SHA256WithRSA; //SGIP_SIGNID_SHA1WithRSA
        iRes = [SGA_CSPInterface computeSign:&cms_signedData aData:[plainText dataUsingEncoding:NSUTF8StringEncoding] aPrikey:decSignKey aSignID:iSignID];
        
//        int iSignID = SGIP_SIGNID_SHA256WithRSA;
//        iRes = [SGA_CSPInterface genSignedData : &cms_signedData
//                                         aSignID : iSignID
//                                      aCertCount : 1
//                                       aSignCert : signCert
//                                     aSignPrikey : decSignKey
//                                           aData : challenge];

        if( iRes != 0 )
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"전자서명 생성 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        
        NSString* signatureBase64 = nil;
        iRes = [SGA_BINInterface encodeBase64:&signatureBase64 aSrc:cms_signedData];
        if (iRes != 0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"인코딩 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
        [item setObject:signatureBase64 forKey:@"signatureValue"];
        
        // 5. 인증서 정보
        SGIP_CertInfo *stCertInfo = [SGIP_CertInfo alloc]; //[SGIP_CertInfo ne];
        iRes = [SGA_CSPInterface getCertInfo:stCertInfo aCert:signCert];
        if(iRes !=0 )
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"저장된 인증서 정보 읽어오기 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }

        NSString *userSignCertPem = nil;
        [SGA_BINInterface encodePEM:&userSignCertPem aType:10 aSrc:signCert];

        NSMutableDictionary* certInfo = [[NSMutableDictionary alloc] init];
        [certInfo setObject:stCertInfo.issuer forKey:@"issueDN"];
        [certInfo setObject:stCertInfo.serial forKey:@"serial"];
        [certInfo setObject:stCertInfo.subject forKey:@"userDN"];
        [certInfo setObject:stCertInfo.publicKey forKey:@"publickey"];
        [certInfo setObject:userSignCertPem forKey:@"certificate"];

        NSLog(@"%@", certInfo);
        
        [item setObject:certInfo forKey:@"X509Data"];
        
        
        // 6. 본인확인용 R
        NSString *rValBase64;
        iRes = [SGA_BINInterface encodeBase64:&rValBase64 aSrc:random];
        
//        NSData* rVal = nil;
//        iRes = [SGA_CSPInterface genRandom:16 aRandom:&rVal];
        if(iRes !=0)
        {
            msg = [NSString stringWithFormat:@"%@(res:%d)",@"보인확인용 R 값 생성 실패!",iRes];
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
            return;
        }
//        NSString* rValBase64 = nil;
//        iRes = [SGA_BINInterface encodeBase64:&rValBase64 aSrc:rVal];
//        if (iRes != 0)
//        {
//            msg = [NSString stringWithFormat:@"%@(res:%d)",@"인코딩 실패!",iRes];
//            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509CallbackFail('%@');", msg] completionHandler:nil];
//            return;
//        }
        [item setObject:rValBase64 forKey:@"base64R"];
        
        NSLog(@"%@", item);
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

//        NSLog(@"%@", jsonString);
        
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\r" withString:@"\\\\r"];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\\\n"];

        NSLog(@"%@", jsonString);

        
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_makeSignDataX509Callback('%@');", jsonString] completionHandler:nil];
        
    }
    
}

- (void)changeCertPassword:(NSString*) dnName p:(NSString*)p n1:(NSString*)n1 n2:(NSString*)n2 {
    _selectRow = -1;
    int iRes = 0;
    NSString* selectDN;
    NSMutableDictionary* tempCertInfo = nil;

    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_changeCertPasswordCallbackFail('%@');", @"현재 등록된 인증서가 없습니다. 인증서 가져오기 메뉴에서 인증서를 등록 후 사용하세요."] completionHandler:nil];
    } else {
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];

        for (int i = 0; i < [_certInfo certCount]; i++) {
            NSInteger row = i;
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:row getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:row getValue:&tempCertInfo];
            }
            
            if ([dnName isEqualToString:[tempCertInfo objectForKey:@"certDN"]]) {
                _selectRow = i;
                
                break;
            }
        }
        
        if (_selectRow == -1) {
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_changeCertPasswordCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];

        } else {

            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:_selectRow getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:_selectRow getValue:&tempCertInfo];
            }
            
            selectDN = [tempCertInfo objectForKey:@"certDN"];
            
            if(keychainSwitch) {
                iRes = [SGA_CSPInterface changePasswordWithKeychain:p aPostPassword:n1 aCertInfo:selectDN accessGroup:accessGroup];
            }
            else {
                iRes = [SGA_CSPInterface changePassword:p aPostPassword:n1 aCertInfo: selectDN];
            }
            
            //비밀번호 불일치의 경우만 구분하고 나머진 변경 실패에러
            if(iRes == 10) {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_changeCertPasswordCallbackFail('%@');", @"현재 인증서 암호 입력이 틀렸습니다."] completionHandler:nil];
            }
            else if(iRes != 0) {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_changeCertPasswordCallbackFail('%@');", @"인증서 암호 변경에 실패하였습니다."] completionHandler:nil];
            }
            else {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_changeCertPasswordCallback('%@');", @"인증서 암호 변경에 성공하였습니다."] completionHandler:nil];
            }
            
        }
        
    }
    
}

- (void)certExport:(NSString*) dnName authcode:(NSString*)authCode passwd:(NSString*)passwd {
    _selectRow = -1;
    int iRes = 0;
    NSString* selectDN;
    NSMutableDictionary* tempCertInfo = nil;

    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallbackFail('%@');", @"현재 등록된 인증서가 없습니다. 인증서 가져오기 메뉴에서 인증서를 등록 후 사용하세요."] completionHandler:nil];
    } else {
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];

        for (int i = 0; i < [_certInfo certCount]; i++) {
            NSInteger row = i;
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:row getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:row getValue:&tempCertInfo];
            }
            
            if ([dnName isEqualToString:[tempCertInfo objectForKey:@"certDN"]]) {
                _selectRow = i;
                
                break;
            }
        }
        
        if (_selectRow == -1) {
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];

        } else {

            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:_selectRow getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:_selectRow getValue:&tempCertInfo];
            }
            
            selectDN = [tempCertInfo objectForKey:@"certDN"];
            
            // 인증번호 확인
            if(authCode.length != 12)
            {
                // 오류 메시지 출력
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallbackFail('%@');", @"인증번호는 12자리 입니다. 정확하게 입력해 주세요."] completionHandler:nil];
                return;
            }
            
            // 암호 입력 확인
            if([passwd isEqualToString:@""])
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallbackFail('%@');", @"인증서 암호를 입력해 주세요."] completionHandler:nil];
                return;

            }
            
            // 인증서 내보내기
            BOOL bRes;
            if(keychainSwitch) {
                bRes = [self.transmitCertServerObj sendCertToServerWithKeychain:selectDN
                                                                   sendAuthCode:authCode
                                                                   certPassword:passwd
                                                                    accessGroup:accessGroup];
            }
            else {
                bRes = [self.transmitCertServerObj sendCertToServer:selectDN sendAuthCode:authCode certPassword:passwd];
            }
            if (bRes == YES)
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallback('%@');", @"인증서 내보내기에 성공하였습니다."] completionHandler:nil];
            }
            else
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_certExportCallbackFail('%@');", [self.transmitCertServerObj getErrorMessage]] completionHandler:nil];
            }

        }
        
    }
    
}

- (void)deleteCert:(NSString*) dnName passwd:(NSString*)passwd {
    _selectRow = -1;
    int iRes = 0;
    NSString* selectDN;
    NSMutableDictionary* tempCertInfo = nil;

    if(keychainSwitch) {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCertWithKeychain:accessGroup];
    }
    else {
        _certInfo = [[SGGetCertInfo alloc] initWithSavedStorageCert];
    }
    
    if ([_certInfo certCount] == 0) {
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallbackFail('%@');", @"현재 등록된 인증서가 없습니다. 인증서 가져오기 메뉴에서 인증서를 등록 후 사용하세요."] completionHandler:nil];
    } else {
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];

        for (int i = 0; i < [_certInfo certCount]; i++) {
            NSInteger row = i;
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:row getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:row getValue:&tempCertInfo];
            }
            
            if ([dnName isEqualToString:[tempCertInfo objectForKey:@"certDN"]]) {
                _selectRow = i;
                selectDN = [tempCertInfo objectForKey:@"certDN"];
                break;
            }
        }
        
        if (_selectRow == -1) {
            [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];

        } else {

            // 1. 인증서 존재
            NSData *signKey = nil;
            NSData *signCert = nil;
            NSData *kmKey =nil;
            NSData *kmCert = nil;
            
            if(keychainSwitch) {
                iRes = [KC_Save readUserAllFromKeychain:selectDN
                                            aSignPrikey:&signKey
                                              aSignCert:&signCert
                                              aKMPrikey:&kmKey
                                                aKMCert:&kmCert
                                                 aGroup:accessGroup];
            }
            else {
                iRes = [SGA_SaveInterface readUserAll:selectDN
                                          aSignPrikey:&signKey
                                            aSignCert:&signCert
                                            aKMPrikey:&kmKey
                                              aKMCert:&kmCert];
            }
            
            if(iRes !=0 /*|| signKey.length <= 0 || signCert.length <= 0*/)
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallbackFail('%@');", @"인증서 정보를 찾을 수 없습니다."] completionHandler:nil];
                return;
            }
            
            // 2. 인증서 암호  확인
            NSData* decSignKey = nil;
            NSData* random = nil; // 사용안함
            
            iRes = [SGA_CSPInterface decryptPrivateKey:&decSignKey
                                               aRandom:&random
                                                 aPass:passwd
                                               aEncKey:signKey];
            if (iRes != 0)
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallbackFail('%@');", @"인증서 비밀번호가 올바르지 않습니다. 확인하고 다시 입력해주세요."] completionHandler:nil];
                return;
            }
            
            if(keychainSwitch) {
                [_certInfo parseCertWithSavedSequenceWithKeychain:_selectRow getValue:&tempCertInfo];
            }
            else {
                [_certInfo parseCertWithSavedSequence:_selectRow getValue:&tempCertInfo];
            }
            
            selectDN = [tempCertInfo objectForKey:@"certDN"];
            
            if(keychainSwitch) {
                iRes = [KC_Save deleteUserAllFromKeychain:selectDN aGroup:accessGroup];
            }
            else {
                iRes = [SGA_SaveInterface deleteUserAll:selectDN];
            }
            
            if(iRes != 0) // 삭제 실패
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallbackFail('%@');", @"선택한 인증서를 삭제하는데 오류가 발생하였습니다."] completionHandler:nil];
            }
            else
            {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_deleteCertCallback('%@');", @"선택한 인증서를 삭제하였습니다."] completionHandler:nil];
            }

        }
        
    }
    
}

- (void)download:(NSString*) download_url {
    NSURL *rurl = [NSURL URLWithString:download_url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:rurl
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) {
                // handle response
        
        if ([data length] >0 && error == nil)
        {
            // DO YOUR WORK HERE
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if([response respondsToSelector:@selector(allHeaderFields)]){
                NSDictionary *dic = httpResponse.allHeaderFields;
                NSString *type = [dic objectForKey:@"Content-Disposition"];
                
                NSRange l_checkName;
                NSString *l_nsmeString;
                l_checkName = [type rangeOfString:@"filename=" options:NSCaseInsensitiveSearch];
                l_nsmeString = [type substringFromIndex:l_checkName.location+l_checkName.length];
                l_nsmeString = [l_nsmeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                l_nsmeString = [l_nsmeString stringByReplacingOccurrencesOfString:@";" withString:@""];
                NSString *fileName = [l_nsmeString stringByRemovingPercentEncoding];
                
                if ( [type rangeOfString:@".hwp"].location != NSNotFound ||
                    [type rangeOfString:@".jpeg"].location != NSNotFound ||
                    [type rangeOfString:@".gif"].location != NSNotFound ||
                    [type rangeOfString:@".docx"].location != NSNotFound ||
                    [type rangeOfString:@".mp3"].location != NSNotFound ||
                    [type rangeOfString:@".mp4"].location != NSNotFound ||
                    [type rangeOfString:@".jpg"].location != NSNotFound ||
                    [type rangeOfString:@".png"].location != NSNotFound ||
                    [type rangeOfString:@".bmp"].location != NSNotFound ||
                    [type rangeOfString:@".txt"].location != NSNotFound ||
                    [type rangeOfString:@".doc"].location != NSNotFound ||
                    [type rangeOfString:@".xls"].location != NSNotFound ||
                    [type rangeOfString:@".xlsx"].location != NSNotFound ||
                    [type rangeOfString:@".ppt"].location != NSNotFound ||
                    [type rangeOfString:@".pptx"].location != NSNotFound ||
                    [type rangeOfString:@".pdf"].location != NSNotFound )
                {
                    
                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString* documentDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    
                    [data writeToFile:documentDir atomically:YES];
                    NSURL *downloadURL = [NSURL fileURLWithPath:documentDir];
                    
                    if (downloadURL) {
                        self.doic = [UIDocumentInteractionController interactionControllerWithURL:downloadURL];
                        
                        self.doic.delegate = self;
                        
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            BOOL rtn = [self.doic presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
                        });
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"알림" message:@"파일을 확인할 수 있는 앱이 설치되어 있지 않습니다." preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                }
            }

        }
        else if ([data length] == 0 && error == nil)
        {
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@"Error = %@", error);
        }
      }] resume];

}



// ============================== Schema Link Process Functions For Webview End ============================== //


#pragma mark - AVCamCameraViewController delegate
- (void)onStillImageSaved:(UIViewController*)vc data:(NSData*)data {
    NSLog(@"[%s], data length=%ld", __FUNCTION__, [data length]);
    
    dispatch_async( dispatch_get_main_queue(), ^{
        CloudVisionViewController *cvvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                           instantiateViewControllerWithIdentifier:@"CloudVisionViewController"];
        [cvvc setImageData:data];
        cvvc.delegate = self;
        [vc presentViewController:cvvc animated:NO completion:nil];
    } );
}

#pragma mark - After take a camera, Send Container nunmber to webview
- (void)conNoToServer:(NSNotification *)notification {
    
    NSString *orcText = [notification.userInfo objectForKey:@"orcText"];
    NSData *data = [notification.userInfo objectForKey:@"imageData"];
    
    [self closeAllModal];
    @try {
        UIImage *image = [UIImage imageWithData:data];
        
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64];
        
        NSString *script = [NSString stringWithFormat:@"addCntrNoData('%@', '%@')", orcText, imageParam];
        NSLog(@"%@", script);
        
        [_webView evaluateJavaScript:script completionHandler:nil];
        [[DataSet sharedDataSet] delWaitPopView:self.view];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"addCntrNoData('', '{}')" completionHandler:nil];
        [[DataSet sharedDataSet] delWaitPopView:self.view];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    switch (_request_type) {
        case CONTAINER_NO_FROM_CAMERA_REQUEST:   // asmyoung
        {
            dispatch_async( dispatch_get_main_queue(), ^{
                [[DataSet sharedDataSet] waitPopView:self.view];  //asmyoung
                CloudVisionViewController *cvvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                   instantiateViewControllerWithIdentifier:@"CloudVisionViewController"];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [cvvc setImageData:data];
                cvvc.delegate = self;
                [self presentViewController:cvvc animated:NO completion:nil];
            } );
        }
            break;
        case CONTAINER_NO_FROM_GALLERY_REQUEST:
            
            break;
        case SEAL_NO_FROM_GALLERY_REQUEST:
            [self sealNoToServer:image from:SEAL_NO_FROM_GALLERY_REQUEST];
        break;
        case SEAL_NO_FROM_CAMERA_REQUEST:
            [self sealNoToServer:image from:SEAL_NO_FROM_CAMERA_REQUEST];
            break;
        case CAR_BIZ_CD_FROM_GALLERY_REQUEST:
            [self imageDataToServer:image dataType:@"car"];
            break;
        case BIZ_CD_FROM_GALLERY_REQUEST:
            [self imageDataToServer:image dataType:@"biz"];
            break;
        case HANDLER_SEARCH_SALE_LIST:
            
            break;
        case MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST:
            [self multiContainerNoToServer:image from:MULTI_CONTAINER_NO_FROM_GALLERY_REQUEST];
            break;
        case MULTI_CONTAINER_NO_FROM_CAMERA_REQUEST:
            [self multiContainerNoToServer:image from:MULTI_CONTAINER_NO_FROM_CAMERA_REQUEST];
            break;
        case UPLOADFILE_FROM_CAMERA_REQUEST:
            [self photoToServer:image from:UPLOADFILE_FROM_CAMERA_REQUEST];
            break;
        case UPLOADFILE_FROM_GALLERY_REQUEST:
            [self photoToServer:image from:UPLOADFILE_FROM_GALLERY_REQUEST];
            break;
        default:
            break;
    }
//    [self sealNoToServer:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GA, Firebase Crashtics
- (void)sendEventFCwithTag:(NSString *)tag message:(NSString *)message {
    if (isFcLogging) {
        [[FIRCrashlytics crashlytics] setUserID: [DataSet sharedDataSet].g_fcUserId];
        [[FIRCrashlytics crashlytics] logWithFormat:@"%@: FC:%@", tag, message];
    }
}

- (void)sendEventGAwithTitle:(NSString *)title message:(NSString *)message {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
    parameters:@{
                 kFIRParameterItemID:[NSString stringWithFormat:@"GA:%@", message],
                 kFIRParameterItemName:title
//                 kFIRParameterContentType:@"image"
                 }];
}

#pragma mark - TMapApi Delegate
- (void)SKTMapApikeySucceed {
    NSString *x = [self getQueryString:_urlForNavi tag:@"wgs84X"];
    NSString *y = [self getQueryString:_urlForNavi tag:@"wgs84Y"];
    NSString *goalName = @"목적지";
    
    NSDictionary *info = @{@"rGoName": goalName,
                           @"rGoX": [NSNumber numberWithDouble:x.doubleValue],
                           @"rGoY": [NSNumber numberWithDouble:y.doubleValue]};
    
    if ([TMapTapi isTmapApplicationInstalled]) {
        [TMapTapi invokeRoute:info];
    } else {
        NSString *downloadUrl = [TMapTapi getTMapDownUrl];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:downloadUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl] options:@{} completionHandler:nil];
        }
    }
}

#pragma mark - 앱 실행중 푸시처리
- (void)pushCheck {
    NSString *push_yn = [DataSet sharedDataSet].push_yn;
    if (push_yn != nil && [push_yn isEqualToString:@"Y"] && [[_preference getLoggedIn] isEqualToString:@"Y"]) {
        
        [self goPush2:[DataSet sharedDataSet].push_userInfo];
        
        [DataSet sharedDataSet].push_yn = @"N";
    }
}

- (void)goPush:(NSNotification *)notification {
    
    //NSDictionary *userInfo = [notification userInfo];
    
    //NSDictionary *dic = [userInfo objectForKey:@"msg"];
    NSString *type = [DataSet sharedDataSet].push_type; //[dic objectForKey:@"type"];
    NSString *seq = [DataSet sharedDataSet].push_seq; //[dic objectForKey:@"seq"];
    NSString *doc_gubun = [DataSet sharedDataSet].push_doc_gubun; //[dic objectForKey:@"doc_gubun"];
    NSString *param = [DataSet sharedDataSet].push_param; //[dic objectForKey:@"param"];
    NSString *title = [DataSet sharedDataSet].push_title; //[dic objectForKey:@"title"];
    NSString *body = [DataSet sharedDataSet].push_body; //[dic objectForKey:@"body"];
    NSString *nilStr = @"";
    
    title = title == nil ? @"" : title;
    seq = seq == nil ? @"" : seq;
    param = param == nil ? @"" : param;
    title = title == nil ? @"" : title;
    
    if (body == nil || body.length == 0) {
        body = @"새로운 알림이 있습니다.";
    }
    
    //if (!_bIsCalling && [[_preference getTTS] isEqualToString:@"Y"]) {
    if (!_bIsCalling) {
        [SpeechHelper speakString:body withCompletion:^{}];
    }
    
    //앱이 온그라운드에 있을때 푸시 알림오고 그 푸시 눌렀을때 실행
    if ([[_preference getLoggedIn] isEqualToString:@"Y"]) {
        
        NSString *params = [NSString stringWithFormat:@"?seq=%@&doc_gubun=%@&type=%@&call_text=%@&call_text_sub=%@&call_param=%@", seq, doc_gubun, type, title, body, param];
        
        if ([doc_gubun  isEqual: @"88"]) {
            [self gotoPushRedirectPage:params];
        } else {
            
            NSString *popTitle = [title componentsSeparatedByString:@"#TTS#"][0];
            NSString *popBody = [body componentsSeparatedByString:@"#TTS#"][0];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:popTitle message:popBody preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self gotoPushRedirectPage:params];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

- (void)goPush2:(NSDictionary *)userInfo {
    
    //NSDictionary *userInfo = [notification userInfo];
    
    //NSDictionary *dic = [userInfo objectForKey:@"msg"];
    NSString *type = [DataSet sharedDataSet].push_type; //[dic objectForKey:@"type"];
    NSString *seq = [DataSet sharedDataSet].push_seq; //[dic objectForKey:@"seq"];
    NSString *doc_gubun = [DataSet sharedDataSet].push_doc_gubun; //[dic objectForKey:@"doc_gubun"];
    NSString *param = [DataSet sharedDataSet].push_param; //[dic objectForKey:@"param"];
    NSString *title = [DataSet sharedDataSet].push_title; //[dic objectForKey:@"title"];
    NSString *body = [DataSet sharedDataSet].push_body; //[dic objectForKey:@"body"];
    NSString *nilStr = @"";
    
    if (body == nil || body.length == 0) {
        body = @"새로운 알림이 있습니다.";
    }
    
    if (!_bIsCalling) {
        [SpeechHelper speakString:body withCompletion:^{}];
    }
    
    //앱이 백그라운드에 있고 알림바에서 푸시 눌렀을때 실행
    if ([[_preference getLoggedIn] isEqualToString:@"Y"]) {
        
        NSString *params = [NSString stringWithFormat:@"?seq=%@&doc_gubun=%@&type=%@&call_text=%@&call_text_sub=%@&call_param=%@", seq, doc_gubun, type, title, body, param];
        
        if ([doc_gubun  isEqual: @"88"]) {
            [self gotoPushRedirectPage:params];
        } else {
            
            NSString *popTitle = [title componentsSeparatedByString:@"#TTS#"][0];
            NSString *popBody = [body componentsSeparatedByString:@"#TTS#"][0];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:popTitle message:popBody preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self gotoPushRedirectPage:params];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBManagerStatePoweredOff:
            NSLog(@"CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"CBManagerStatePoweredOn");
//            if (_bIsDostartinit) {
//                CLLocation *location = [_locationManager location];
//
//                NSString *script = @"";
//                script = [NSString stringWithFormat:@"fn_doStart('%f', '%f', '%@')", location.coordinate.longitude, location.coordinate.latitude, @"G"];
//
//                [self.webView evaluateJavaScript:script completionHandler: nil];
//
//                _bIsDostartinit = NO;
//            }
            break;
        case CBManagerStateUnknown:
            NSLog(@"CBManagerStateUnknown");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBManagerStateUnauthorized");
            break;
        default:
            break;
    }
}

#pragma mark - upload file Method
- (void)chooseUploadSource {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"업로드 파일 선택" message:@"수단을 선택해주세요." preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self getUploadFile:@"camera"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self getUploadFile:@"gallary"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"파일" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self getUploadFile:@"file"];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)getUploadFile:(NSString *)type {
    
    if ([type isEqualToString:@"camera"]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        _request_type = UPLOADFILE_FROM_CAMERA_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if ([type isEqualToString:@"gallary"]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        _request_type = UPLOADFILE_FROM_GALLERY_REQUEST;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if ([type isEqualToString:@"file"]) {
        _request_type = UPLOADFILE_FROM_FILE_REQUEST;
        UIDocumentPickerViewController* documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
            inMode:UIDocumentPickerModeImport];
            documentPicker.delegate = self;
            if (@available(iOS 11.0, *)) {
                documentPicker.allowsMultipleSelection = true;
              
            } else {
                // Fallback on earlier versions
            }
            [self presentViewController:documentPicker animated:YES completion:nil];
        
    }
}

- (void)photoToServer:(UIImage *)image from:(enum REQUEST_TYPE)from {
    @try {
        float width = image.size.width;
        float height = image.size.height;
        
        float newHeight = height * 0.5;
        float newWidth = width * 0.5;

        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData * jpgData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *base64 = [jpgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        NSString *imageParam = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64];
        
        NSString *script = @"";

        script = [NSString stringWithFormat:@"fn_getUploadFileCallback('%@', '%@')", imageParam, @"upload.jpg"];
        
        [_webView evaluateJavaScript:script completionHandler:nil];
    } @catch (NSException *exception) {
        [_webView evaluateJavaScript:@"fn_getUploadFileCallbackFail('업로드 이미지 생성에 실패하였습니다.')" completionHandler:nil];
    }
}


- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSLog(@"picked document %@", url);
    
    NSData* documentData = [[NSData alloc] initWithContentsOfURL:url];
    documentData = [[NSData alloc] initWithContentsOfFile:[url path]];
    
    if (documentData == nil) {
        NSString *script = @"";

        script = @"fn_getUploadFileCallbackFail('업로드 파일 생성에 실패하였습니다.')";
        
        [_webView evaluateJavaScript:script completionHandler:nil];
        
        return;
    }
    
    NSString* fileName = [url lastPathComponent];
    
    NSString *base64 = [documentData base64EncodedStringWithOptions:nil];
    
    NSString *script = @"";

    script = [NSString stringWithFormat:@"fn_getUploadFileCallback('%@', '%@')", base64, fileName];
    
    [_webView evaluateJavaScript:script completionHandler:nil];
    

 }
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
    
    if ([urls count] > 5) {
        NSString *script = @"";

        script = @"fn_getUploadFileCallbackFail('업로드 파일은 한번에 5개까지 선택가능합니다.')";
        
        [_webView evaluateJavaScript:script completionHandler:nil];
        
        return;
    }
    
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    NSMutableArray* jlist = [[NSMutableArray alloc] init];

    for (int i = 0; i < [urls count]; i++) {
        
        NSURL *url = [urls objectAtIndex:i];
        NSData* documentData = [[NSData alloc] initWithContentsOfURL:url];
        documentData = [[NSData alloc] initWithContentsOfFile:[url path]];
        
        if (documentData == nil) {
            NSString *script = @"";

            script = @"fn_getUploadFileCallbackFail('업로드 파일 생성에 실패하였습니다.')";
            
            [_webView evaluateJavaScript:script completionHandler:nil];
            
            return;
        }
        NSString* fileName = [url lastPathComponent];
        
        NSString *base64 = [documentData base64EncodedStringWithOptions:0];
        
        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
        [item setObject:base64 forKey:@"data"];
        [item setObject:fileName forKey:@"name"];
        
        [jlist addObject:item];

    }
    
    [ret setObject:jlist forKey:@"fileList"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

    [_webView evaluateJavaScript:[NSString stringWithFormat:@"javascript:fn_getUploadFileMultiCallback('%@');", jsonString] completionHandler:nil];
    
}


#pragma mark - CXCallObserverDelegate Method
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if (call.hasEnded) {
        //Disconnected
        NSLog(@"CXCallObserver ======== Disconnected");
        
        if (_bIsCalling) {
            _bIsCalling = NO;
            
            //if ([[_preference getTTS] isEqualToString:@"N"]) return;
            
            NSString *body = [DataSet sharedDataSet].push_body; //[dic objectForKey:@"body"];
            
            if (body == nil || body.length == 0) {
                body = @"새로운 알림이 있습니다.";
            }
            
            [SpeechHelper speakString:body withCompletion:^{}];
        }
        
    } else if (call.isOutgoing && !call.hasConnected) {
        //Dialing
        NSLog(@"CXCallObserver ======== Dialing");
        _bIsCalling = YES;
    } else if (!call.isOutgoing && !call.hasConnected && !call.hasEnded) {
        //Incoming
        NSLog(@"CXCallObserver ======== Incoming");
        _bIsCalling = YES;
    } else if (call.hasConnected && !call.hasEnded) {
        //Connected
        NSLog(@"CXCallObserver ======== Connected");
        _bIsCalling = YES;
    }
}

- (NSString *)sendDataToServer{
    __block NSString *returnValue;
    
    NSLog( @"sendDataToServer - MAIN_URL : %@", CONNECTION_URL);
    NSUInteger length = [CONNECTION_URL length];
    NSString *getURL = [NSString stringWithFormat:@"%@/newmobile/selectMobileHashKey.do?method=selectMobileHashKey&app_id=ETDRIVING&app_os=ios&app_version=%lu",CONNECTION_URL,(unsigned long)length];
    
    
    NSURL* url = [NSURL URLWithString:getURL];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil  error:&error];
    
    if(data != nil) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        returnValue = [dic objectForKey:@"hash_code"];
    }
    
    return returnValue;
}

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i=0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x",digest[i]];
    
    
    return output;
}

- (BOOL)checkRooting {
    BOOL returnValue = YES;
    NSArray *checkList=[NSArray arrayWithObjects:
                         @"/Applications/Cydia.app",
                         @"/Applications/RockApp.app",
                         @"/Applications/Icy.app",
                         @"/usr/sbin/sshd",
                         @"/usr/bin/sshd",
                         @"/usr/libexec/sftp-server",
                         @"/Applications/WinterBoard.app",
                         @"/Applications/SBSettings.app",
                         @"/Applications/MxTube.app",
                         @"/Applications/IntelliScreen.app",
                         @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                         @"/Applications/FakeCarrier.app",
                         @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                         @"/private/var/lib/apt",
                         @"/Applications/blackra1n.app",
                         @"/private/var/stash",
                         @"/private/var/mobile/Library/SBSettings/Themes",
                         @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                         @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                         @"/private/var/tmp/cydia.log",
                         @"/private/var/lib/cydia",
                         nil];
    if(!TARGET_IPHONE_SIMULATOR) {
        for (NSString *filePath in checkList) {
            if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                returnValue = NO;
                break;
            }
        }
    }
    return returnValue;
}

@end

