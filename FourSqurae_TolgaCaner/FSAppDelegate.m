//
//  FSAppDelegate.m
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 25/04/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import "FSAppDelegate.h"

@implementation FSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.controller = [[FSViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.controller];
    
    
    [self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // NOTE: Here we grab the instatest:// url when safari redirects back to our application from the OAuth 2 flow. Don't forget to set this URL type (instatest://) under Info in Project Settings.
    
    NSLog(@"url: %@", url.absoluteString);
    NSLog(@"sourceApplication: %@", sourceApplication);
    NSLog(@"annotation: %@", annotation);
    
    NSArray *splittedString = [url.absoluteString componentsSeparatedByString:@"="];
    NSString *accessToken = splittedString[1];
    [self.controller saveToken:accessToken];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
