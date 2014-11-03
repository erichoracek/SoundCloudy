//
//  NSURL+SoundCloud.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/3/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SoundCloudHost;

@interface NSURL (SoundCloud)

+ (NSURL *)soundCloudHomePageURL;

@property (nonatomic, readonly) BOOL isOnSoundCloudDomain;

@end
