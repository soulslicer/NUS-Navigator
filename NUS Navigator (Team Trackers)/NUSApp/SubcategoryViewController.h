//
//  SubcategoryViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface SubcategoryViewController : UITableViewController{
    NSArray* subcategory;
    MapController* mapController;
}
@property(nonatomic)NSArray* subcategory;
@property(nonatomic,strong)MapController* mapController;


@end
