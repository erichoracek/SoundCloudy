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

@property (nonatomic, readonly) RACSignal *isPlaying;
@property (nonatomic, readonly) RACSignal *isSoundCloudURL;

- (void)play;
- (void)next;
- (void)prev;
- (void)help;

@end
