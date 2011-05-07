//
//  CoreLocationManager.m
//  LocationAlert
//
//  Created by honcheng on 10/26/09.
//  Copyright 2009 honcheng. All rights reserved.
//

#import "CoreLocationManager.h"

@implementation CoreLocationManager
@synthesize locationManager, delegate;
@synthesize locationInfo;

static CoreLocationManager *defaultManager = nil;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
		[self.locationManager setDistanceFilter:500];
		self.locationInfo = [[[LocationInfo alloc] init] autorelease];
	}
	return self;
}

+ (CoreLocationManager *)defaultManager {
    @synchronized(self) {
        if (defaultManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return defaultManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (defaultManager==nil)
		{
			defaultManager = [super allocWithZone:zone];
			return defaultManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}


- (id)retain {
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX; 
}

- (void)release 
{
}

- (id)autorelease 
{
    return self;
}

- (void)dealloc {
    self.locationManager = nil;
    self.locationInfo = nil;
	[super dealloc];
}

#pragma mark location delegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	if (oldLocation!=nil)
	{
		self.locationInfo.distance_travelled = [newLocation distanceFromLocation:oldLocation];
	}
	else
	{
		self.locationInfo.distance_travelled = -1;
	}
   	
	self.locationInfo.coordinate = newLocation.coordinate;
	self.locationInfo.altitude = newLocation.altitude;
	self.locationInfo.horizontal_accuracy = newLocation.horizontalAccuracy;
	self.locationInfo.vertical_accuracy = newLocation.verticalAccuracy;

	
	NSMutableString *eventText = [NSMutableString stringWithFormat:@"\nlatitude: %f\nlongitude: %f\naltitutde: %f",self.locationInfo.coordinate.latitude,self.locationInfo.coordinate.longitude,self.locationInfo.altitude];
	[eventText appendFormat:@"\nhorizontal accuracy: %f\nvertical accuracy: %f",self.locationInfo.horizontal_accuracy,self.locationInfo.vertical_accuracy];

	NSTimeInterval interval = [[newLocation timestamp] timeIntervalSinceNow];
	if (interval>-15 && interval<0)
	{
		[self.locationInfo setLocAvailable:YES];
		if ([delegate respondsToSelector:@selector(newLocationUpdate:)])
		{
			[self.delegate newLocationUpdate:self.locationInfo];
		}
		NSLog(@"new location found : %@", eventText);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_NewLocationUpdated" object:self.locationInfo];
    }
	else
	{
		NSLog(@"old location found : %@", eventText);
		[self.locationInfo setLocAvailable:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_OldLocationUpdated" object:self.locationInfo];

	}

}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	
}



@end