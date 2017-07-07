//
//  AppDelegate.m
//  Picto
//
//  Created by Mark Gage on 2017-07-06.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "AppDelegate.h"
#import "DLDribbbleAPI.h"

@interface AppDelegate ()
@property (strong, nonatomic) DLDribbbleAPI *apiClient;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.apiClient authorize];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (!url) {
        return NO;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[url absoluteString]];
    
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"code"]) {
            [self.apiClient setApiCode:item.value];            
        }
    }
    return YES;
}

- (DLDribbbleAPI *)apiClient
{
    if (!_apiClient) {
        _apiClient = [DLDribbbleAPI sharedInstance];
    }
    return _apiClient;
}

@end
