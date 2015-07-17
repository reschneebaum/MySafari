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
    self.urlTextField.text = self.currentUrl;
    NSLog(@"text field set in viewdidload");
    self.backButton.enabled = false;
    self.forwardButton.enabled = false;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textFieldArg {
    [self loadUrl:self.urlTextField.text];
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
    self.currentUrl = [url absoluteString];

    //attempted urltextfield updating -- doesn't work yet!
        /*[self updateAddressBarText:self.webView.request.URL];
        self.urlTextField.text = [url absoluteString];
        NSLog(@"text field set in loadurl"); */
    self.urlTextField.placeholder = @"enter url";
}

//attempted urltextfield updating -- doesn't work yet!
/* - (void) updateAddressBarText: (NSURL *)updatedUrl {
    NSString *urlString = [updatedUrl absoluteString];
    self.urlTextField.text = urlString;
} */

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    //self.urlTextField.text = self.currentUrl;
    //NSLog(@"text field set in didfinishload");
    [self setEnabled];
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
    self.urlTextField.text = self.currentUrl;
    NSLog(@"text field set in backbuttonpressed");
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    [self.webView goForward];
    self.urlTextField.text = self.currentUrl;
    NSLog(@"text field set in forwardbuttonpressed");
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Invalid URL";
    alert.message = error.localizedDescription;
    alert.delegate = self;
    [alert addButtonWithTitle:@"Try Again"];
    [alert addButtonWithTitle:@"Go Home"];
    [alert show];
    [self.activityIndicator stopAnimating];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self loadUrl:@"google.com"];
        self.urlTextField.text = @"google.com";
    } else {
        self.urlTextField.text = nil;
    }
}


@end
