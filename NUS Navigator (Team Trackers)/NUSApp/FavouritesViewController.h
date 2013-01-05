//
//  FavouritesViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import "PointDetails.h"
#import "MBProgressHUD.h"

@interface FavouritesViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *list;
    NSMutableDictionary* listDict;
    UITableView* tableViews;
    MapController* mapController;
    PointDetails* pointDetails;
    
}
@property (nonatomic) NSMutableArray *list;
@property(nonatomic)IBOutlet UITableView* tableViews;
@property(nonatomic)NSMutableDictionary* listDict;
@property(nonatomic)MapController* mapController;
- (IBAction)toggleEdit:(id)sender;
-(void)loaddata;
-(void)writedata;
@end

