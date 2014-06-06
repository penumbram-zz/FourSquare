//
//  FSViewController.m
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 25/04/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import "FSViewController.h"

@interface FSViewController ()

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    FSViewController* fsVC = [[FSViewController alloc] init];
    [fsVC setTitle:@"FourSquare 4 Square"];
    
    UILabel *recentCheckinsLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 10, 200, 250)];
    [recentCheckinsLbl setText:@"Search recent Check-ins"];
    [self.view addSubview:recentCheckinsLbl];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Search" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(self.view.frame.size.width/2 - 50 , self.view.frame.size.height/2 - 25, 100, 50)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton* btnFetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) btnClicked:(UIButton*)sender
{
    if (self.view.backgroundColor == [UIColor lightGrayColor]) {
        [self.view setBackgroundColor:[UIColor redColor]];
    } else {
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
    }
    [self connect];
}

- (void)connect {
    
    NSURL *url = [NSURL URLWithString:@"https://foursquare.com/oauth2/authenticate?client_id=OL0WLMHKXTL3YTOJMPRJD2WO1Z2TTOSTBVE44ZCQCPG4TGAW&response_type=token&redirect_uri=fstolgacaner://foursquare"];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)saveToken:(NSString *)token {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"foursquare_token"];
    [userDefaults synchronize];
    
    FSCollectionViewController* fscvc = [[FSCollectionViewController alloc] init];
    [self.navigationController pushViewController:fscvc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
