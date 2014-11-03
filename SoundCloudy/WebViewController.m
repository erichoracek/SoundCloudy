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
#import "SpaceKeySignal.h"
#import "WKWebView+SoundCloud.h"
#import "MediaKeys.h"

@interface WebViewController ()

@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic) SpaceKeySignal *spaceKeySignal;

@end

@implementation WebViewController

#pragma mark - NSViewController

- (void)loadView
{
    self.view = [WKWebView new];
    self.spaceKeySignal = [SpaceKeySignal new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.allowsBackForwardNavigationGestures = YES;
    [self bindMediaKeys:[MediaKeys sharedInstance] toWebView:self.view];
    [self.view loadRequest:self.request];
    
    [self.view.isSoundCloudURL subscribeNext:^(id x) {
        NSLog(@"is sound cloud %@", x);
    }];
    
    [self.view.isPlaying subscribeNext:^(id x) {
        NSLog(@"is playing %@", x);
    }];
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

@end
