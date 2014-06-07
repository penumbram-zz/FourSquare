//
//  FSInfoView.m
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 06/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import "FSInfoView.h"

@implementation FSInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        [self addSubview:self.titleLabel];
        
        self.descTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 110, 320, 200)];
        [self.descTV setUserInteractionEnabled:NO];
        [self.descTV setEditable:NO];
        [self addSubview:self.descTV];
        
        self.likelbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 50)];
        [self addSubview:self.likelbl];
        
        self.dislikelbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 50)];
        [self addSubview:self.dislikelbl];
        
        self.likelbl.adjustsFontSizeToFitWidth = YES;
        self.dislikelbl.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        
        self.btnLike = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnLike setFrame:CGRectMake(0, 300, 50, 20)];
        [self.btnLike setTitle:@"Like" forState:UIControlStateNormal];
        [self addSubview:self.btnLike];
        [self.btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnSimilar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnSimilar setFrame:CGRectMake(50, 300, 150, 20)];
        [self.btnSimilar setTitle:@"Find Similar Places" forState:UIControlStateNormal];
        [self.btnSimilar titleLabel].adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.btnSimilar];
        [self.btnSimilar addTarget:self action:@selector(btnFindSimilar:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btn setTitle:@"Go Back" forState:UIControlStateNormal];
        [self.btn setFrame:CGRectMake(240, 325, 80, 40)];
        [self addSubview:self.btn];
        [self.btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnImages = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnImages setTitle:@"Images" forState:UIControlStateNormal];
        [self.btnImages setFrame:CGRectMake(200, 300, 50, 20)];
        [self addSubview:self.btnImages];
        [self.btnImages addTarget:self action:@selector(btnImagesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnNextVenues = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnNextVenues setTitle:@"Next Venues" forState:UIControlStateNormal];
        [self.btnNextVenues setFrame:CGRectMake(70, 325, 120, 20)];
        [self addSubview:self.btnNextVenues];
        [self.btnNextVenues addTarget:self action:@selector(btnNextVenuesAction:) forControlEvents:UIControlEventTouchUpInside];
        
       self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];
        [self addSubview:self.imageView];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setHidden:YES];
        
        self.btnNextImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnNextImage setTitle:@"Next" forState:UIControlStateNormal];
        [self.btnNextImage setFrame:CGRectMake(260, 300, 50, 20)];
        [self addSubview:self.btnNextImage];
        [self.btnNextImage setHidden:YES];
        [self.btnNextImage addTarget:self action:@selector(btnNextImagePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnLeaveImageView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnLeaveImageView setTitle:@"Close" forState:UIControlStateNormal];
        [self.btnLeaveImageView setFrame:CGRectMake(260, 10, 50, 20)];
        [self addSubview:self.btnLeaveImageView];
        [self.btnLeaveImageView setHidden:YES];
        [self.btnLeaveImageView addTarget:self action:@selector(btnLeaveImageViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) btnPressed:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"hideSubView" object: nil];
    [self setHidden:YES];
}

- (void) btnLeaveImageViewPressed:(UIButton*)sender
{
    [[self imageView] setHidden:YES];
    [[self btnNextImage] setHidden:YES];
    [[self btnLeaveImageView] setHidden:YES];
}

- (void) btnNextImagePressed:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"nextImage" object: nil];
    NSLog(@"HELLO");
}

- (void) btnLikeAction:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"like" object: string];
}

- (void) btnNextVenuesAction:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"events" object: string];
}

- (void) btnFindSimilar:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"similar" object: string];
}

- (void) btnImagesAction:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"images" object: string];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
