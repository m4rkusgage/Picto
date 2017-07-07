//
//  DLDribbbleAPI.m
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLDribbbleAPI.h"


@implementation DLDribbbleAPI

+ (DLDribbbleAPI *)sharedInstance
{
    static dispatch_once_t onceToken;
    static DLDribbbleAPI *_instance;
    
    dispatch_once(&onceToken, ^{
        //_instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.dribbble.com/"]];
        _instance = [[self alloc] init];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        [policy setValidatesDomainName:NO];

        _instance.securityPolicy = policy;
        _instance.perPage = 30;
        _instance.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSOperationQueue *operationQueue = _instance.operationQueue;
        [_instance.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
    });
    return _instance;
}

- (void)authorize
{
    NSString *authURL = @"https://dribbble.com/oauth/authorize";
    NSString *clientString = @"client_id=ca1cee99703b30482e9fdf433bac917324ba2f8c9e700233af59650841d4ce9d";
    NSString *scopeString = @"scope=public+write+comment+upload&state=markgage86@";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@&%@",authURL,clientString,scopeString]] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)getAccessToken
{
    NSDictionary *parameters = @{@"client_id":@"ca1cee99703b30482e9fdf433bac917324ba2f8c9e700233af59650841d4ce9d",
                                 @"client_secret":@"331dbb69baabcee9e487de27f7bff05c3a4884b2a244bb42d9827dd32093b0d2",
                                 @"code":self.apiCode};
    
    [self POST:@"https://dribbble.com/oauth/token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        self.accessToken = responseDictionary[@"access_token"];
        
        [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.accessToken] forHTTPHeaderField:@"Authorization"];
        
        [self popularShots:1 completionHandler:^(id result, NSError *error) {
            NSArray *resultDict = (NSArray *)result;
            NSLog(@"Result: %@",result);
            NSLog(@"Error: %@",error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@",error);
    }];
    
    [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition (NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential) {
        return NSURLSessionAuthChallengePerformDefaultHandling;
    }];
}

- (void)shots:(NSString *)listType page:(int)page completionHandler:(DLResultBlock)resultsBlock
{
    NSDictionary *parameters = @{@"per_page": @(self.perPage),
                                 @"page": @(page)};
    
    [self GET:listType parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resultsBlock)
        {
            resultsBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (resultsBlock)
        {
            resultsBlock(nil, error);
        }
    }];
}

- (void)popularShots:(int)page completionHandler:(DLResultBlock)completionHandler
{
    [self shots:@"https://api.dribbble.com/v1/shots" page:page completionHandler:completionHandler];
}
@end
