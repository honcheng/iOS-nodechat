//
//  LocationInfo.m
//  LocationAlert
//
//  Created by honcheng on 10/26/09.
//  Copyright 2009 honcheng. All rights reserved.
//

#import "LocationInfo.h"


@implementation LocationInfo

@synthesize coordinate, altitude, horizontal_accuracy, vertical_accuracy, distance_travelled, locAvailable, locServiceEnabled;

- (void)setLatitude:(float)latitude
{
	coordinate.latitude = latitude;
}

- (void)setLongitude:(float)longitude
{
	coordinate.longitude = longitude;
}

- (CLLocation*)location
{
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease];
	return location;
}

@end
