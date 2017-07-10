//
//  DLTeam.m
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLTeam.h"

@implementation DLTeam

- (void)setDataWith:(NSDictionary *)dictionary
{
    self.companyName = dictionary[@"name"];
    self.companyAvatarURL = dictionary[@"avatar_url"];
}

@end
