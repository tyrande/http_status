//
//  hsSiteViewController.m
//  http_status
//
//  Created by tyrande on 26/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsSiteViewController.h"
#import "hsSiteDetailViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

#import "hsDrawOpaqueRectBlockCellObject.h"

#import "hsHttpEngine.h"

@interface hsSiteViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) MBProgressHUD* HUD;
@property (nonatomic, readwrite, retain) NSMutableArray* tableContents;
@end

@implementation hsSiteViewController

@synthesize model = _modal;
@synthesize actions = _actions;
@synthesize HUD = _HUD;
@synthesize tableContents = _tableContents;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadSite:)];
    
//    UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [tempImg setImage:[UIImage imageNamed:@"bg_1.JPG"]];
//    [self.tableView setBackgroundView:tempImg];

    self.tableContents = [NSMutableArray array];
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    self.model = [[NITableViewModel alloc] initWithListArray:self.tableContents delegate:(id)[NICellFactory class]];
    self.tableView.delegate = [self.actions forwardingTo:self];
    self.tableView.dataSource = self.model;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
//    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_1.png"]];
    self.tableView.opaque = NO;
//    self.tableView.backgroundView = [UIImage imageNamed:@"gradientBackground.png"];
//    NSLog(@"NAV H: %@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    
    self.HUD.labelText = @"Loading";
    
    [self setSiteData];
}

- (void)reloadSite:(NSString *)identifer {
    [self.HUD showUsingAnimation:YES];
//    [self.blockAlertView show];
    [hsHttpEngine loadSiteConfig:^() {
        [self setSiteData];
        [self.HUD hideUsingAnimation:YES];
//        [self.blockAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

- (void)setSiteData {
    NICellDrawRectBlock drawTextBlock = ^CGFloat(CGRect rect, id object, UITableViewCell *cell) {
//        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"site_bar.jpg"];
//        [[UIColor redColor] set];
//        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] set];
//        rect.size = CGSizeMake(20, 20);
//        UIRectFill(rect);
//        [[UIColor clearColor] set];
//        cell.opaque = NO;
        
//        cell.backgroundColor = [UIColor clearColor];
//        cell.viewForBaselineLayout.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"site_bar.jpg"]];
//        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"site_bar.jpg"]];
//        cell.accessoryView.backgroundColor = [UIColor clearColor];
//        cell.contentView.backgroundColor = [UIColor clearColor];
        
//        ((UIView *)[cell.contentView.subviews objectAtIndex:0]).backgroundColor = [UIColor clearColor];
//        [((UIView *)[cell.contentView.subviews objectAtIndex:0]) setAlpha:0];
//        ((UIView *)[cell.contentView.subviews objectAtIndex:0]).opaque = NO;
//        NSLog(@"A: %@", ((UIView *)cell.contentView.subviews[0]).subviews);
//        NSLog(@"B: %d", ((UIView *)[cell.contentView.subviews objectAtIndex:0]).opaque);
//        NSLog(@"C: %d", cell.opaque);
        
//        titleLabel.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"site_bar.jpg"]];
//        NSLog(@"Block: %@", titleLabel.text);
        
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
        if (titleLabel) {
            titleLabel.text = [(NSDictionary *)object objectForKey:@"title"];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:[NSString stringWithFormat:@"cell_%@.png", [(NSDictionary *)object objectForKey:@"color"]]] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:[NSString stringWithFormat:@"cell_%@_s.png", [(NSDictionary *)object objectForKey:@"color"]]] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            ((UIButton *)cell.subviews[2]).hidden = YES;
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 50)];
            titleLabel.tag = 1;
            titleLabel.text = [(NSDictionary *)object objectForKey:@"title"];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            titleLabel.shadowOffset = CGSizeMake(0, -1);
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            titleLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:titleLabel];
            
//            ((UIButton *)cell.subviews[2]).frame = CGRectMake(20, 300, 30, 44);
//            
            
//            [((UIButton *)cell.subviews[2]) setFrame:CGRectMake(20, 300, 30, 44)];
//            ((UIButton *)cell.subviews[2]).hidden = NO;
//            UIButton *accessory_btn = (UIButton *)cell.subviews[2];
//            accessory_btn.frame = CGRectMake(20, 300, 30, 44);
//            cell.accessoryView = accessory_btn;
//            NSLog(@"BTN: %@", cell.subviews[2]);
//            NSLog(@"S1: %@", cell.subviews[1]);
//            NSLog(@"S0: %@", cell.subviews[0]);
        }
        UILabel *subTitleLabel = (UILabel *)[cell.contentView viewWithTag:2];
        if (subTitleLabel) {
            subTitleLabel.text = [(NSDictionary *)object objectForKey:@"subtitle"];
        } else {
            subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 36, 200, 20)];
            subTitleLabel.tag = 1;
            subTitleLabel.text = [(NSDictionary *)object objectForKey:@"subtitle"];
            subTitleLabel.textColor = [UIColor whiteColor];
            subTitleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            subTitleLabel.shadowOffset = CGSizeMake(0, -1);
            subTitleLabel.font = [UIFont boldSystemFontOfSize:10];
            subTitleLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:subTitleLabel];
        }
        return 0;
    };
    NSMutableDictionary *siteDictionary = [hsHttpEngine sites];
    
    NSArray *siteArray = [[siteDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (NSInteger ix = 0; ix < [siteDictionary count]; ++ix) {
        NSString *indentifer = [siteArray objectAtIndex:ix];
        NSString *subtitle = [[siteDictionary objectForKey:indentifer] objectForKey:@"Domain"];
//        NSLog(@"Mod: %d", ix%5);
//        [tableContents addObject:[_actions attachToObject:[NISubtitleCellObject objectWithTitle:indentifer subtitle:subtitle]
        [self.tableContents addObject:[_actions attachToObject:[hsDrawOpaqueRectBlockCellObject objectWithBlock:drawTextBlock object:[NSDictionary dictionaryWithObjectsAndKeys: indentifer, @"title", subtitle, @"subtitle", [NSString stringWithFormat:@"%d", (ix%5)], @"color", nil]]
                                          navigationBlock:^(id object, UIViewController* controller) {
                                              hsSiteDetailViewController* siteDetailController = [[hsSiteDetailViewController alloc] init];
                                              [siteDetailController loadSite:[(NSDictionary *)[object object] objectForKey:@"title"]];
                                              [controller.navigationController pushViewController:siteDetailController animated:YES];
                                              return NO;
                                          }]];
    }
    
    [self.tableView reloadData];
}

@end
