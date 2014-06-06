//
//  FSCVCell.h
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 06/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCVCell : UICollectionViewCell

-(void)setTitleLabelText:(NSString*)text;



@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *countLabel;
@property (nonatomic,retain) UILabel *tipLabel;
@property (nonatomic,retain) UILabel *userLabel;
@property (nonatomic,retain) UIButton *btn;
@property (nonatomic, strong) NSString* venueID;

@end
