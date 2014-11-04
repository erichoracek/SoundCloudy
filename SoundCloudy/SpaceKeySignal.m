//
//  SpaceKeySignal.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "SpaceKeySignal.h"

@interface SpaceKeySignal ()

@property (nonatomic) id monitor;

@end

@implementation SpaceKeySignal

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        self.monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *event) {
            @strongify(self);
            [self handleKeyDownEvent:event];
            return event;
        }];
    }
    return self;
}

- (void)dealloc
{
    [NSEvent removeMonitor:self.monitor];
}

static unsigned short const SpaceKeyCode = 49;

- (void)handleKeyDownEvent:(NSEvent *)event;
{
    if (event.keyCode == SpaceKeyCode) {
        [self sendNext:event];
    }
}

@end
