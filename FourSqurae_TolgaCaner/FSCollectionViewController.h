//
//  FSCollectionViewController.h
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 02/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include "FSCVCell.h"
#include "FSInfoView.h"

@interface FSCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (nonatomic, strong) IBOutlet UICollectionView *_collectionView;

@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, strong) NSMutableArray *venueNames;
@property (nonatomic, strong) NSMutableArray *totalCheckins;
@property (nonatomic, strong) NSMutableArray *totalTips;
@property (nonatomic, strong) NSMutableArray *totalUsers;
@property (nonatomic, strong) NSMutableArray *venueIDs;
@property (nonatomic, strong) FSInfoView* infoView;
@property (nonatomic, strong) NSString* lastClickedCellID;

@end
