//
//  UserNotificationDispatch.m
//  SoundCloudy
//
//  Created by Eric Horacek on 11/2/14.
//  Copyright (c) 2014 Eric Horacek. All rights reserved.
//

#import <ReactiveCocoa/RACEXTScope.h>
#import "UserNotificationDispatch.h"
#import "SoundCloudTrackInfo.h"

@interface UserNotificationDispatch () <NSUserNotificationCenterDelegate>

@property (nonatomic, weak, readwrite) RACSignal *trackInfoSignal;
@property (nonatomic, readwrite) RACSubject *skipTrackSignal;
@property (nonatomic, readwrite) RACSubject *viewTrackSignal;
@property (nonatomic, readwrite) NSUserNotificationCenter *notificationCenter;

@end

@implementation UserNotificationDispatch

#pragma mark - UserNotificationDispatch

- (instancetype)initWithTrackInfoSignal:(RACSignal *)trackInfoSignal notificationCenter:(NSUserNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self) {
        self.trackInfoSignal = trackInfoSignal;
        self.notificationCenter = notificationCenter;
        self.notificationCenter.delegate = self;
        self.skipTrackSignal = [RACSubject new];
        self.viewTrackSignal = [RACSubject new];
    }
    return self;
}

- (void)dispatchUserNotificationFromTrackInfo:(SoundCloudTrackInfo *)trackInfo
{
    NSUserNotification *notification = [self userNotificationForTrackInfoTrackInfo:trackInfo];
    [self.notificationCenter deliverNotification:notification];
}

static NSString * const UserNotificationUserInfoTrackKey = @"UserNotificationUserInfoTrackKey";
static const char _showsButtons [] = {0x5F, 0x73, 0x68, 0x6F, 0x77, 0x73, 0x42, 0x75, 0x74, 0x74, 0x6F, 0x6E, 0x73};

- (NSUserNotification *)userNotificationForTrackInfoTrackInfo:(SoundCloudTrackInfo *)trackInfo
{
    NSParameterAssert(trackInfo);
    NSUserNotification *notification = [NSUserNotification new];
    // Display a button even though it's a "banner" notification
    NSString *showsButtonsKey = [[NSString alloc] initWithData:[NSData dataWithBytes:_showsButtons length:13] encoding:NSASCIIStringEncoding];
    if ([notification respondsToSelector:NSSelectorFromString(showsButtonsKey)]) {
        [notification setValue:@YES forKey:showsButtonsKey];
    }
    notification.actionButtonTitle = NSLocalizedString(@"Skip", nil);
    notification.hasActionButton = YES;
    notification.userInfo = @{
        UserNotificationUserInfoTrackKey : @YES
    };
    notification.title = trackInfo.trackName;
    switch (trackInfo.type) {
    case SoundCloudTrackInfoTypeTrack:
        notification.subtitle = trackInfo.artistName;
        break;
    case SoundCloudTrackInfoTypePlaylist:
        notification.subtitle = trackInfo.playlistName;
        break;
    }
    return notification;
}

- (void)setTrackInfoSignal:(RACSignal *)trackInfoSignal
{
    _trackInfoSignal = trackInfoSignal;
    @weakify(self);
    [[[self.trackInfoSignal distinctUntilChanged] ignore:nil] subscribeNext:^(SoundCloudTrackInfo *trackInfo) {
        @strongify(self);
        [self dispatchUserNotificationFromTrackInfo:trackInfo];
    }];
}

#pragma mark - UserNotificationDispatch <NSUserNotificationCenterDelegate>

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    // Contains a track info object
    if (!notification.userInfo[UserNotificationUserInfoTrackKey]) {
        // "Skip" button clicked
        if (notification.activationType == NSUserNotificationActivationTypeActionButtonClicked) {
            [(RACSubject *)self.skipTrackSignal sendNext:nil];
        }
        // Rest of the notification clicked
        else {
            [(RACSubject *)self.viewTrackSignal sendNext:nil];
        }
    }
}

@end
