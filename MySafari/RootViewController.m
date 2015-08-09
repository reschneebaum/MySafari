//
//  ViewController.m
//  MySafari
//
//  Created by Rachel Schneebaum on 7/15/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "RootViewController.h"
#import <WebKit/WebKit.h>

@interface RootViewController () <UIWebViewDelegate,  UITextFieldDelegate, UIAlertViewDelegate, UINavigationBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property NSString *currentUrl;
@property CGPoint startingPoint;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.delegate = self;

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
    self.currentUrl = [url absoluteString];
    self.urlTextField.text = urlString;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [self setEnabled];

    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.navigationItem.title = title;
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
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startingPoint = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<self.startingPoint.y) {
        self.urlTextField.hidden = false;
    } else if (scrollView.contentOffset.y>self.startingPoint.y) {
        self.urlTextField.hidden = true;
    }
}


@end
