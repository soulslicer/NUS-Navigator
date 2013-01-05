//
//  NUSAppAppDelegate.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NUSAppAppDelegate.h"
#import "IntroViewController.h"
#import "GenerateFiles.h"

@implementation NUSAppAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize searchviewController,mapController,favouritesViewController,universalSearchController,selectViewController,ivleController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Generate Files
    GenerateFiles* generateFiles=[[GenerateFiles alloc]init];
    [generateFiles generateFiles];
    
    //Check if User Files Exist yet or elese we will create them
    // 1.IntroView
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath1 = [path1 stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* introCheck=[[NSDictionary alloc]initWithContentsOfFile:plistpath1];
    if(introCheck==nil){
        NSMutableDictionary* temps=[[NSMutableDictionary alloc]init];
        BOOL check=YES;
        [temps setObject:@"" forKey:@"Token"];
        [temps setObject:[NSNumber numberWithBool:check]forKey:@"showIntroView"];
        [temps writeToFile:plistpath1 atomically:YES];
    }
    introCheck=nil;
    
    // 2. IVLESAVE
    NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath2 = [path2 stringByAppendingPathComponent:@"IVLESave.plist"];
    NSDictionary* ivleCheck=[[NSDictionary alloc]initWithContentsOfFile:plistpath2];
    if(ivleCheck==nil){
        NSMutableDictionary* temps=[[NSMutableDictionary alloc]init];
        [temps setObject:@" " forKey:@"CurrUser"];
        [temps writeToFile:plistpath2 atomically:YES];
    }
    ivleCheck=nil;
    
    // 3. FAVLIST
    NSString *path3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath3 = [path3 stringByAppendingPathComponent:@"FavData.plist"];
    NSDictionary* favCheck=[[NSDictionary alloc]initWithContentsOfFile:plistpath3];
    if(favCheck==nil){
        NSMutableDictionary* temps=[[NSMutableDictionary alloc]init];
        [temps writeToFile:plistpath3 atomically:YES];
    }
    favCheck=nil;
    
    //Linking mapController with other views
    self.searchviewController.mapController=self.mapController;
    self.favouritesViewController.mapController=self.mapController;
    self.universalSearchController.mapController=self.mapController;
    self.selectViewController.mapController=self.mapController;
    self.universalSearchController.tabBarController=self.tabBarController;
    self.ivleController.mapController=self.mapController;
    
    //Set root as tab bar controller
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    //Show the IntroView (Login Screen) if not logged in first
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* temp=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    BOOL showIntroView = [[temp objectForKey:@"showIntroView"] boolValue];
    IntroViewController* introController = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:[NSBundle mainBundle]];
    if (showIntroView) {
        [self.window.rootViewController presentModalViewController:introController animated:NO];
    }    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
