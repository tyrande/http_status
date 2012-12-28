//
//  hsCookieDetailViewController.m
//  http_status
//
//  Created by tyrande on 27/12/12.
//  Copyright (c) 2012 tyrande. All rights reserved.
//

#import "hsCookieDetailViewController.h"

#import "NimbusModels.h"
#import "NimbusCore.h"

@interface hsCookieDetailViewController ()
@property (nonatomic, readwrite, retain) NITableViewModel* model;
@end

@implementation hsCookieDetailViewController

@synthesize model = _model;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = _model;
}

-(void)showCookie:(NSHTTPCookie *)cookie {
    NICellDrawRectBlock drawTextBlock = ^CGFloat(CGRect rect, id object, UITableViewCell *cell) {
        UITextView *comment = [[UITextView alloc] initWithFrame:rect];
        comment.text = object;
        comment.editable = NO;
        [cell.contentView addSubview:comment];
        return 0;
    };
    NSMutableArray* tableContents =
    [NSMutableArray arrayWithObjects:
     cookie.name,
     [NIDrawRectBlockCellObject objectWithBlock:drawTextBlock object:cookie.value],
     @"domain",
     [NITitleCellObject objectWithTitle:cookie.domain],
     @"path",
     [NITitleCellObject objectWithTitle:cookie.path],
     @"expires date",
     [NITitleCellObject objectWithTitle:[NSString stringWithFormat:@"%@", cookie.expiresDate]],
     nil];
    if (cookie.isHTTPOnly) {
        [tableContents addObject:@"HTTPOnly"];
    }
    if (cookie.isSecure) {
        [tableContents addObject:@"Secure"];
    }
    if (cookie.isSessionOnly) {
        [tableContents addObject:@"SessionOnly"];
    }
    [tableContents addObject:@"portList"];
    [tableContents addObject:[NIDrawRectBlockCellObject objectWithBlock:drawTextBlock object:[NSString stringWithFormat:@"%@", cookie.portList]]];
    [tableContents addObject:@"properties"];
    [tableContents addObject:[NIDrawRectBlockCellObject objectWithBlock:drawTextBlock object:[NSString stringWithFormat:@"%@", cookie.properties]]];
    [tableContents addObject:@"comment"];
    [tableContents addObject:[NITitleCellObject objectWithTitle:cookie.comment]];
    [tableContents addObject:@"commentURL"];
    [tableContents addObject:[NITitleCellObject objectWithTitle:[NSString stringWithFormat:@"%@", cookie.commentURL]]];
    [tableContents addObject:@"version"];
    [tableContents addObject:[NITitleCellObject objectWithTitle:[NSString stringWithFormat:@"%d",cookie.version]]];
    
    self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents delegate:(id)[NICellFactory class]];
    [self.tableView reloadData];
    
}

@end
