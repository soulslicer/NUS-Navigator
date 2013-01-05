#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject<MKAnnotation> {
    
    NSString *title; 
    NSString *subTitle; 
    CLLocationCoordinate2D coordinate; 
    NSString* imagename;
    NSString* alias;
    NSString* mapInfoType;
    NSString* bus;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate; 
@property (nonatomic,copy) NSString *title; 
@property (nonatomic,copy) NSString *subTitle; 
@property(nonatomic,copy)NSString* imagename;
@property(nonatomic,copy)NSString* alias;
@property(nonatomic,copy)NSString* mapInfoType;
@property(nonatomic,copy)NSString* bus;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st;
- (void) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
-(void)shiftlong;
-(void)shiftlat;
-(NSString*)subtitle;

@end