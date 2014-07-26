//
//  AEHangarViewController.h
//  AirEscape
//
//  Created by Horatiu Istrate on 12/07/14.
//  Copyright (c) 2014 Horatiu Istrate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEHangarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
}

@property (nonatomic, strong) NSDictionary *shopItemsDictionary;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *numberOfRockets;
@property (nonatomic, strong) UILabel *titleOfScreen;
@property (nonatomic, strong) UIImageView *rocketsImageView;
@property (nonatomic, strong) UIImageView *backgroundView;

@end
