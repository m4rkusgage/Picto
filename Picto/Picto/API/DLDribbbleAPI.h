//
//  DLDribbbleAPI.h
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DLOAuthCredential.h"

typedef void (^DLResultBlock)(id result, NSError *error);

typedef enum : NSUInteger {
    DLAccessLevelApp,
    DLAccessLevelOAuth
} DLAccessLevel;

@interface DLDribbbleAPI : AFHTTPSessionManager

@property (strong, nonatomic) DLOAuthCredential *credential;
@property (assign, nonatomic) NSInteger perPage;

+ (DLDribbbleAPI *)sharedInstance;

- (void)authorize;
- (void)getAccessTokenWithView:(UIView *)view completionHandler:(DLResultBlock)completionHandler;
- (void)getAccessWithAppOnView:(UIView *)view completionHandler:(DLResultBlock)completionHandler;

- (void)popularShots:(int)page completionHandler:(DLResultBlock)completionHandler;
- (void)oAuthUserShots:(int)page completionHandler:(DLResultBlock)completionHandler;

- (void)oAuthUser:(DLResultBlock)completionHandler;
- (void)getUser:(NSString *)userID completionHandler:(DLResultBlock)completionHandler;

- (void)setAuthorizationLevel:(DLAccessLevel)access;
@end
