//
//  FSInfoView.h
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 06/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSInfoView : UIView

@property (nonatomic,retain) UILabel* titleLabel;
@property (nonatomic,retain) UITextView* descTV;
@property (nonatomic,retain) UILabel* likelbl;
@property (nonatomic,retain) UILabel* dislikelbl;
@property (nonatomic,retain) UIButton* btn;
@property (nonatomic,retain) NSString* venueID;

@property (nonatomic, retain) UIButton* btnLike;
@property (nonatomic, retain) UIButton* btnSimilar;
@property (nonatomic, retain) UIButton* btnImages;
@property (nonatomic, retain) UIButton* btnNextImage;
@property (nonatomic, retain) UIButton* btnLeaveImageView;
@property (nonatomic, retain) UIButton* btnNextVenues;
@property (nonatomic,retain) UIImageView* imageView;

@end
