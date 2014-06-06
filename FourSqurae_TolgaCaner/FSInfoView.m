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
        [self.btnLike setFrame:CGRectMake(10, 310, 50, 15)];
        [self.btnLike setTitle:@"Like" forState:UIControlStateNormal];
        [self addSubview:self.btnLike];
        [self.btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnSimilar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btnSimilar setFrame:CGRectMake(60, 310, 50, 15)];
        [self.btnSimilar setTitle:@"Find Similar Places" forState:UIControlStateNormal];
        [self.btnSimilar titleLabel].adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.btnSimilar];
        [self.btnSimilar addTarget:self action:@selector(btnFindSimilar:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btn setTitle:@"Go Back" forState:UIControlStateNormal];
        [self.btn setFrame:CGRectMake(240, 320, 80, 40)];
        [self addSubview:self.btn];
        [self.btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) btnPressed:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"hideSubView" object: nil];
    [self setHidden:YES];
}

- (void) btnLikeAction:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"like" object: string];
}

- (void) btnFindSimilar:(UIButton*)sender
{
    NSString* temp = sender.titleLabel.text;
    NSString* string = [NSString stringWithFormat:@"%@|%@",self.venueID,temp];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"similar" object: string];
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
