//
//  AEHangarViewController.m
//  AirEscape
//
//  Created by Horatiu Istrate on 12/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import "AEHangarViewController.h"
#import "AEHangarItemTableViewCell.h"
#import "AEShopItem.h"
#import "PPConstants.h"



#define TOP_VIEW_HEIGHT 60
#define TOP_VIEW_TITLE_WIDTH 200

@interface AEHangarViewController ()

@end

@implementation AEHangarViewController

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
    
    _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:_backgroundView];
    
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] init];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setFrame:self.view.frame];
    
    [self.view addSubview:_tableView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_VIEW_HEIGHT)];
    //[_topView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(30, 5, 100, TOP_VIEW_HEIGHT - 10)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor blueColor]];
    [_topView addSubview:backButton];
    
    _titleOfScreen = [[UILabel alloc] init];
    [_titleOfScreen setTextAlignment:NSTextAlignmentCenter];
    [_titleOfScreen setText:@"Hangar"];
    [self.view addSubview:_titleOfScreen];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ShopItems" ofType:@"plist"];
    _shopItemsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    [_topView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_VIEW_HEIGHT)];
    [_tableView setFrame:CGRectMake(0, 0, 800 , 600)];
    [_tableView setCenter:CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5)];
    
    [_titleOfScreen setFrame:CGRectMake((self.view.bounds.size.width - TOP_VIEW_TITLE_WIDTH) * 0.5, 0, TOP_VIEW_TITLE_WIDTH, TOP_VIEW_HEIGHT)];
    
    [_backgroundView setCenter:self.view.center];
    
    [self.tableView reloadData];
}


#pragma mark - Table View Delegates -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_shopItemsDictionary allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomCell";
    
    AEHangarItemTableViewCell *cell = (AEHangarItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AEHangarItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
//    NSString *keyOfItem = getKeyForShopItem(indexPath.row);
//    
//    AEShopItem *currentItem = [[AEShopItem alloc] initWithDictionary:[_shopItemsDictionary objectForKey:keyOfItem]];
//    [cell setShopItem:currentItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - Button methods -

- (void)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Methods -

//NSString* getKeyForShopItem(NSUInteger shopItemType) {
//    switch (shopItemType) {
//        case AEShopItemBuyLowAirplane:
//            return @"Airplane Low";
//            break;
//        case AEShopItemBuyMediumAirplane:
//            return @"Airplane Medium";
//            break;
//        case AEShopItemBuyHighAirplane:
//            return @"Airplane High";
//            break;
//        case AEShopItemBuyLowSmoke:
//            return @"Smoke Low";
//            break;
//        case AEShopItemBuyMediumSmoke:
//            return @"Smoke Medium";
//            break;
//        case AEShopItemBuyHighSmoke:
//            return @"Smoke High";
//            break;
//        case AEShopItemBuyMissiles:
//            return @"Buy Missiles";
//            break;
//        case AEShopItemBuyRemoveAds:
//            return @"Remove Ads";
//            break;
//        default:
//            return @"";
//            break;
//    }
//}

@end
