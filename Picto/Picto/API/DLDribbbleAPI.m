//
//  DLDribbbleAPI.m
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLDribbbleAPI.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "DLShot.h"

@interface DLDribbbleAPI ()
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation DLDribbbleAPI

+ (DLDribbbleAPI *)sharedInstance
{
    static dispatch_once_t onceToken;
    static DLDribbbleAPI *_instance;
    
    dispatch_once(&onceToken, ^{
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
        
        [_instance setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition (NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential) {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }];
    });
    return _instance;
}

- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithFrame:CGRectZero];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.label.text = @"Loading";
    }
    return _hud;
}

- (DLOAuthCredential *)credential
{
    if (!_credential){
        _credential = [DLOAuthCredential sharedInstance];
    }
    return _credential;
}

- (void)authorize
{
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&scope=public+write+comment+upload",kDLDribbbleAuthorizeURL,kDLDribbbleClientID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]
                                       options:@{}
                             completionHandler:^(BOOL success) {
    }];
}

- (void)getAccessTokenWithView:(UIView *)view completionHandler:(DLResultBlock)completionHandler
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    NSDictionary *parameters = @{@"client_id":kDLDribbbleClientID,
                                 @"client_secret":kDLDribbbleClientSecret,
                                 @"code":self.credential.accessCode};
    
    [self POST:kDLDribbbleGetTokenURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        self.credential.accessToken = responseDictionary[@"access_token"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.credential];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"oauthCredential"];
        [self setAuthorizationLevel:DLAccessLevelOAuth];
        
        [MBProgressHUD hideHUDForView:view animated:YES];
        completionHandler(@YES, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@",error);
        completionHandler(@NO, error);
    }];
}

- (void)getAccessWithAppOnView:(UIView *)view completionHandler:(DLResultBlock)completionHandler
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self setAuthorizationLevel:DLAccessLevelApp];
    [MBProgressHUD hideHUDForView:view animated:YES];
    completionHandler(@YES, nil);
}

- (void)shots:(NSString *)listType page:(int)page completionHandler:(DLResultBlock)resultsBlock
{
    NSDictionary *parameters = @{@"per_page": @(self.perPage),
                                 @"page": @(page)};
    
    [self GET:listType parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (resultsBlock)
        {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSMutableArray *shotsArray = [[NSMutableArray alloc] init];
                for (NSDictionary *shotDictionary in (NSArray *)responseObject) {
                    DLShot *shot = [[DLShot alloc] init];
                    [shot setDataWith:shotDictionary];
                    [shotsArray addObject:shot];
                }
                resultsBlock(shotsArray, nil);
            } else {
                resultsBlock(nil, nil);
            }
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

- (void)setAuthorizationLevel:(DLAccessLevel)access
{
    switch (access) {
        case DLAccessLevelApp:
            [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.credential.accessAppToken] forHTTPHeaderField:@"Authorization"];
            break;
            
        case DLAccessLevelOAuth:
            [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.credential.accessToken] forHTTPHeaderField:@"Authorization"];
            break;
            
        default:
            break;
    }
}

@end
