//
//  BNRCoursesTableViewController.m
//  NerdFeed
//
//  Created by test on 1/6/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRCoursesTableViewController.h"
#import "BNRWebViewController.h"

@interface BNRCoursesTableViewController () <NSURLSessionDataDelegate>
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSArray *cursersArray;
@property (nonatomic) int selectedRow;

@end

@implementation BNRCoursesTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"BNR Courses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self fetchFeed];
        _selectedRow = -1;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [[self navigationController] setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cursersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.cursersArray[indexPath.row][@"title"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *url = self.cursersArray[indexPath.row][@"url"];
    NSString *url = @"http://www.baidu.com";
    NSURL *nsURL = [NSURL URLWithString:url];
    if (self.selectedRow != indexPath.row) {
        self.webVC.URL = nsURL;
        self.webVC.title = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
        self.selectedRow = indexPath.row;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [[self navigationController] pushViewController:self.webVC animated:YES];
    }
   // [[self navigationController] pushViewController:self.webVC animated:YES];
}

#pragma mark- private funtion
-(void)fetchFeed
{
    NSString *url = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *nsURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsURL];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       // NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _cursersArray = [[NSArray alloc] init];
        self.cursersArray = json[@"courses"];
        NSLog(@"array:%@",self.cursersArray);
       
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        
    }];
    [task resume];
}

#pragma mark- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

#pragma mark-UISplitViewControllerDelegate
//- (UIViewController *)primaryViewControllerForCollapsingSplitViewController:(UISplitViewController *)splitViewController
//{
//    self.webVC.navigationItem.leftBarButtonItem.title = @"change";
//    self.webVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//    return [self.webVC navigationController] ;
//}
//
//- (nullable UIViewController *)primaryViewControllerForExpandingSplitViewController:(UISplitViewController *)splitViewController NS_AVAILABLE_IOS(8_0){
//    return [self navigationController];
//}
//
//- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController
//separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController
//{
//    return [self.webVC navigationController] ;
//}
//
// perform its default collapsing behavior.
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController NS_AVAILABLE_IOS(8_0)
{
    return YES;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode NS_AVAILABLE_IOS(8_0)
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden)
    {
        self.webVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        NSLog(@"webVC width:%f height:%f",self.webVC.view.frame.size.width, self.webVC.view.frame.size.height);
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        NSLog(@"screenRect width:%f height:%f",screenRect.size.width, screenRect.size.height);
//        NSLog(@"tableview width:%f height:%f",self.view.frame.size.width, self.view.frame.size.height);
//        
//        CGSize splitSize = [[self splitViewController] view].bounds.size;
//        NSLog(@"splitSize width:%f height:%f",splitSize.width, splitSize.height);
//        CGRect windowSize = [[[[UIApplication sharedApplication] delegate] window] bounds] ;
//        NSLog(@"windowSize width:%f height:%f",windowSize.size.width, windowSize.size.height);

        //self.webVC.navigationItem.leftBarButtonItem.title = @"change";

       
    }
    else if (displayMode == UISplitViewControllerDisplayModeAllVisible)
    {
        self.webVC.navigationItem.leftBarButtonItem = nil;
//        NSLog(@"webVC width:%f height:%f",self.webVC.view.frame.size.width, self.webVC.view.frame.size.height);
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        NSLog(@"screenRect width:%f height:%f",screenRect.size.width, screenRect.size.height);
//        NSLog(@"tableview width:%f height:%f",self.view.frame.size.width, self.view.frame.size.height);
//        
//        CGSize splitSize = [[self splitViewController] view].bounds.size;
//        NSLog(@"splitSize width:%f height:%f",splitSize.width, splitSize.height);
//        
//        CGRect windowSize = [[[[UIApplication sharedApplication] delegate] window] bounds] ;
//        NSLog(@"windowSize width:%f height:%f",windowSize.size.width, windowSize.size.height);
//
//        
    }
}

@end
