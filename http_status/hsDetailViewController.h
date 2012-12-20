//
//  hsDetailViewController.h
//  http_status
//
//  Created by tyrande on 20/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hsDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
