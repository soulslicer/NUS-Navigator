//
//  SelectViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * SELECT VIEW CONTROLLER
 
 This class does the following:
 
 1. Select a location in NUS and display it on the Map
 2. Select a phone number to call for a particular locale
 ************************************************************************/

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface SelectViewController : UITableViewController
{
    NSArray* campus;
    MapController* mapController;
}
@property(nonatomic)NSArray* campus;
@property(nonatomic,strong)MapController* mapController;

@end
