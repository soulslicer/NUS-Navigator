//
//  RouterView.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouterView.h"

@interface RouterView ()

@end

@implementation RouterView
@synthesize mapController,one,two,three,four,five;

BOOL nearestype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)close{
    [self.mapController closeRouterView];
}

-(IBAction)clickRoute{
    combination=8;
    
    if((one.selectedSegmentIndex==0) && (four.selectedSegmentIndex==0))
        combination=0;
    if((one.selectedSegmentIndex==0) && (four.selectedSegmentIndex==1))
        combination=1;
    if((one.selectedSegmentIndex==1) && (four.selectedSegmentIndex==0))
        combination=2;
    if((one.selectedSegmentIndex==1) && (four.selectedSegmentIndex==1))
        combination=3;
    else if((two.selectedSegmentIndex==0) && (three.selectedSegmentIndex==0))
        combination=4;
    else if((two.selectedSegmentIndex==0) && (three.selectedSegmentIndex==1))
        combination=5;
    else if((two.selectedSegmentIndex==1) && (three.selectedSegmentIndex==0))
        combination=6;
    else if((two.selectedSegmentIndex==1) && (three.selectedSegmentIndex==1))
        combination=7;
    
    if(five.selectedSegmentIndex==0){
        self.mapController.shortestOrFastest=YES;
    }else{
        self.mapController.shortestOrFastest=NO;
    }
    
    [self.mapController routingActions:combination];
    [self.mapController closeRouterView];
}

-(IBAction)valueChanged:(id)sender{
    if((sender==one) || (sender==four)){
        [two setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [three setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        if(one.selectedSegmentIndex==0){
            [four setTitle:@"Nearest" forSegmentAtIndex:0];
            [four setTitle:@"Opposite" forSegmentAtIndex:1];
        }else if(one.selectedSegmentIndex==1){
            [four setTitle:@"Visitor" forSegmentAtIndex:0];
            [four setTitle:@"All" forSegmentAtIndex:1];
        }
    }
    if((sender==two) || (sender==three)){
        [one setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [four setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
