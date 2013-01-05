//
//  RouteDetails.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 30/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"
#import "MapController.h"

@interface RouteDetails : UIViewController{
    UINavigationItem* item;
    UITableView* table;
    NSMutableArray* route;
    MapController* mapController;
    NSMutableArray* busDisplayArray;
    UITableViewCell* tvCell;
    int closest;
}
@property(nonatomic)IBOutlet UINavigationItem* item;
@property(nonatomic)IBOutlet UITableView* table;
@property(nonatomic)IBOutlet NSMutableArray* route;
@property(nonatomic)MapController* mapController;
@property (nonatomic,strong) IBOutlet UITableViewCell *tvCell;

-(IBAction)dismiss;

@end
