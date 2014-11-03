//
//  SoundCloudTrackInfo.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import "SoundCloudTrackInfo.h"

@implementation SoundCloudTrackInfo

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        // Lazy equality
        return (self.hash == [object hash]);
    }
    return [super isEqual:object];
}

- (NSUInteger)hash
{
    return (self.artistName.hash ^ self.trackName.hash ^ self.playlistName.hash);
}

@end
