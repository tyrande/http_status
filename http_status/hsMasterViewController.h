//
//  hsMasterViewController.h
//  http_status
//
//  Created by tyrande on 20/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import <UIKit/UIKit.h>

@class hsDetailViewController;

@interface hsMasterViewController : UITableViewController

@property (strong, nonatomic) hsDetailViewController *detailViewController;

@end
