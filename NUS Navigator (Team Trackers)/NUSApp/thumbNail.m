//
//  thumbNail.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 18/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "thumbNail.h"

@implementation UIImage (PhoenixMaster)
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);  
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();        
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil) 
        NSLog(@"could not scale image");
    return newThumbnail;
}

@end
