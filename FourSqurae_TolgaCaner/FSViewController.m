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
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, -50, 200, 250)];
    [lbl1 setText:@"Provide latitude - longitude coordinates in the texfields below and press search"];
    [self.view addSubview:lbl1];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Search" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(self.view.frame.size.width/2 - 50 , self.view.frame.size.height/2 - 25, 100, 50)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    textfield1 = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.width/2 - 10, 80, 20)];
    textfield1.borderStyle = UITextBorderStyleRoundedRect;
    textfield1.returnKeyType = UIReturnKeyDone;
    textfield1.delegate = self;
    textfield1.placeholder = @"41.03";
    [self.view addSubview:textfield1];
    textfield2 = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.width/2 - 40, 80, 20)];
    textfield2.borderStyle = UITextBorderStyleRoundedRect;
    textfield2.returnKeyType = UIReturnKeyDone;
    textfield2.delegate = self;
    textfield2.placeholder = @"28.98";
    [self.view addSubview:textfield2];
    

    
    // "41.03,28.98" Taksim
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"TF1: %@",textfield1.text);
    NSLog(@"TF2: %@",textfield2.text);
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    return YES;
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
    
    fscvc.latitude = textfield1.text;
    fscvc.longitude = textfield2.text;
    
    //In case the user does not provide any latitude or longitude coordinates, we use the placeholder coordinates - Taksim, İstanbul -s
    if ([textfield1.text isEqualToString:@""])
        fscvc.latitude = textfield1.placeholder;
    if ([textfield2.text isEqualToString:@""])
        fscvc.longitude = textfield2.placeholder;
    
    [self.navigationController pushViewController:fscvc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
