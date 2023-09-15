//
//  SpeechHelper.m
//  eTransDrivingIOS
//
//  Created by SeongWoo Lee on 2020/11/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "SpeechHelper.h"

@implementation SpeechHelper

AVSpeechSynthesizer *synthesizer;
AVAudioSession *audioSession;

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (_completion) {
        _completion();
        
        NSError *error = nil;
        // 오디오 세션 설정 제거
        if (![audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
            NSLog(@"AVAudioSession setActive:NO failed: %@", error);
        }
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    NSLog(@"willSpeakRangeOfSpeechString");
}

- (void)performSpeech:(NSString *)str {
    
    if (str == nil || str.length == 0 || ![str containsString:@"#TTS#"]) return;
    
    NSString *ttsStr = [str componentsSeparatedByString:@"#TTS#"][0];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:ttsStr];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    utterance.volume = 1.5f;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ko-KR"];
    
    synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = self;
    
    // AVAudioSession 설정
    audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;

    // 카테고리 설정
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error]) {
        NSLog(@"AVAudioSession setCategory failed: %@", error);
    }

    // 모드 설정
    if (![audioSession setMode:AVAudioSessionModeSpokenAudio error:&error]) {
        NSLog(@"AVAudioSession setMode failed: %@", error);
    }
    
    if (! [audioSession setActive:TRUE error:&error] ){
        NSLog(@"AVAudioSession setActive failed: %@", error);
    }
    
    [synthesizer speakUtterance:utterance];
}

- (void)speakString:(NSString *)str withCompletion:(SpeechCompletionBlock)completion {
    _completion = completion;
    [self performSpeech:str];
}

+ (void)speakString:(NSString *)str withCompletion:(SpeechCompletionBlock)completion {
    [[self new] speakString:str withCompletion:completion];
}
@end
