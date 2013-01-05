//
//  IntroViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntroViewController.h"
#import "IVLERequest.h"

@interface IntroViewController ()

@end

@implementation IntroViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize usernameValue;
@synthesize passwordValue;
@synthesize token;
@synthesize activity,segment;

-(IBAction)valuechanged:(id)sender{
    switch(segment.selectedSegmentIndex)
    {
        case 0:
            domain=@"NUSSTU";
            break;
        case 1:
            domain=@"NUSSTF";
            break;
        case 2:
            domain=@"NUSEXT";
            break;
    }
}

-(IBAction)login{
    self.usernameValue = usernameTextField.text;
    self.passwordValue = passwordTextField.text;
    activity.hidden=NO;
    [activity startAnimating];
    
    NSString* post=[NSString stringWithFormat:@"APIKey=Lq2C5n2ALv6dUgJ0neFn0&UserID=%@&Password=%@&Domain=%@",usernameValue,passwordValue,domain];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://ivle.nus.edu.sg/api/Lapi.svc/Login_XML?&output=xml"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    responseData=[[NSData alloc]initWithData:data];
    
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
    [activity stopAnimating];
    activity.hidden=YES;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activity stopAnimating];
    activity.hidden=YES;
    IVLERequest* parser=[[IVLERequest alloc]init];
    token=[parser returnUserID:responseData];
    
    if(token==nil){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Wrong Username or Password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self writeDatas];
        [self dismissModalViewControllerAnimated:YES];
    }
        
}

-(void)writeDatas{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IntroViewData.plist"];
    NSDictionary* temp=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    
    [temp setValue:token forKey:@"Token"];
    BOOL x=YES;
    [temp setValue:[NSNumber numberWithBool:x] forKey:@"showIntroView"];

    // write plistData to our Data.plist file
    BOOL a=[temp writeToFile:plistpath atomically:YES];
    if(!a){
        NSLog(@"FAIL");
    }else{
        NSLog(@"pass");
    }
}



-(IBAction)dismissTheModalView{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    domain=@"NUSSTU";
    activity.hidden=YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    if(animated==NO){
        [self resignFirstResponder];

    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [passwordTextField resignFirstResponder];
        [usernameTextField resignFirstResponder];
    }
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
