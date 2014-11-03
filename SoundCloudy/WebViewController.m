//
//  WebViewController.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "WebViewController.h"
#import "WKWebView+SoundCloud.h"
#import "MediaKeys.h"
#import "SoundCloudTrackInfo.h"
#import "UserNotificationDispatch.h"
#import "NSURL+SoundCloud.h"

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic) UserNotificationDispatch *userNotificationDispatch;


@end

@implementation WebViewController

#pragma mark - NSViewController

- (void)loadView
{
    self.view = [WKWebView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.allowsBackForwardNavigationGestures = YES;
    self.view.navigationDelegate = self;
    [self bindMediaKeys:[MediaKeys sharedInstance] toWebView:self.view];
    [self bindUserNotificationDispatch:self.userNotificationDispatch toWebView:self.view];
    [self.view loadRequest:self.request];
}

#pragma mark - WebViewController

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)bindMediaKeys:(MediaKeys *)mediaKeys toWebView:(WKWebView *)webView
{
    [mediaKeys.playKeySignal subscribeNext:^(id x) {
        [webView play];
    }];
    [mediaKeys.nextKeySignal subscribeNext:^(id x) {
        [webView next];
    }];
    [mediaKeys.prevKeySignal subscribeNext:^(id x) {
        [webView prev];
    }];
}

- (void)bindUserNotificationDispatch:(UserNotificationDispatch *)userNotificationDispatch toWebView:(WKWebView *)webView
{
    [userNotificationDispatch.skipTrackSignal subscribeNext:^(id x) {
        [webView next];
    }];
    [userNotificationDispatch.viewTrackSignal subscribeNext:^(id x) {
        [webView scrollToCurrentTrack];
    }];
}

- (UserNotificationDispatch *)userNotificationDispatch
{
    if (!_userNotificationDispatch) {
        NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
        self.userNotificationDispatch = [[UserNotificationDispatch alloc] initWithTrackInfoSignal:self.view.trackInfoSignal notificationCenter:center];
    }
    return _userNotificationDispatch;
}

#pragma mark - WebViewController <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (!navigationAction.targetFrame || !navigationAction.request.URL.isOnSoundCloudDomain) {
        [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
