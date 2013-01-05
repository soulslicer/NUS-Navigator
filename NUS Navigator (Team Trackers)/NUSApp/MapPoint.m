//
//  MapPoint.m
//  WhereAmIView
//
//  Created by Yaadhav Raaj on 30/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize coordinate,subTitle,title,subtitle,imagename,alias,mapInfoType,bus;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st{
    self.title=t;
    //self.coordinate=c;
    self.subTitle=st;
    return self;
}

- (void) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
{
    coordinate = aCoordinate;
}

-(NSString*)subtitle{
    return self.subTitle;
}

-(void)shiftlong{
    coordinate.longitude+=0.000099;
}
-(void)shiftlat{
    coordinate.latitude+=0.000099;
}


@end
