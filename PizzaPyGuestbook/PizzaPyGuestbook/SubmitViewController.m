//
//  SubmitViewController.m
//  PizzaPyGuestbook
//
//  Created by Roger on 11/27/14.
//  Copyright (c) 2014 radj. All rights reserved.
//

#import "SubmitViewController.h"

@interface UIAlertView (Extensions)
+ (void)popup:(NSString *)message;
@end

@implementation UIAlertView (Extensions)
+ (void)popup:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Did you know?"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"Yeah!"
                      otherButtonTitles:nil] show];
}
@end

@interface SubmitViewController ()

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSubmitClicked:(id)sender {
    NSLog(@"Sending data: %@, %@", _fieldName.text, _textMessage.text);
    
    [self postName:_fieldName.text message:_textMessage.text];
}

- (void)postName:(NSString*)name
         message:(NSString*)message {
    [self startActivity];

    NSURL *url = [NSURL URLWithString:@"http://10.0.1.42:5000/guests/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // The HTTP body submit
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterMediumStyle
                                                    timeStyle:NSDateFormatterShortStyle];
    NSString *body = [NSString stringWithFormat:@"guest={\"name\":\"%@\",\"message\":\"%@\",\"date\":\"%@\"}", _fieldName.text, _textMessage.text, date];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask =
        [delegateFreeSession dataTaskWithRequest:request
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   
                                   //NSLog(@"Response = %@ %@\n", response, error);
                                   
                                   if (error == nil) {
                                       [UIAlertView popup:@"Entry submitted successfully!"];
                                   } else {
                                       [UIAlertView popup:[NSString stringWithFormat:@"Dude, there was a problem with submission.\n%@", error]];
                                   }
                                   
                                   _fieldName.text = @"";
                                   _textMessage.text = @"Something cool...";
                                   
                                   [self stopActivity];
                                }];
    [dataTask resume];
}

- (void)startActivity {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    UIBarButtonItem *activityBtn =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityBtn;
    [activityIndicator startAnimating];
}

- (void)stopActivity {
    UIActivityIndicatorView *activityIndicator =
    (UIActivityIndicatorView*)self.navigationItem.leftBarButtonItem.customView;
    [activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
