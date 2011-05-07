//
//  CoreLocationManager.h
//  Chat
//
//  Created by honcheng on 10/26/09.
//  Copyright 2009 honcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationInfo.h"

@protocol CoreLocationManagerDelegate <NSObject>
@optional
- (void)newLocationUpdate:(LocationInfo *)locationInfo;
- (void)newLocationUpdateError:(NSString *)text;
- (void)newError:(NSString *)text;
@end

@interface CoreLocationManager : NSObject <CLLocationManagerDelegate>{
	CLLocationManager	*locationManager;
	id					delegate;
	LocationInfo		*locationInfo;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <CoreLocationManagerDelegate> delegate;
@property (nonatomic, retain) LocationInfo *locationInfo;

+ (CoreLocationManager *)defaultManager;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;



@end
