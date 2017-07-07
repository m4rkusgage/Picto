//
//  ViewController.m
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "ViewController.h"
#import "DLDribbbleAPI.h"

@interface ViewController ()
@property (strong, nonatomic) DLDribbbleAPI *apiClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DLDribbbleAPI *)apiClient
{
    if (!_apiClient) {
        _apiClient = [DLDribbbleAPI sharedInstance];
    }
    return _apiClient;
}

- (void)updateData
{
    if (self.apiClient.apiCode) {
        [self.apiClient getAccessToken];
       /* NSDictionary *parameters = @{@"client_id":@"ca1cee99703b30482e9fdf433bac917324ba2f8c9e700233af59650841d4ce9d",
                                     @"client_secret":@"331dbb69baabcee9e487de27f7bff05c3a4884b2a244bb42d9827dd32093b0d2",
                                     @"code":self.apiClient.apiCode};
        
        [self.apiClient POST:@"https://dribbble.com/oauth/token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            NSLog(@"Result: %@",responseDictionary);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@",error);
        }];
        
        
        [self.apiClient setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition (NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential) {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }];*/
    }
}
@end
