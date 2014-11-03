//
//  WKWebView+SoundCloud.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <objc/runtime.h>
#import "WKWebView+SoundCloud.h"
#import "NSURL+SoundCloud.h"
#import "SoundCloudTrackInfo.h"

typedef NS_ENUM(NSInteger, SoundCloudKeyCode) {
    SoundCloudKeyCodeNext = 74, // J
    SoundCloudKeyCodePrev = 75, // K
    SoundCloudKeyCodePlay = 32, // Space
    SoundCloudKeyCodeHelp = 72, // H
    SoundCloudKeyCodeScrollToCurrentTrack = 80 // P
};

static NSString * const SoundCloudKeydownJavaScript = @"\
    event = new Event('keydown');\
    event.keyCode = %ld;\
    document.dispatchEvent(event);\
";

@implementation WKWebView (SoundCloud)

#pragma mark Public

static NSString * const SoundCloudTitleIsPlayingString = @"▶ ";

- (RACSignal *)isPlayingSignal
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (!signal) {
        signal = [RACSignal combineLatest:@[RACObserve(self, title), self.isSoundCloudURLSignal] reduce:^id(NSString *title, NSNumber *isSoundCloudURL){
            return @(
                [isSoundCloudURL boolValue]
                && ([title rangeOfString:SoundCloudTitleIsPlayingString].location != NSNotFound)
            );
        }];
        objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return signal;
}

- (RACSignal *)isSoundCloudURLSignal
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (!signal) {
        signal = [RACObserve(self, URL) map:^id(NSURL *URL) {
            return @(URL.isOnSoundCloudDomain);
        }];
        objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return signal;
}

- (RACSignal *)artistNameSignal
{
    return nil;
}

static NSString * const SoundCloudSingleTrackArtistSeparatorString = @" by ";
static NSString * const SoundCloudPlaylistSeparatorString = @" in ";

- (RACSignal *)trackInfoSignal
{
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (!signal) {
        signal = [RACSignal combineLatest:@[RACObserve(self, title), self.isPlayingSignal] reduce:^id(NSString *title, NSNumber *isPlaying){
            if (!isPlaying) {
                return nil;
            }
            title = [title stringByReplacingOccurrencesOfString:SoundCloudTitleIsPlayingString withString:@""];
            // Single Track
            if ([title rangeOfString:SoundCloudSingleTrackArtistSeparatorString].location != NSNotFound) {
                NSArray *components = [title componentsSeparatedByString:SoundCloudSingleTrackArtistSeparatorString];
                SoundCloudTrackInfo *trackInfo = [SoundCloudTrackInfo new];
                trackInfo.type = SoundCloudTrackInfoTypeTrack;
                trackInfo.trackName = [components firstObject];
                trackInfo.artistName = [components lastObject];
                return trackInfo;
            }
            // Playlist
            if ([title rangeOfString:SoundCloudPlaylistSeparatorString].location != NSNotFound) {
                NSArray *components = [title componentsSeparatedByString:SoundCloudPlaylistSeparatorString];
                SoundCloudTrackInfo *trackInfo = [SoundCloudTrackInfo new];
                trackInfo.type = SoundCloudTrackInfoTypePlaylist;
                trackInfo.trackName = [components firstObject];
                trackInfo.playlistName = [components lastObject];
                return trackInfo;
            }
            return nil;
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

- (void)scrollToCurrentTrack
{
    [self evaluateJavaScriptForKeyCode:SoundCloudKeyCodeScrollToCurrentTrack];
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
