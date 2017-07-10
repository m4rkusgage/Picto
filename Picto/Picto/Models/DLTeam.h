//
//  DLTeam.h
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLTeam : NSObject

@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyAvatarURL;

- (void)setDataWith:(NSDictionary *)dictionary;


@end
