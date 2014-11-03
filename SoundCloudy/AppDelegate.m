//
//  AppDelegate.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "AppDelegate.h"
#import "WebWindowController.h"
#import "WebViewController.h"
#import "WKWebView+SoundCloud.h"
#import "NSURL+SoundCloud.h"

@interface AppDelegate ()

@property (nonatomic, strong) WebWindowController *windowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL soundCloudHomePageURL]];
    self.windowController = [[WebWindowController alloc] initWithRequest:request];
    [self.windowController showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    
}

#pragma mark - Menu Items

- (IBAction)help:(id)sender
{
    [self.windowController.webViewController.view help];
}

- (IBAction)reload:(id)sender
{
    [self.windowController.webViewController.view reload];
}

- (IBAction)goToCurrentTrack:(id)sender
{
    [self.windowController.webViewController.view scrollToCurrentTrack];
}

- (IBAction)showMainWindow:(id)sender
{
    [self.windowController showWindow:sender];
}

@end
