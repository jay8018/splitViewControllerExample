//
//  BNRWebViewController.m
//  NerdFeed
//
//  Created by test on 1/6/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UIWebViewDelegate>
@property (nonatomic) UIBarButtonItem *backButton;
@property (nonatomic) UIBarButtonItem *forwardButton;
@end

@implementation BNRWebViewController

-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
   // [[NSBundle mainBundle] loadNibNamed:@"ToolBar" owner:self options:nil];
   // CGRect screenRect = [[UIScreen mainScreen] bounds];
   // CGFloat y = (screenRect.size.height - 44.0);
    //self.toolBar.frame = CGRectMake(0, y, screenRect.size.width, 44.0);
    //y = MAX(y, screenRect.size.width - 44.0);
//    self.toolBar.frame = CGRectMake(0, y, self.view.bounds.size.width, 44.0);
    //self.toolBar.delegate = self;
  //  [webView addSubview:self.toolBar];
     _backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:(UIBarButtonItemStylePlain) target:self action:@selector(goBack:)];
    _backButton.width = 30.0;
    
    _forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"> " style:(UIBarButtonItemStylePlain) target:self action:@selector(forward:)];
    _forwardButton.width = 30.0;
    
    NSArray *items = @[self.backButton,self.forwardButton];
    
    [self setToolbarItems:items animated:YES];
    [[self navigationController] setToolbarHidden:NO];
    
    self.view = webView;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateButtonState];
   
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    }
}

-(void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
        [(UIWebView *)self.view loadRequest:request];
    }
}

- (IBAction)goBack:(id)sender {
    [(UIWebView *)self.view goBack];
    [self updateButtonState];
}

- (IBAction)forward:(id)sender {
    [(UIWebView *)self.view goForward];
    [self updateButtonState];
}

-(void)updateButtonState
{
    if ([(UIWebView *)self.view canGoBack] == YES) {
        [self.backButton setEnabled:YES];
    }
    else{
        [self.backButton setEnabled:NO];
    }
    
    if ([(UIWebView *)self.view canGoForward] == YES) {
        [self.forwardButton setEnabled:YES];
    }
    else{
        [self.forwardButton setEnabled:NO];
    }

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateButtonState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateButtonState];
}

@end
