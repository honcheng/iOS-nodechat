//
//  LocationInfo.h
//  LocationAlert
//
//  Created by honcheng on 10/26/09.
//  Copyright 2009 honcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationInfo : NSObject {
	CLLocationCoordinate2D	coordinate;
	float			altitude;
	float			horizontal_accuracy;
	float			vertical_accuracy;
	float			distance_travelled;
	bool			locAvailable;
	bool			locServiceEnabled;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) float altitude;
@property (nonatomic, assign) float horizontal_accuracy;
@property (nonatomic, assign) float vertical_accuracy;
@property (nonatomic, assign) float distance_travelled;
@property (nonatomic, assign) bool locAvailable;
@property (nonatomic, assign) bool locServiceEnabled;

- (CLLocation*)location;
- (void)setLatitude:(float)latitude;
- (void)setLongitude:(float)longitude;

@end
