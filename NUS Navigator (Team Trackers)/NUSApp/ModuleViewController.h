//
//  ModuleViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface ModuleViewController : UIViewController{
    NSString* token;
    NSString* APIKey;
    UIActivityIndicatorView* activity;
    NSData* responseData;
    NSMutableArray* moduleArray;
    UITableView* table;
    MapController* mapController;
}
@property(nonatomic)MapController* mapController;
@property(nonatomic)NSString* token;
@property(nonatomic)NSString* APIKey;
@property(nonatomic)IBOutlet UIActivityIndicatorView* activity;
@property(nonatomic)IBOutlet UITableView* table;

@end
