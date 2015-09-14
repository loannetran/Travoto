//
//  CustomPinView.m
//  MapApp
//
//  Created by Vivian Aranha on 8/31/15.
//  Copyright (c) 2015 Vivian Aranha. All rights reserved.
//

#import "CustomPinView.h"
#import "MapAnnotation.h"

@implementation CustomPinView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        
        self.image = [UIImage imageNamed:@"pin_blue.png"];
        self.enabled = YES;
        self.canShowCallout = YES;
        
        
    }
    return self;
}


@end
