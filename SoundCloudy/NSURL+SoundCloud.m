//
//  NSURL+SoundCloud.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/3/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "NSURL+SoundCloud.h"

NSString * const SoundCloudHost = @"soundcloud.com";

@implementation NSURL (SoundCloud)

+ (NSURL *)soundCloudHomePageURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", SoundCloudHost]];
}

- (BOOL)isOnSoundCloudDomain
{
    return ([self.host rangeOfString:SoundCloudHost].location != NSNotFound);
}

@end
