//
//  LocationsViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"


@interface LocationsViewController : UITableViewController{
    NSArray* locations;
    NSDictionary* buildingList;
    MapController* mapController;
}
@property(nonatomic,retain)NSArray* locations;
@property(nonatomic,retain)NSDictionary* buildingList;
@property(nonatomic,strong)MapController* mapController;


@end
