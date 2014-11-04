//
//  AppDelegate.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import <LetsMove/PFMoveApplication.h>
#import "AppDelegate.h"
#import "WebWindowController.h"
#import "WebViewController.h"
#import "WKWebView+SoundCloud.h"
#import "NSURL+SoundCloud.h"

@interface AppDelegate ()

@property (nonatomic) WebWindowController *windowController;
@property (nonatomic) SUUpdater *updater;

@end

@implementation AppDelegate

#pragma mark - AppDelegate <NSApplicationDelegate>

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
#ifndef DEBUG
    PFMoveToApplicationsFolderIfNecessary();
#endif
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL soundCloudHomePageURL]];
    self.windowController = [[WebWindowController alloc] initWithRequest:request];
    [self.windowController showWindow:nil];
    
    [self.updater checkForUpdatesInBackground];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    
}

#pragma mark - AppDelegate

#pragma mark Updates

- (SUUpdater *)updater
{
    if (!_updater) {
        self.updater = [SUUpdater new];
    }
    return _updater;
}

#pragma mark Menu Items

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

- (IBAction)checkForUpdates:(id)sender
{
    [self.updater checkForUpdates:sender];
}

@end
