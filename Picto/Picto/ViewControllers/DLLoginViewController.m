//
//  DLLoginViewController.m
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLLoginViewController.h"
#import "DLLoginView.h"
#import "DLDribbbleAPI.h"
#import "DLShotLIstingTableViewController.h"

@interface DLLoginViewController ()<DLLoginViewDelegate>
@property (strong, nonatomic) IBOutlet DLLoginView *loginView;
@property (strong, nonatomic) DLDribbbleAPI *apiClient;
@end

@implementation DLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginView = [[[NSBundle mainBundle] loadNibNamed:@"DLLoginView"
                                   owner:self
                                 options:nil] lastObject];
    [self.view addSubview:self.loginView];
    
    [self.loginView setDelegate:self];
}

- (DLDribbbleAPI *)apiClient
{
    if (!_apiClient) {
        _apiClient = [DLDribbbleAPI sharedInstance];
    }
    return _apiClient;
}

- (void)loginView:(DLLoginView *)loginView loginStatus:(DLLoginStatus)status
{
    switch (status) {
        case DLLoginStatusOK:
            [self.apiClient authorize];
            break;
            
        case DLLoginStatusSkip:
            [self enterAppWithoutAuthorization];
            break;
            
        default:
            break;
    }
}

- (void)hasBeenAuthorized:(BOOL)isAuthorized
{
    if (isAuthorized) {
        [self.apiClient getAccessTokenWithView:self.navigationController.view completionHandler:^(id result, NSError *error) {
            if (result) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                DLShotLIstingTableViewController *listingTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShotListingTableViewController"];
                [self.navigationController pushViewController:listingTableViewController animated:YES];
            }
        }];
    } else {
        
    }
}

- (void)enterAppWithoutAuthorization
{
    [self.apiClient getAccessWithAppOnView:self.navigationController.view completionHandler:^(id result, NSError *error) {
        if (result) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            DLShotLIstingTableViewController *listingTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShotListingTableViewController"];
            [self.navigationController pushViewController:listingTableViewController animated:YES];
        }
    }];
}

@end
