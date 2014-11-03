//
//  WebViewController.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebViewController.h"
#import "SpaceKeySignal.h"

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
    
    [self.spaceKeySignal subscribeNext:^(id x) {
        NSLog(@"whaaat");
    }];
    
    self.view.allowsBackForwardNavigationGestures = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

@end
