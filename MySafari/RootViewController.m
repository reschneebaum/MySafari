//
//  ViewController.m
//  MySafari
//
//  Created by Rachel Schneebaum on 7/15/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property NSString *currentUrl;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //set defaults
    [self loadUrl:@"google.com"];
    self.backButton.enabled = false;
    self.forwardButton.enabled = false;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textFieldArg {
    [self loadUrl:textFieldArg.text];
    [textFieldArg resignFirstResponder];
    return YES;
}

- (void)loadUrl: (NSString *) urlString {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@", urlString]];
    if (urlString.length >= 7) {
        if ([[urlString substringToIndex:7]  isEqual: @"http://"]){
            url = [NSURL URLWithString:urlString];
        }
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.currentUrl = urlString;
    self.urlTextField.text = urlString;
    self.urlTextField.placeholder = @"enter url";

}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [self setEnabled];
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}

- (IBAction)onNewsButtonPressed:(UIButton *)sender {
    UIAlertView *newsAlert = [[UIAlertView alloc] init];
    newsAlert.title = @"New Feature";
    newsAlert.message = @"Coming soon!";
    [newsAlert addButtonWithTitle:@"back"];
    newsAlert.delegate = self;
    [newsAlert show];
}

-(void)setEnabled {
    //refactored commented code below
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

    /*if (self.webView.canGoBack == true) {
        self.backButton.enabled = true;
    } else {
        self.backButton.enabled = false;
    }

    if (self.webView.canGoForward == true) {
        self.forwardButton.enabled = true;
    } else {
        self.forwardButton.enabled = false;
    }*/
}

@end
