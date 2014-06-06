//
//  FSCVCell.m
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 06/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import "FSCVCell.h"

@implementation FSCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 10.0;
        [self.contentView addSubview:self.titleLabel];
        
        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 200, 50)];
        self.countLabel.adjustsFontSizeToFitWidth = YES;
        self.countLabel.minimumFontSize = 10.0;
        [self.contentView addSubview:self.countLabel];
        
        self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 50)];
        self.tipLabel.adjustsFontSizeToFitWidth = YES;
        self.tipLabel.minimumFontSize = 10.0;
        [self.contentView addSubview:self.tipLabel];
        
        self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 200, 50)];
        self.userLabel.adjustsFontSizeToFitWidth = YES;
        self.userLabel.minimumFontSize = 10.0;
        [self.contentView addSubview:self.userLabel];
        
        self.venueID = [[NSString alloc] init];
        
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.btn addTarget:self action:@selector(buttonPressed)
         forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn];
        
    }
    return self;
}

-(void)buttonPressed
{
    NSLog(self.titleLabel.text);
    NSString* temp = [NSString stringWithFormat:@"%@|%@",self.venueID,self.titleLabel.text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"venueInfo" object: temp];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    self.countLabel.text = @"";
    self.tipLabel.text = @"";
    self.userLabel.text = @"";
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
