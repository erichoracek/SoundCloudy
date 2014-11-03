//
//  WKWebView+SoundCloud.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WKWebView (SoundCloud)

@property (nonatomic, readonly) RACSignal *isPlayingSignal;
@property (nonatomic, readonly) RACSignal *isSoundCloudURLSignal;
@property (nonatomic, readonly) RACSignal *trackInfoSignal;

- (void)play;
- (void)next;
- (void)prev;
- (void)help;
- (void)scrollToCurrentTrack;

@end
