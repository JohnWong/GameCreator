//
//  UIViewController+WL.m
//  GameCreator
//
//  Created by John Wong on 11/5/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "UIViewController+WL.h"
#import <objc/runtime.h>


@implementation UIViewController (WL)

+ (void)initialize
{
    if (self == NSClassFromString(@"CreateAlbumViewController")) {
        {
            Method m1 = class_getInstanceMethod(self, @selector(albumLocationViewController:location:desc:));
            Method m2 = class_getInstanceMethod(self, @selector(wl_albumLocationViewController:location:desc:));
            method_exchangeImplementations(m1, m2);
        }
        {
            Method m1 = class_getInstanceMethod(self, @selector(ca_viewDidLoad));
            Method m2 = class_getInstanceMethod(self, @selector(viewDidLoad));
            method_exchangeImplementations(m1, m2);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    id chnLocation = NSClassFromString(@"CHNLocation");
    BOOL isOutOfChina = [chnLocation performSelector:@selector(outOfChinaWithLocation:) withObject:location];
    if (!isOutOfChina) {
        location = [chnLocation performSelector:@selector(convertCHNLocation:) withObject:location];
    }
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        ;
        CLPlacemark *placemark = placemarks.firstObject;
        if (!placemark) {
            return;
        }
        [self wl_albumLocationViewController:nil location:placemark.location desc:placemark.name];
    }];
    objc_setAssociatedObject(self, &geoCoder, @"geoCoder", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ca_viewDidLoad
{
    [self ca_viewDidLoad];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:32 longitude:32];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    objc_setAssociatedObject(self, @"locationManager", locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wl_albumLocationViewController:(UIViewController *)controller location:(CLLocation *)location desc:(NSString *)desc
{
    [self wl_albumLocationViewController:nil location:location desc:desc];
}

@end
