//
//  TimeTableViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import "Conversions.h"

@interface TimeTableViewController : UIViewController{
    NSString* courseID;
    NSString* token;
    NSString* APIKey;
    UIActivityIndicatorView* activity;
    NSData* responseData;
    NSMutableArray* courseArray;
    UITableView* table;
    MapController* mapController;
    NSDictionary* buildingList;
    Conversions* convert;
}
@property(nonatomic,retain)NSDictionary* buildingList;
@property(nonatomic)MapController* mapController;
@property(nonatomic)NSString* courseID;
@property(nonatomic)NSString* token;
@property(nonatomic)NSString* APIKey;
@property(nonatomic)IBOutlet UIActivityIndicatorView* activity;
@property(nonatomic)IBOutlet UITableView* table;
@end
