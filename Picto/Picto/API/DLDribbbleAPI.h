//
//  DLDribbbleAPI.h
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^DLResultBlock)(id result, NSError *error);

@interface DLDribbbleAPI : AFHTTPSessionManager

@property (assign, nonatomic) NSInteger perPage;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *apiCode;

+ (DLDribbbleAPI *)sharedInstance;

- (void)authorize;
- (void)getAccessToken;
- (void)popularShots:(int)page completionHandler:(DLResultBlock)completionHandler;

@end
