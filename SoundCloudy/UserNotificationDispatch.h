//
//  UserNotificationDispatch.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UserNotificationDispatch : NSObject

- (instancetype)initWithTrackInfoSignal:(RACSignal *)trackInfoSignal notificationCenter:(NSUserNotificationCenter *)notificationCenter;

@property (nonatomic, weak, readonly) RACSignal *trackInfoSignal;
@property (nonatomic, readonly) NSUserNotificationCenter *notificationCenter;
@property (nonatomic, readonly) RACSignal *skipTrackSignal;
@property (nonatomic, readonly) RACSignal *viewTrackSignal;

@end
