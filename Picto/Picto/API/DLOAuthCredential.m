//
//  DLOAuthCredential.m
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLOAuthCredential.h"
#import "Constants.h"

@interface DLOAuthCredential ()
@property (assign, nonatomic, readwrite, getter=isLoggedIn) BOOL loginStatus;
@end

@implementation DLOAuthCredential

+ (DLOAuthCredential *)sharedInstance
{
    static dispatch_once_t onceToken;
    static DLOAuthCredential *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        _instance.clientID = kDLDribbbleClientID;
        _instance.cliendSecret = kDLDribbbleClientSecret;
        _instance.accessAppToken = kDLDribbbleClientAppToken;
    });
    
    return _instance;
}

- (BOOL)isLoggedIn
{
    if (self.accessToken.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hasAccessCode
{
    if (self.accessCode.length > 0) {
        return YES;
    }
    return NO;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    DLOAuthCredential *credential = [DLOAuthCredential sharedInstance];
    credential.accessToken = [decoder decodeObjectForKey:@"accessToken"];
    return credential;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    DLOAuthCredential *credential = [DLOAuthCredential sharedInstance];
    [encoder encodeObject:credential.accessToken forKey:@"accessToken"];
}
@end
