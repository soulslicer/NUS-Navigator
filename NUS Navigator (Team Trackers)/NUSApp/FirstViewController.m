//
//  FirstViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "IVLELoginParser.h"
#import "IVLEValidateParser.h"
#import "ModuleViewController.h"
#import "TodayViewControllerViewController.h"
#import "HelpViewController.h"

NSString* WELCOMEPAGE=@"http://www.a-iats.com/Welcome.html";
NSString* APIKEY=@"false";

@implementation FirstViewController
@synthesize message;
@synthesize introViewController;
@synthesize nameLabel,token,APIKey,moduleButton,todayButton;
@synthesize mapController;
@synthesize webview;

-(void)deleteInfo{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IVLESave.plist"];
    NSMutableDictionary* ivleDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    
    NSDictionary* emptyDic=[[NSDictionary alloc]init];
    [ivleDict setObject:emptyDic forKey:nameLabel.text];
    
    [ivleDict writeToFile:plistpath atomically:YES];
    
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Information Removed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)LoadHelpController{
    HelpViewController* helpController=[[HelpViewController alloc]init];
    [self presentModalViewController:helpController animated:YES];
}

-(void)updateCurrUser:(BOOL)userExists{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IVLESave.plist"];
    NSMutableDictionary* ivleDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    
    if(userExists==YES){
        [ivleDict setObject:nameLabel.text forKey:@"CurrUser"];
        if([ivleDict objectForKey:nameLabel.text]==nil){
            NSDictionary* tempDict=[[NSDictionary alloc]init];
            [ivleDict setObject:tempDict forKey:nameLabel.text];
        }
            
    }
    else
        [ivleDict setObject:@" " forKey:@"CurrUser"];
    
    [ivleDict writeToFile:plistpath atomically:YES];

}

-(void)buttonRemoveLoad:(BOOL)unlinkSelected{
    if(unlinkSelected==YES){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                  initWithTitle: @"Unlink"
                                                  style:UIBarButtonItemStyleDone 
                                                  target:self 
                                                  action:@selector(deleteInfo)];
    }else{
        self.navigationItem.rightBarButtonItem=nil;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle: @"Help"
                                              style:UIBarButtonItemStyleDone 
                                              target:self 
                                              action:@selector(LoadHelpController)];
}

-(void)loadFirstView{
    NSURL* url=[[NSURL alloc]initWithString:WELCOMEPAGE];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    APIKey=APIKEY;
    introViewController=[[IntroViewController alloc]init];
    
    //Load Token
    [self loadToken];
    NSLog(@"%@",token);
    
    //Check if token valid, if it is, enable buttons and save info
    if([token isEqualToString:@""]){
        loggedin=NO;
        nameLabel.text=@" ";
        moduleButton.enabled=NO;
        todayButton.enabled=NO;
        [self updateCurrUser:NO];
        [self buttonRemoveLoad:NO];
    }else{
        loggedin=YES;
        IVLEValidateParser* validate=[[IVLEValidateParser alloc]init];
        self.token=[validate returnValidate:token :APIKey];
        IVLELoginParser* loginParser=[[IVLELoginParser alloc]init];
        nameLabel.text=[loginParser returnUserID:token :APIKey];
        if(nameLabel.text==NULL){
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"No Connection" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            moduleButton.enabled=NO;
            todayButton.enabled=NO;
        }else{
            moduleButton.enabled=YES;
            todayButton.enabled=YES;
            [self updateCurrUser:YES];
            [self buttonRemoveLoad:YES];
        }
    }
}

- (void)viewDidLoad
{
    self.title=@"IVLE";
    [self loadFirstView];
}


- (void)viewWillAppear:(BOOL)animated
{

}

-(void)viewDidAppear:(BOOL)animated{
    if(animated==YES){
        [self loadFirstView];
        viewloading=NO;
    }
}

-(IBAction)modules:(id)sender{
    ModuleViewController* modView=[[ModuleViewController alloc]init];
    modView.APIKey=self.APIKey;
    modView.token=self.token;
    modView.mapController=mapController;
    [self.navigationController pushViewController:modView animated:YES];
}

-(IBAction)today:(id)sender{
    TodayViewControllerViewController* todayView=[[TodayViewControllerViewController alloc]init];
    todayView.APIKey=self.APIKey;
    todayView.token=self.token;
    todayView.mapController=mapController;
    todayView.name=nameLabel.text;
    [self.navigationController pushViewController:todayView animated:YES];
}

-(IBAction)logout:(id)sender{
    viewloading=YES;
    [self logoutErase];
    if(self.introViewController==nil){
        IntroViewController* temp=[[IntroViewController alloc]initWithNibName:@"IntroViewController" bundle:[NSBundle mainBundle]];
        self.introViewController=temp;
    }
    [self presentModalViewController:self.introViewController animated:YES];
}

-(void)logoutErase{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* temp=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    
    
    [temp setValue:@"" forKey:@"Token"];
    BOOL x=NO;
    [temp setValue:[NSNumber numberWithBool:x] forKey:@"showIntroView"];
    [temp writeToFile:plistpath atomically:YES];
    
    [self updateCurrUser:NO];

}

-(void)loadToken{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* temp=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    
    token = [temp objectForKey:@"Token"];
    
    if([token isEqualToString:@""]){
        [self writeLoginData:YES];
        NSLog(@"EMPTY");
    }else{
        [self writeLoginData:NO];
    }
}

-(void)writeLoginData:(BOOL)x{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* temp=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    
    [temp setValue:[NSNumber numberWithBool:x] forKey:@"showIntroView"];

    // write plistData to our Data.plist file
    BOOL a=[temp writeToFile:plistpath atomically:YES];
    if(!a){
        NSLog(@"FAIL");
    }else{
        NSLog(@"PASS");
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
