//
//  MediaKeys.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MediaKeys : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) RACSignal *playKeySignal;
@property (nonatomic, readonly) RACSignal *nextKeySignal;
@property (nonatomic, readonly) RACSignal *prevKeySignal;

@end
