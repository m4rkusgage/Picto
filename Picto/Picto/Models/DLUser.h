//
//  DLUser.h
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatarURL;

- (void)setDataWith:(NSDictionary *)dictionary;

@end
