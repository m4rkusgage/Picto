//
//  DLShot.h
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLUser.h"
#import "DLTeam.h"

@interface DLShot : NSObject

@property (assign, nonatomic) BOOL isAnimated;
@property (assign, nonatomic) int bucketCount;
@property (assign, nonatomic) int likeCount;
@property (assign, nonatomic) int reboundCount;
@property (assign, nonatomic) int viewCount;
@property (assign, nonatomic) int commentCount;
@property (assign, nonatomic) int shotID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *shotDescription;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) DLUser *user;
@property (strong, nonatomic) DLTeam *team;

- (void)setDataWith:(NSDictionary *)dictionary;
@end
