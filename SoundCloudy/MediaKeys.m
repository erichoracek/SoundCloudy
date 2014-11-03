//
//  MediaKeys.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "SPMediaKeyTap.h"
#import "MediaKeys.h"

@interface MediaKeys ()

@property (nonatomic) SPMediaKeyTap *mediaKeyTap;
@property (nonatomic, readwrite) RACSubject *playKeySignal;
@property (nonatomic, readwrite) RACSubject *nextKeySignal;
@property (nonatomic, readwrite) RACSubject *prevKeySignal;

@end

@implementation MediaKeys

+ (void)initialize;
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        kMediaKeyUsingBundleIdentifiersDefaultsKey: [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers]
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mediaKeyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
        if ([SPMediaKeyTap usesGlobalMediaKeyTap]) {
            [self.mediaKeyTap startWatchingMediaKeys];
        } else {
            NSLog(@"%@: Media key monitoring disabled", [self class]);
        }
        self.playKeySignal = [RACSubject new];
        self.nextKeySignal = [RACSubject new];
        self.prevKeySignal = [RACSubject new];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - SPMediaKeyTap "Delegate"

-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event
{
    NSAssert(
        (
            ([event type] == NSSystemDefined)
            && ([event subtype] == SPSystemDefinedEventMediaKeys)
        ),
        @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:"
     );
    
    int keyCode = (([event data1] & 0xFFFF0000) >> 16);
    int keyFlags = ([event data1] & 0x0000FFFF);
    BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;
    
    if (!keyIsPressed) {
        return;
    }
    
    switch (keyCode) {
    case NX_KEYTYPE_PLAY:
        [(RACSubject *)self.playKeySignal sendNext:event];
        break;
    case NX_KEYTYPE_FAST:
        [(RACSubject *)self.nextKeySignal sendNext:event];
        break;
    case NX_KEYTYPE_REWIND:
        [(RACSubject *)self.prevKeySignal sendNext:event];
        break;
    }
}

@end
