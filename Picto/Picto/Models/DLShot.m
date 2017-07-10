//
//  DLShot.m
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLShot.h"
#import "DLOAuthCredential.h"

@interface DLShot ()
@property (strong, nonatomic) DLOAuthCredential *credential;
@end

@implementation DLShot

- (void)setDataWith:(NSDictionary *)dictionary
{
    self.isAnimated = [dictionary[@"animated"] boolValue];
    
    self.shotID = [dictionary[@"id"] intValue];
    self.bucketCount = [dictionary[@"buckets_count"] intValue];
    self.likeCount = [dictionary[@"likes_count"] intValue];
    self.reboundCount = [dictionary[@"rebounds_count"] intValue];
    self.viewCount = [dictionary[@"views_count"] intValue];
    self.commentCount = [dictionary[@"comments_count"] intValue];
    
    self.title = dictionary[@"title"];
    self.shotDescription = dictionary[@"description"];
    self.createdAt = [self normalizeDateFormat:dictionary[@"created_at"]];
    
    NSArray *tagArray = dictionary[@"tags"];
    for (NSString *tagItem in tagArray) {
        [self.tags addObject:tagItem];
    }
    
    if (![dictionary[@"team"] isKindOfClass:[NSNull class]]) {        
        DLTeam *team = [[DLTeam alloc] init];
        [team setDataWith:dictionary[@"team"]];
        self.team = team;
    }
    
    if (dictionary[@"user"]) {
        DLUser *user = [[DLUser alloc] init];
        [user setDataWith:dictionary[@"user"]];
        self.user = user;
    } else {
        self.user = self.credential.oAuthUser;
    }
    
    self.imageURLString = dictionary[@"images"][@"normal"];
}

- (NSMutableArray *)tags
{
    if (!_tags) {
        _tags = [[NSMutableArray alloc] init];
    }
    return _tags;
}

- (DLOAuthCredential *)credential
{
    if (!_credential) {
        _credential = [DLOAuthCredential sharedInstance];
    }
    return _credential;
}

- (NSString *)normalizeDateFormat:(NSString *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *dates = [dateFormatter dateFromString:date];
    
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:dates];
    return newDate;
}


@end
