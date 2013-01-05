//
//  UniversalSearch.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 19/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * UNIVERSAL SEARCH VIEW CONTROLLER
 
 This class does the following:
 
 1. Select a search type (Bus,Carpark,Room,Building)
 2. Select it to view it on the map
 ************************************************************************/

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface UniversalSearch : UIViewController{
    MapController* mapController;
    UIView* views;
    UIToolbar* tool;
    UITabBarController *tabBarController;
}
@property(nonatomic,retain)MapController* mapController;
@property(nonatomic,retain)IBOutlet UIView* views;
@property(nonatomic,retain)IBOutlet UIToolbar* tool;
@property (nonatomic,retain)UITabBarController *tabBarController;

- (IBAction)toggleControls:(id)sender;

@end
