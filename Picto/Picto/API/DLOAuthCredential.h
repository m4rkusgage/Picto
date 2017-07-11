//
//  DLOAuthCredential.h
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLUser.h"

@interface DLOAuthCredential : NSObject<NSCoding>

@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *cliendSecret;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *accessAppToken;
@property (copy, nonatomic) NSString *accessCode;
@property (strong, nonatomic) DLUser *oAuthUser;

+ (DLOAuthCredential *)sharedInstance;
- (BOOL)isLoggedIn;

@end
