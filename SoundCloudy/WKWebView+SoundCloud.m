//
//  WKWebView+SoundCloud.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>
#import "WKWebView+SoundCloud.h"

typedef NS_ENUM(NSInteger, SoundCloudKeyCode) {
    SoundCloudKeyCodeNext = 74,
    SoundCloudKeyCodePrev = 75,
    SoundCloudKeyCodePlay = 32,
    SoundCloudKeyCodeHelp = 72
};

static NSString * const SoundCloudKeydownJavaScript = @"\
    event = new Event('keydown');\
    event.keyCode = %ld;\
    document.dispatchEvent(event);\
";

@implementation WKWebView (SoundCloud)

#pragma mark Public

static NSString * const SoundCloudTitleIsPlayingCharacter = @"▶";

- (RACSignal *)isPlayingSignal
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (!signal) {
        signal = [RACSignal combineLatest:@[RACObserve(self, title), self.isSoundCloudURLSignal] reduce:^id(NSString *title, NSNumber *isSoundCloudURL){
            return @(
                [isSoundCloudURL boolValue]
                && ([title rangeOfString:SoundCloudTitleIsPlayingCharacter].location != NSNotFound)
            );
        }];
        objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return signal;
}

static NSString * const SoundCloudHost = @"soundcloud.com";

- (RACSignal *)isSoundCloudURLSignal
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (!signal) {
        signal = [RACObserve(self, URL) map:^id(NSURL *URL) {
            return @([URL.host rangeOfString:SoundCloudHost].location != NSNotFound);
        }];
        objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return signal;
}

- (void)play
{
    [self evaluateJavaScriptForKeyCode:SoundCloudKeyCodePlay];
}

- (void)next
{
    [self evaluateJavaScriptForKeyCode:SoundCloudKeyCodeNext];
}

- (void)prev
{
    [self evaluateJavaScriptForKeyCode:SoundCloudKeyCodePrev];
}

- (void)help
{
    [self evaluateJavaScriptForKeyCode:SoundCloudKeyCodeHelp];
}

#pragma mark Private

- (void)evaluateJavaScriptForKeyCode:(SoundCloudKeyCode)keyCode
{
    if (self.isSoundCloudURLSignal) {
        [self evaluateJavaScript:[self keydownJavaScriptForKeyCode:keyCode] completionHandler:nil];
    }
}

- (NSString *)keydownJavaScriptForKeyCode:(SoundCloudKeyCode)keyCode
{
    return [NSString stringWithFormat:SoundCloudKeydownJavaScript, keyCode];
}

@end
