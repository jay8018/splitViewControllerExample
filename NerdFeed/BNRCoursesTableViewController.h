//
//  BNRCoursesTableViewController.h
//  NerdFeed
//
//  Created by test on 1/6/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRWebViewController;

@interface BNRCoursesTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UISplitViewControllerDelegate>
@property (nonatomic) BNRWebViewController *webVC;
@end
