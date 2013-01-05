//
//  TodayViewControllerViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import "Conversions.h"

@interface TodayViewControllerViewController : UIViewController{
    NSString* name;
    NSString* token;
    NSString* APIKey;
    UIActivityIndicatorView* activity;
    NSData* responseData;
    NSMutableArray* moduleArray;
    NSMutableArray* courseArray;
    UITableView* table;
    MapController* mapController;
    NSDictionary* buildingList;
    Conversions* convert;
}
@property(nonatomic)NSString* name;
@property(nonatomic)MapController* mapController;
@property(nonatomic)NSString* token;
@property(nonatomic)NSString* APIKey;
@property(nonatomic)IBOutlet UIActivityIndicatorView* activity;
@property(nonatomic)IBOutlet UITableView* table;

@end
