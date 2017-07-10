//
//  DLUser.m
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLUser.h"

@implementation DLUser

- (void)setDataWith:(NSDictionary *)dictionary
{
    self.username = dictionary[@"username"];
    self.name = dictionary[@"name"];
    self.avatarURL = dictionary[@"avatar_url"];
}

@end
