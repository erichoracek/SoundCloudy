//
//  SoundCloudTrackInfo.h
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SoundCloudTrackInfoType) {
    SoundCloudTrackInfoTypePlaylist,
    SoundCloudTrackInfoTypeTrack
};

@interface SoundCloudTrackInfo : NSObject

@property (nonatomic) SoundCloudTrackInfoType type;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *playlistName;

@end
