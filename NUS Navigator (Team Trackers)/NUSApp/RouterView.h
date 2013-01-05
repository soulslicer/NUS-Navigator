//
//  RouterView.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@class MapController;
@interface RouterView : UIViewController{
    int combination;
    MapController* mapController;
    UISegmentedControl* one;
    UISegmentedControl* two;
    UISegmentedControl* three;
    UISegmentedControl* four;
    UISegmentedControl* five;
}
@property(nonatomic)MapController* mapController;
@property(nonatomic)IBOutlet UISegmentedControl* one;
@property(nonatomic)IBOutlet UISegmentedControl* two;
@property(nonatomic)IBOutlet UISegmentedControl* three;
@property(nonatomic)IBOutlet UISegmentedControl* four;
@property(nonatomic)IBOutlet UISegmentedControl* five;

-(IBAction)close;
-(IBAction)valueChanged:(id)sender;
-(IBAction)clickRoute;


@end
