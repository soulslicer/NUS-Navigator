//
//  PointDetails.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PointDetails.h"
#import "RoomDetailParser.h"
#import "RoomDetails.h"
#import "BusURLViewController.h"
#import "thumbNail.h"
#import "MBProgressHUD.h"
#import <MobileCoreServices/UTCoreTypes.h>

/************************************************************************
 * IMAGE/CAMERA FUNCTIONS
 ************************************************************************/

@interface PointDetails ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation PointDetails
@synthesize names;
@synthesize keys;
@synthesize information;
@synthesize tvCell;
@synthesize mapInfoType;
@synthesize hideNavBar;
@synthesize image;
@synthesize table,takePicture,deletePic,grabPicture,imageView,mapController,phoneNumber;

NSString* temp;
NSString* temp2;
NSString* temp3;

-(void)checkImageKey:(BOOL)add{
    if(add){
        if(![keys containsObject:@"Image"]){
            [keys insertObject:@"Image" atIndex:1];
        }
    }else{//remove
        if([keys containsObject:@"Image"])
            [keys removeObject:@"Image"];
    }
}

- (IBAction)shootPictureOrVideo:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPictureOrVideo:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(IBAction)deletePic:(id)sender{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* imagepath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",temp]];
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:imagepath error:&error];
    [self updateDisplay];
    [self checkImageKey:NO];
    [table reloadData];
}

#pragma mark  -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale,
												 size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context,
					   CGRectMake(0, 0, size.width * scale, size.height * scale),
					   original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(context);
    CGImageRelease(shrunken);	
	
    return final;
}

- (void)updateDisplay {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* imagepath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",temp]];
    self.image=[[UIImage alloc]initWithContentsOfFile:imagepath];
    
    if(self.image==nil){
        NSLog(@"No Image");
        imageFrame=CGRectMake(0, 0, 320, 320);
    }else{
        NSLog(@"Image available");
        imageView=[[UIImageView alloc]initWithImage:self.image];
        imageFrame = imageView.frame;
        imageView.frame=CGRectMake(0, 0, 320, 320);
        image=[image makeThumbnailOfSize:CGSizeMake(300, 300)];
        [table reloadData];
        //[tmps release];
    }
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
    UIImage* images=[[UIImage alloc]init];
    images = shrunkenImage;
    
    NSData* pngData=UIImagePNGRepresentation(images);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory 
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",temp]]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    [picker dismissModalViewControllerAnimated:YES];
    [self checkImageKey:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
						   availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
							   availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing media" 
                              message:@"Device doesn’t support that media source." 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self shootPictureOrVideo:nil];
            NSLog(@"0");
            break;
            
        case 1:
            [self deletePic:nil];
            NSLog(@"1");
            break;
            
        case 2:
            [self selectExistingPictureOrVideo:nil];
            NSLog(@"2");
            break;
            
        default:
            break;
    }
    
}

-(void)alert{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Select Function" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Delete",@"Library",@"Cancel", nil];
    [alert show];
}


/************************************************************************
 * CONSTRUCTORS
 ************************************************************************/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadarray:(NSString*)one: (NSString*)two: (NSString*)three: (NSString*)four: (NSString*)five{
    temp=one;
    temp2=four;
    temp3=two;
    
    one=[NSString stringWithFormat:@"Title: %@",one];
    two=[NSString stringWithFormat:@"Short: %@",two];
    three=[NSString stringWithFormat:@"Alias: %@",three];
    
    if([five isEqualToString:@"Bus"])
        four=[NSString stringWithFormat:@"Buses: %@",four];
    else if([five isEqualToString:@"Carpark"])
        four=[NSString stringWithFormat:@"Type: %@",four];
    else
        four=[NSString stringWithFormat:@"Building: %@",four];
    
    mapInfoType=five;
    information=[[NSMutableArray alloc]initWithObjects:one,two,three,four, nil];
    if([two isEqualToString:@"Short: "])
        [information removeObject:@"Short: "];
    if([three isEqualToString:@"Alias: "])
        [information removeObject:@"Alias: "];
    if([two isEqualToString:@"Short:  "])
        [information removeObject:@"Short:  "];
    if([three isEqualToString:@"Alias:  "])
        [information removeObject:@"Alias:  "];
    
}

-(void)loadAllInfo{
    
    [self updateDisplay];
    convert=[[Conversions alloc]init];
    NSArray* x=[temp componentsSeparatedByString:@" ("];
    NSString* newStr=[x objectAtIndex:0];
    RoomDetailParser* parser=[[RoomDetailParser alloc]init];
    
    //Room or Bus Checking or Carpark
    NSMutableArray* roomArr;
    NSArray* busArr;
    NSArray* carArr;
    if([mapInfoType isEqualToString:@"Room"]){
        [parser initWithContentRoomCode:temp];
        roomArr=[parser returnList];
    }else if([mapInfoType isEqualToString:@"Normal"]){
        NSLog(@"function called on %@",newStr);
        [parser initWithContent:newStr];
        roomArr=[parser returnList];
    }else if([mapInfoType isEqualToString:@"Bus"]){
        busParser=[[BusParsingNew alloc]init];
        [busParser loadData:temp];
        NSString *pathfulllist = [[NSBundle mainBundle] pathForResource:@"BusStopServices" ofType:@"plist"];
        NSDictionary* busDict=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
        busArr=[busDict objectForKey:temp3]; busList=busArr;
    }else if([mapInfoType isEqualToString:@"Carpark"]){
        carparkParser=[[CarParkParser alloc]init];
        [carparkParser refreshData];
        NSString *pathfulllist = [[NSBundle mainBundle] pathForResource:@"CarPark" ofType:@"plist"];
        NSDictionary* carDict=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
        NSArray* holdArr=[carDict objectForKey:temp3];
        carArr=[[NSArray alloc]initWithObjects:holdArr, nil];
    }else{
        mapInfoType=@"Normal";
        NSLog(@"function called on %@",newStr);
        [parser initWithContent:newStr];
        roomArr=[parser returnList];
    }
    
    
    
    //Check for Food Type
    NSMutableArray* foodArray=[[NSMutableArray alloc]init];;
    for(NSString* tempstring in information){
        if([tempstring isEqualToString:@"Alias: Food"] || [tempstring isEqualToString:@"Alias: Canteen"]){
            [foodArray addObject:temp];
            mapInfoType=@"Food";
        }
    }
    
    //Check for IVLE Info
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IVLESave.plist"];
    NSDictionary* ivleDict=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    NSString* userName=[ivleDict objectForKey:@"CurrUser"];
    NSDictionary* userDict=[ivleDict objectForKey:userName];
    NSArray* ivleArray=[userDict objectForKey:temp];
    
    names=[[NSMutableDictionary alloc]init];
    keys=[[NSMutableArray alloc]initWithObjects:@"Info",@"Image", nil];
    
    //For Image cell
    NSArray* arr=[[NSArray alloc]initWithObjects:@"a", nil];
    [names setObject:arr forKey:@"Image"];
    if(image==nil)
        [keys removeObject:@"Image"];
    
    //For Basic Info
    [names setObject:information forKey:@"Info"];
    
    if(ivleArray==nil){
        NSLog(@"NO ivle info");
    }else{
        [self.keys addObject:@"IVLE"];
        [names setObject:ivleArray forKey:@"IVLE"];
    }
    
    if([mapInfoType isEqualToString:@"Food"]){
        [self.keys addObject:@"Food"];
        [names setObject:foodArray forKey:@"Food"];
    }
    else if([mapInfoType isEqualToString:@"Room"] || [mapInfoType isEqualToString:@"Normal"]){
        NSLog(@"called me");
        [self.keys addObject:@"Room"];
        [names setObject:roomArr forKey:@"Room"];
    }
    else if([mapInfoType isEqualToString:@"Bus"]){
        [self.keys addObject:@"Bus"];
        [names setObject:busArr forKey:@"Bus"];
        [self.keys addObject:@"Refresh"];
        NSArray* psuedo=[[NSArray alloc]initWithObjects:@"a", nil]; [names setObject:psuedo forKey:@"Refresh"];
    }
    else if([mapInfoType isEqualToString:@"Carpark"]){
        [self.keys addObject:@"Carpark"];
        [self.keys addObject:@"Refresh"];
        [names setObject:carArr forKey:@"Carpark"];
        NSArray* psuedo=[[NSArray alloc]initWithObjects:@"a", nil]; [names setObject:psuedo forKey:@"Refresh"];
    }
    
    
    [self updateDisplay];
    [self.view bringSubviewToFront:self.table];
}


- (void)viewDidLoad
{
    self.title=@"Details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle: @"Image"
                                              style:UIBarButtonItemStyleDone 
                                              target:self 
                                              action:@selector(alert)];
    NSLog(@"MAPINFOTYPE: %@",mapInfoType);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    if(animated){
        [self loadAllInfo];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if(hideNavBar){
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [super viewWillDisappear:animated];
    }
}

-(void)viewDidDisappear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewDidUnload {
    self.names = nil;
    self.keys = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/************************************************************************
 * TABLE DATA METHODS
 ************************************************************************/

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

-(NSString*)labelGen:(NSString*)input{
    input=[input stringByReplacingOccurrencesOfString:@"  " withString:@" &"];
    input=[input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray* textArr=[input componentsSeparatedByString:@" "];
    if([textArr count]==3){
        NSString* output=[NSString stringWithFormat:@"%@ %@\n%@",[textArr objectAtIndex:0],[textArr objectAtIndex:1],[textArr objectAtIndex:2]];
        return output;
    }
    if([textArr count]==4){
        NSString* output=[NSString stringWithFormat:@"%@ %@\n%@ %@",[textArr objectAtIndex:0],[textArr objectAtIndex:1],[textArr objectAtIndex:2],[textArr objectAtIndex:3]];
        return output;
    }
    if([textArr count]==5){
        NSString* output=[NSString stringWithFormat:@"%@ %@\n%@ %@ %@",[textArr objectAtIndex:0],[textArr objectAtIndex:1],[textArr objectAtIndex:2],[textArr objectAtIndex:3],[textArr objectAtIndex:4]];
        return output;
    }
    return input;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	
    NSString *key = [keys objectAtIndex:section];
    NSArray*  nameSection = [names objectForKey:key];
    	
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    
    if([key isEqualToString:@"Image"]){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCell"
                                                     owner:self options:nil];
        if ([nib count] > 0) {
            
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }else if([key isEqualToString:@"Info"] || [key isEqualToString:@"IVLE"]){
        //NSLog(@"Loading %@",key);
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:SectionsTableIdentifier];
    }else if([key isEqualToString:@"Refresh"]){
        //NSLog(@"Loading %@",key);
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }else if([key isEqualToString:@"Room"]){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
                                                     owner:self options:nil];
        //NSLog(@"Loading %@",key);
        if ([nib count] > 0) {
            
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }else if([key isEqualToString:@"Food"]){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FoodCell"
                                                     owner:self options:nil];
        //NSLog(@"Loading %@",key);
        if ([nib count] > 0) {
            
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }else if([key isEqualToString:@"Bus"]){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BusCell"
                                                     owner:self options:nil];
        //NSLog(@"Loading %@",key);
        if ([nib count] > 0) {
            
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }else if([key isEqualToString:@"Carpark"]){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarparkCell"
                                                     owner:self options:nil];
        //NSLog(@"Loading %@",key);
        if ([nib count] > 0) {
            
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }
    
    if([key isEqualToString:@"Image"]){
        NSLog(@"ImageCell calld");
        UIImageView* imView=(UIImageView*)[cell viewWithTag:1];
        if(image!=nil)
            [imView setImage:self.image];
    }else if([key isEqualToString:@"Info"]){
        cell.textLabel.text = [nameSection objectAtIndex:row];
    }else if([key isEqualToString:@"Room"]){
        RoomDetails* tempDetail=[nameSection objectAtIndex:row];
        UILabel* roomnameLabel=(UILabel*)[cell viewWithTag:1];
        roomnameLabel.text=tempDetail.roomName;
        UILabel* roomcodeLabel=(UILabel*)[cell viewWithTag:2];
        roomcodeLabel.text=tempDetail.roomCode;
        UILabel* deptlabel=(UILabel*)[cell viewWithTag:3];
        deptlabel.text=tempDetail.dept;
    }else if([key isEqualToString:@"Food"]){
        NSString* item=[nameSection objectAtIndex:0];
        NSString *path4 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* path1 = [path4 stringByAppendingPathComponent:@"FoodDetails.plist"];
        NSDictionary* foodDict=[[NSDictionary alloc]initWithContentsOfFile:path1];
        NSMutableArray* foodArray=[foodDict objectForKey:item];
        
        UILabel* numLabel=(UILabel*)[cell viewWithTag:1];
        numLabel.text=[foodArray objectAtIndex:0];
        UILabel* seatLabel=(UILabel*)[cell viewWithTag:2];
        seatLabel.text=[foodArray objectAtIndex:1];
        UILabel* detailLabel=(UILabel*)[cell viewWithTag:3];
        detailLabel.text=[foodArray objectAtIndex:2];
        UILabel* phoneLabel=(UILabel*)[cell viewWithTag:4];
        phoneLabel.text=[foodArray objectAtIndex:3];
        UILabel* moreLabel=(UILabel*)[cell viewWithTag:5];
        moreLabel.text=[foodArray objectAtIndex:4];
        self.phoneNumber=[foodArray objectAtIndex:3];
    }else if([key isEqualToString:@"Bus"]){
        NSString* busname=[nameSection objectAtIndex:row];
        unichar cha=[busname characterAtIndex:0];
        if(isdigit(cha)){
            UILabel* busLabel=(UILabel*)[cell viewWithTag:1];
            busLabel.text=busname;
            UILabel* timeLabel=(UILabel*)[cell viewWithTag:2];
            timeLabel.text=@"No Info";
            UILabel* locaLabel=(UILabel*)[cell viewWithTag:3];
            locaLabel.text=@"No Info";
        }else{
            UILabel* busLabel=(UILabel*)[cell viewWithTag:1];
            busLabel.text=busname;
            NSString* nextBus=[NSString stringWithFormat:@"N%@",busname];
            
            UILabel* timeLabel=(UILabel*)[cell viewWithTag:2];
            timeLabel.text=[busParser getArrivalTiming:busname];
            UILabel* locLabel=(UILabel*)[cell viewWithTag:3];
            locLabel.text=@"No Info";
            UILabel* timeLabel2=(UILabel*)[cell viewWithTag:4];
            timeLabel2.text=[busParser getNextArrivalTiming:busname];
            UILabel* locLabel2=(UILabel*)[cell viewWithTag:5];
            locLabel2.text=@"No Info";
        }
    }else if([key isEqualToString:@"Carpark"]){
        NSArray* arrayone=[nameSection objectAtIndex:row];
        NSString* stringone=[arrayone objectAtIndex:3];
        NSLog(@"%@",stringone);
        
        NSString* carparktype;
        if([stringone isEqualToString:@"Reserved"] || [stringone isEqualToString:@"Visitor"])
            carparktype=@"C1";
        else if([stringone isEqualToString:@"Visitor 2"])
            carparktype=@"C2";
        else if([stringone isEqualToString:@"Staff Season"])
            carparktype=@"C3";
        NSString *pathfulllist = [[NSBundle mainBundle] pathForResource:carparktype ofType:@"png"];
        
        UIImage* img=[[UIImage alloc]initWithContentsOfFile:pathfulllist];
        UIImageView* imgView=(UIImageView*)[cell viewWithTag:1];
        [imgView setImage:img];
        
        UILabel* lotLabel=(UILabel*)[cell viewWithTag:2];
        lotLabel.text=[NSString stringWithFormat:@"Lots Available: %d",[carparkParser getLots:temp3]];
    }
    
    if([key isEqualToString:@"IVLE"]){
        NSString* ivleInfo=[nameSection objectAtIndex:row];
        NSArray* both=[ivleInfo componentsSeparatedByString:@">"];
        cell.textLabel.text=[both objectAtIndex:0];
        cell.detailTextLabel.text=[both objectAtIndex:1];
    }
    
    if([key isEqualToString:@"Refresh"]){
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text=@"Refresh Info";
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    
    if([key isEqualToString:@"Info"]){
        return 30;
    }else if([key isEqualToString:@"IVLE"]){
        return 50;
    }else if([key isEqualToString:@"Room"]){
        return 66;
    }else if([key isEqualToString:@"Food"]){
        return 190;
    }else if([key isEqualToString:@"Bus"]){
        return 71;
    }else if([key isEqualToString:@"Carpark"]){
        return 417;
    }else if([key isEqualToString:@"Image"]){
        return 300;
    }else if([key isEqualToString:@"Refresh"]){
        return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];    
    
    if([key isEqualToString:@"Room"]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel* roomcode=(UILabel*)[cell viewWithTag:2];
        UILabel* roomdept=(UILabel*)[cell viewWithTag:3];
        
        NSLog(@"buildingstring passed: %@",[convert converter:roomcode.text :roomdept.text]);
        NSLog(@"Department %@",roomdept.text);

        NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
        MapPoint* mapPoint=[[MapPoint alloc]init];
        mapPoint.title=roomcode.text;
        mapPoint.subTitle=[convert converter:roomcode.text :roomdept.text];
        mapPoint.imagename=@"Room";
        mapPoint.alias=@" ";
        mapPoint.mapInfoType=@"Room";
        [MapPointArray addObject:mapPoint];
        [mapController setter];
        mapController.mapPointArray=MapPointArray;
        [self.tabBarController setSelectedIndex:3];
        
        //CHECK CODE
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if([key isEqualToString:@"Food"]){
        if(![phoneNumber isEqualToString:@"None"]){
            UIDevice *device = [UIDevice currentDevice];
            if ([[device model] isEqualToString:@"iPhone"] ) {
                phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                NSString* num=[NSString stringWithFormat:@"telprompt://%@",phoneNumber];
                NSURL *url = [NSURL URLWithString:num];
                [[UIApplication sharedApplication] openURL:url];
            } else {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }
        }
        
    }
    
    if([key isEqualToString:@"Bus"]){
        BusURLViewController* busControl=[[BusURLViewController alloc]initWithNibName:@"BusURLViewController" bundle:[NSBundle mainBundle]];
        NSArray*  nameSection = [names objectForKey:key];
        NSUInteger row = [indexPath row];
        NSString* bus=[nameSection objectAtIndex:row];
        
        if([bus isEqualToString:@"D1"] || [bus isEqualToString:@"D2"])
            bus=@"D";
        busControl.busName=bus;
        busControl.stringURL=[NSString stringWithFormat:@"https://inetapps.nus.edu.sg/ws/nextsbus/webapp/ShuttleBusTiming/mobile/%@_route.html",bus];
        [self presentModalViewController:busControl animated:YES];
    }
    
    if([key isEqualToString:@"Refresh"]){
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText=@"Loading";
        
        if([mapInfoType isEqualToString:@"Bus"])
            [HUD showWhileExecuting:@selector(getBusAction) onTarget:self withObject:nil animated:YES];
        else if([mapInfoType isEqualToString:@"Carpark"])
            [HUD showWhileExecuting:@selector(getLotsAction) onTarget:self withObject:nil animated:YES];
    }
}

-(void)getLotsAction{
    [carparkParser refreshData];
    [table reloadData];
}

-(void)getBusAction{
    [busParser loadData:temp];
    [table reloadData];
}

- (IBAction)busTracks:(id)sender event:(id)event
{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Bus Tracker is currently unavailable" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
    
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:self.table];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint: currentTouchPosition];
//    NSLog(@"%u",indexPath.row);
//    
//    NSUInteger section = [indexPath section];
//    NSUInteger row = [indexPath row];
//    NSString *key = [keys objectAtIndex:section];
//    NSArray*  nameSection = [names objectForKey:key];
//    NSString* bus=[nameSection objectAtIndex:row];
//    
////    if([bus isEqualToString:@"C"] || [bus isEqualToString:@"B"]){
////        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Sorry, B and C not supported yet" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
////        return;
////    }
//    
//    [self.mapController busTracking:bus :temp];
//    [self.tabBarController setSelectedIndex:3];
//    [self.navigationController popViewControllerAnimated:YES];
}





//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
//	
//    UITableViewCell *cell = [tableView
//							 dequeueReusableCellWithIdentifier: CustomCellIdentifier];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
//													 owner:self options:nil];
//        if ([nib count] > 0) {
//            cell = self.tvCell;
//        } else {
//            NSLog(@"failed to load CustomCell nib file!");
//        }
//    }
//    
//    NSUInteger section = [indexPath section];
//    NSUInteger row = [indexPath row];
//	
//    NSString *key = [keys objectAtIndex:section];
//    NSArray*  nameSection = [names objectForKey:key];
//    
////    RoomDetails* tempDetail=[nameSection objectAtIndex:row];
////    UILabel* roomLabel=(UILabel*)[cell viewWithTag:0];
////    roomLabel.text=tempDetail.roomCode;
//    
//    UILabel *colorLabel = (UILabel *)[cell viewWithTag:1];
//    colorLabel.text = @"aa";
//    
//    return cell;
//}

//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section {
//    NSString *key = [keys objectAtIndex:section];
//    return key;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    NSString *key = [keys objectAtIndex:section];
//    return key;
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return keys;
//}

@end
