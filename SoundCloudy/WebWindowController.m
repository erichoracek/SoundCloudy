//
//  WebWindowController.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "WebWindowController.h"
#import "WebViewController.h"
#import "SpaceKeyCommand.h"
#import "WKWebView+SoundCloud.h"

@interface WebWindowController ()

@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic, readwrite) WebViewController *webViewController;
@property (nonatomic) SpaceKeyCommand *spaceKeyCommand;
@property (nonatomic) RACSignal *spaceKeyPlayEnabledSignal;
@property (nonatomic) NSNumber *windowVisible;

@end

@implementation WebWindowController

#pragma mark - NSWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.contentView = self.webViewController.view;
    self.webViewController.view.frame = [self.window.contentView bounds];
    
    RAC(self.window, title) = RACObserve(self.webViewController.view, title);
    
    // Bind NSWindow's visible binding to the windowVisibleProperty for spaceKeyPlayEnabledSignal
    [self.window bind:@"visible" toObject:self withKeyPath:NSStringFromSelector(@selector(windowVisible)) options:nil];

    // Play/pause when the space key is pressed while the window is not visible
    @weakify(self);
    self.spaceKeyCommand = [[SpaceKeyCommand alloc] initWithEnabled:self.spaceKeyPlayEnabledSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal startEagerlyWithScheduler:[RACScheduler mainThreadScheduler] block:^(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.webViewController.view play];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
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

- (RACSignal *)spaceKeyPlayEnabledSignal
{
    if (!_spaceKeyPlayEnabledSignal) {
        // The space key should only be able to pause when the window is NOT visible, since it works correctly when it is
        self.spaceKeyPlayEnabledSignal = [[RACObserve(self, windowVisible) map:^id(id value) {
            // The value is @YES when window is visible, @NO or nil when it is not visible
            return (value ?: @NO);
        }] not];
    }
    return _spaceKeyPlayEnabledSignal;
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
