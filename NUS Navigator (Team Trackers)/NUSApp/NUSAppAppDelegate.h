//
//  NUSAppAppDelegate.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * TAB BAR CONTROLLER
 
 This class does the following:
 
 1. Generate the required plist data files in the documents directory
    so that they can be (updated) within the app
 2. Link MapController with all other views in the Tab so that they
    can interact
 3. Load IntroViewController (Log-in View) if not logged in
 ************************************************************************/

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "FirstViewController.h"
#import "SearchViewController.h"
#import "MapController.h"
#import "SearchRoomsViewController.h"
#import "FavouritesViewController.h"
#import "UniversalSearch.h"
#import "SelectViewController.h"

@interface NUSAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>{
    
    FirstViewController* ivleController;
    SearchViewController* searchviewController;
    SearchRoomsViewController* searchRoomsViewController;
    MapController* mapController;
    FavouritesViewController* favouritesViewController;
    UniversalSearch* universalSearchController;
    SelectViewController* selectViewController;

}

@property (nonatomic) IBOutlet UIWindow *window;
@property (nonatomic) IBOutlet UITabBarController *tabBarController;
@property(nonatomic)IBOutlet FirstViewController* ivleController;
@property(nonatomic)IBOutlet SearchViewController* searchviewController;
@property(nonatomic)IBOutlet MapController* mapController;
@property(nonatomic)IBOutlet FavouritesViewController* favouritesViewController;
@property(nonatomic)IBOutlet UniversalSearch* universalSearchController;
@property(nonatomic)IBOutlet SelectViewController* selectViewController;


@end
