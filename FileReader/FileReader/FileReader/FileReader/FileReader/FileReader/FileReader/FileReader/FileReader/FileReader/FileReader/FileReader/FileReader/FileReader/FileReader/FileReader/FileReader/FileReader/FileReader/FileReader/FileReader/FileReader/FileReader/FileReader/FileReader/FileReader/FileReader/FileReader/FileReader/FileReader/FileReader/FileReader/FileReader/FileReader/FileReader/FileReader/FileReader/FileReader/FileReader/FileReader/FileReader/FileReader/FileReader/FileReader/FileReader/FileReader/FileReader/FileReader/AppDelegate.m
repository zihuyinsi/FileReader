//
//  AppDelegate.m
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _viewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: _viewController];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    [self performSelectorInBackground: @selector(wirteFileToDocument) withObject: nil];
    
    return YES;
}

- (void) wirteFileToDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Resour资源文件夹
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat: @"/Resour"];
    NSMutableArray *txtArray = [[NSMutableArray alloc] init];
    [txtArray addObjectsFromArray: [fileManager contentsOfDirectoryAtPath: defaultDBPath error: nil]];
    
    NSMutableArray *documentFileArray = [[NSMutableArray alloc] init];
    [documentFileArray addObjectsFromArray: [fileManager contentsOfDirectoryAtPath: DoucmentPath error: nil]];
    
    for (int i = 0; i < [txtArray count]; i++)
    {
        NSString *nameStr = [txtArray objectAtIndex: i];
        
        if (![documentFileArray containsObject: nameStr])
        {
            BOOL success = [fileManager copyItemAtPath: [NSString stringWithFormat: @"%@/%@", defaultDBPath, nameStr] toPath:[NSString stringWithFormat: @"%@/%@", DoucmentPath, nameStr] error: nil];
            if (success)
            {
                MyLog(@"文件路径： %@", [NSString stringWithFormat: @"%@/%@", DoucmentPath, nameStr]);
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
