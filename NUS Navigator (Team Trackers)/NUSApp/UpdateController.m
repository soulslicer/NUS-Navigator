//
//  UpdateController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 13/8/12.
//
//

#import "UpdateController.h"
#import "GenerateFiles.h"
#import "SVProgressHUD.h"

@interface UpdateController ()

@end

@implementation UpdateController
@synthesize tabBarController,mapController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateSelector{
    GenerateFiles* genFiles=[[GenerateFiles alloc]init];
    [genFiles updateFiles];
    [SVProgressHUD dismiss];
}

-(IBAction)update:(id)sender{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"Updating"];
    [self performSelector:@selector(updateSelector) withObject:nil afterDelay:0.5];
}

-(IBAction)mail:(id)sender{
    // Check that a mail account is available
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        
        [emailController setSubject:@"Update!"];
        [emailController setMessageBody:@"Hi I'd like to update you" isHTML:YES];
        NSArray *arr=[NSArray arrayWithObjects:@"yaadhavraaj@me.com",nil];
        [emailController setToRecipients:arr];

//        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentModalViewController:emailController animated:YES];
        [self.tabBarController presentModalViewController:emailController animated:YES];
        
    }
    // Show error if no mail account is active
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    NSURL* url=[[NSURL alloc]initWithString:@"http://www.a-iats.com/Update.html"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
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
