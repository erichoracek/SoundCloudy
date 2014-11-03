//
//  WebWindowController.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebViewController;

@interface WebWindowController : NSWindowController

- (instancetype)initWithRequest:(NSURLRequest *)request;

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) WebViewController *webViewController;

@end
