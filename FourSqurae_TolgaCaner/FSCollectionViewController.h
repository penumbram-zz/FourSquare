//
//  FSCollectionViewController.h
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 02/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CVCell.h"

@interface FSCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CLLocationManagerDelegate>
{
    UICollectionView *_collectionView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}



@end
