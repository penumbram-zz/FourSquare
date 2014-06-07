//
//  FSCollectionViewController.m
//  FourSqurae_TolgaCaner
//
//  Created by Tolga Caner on 02/06/14.
//  Copyright (c) 2014 Tolga Caner. All rights reserved.
//

#import "FSCollectionViewController.h"
#import "AFNetworking.h"

@interface FSCollectionViewController ()


@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FSCollectionViewController
@synthesize _collectionView,latitude,longitude, venueNames,totalCheckins,totalTips,totalUsers,venueIDs,infoView,lastClickedCellID,photoPrefixes,photoSuffixes,imageCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    venueNames = [[NSMutableArray alloc] init];
    totalUsers = [[NSMutableArray alloc]init];
    totalTips = [[NSMutableArray alloc]init];
    totalCheckins = [[NSMutableArray alloc]init];
    venueIDs = [[NSMutableArray alloc]init];
    photoPrefixes = [[NSArray alloc] init];
    photoSuffixes = [[NSArray alloc] init];
    
    infoView = [[FSInfoView alloc] initWithFrame:CGRectMake(0, 0, 360, 360)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingVenue:) name:@"venueInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSubView:) name:@"hideSubView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeVenue:) name:@"like" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findSimilar:) name:@"similar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImages:) name:@"images" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nextImage:) name:@"nextImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNextVenues:) name:@"events" object:nil];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    self.dateString= [dateFormat stringFromDate:today];
    
    NSString *venues = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/trending?oauth_token=%@&v=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    
    NSString* coordinates= [NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude];
    NSDictionary *parameters = @{@"ll": coordinates,@"limit": @"10",@"radius": @"1500"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager GET:venues parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
        // meta 0, notifications 1, response 2. -- We are interested in the response here.
         id idd = (id)[arr objectAtIndex:2];
         NSArray* array = idd[@"venues"];
         NSArray* names = [array valueForKey:@"name"];
         NSArray* allIDs = [array valueForKey:@"id"];
         NSArray* stats = [array valueForKey:@"stats"];
         NSArray* checkinsCount = [stats valueForKey:@"checkinsCount"];
         NSArray* tipCount = [stats valueForKey:@"tipCount"];
         NSArray* usersCount = [stats valueForKey:@"usersCount"];
         
         venueNames = [NSMutableArray arrayWithArray:names];
         totalCheckins = [NSMutableArray arrayWithArray:checkinsCount];
         totalTips = [NSMutableArray arrayWithArray:tipCount];
         totalUsers = [NSMutableArray arrayWithArray:usersCount];
         venueIDs = [NSMutableArray arrayWithArray:allIDs];
         [_collectionView reloadData];
         [SVProgressHUD dismiss];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"fail: %@", error);
         [SVProgressHUD dismiss];
     }];
    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[FSCVCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.allowsSelection = NO;
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:infoView];
    [infoView setHidden:TRUE];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

-(void)hideSubView:(NSNotification *)notification
{
    [self setBGForState:YES];
}

-(void)nextImage:(NSNotification *)notification
{
   if ([[photoPrefixes objectAtIndex:2]count] == imageCount.intValue+1)
       imageCount = [NSNumber numberWithInt:0];
    
    [self setImageCount:[NSNumber numberWithInt:imageCount.intValue+1]];
    
    NSString* prefix = [NSString stringWithFormat:@"%@",[[photoPrefixes objectAtIndex:2] objectAtIndex:imageCount.intValue]];
    NSString* suffix = [NSString stringWithFormat:@"%@",[[photoSuffixes objectAtIndex:2] objectAtIndex:imageCount.intValue]];
    NSString* urlStr = [[NSString alloc] init];
    urlStr = [NSString stringWithFormat:@"%@280x440%@",prefix,suffix];
    NSURL *imageURL = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [SVProgressHUD show];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        [[self infoView] imageView].image = responseObject;
        [self imageViewMode:YES];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        
    }];
    [requestOperation start];
}

-(void)likeVenue:(NSNotification *)notification
{
    NSArray* temp = [[notification object] componentsSeparatedByString:@"|"];
    NSString* venueID = [temp objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/like?oauth_token=%@&v=%@",venueID,[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    NSString* likeState = @"";
    if ([[temp objectAtIndex:1] isEqualToString:@"Like"])
        likeState = @"1";
    else
        likeState = @"0";
    
    NSDictionary *parameters = @{@"VENUE_ID": venueID,@"set": likeState};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
         // meta 0, notifications 1, response 2. -- We are interested in the response here.
         NSArray* array = [arr objectAtIndex:2];
         NSString* likeCount = [[array valueForKey:@"likes"] valueForKey:@"count"];
         NSString* summary = [[array valueForKey:@"likes"] valueForKey:@"summary"];
         NSString* summaryStr = [NSString stringWithFormat:@"%@",summary];
         
         if ([summaryStr rangeOfString:@"You"].location == NSNotFound) {
             [[infoView btnLike] setTitle:@"Like" forState:UIControlStateNormal];
         } else {
             [[infoView btnLike] setTitle:@"Dislike" forState:UIControlStateNormal];
         }
         
         [[infoView likelbl] setText:summaryStr];
         [SVProgressHUD dismiss];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"fail: %@", error);
         [SVProgressHUD dismiss];
     }];
}

-(void)incomingVenue:(NSNotification *)notification{
    NSArray *array = [[notification object] componentsSeparatedByString:@"|"];
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?oauth_token=%@&v=%@",[array objectAtIndex:0],[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    [self setLastClickedCellID:[array objectAtIndex:0]];
    [[infoView titleLabel] setText:[array objectAtIndex:1]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
         // meta 0, notifications 1, response 2. -- We are interested in the response here.
         id idd = (id)[arr objectAtIndex:2];
         NSArray* array = idd[@"venue"];
         NSString* description = [array valueForKey:@"description"];
         NSString* likeCount = [[array valueForKey:@"likes"] valueForKey:@"count"];
         NSString* likeState = [array valueForKey:@"like"];
         NSString* summaryStr = [NSString stringWithFormat:@"%@",[[array valueForKey:@"likes"] valueForKey:@"summary"]];
         

         [infoView setVenueID:[self lastClickedCellID]];
         
         if (description == nil || [description isEqualToString:@""])
             description = @"No Description Available on FourSquare for this venue";
         
         
         [[infoView descTV] setText:description];
         [[infoView likelbl] setText:summaryStr];
         NSString* temp = [NSString stringWithFormat:@"%@",likeState];
         if ([temp isEqualToString:@"1"])
             [[infoView btnLike] setTitle:@"Dislike" forState:UIControlStateNormal];
         else
             [[infoView btnLike] setTitle:@"Like" forState:UIControlStateNormal];
         
         [[self infoView] setHidden:NO];
         [self setBGForState:FALSE];
         [SVProgressHUD dismiss];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"fail: %@", error);
     }];
    
}

-(void)findSimilar:(NSNotification *)notification
{
    NSArray* temp = [[notification object] componentsSeparatedByString:@"|"];
    NSString* venueID = [temp objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/similar?oauth_token=%@&v=%@",venueID,[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    
    NSDictionary *parameters = @{@"VENUE_ID": venueID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
         // meta 0, notifications 1, response 2. -- We are interested in the response here.
         NSArray* array = [arr objectAtIndex:2];
         NSArray* items = [[array valueForKey:@"similarVenues"] valueForKey:@"items"];
         NSArray* names = [items valueForKey:@"name"];
         NSArray* allIDs = [items valueForKey:@"id"];
         NSArray* stats = [items valueForKey:@"stats"];
         NSArray* checkinsCount = [stats valueForKey:@"checkinsCount"];
         NSArray* tipCount = [stats valueForKey:@"tipCount"];
         NSArray* usersCount = [stats valueForKey:@"usersCount"];
         
         venueNames = [NSMutableArray arrayWithArray:names];
         totalCheckins = [NSMutableArray arrayWithArray:checkinsCount];
         totalTips = [NSMutableArray arrayWithArray:tipCount];
         totalUsers = [NSMutableArray arrayWithArray:usersCount];
         venueIDs = [NSMutableArray arrayWithArray:allIDs];
         [_collectionView reloadData];
         [self setBGForState:YES];
         [[self infoView] setHidden:YES];
         [SVProgressHUD dismiss];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"fail: %@", error);
     }];
}

-(void)getImages:(NSNotification *)notification
{
    NSArray* temp = [[notification object] componentsSeparatedByString:@"|"];
    NSString* venueID = [temp objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?oauth_token=%@&v=%@",venueID,[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    
    NSDictionary *parameters = @{@"VENUE_ID": venueID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
         imageCount = [NSNumber numberWithInt:0];
         // meta 0, notifications 1, response 2. -- We are interested in the response here.
         NSArray* array = [arr objectAtIndex:2];
         NSArray* photos = [[arr valueForKey:@"photos"] valueForKey:@"items"];
         NSArray*prefixes = [NSArray arrayWithArray:[photos valueForKey:@"prefix"]];
         NSArray*suffixes = [NSArray arrayWithArray:[photos valueForKey:@"suffix"]];
         photoSuffixes = [NSMutableArray arrayWithArray:suffixes];
         photoPrefixes = [NSMutableArray arrayWithArray:prefixes];
                  
         NSString* prefix = [NSString stringWithFormat:@"%@",[[prefixes objectAtIndex:2] objectAtIndex:imageCount.intValue]];
         NSString* suffix = [NSString stringWithFormat:@"%@",[[suffixes objectAtIndex:2] objectAtIndex:imageCount.intValue]];
         NSString* urlStr = [[NSString alloc] init];
         urlStr = [NSString stringWithFormat:@"%@280x440%@",prefix,suffix];
         NSURL *imageURL = [NSURL URLWithString:urlStr];
         NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
         
         AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
         [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Response: %@", responseObject);
             [[self infoView] imageView].image = responseObject;
             [self imageViewMode:YES];
             [SVProgressHUD dismiss];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
             NSLog(@"Image error: %@", error);
         }];
         [requestOperation start];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"fail: %@", error);
     }];
}

-(void)imageViewMode:(BOOL)b
{
    [[[self infoView] imageView] setHidden:!b];
    [[[self infoView] btnNextImage] setHidden:!b];
    [[[self infoView]btnLeaveImageView] setHidden:!b];
}

-(void)getNextVenues:(NSNotification *)notification
{
    NSArray* temp = [[notification object] componentsSeparatedByString:@"|"];
    NSString* venueID = [temp objectAtIndex:0];
    NSString* urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/nextvenues?oauth_token=%@&v=%@",venueID,[[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_token"],self.dateString];
    
    NSDictionary *parameters = @{@"VENUE_ID": venueID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD show];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* dict = (NSDictionary*)responseObject;
         NSArray * arr = [dict allValues];
         // meta 0, notifications 1, response 2. -- We are interested in the response here.
         NSArray* array = [arr objectAtIndex:2];
         NSArray* items = [[array valueForKey:@"nextVenues"] valueForKey:@"items"];
         NSArray* names = [items valueForKey:@"name"];
         NSArray* allIDs = [items valueForKey:@"id"];
         NSArray* stats = [items valueForKey:@"stats"];
         NSArray* checkinsCount = [stats valueForKey:@"checkinsCount"];
         NSArray* tipCount = [stats valueForKey:@"tipCount"];
         NSArray* usersCount = [stats valueForKey:@"usersCount"];
         
         venueNames = [NSMutableArray arrayWithArray:names];
         totalCheckins = [NSMutableArray arrayWithArray:checkinsCount];
         totalTips = [NSMutableArray arrayWithArray:tipCount];
         totalUsers = [NSMutableArray arrayWithArray:usersCount];
         venueIDs = [NSMutableArray arrayWithArray:allIDs];
         [_collectionView reloadData];
         [self setBGForState:YES];
         [[self infoView] setHidden:YES];
         [SVProgressHUD dismiss];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"fail: %@", error);
     }];
}


-(void)setBGForState:(BOOL)b
{
    [_collectionView setUserInteractionEnabled:b];
    if (!b)
    {
        for(UICollectionView *cell in _collectionView.visibleCells)
            [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        
        [_collectionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    }
    else
    {
        for(UICollectionView *cell in _collectionView.visibleCells)
            [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:1.0]];
        
        [_collectionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:1.0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [venueNames count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    FSCVCell* cell = (FSCVCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [[cell titleLabel] setText:[venueNames objectAtIndex:indexPath.row]];
    [[cell countLabel] setText:[NSString stringWithFormat:@"Check-ins: %@",[totalCheckins objectAtIndex:indexPath.row]]];
    [[cell tipLabel] setText:[NSString stringWithFormat:@"Total Tips: %@",[totalTips objectAtIndex:indexPath.row]]];
    [[cell userLabel] setText:[NSString stringWithFormat:@"Users: %@",[totalUsers objectAtIndex:indexPath.row]]];
    [cell setVenueID:[venueIDs objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 200);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected %@",indexPath);
    FSCVCell *cell = (FSCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%@",cell.titleLabel.text);
}

@end
