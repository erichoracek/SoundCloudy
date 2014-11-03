//
//  WebWindowController.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WebWindowController.h"
#import "WebViewController.h"

@interface WebWindowController ()

@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic, readwrite) WebViewController *webViewController;

@end

@implementation WebWindowController

#pragma mark - NSWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    RAC(self.window, title) = RACObserve(self.webViewController.view, title);
    self.window.contentView = self.webViewController.view;
    self.webViewController.view.frame = [self.window.contentView bounds];
}

- (NSString *)windowNibName
{
    return @"WebWindow";
}

#pragma mark - WebWindowController

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super initWithWindowNibName:self.windowNibName];
    if (self) {
        self.request = request;
    }
    return self;
}

- (WebViewController *)webViewController
{
    if (!_webViewController) {
        self.webViewController = ({
            WebViewController *webViewController = [[WebViewController alloc] initWithRequest:self.request];
            webViewController;
        });
    }
    return _webViewController;
}

@end
