//
//  GoogleRouteViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleRouteViewController.h"

@interface GoogleRouteViewController ()

@end

@implementation GoogleRouteViewController
@synthesize webView,transfer,start,item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)openGoogleMaps{
    NSURL* url=[[NSURL alloc]initWithString:googleMapsURLString];
     [[UIApplication sharedApplication] openURL:url];
}

- (void)viewDidLoad
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(dismiss)];
    self.item.title=@"Normal Routing";
    self.item.rightBarButtonItem=editButton;
    
    UIBarButtonItem *openButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Maps"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(openGoogleMaps)];
    self.item.leftBarButtonItem=openButton;
    
    CLLocationCoordinate2D destination={ transfer.coordinate.latitude,transfer.coordinate.longitude};
    googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f&output=embed&t=h",start.coordinate.latitude, start.coordinate.longitude, destination.latitude, destination.longitude];
    NSURL* url=[[NSURL alloc]initWithString:googleMapsURLString];
    NSURLRequest* req=[[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:req];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)dismiss{
    [self dismissModalViewControllerAnimated:YES];
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
