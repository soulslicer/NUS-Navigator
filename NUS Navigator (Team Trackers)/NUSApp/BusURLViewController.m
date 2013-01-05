//
//  BusURLViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusURLViewController.h"

@interface BusURLViewController ()

@end

@implementation BusURLViewController
@synthesize busInfoURL,item,busName,stringURL,webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(dismiss)];
    self.item.title=busName;
    self.item.rightBarButtonItem=editButton;
    
    self.busInfoURL=[[NSURL alloc]initWithString:stringURL];
    NSURLRequest* url=[[NSURLRequest alloc]initWithURL:busInfoURL];
    [webView loadRequest:url];
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
