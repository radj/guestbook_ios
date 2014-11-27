//
//  ListViewController.m
//  PizzaPyGuestbook
//
//  Created by Roger on 11/27/14.
//  Copyright (c) 2014 radj. All rights reserved.
//

#import "ListViewController.h"
#import "MessageViewController.h"

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

@interface ListViewController ()

@property (strong) NSDictionary *entries;
@property (weak)   NSMutableDictionary *selectedEntry;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *refreshBtn =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(btnRefreshClicked:)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
    [self loadData];
}

- (void)btnRefreshClicked:(id)sender {
    [self loadData];
}

- (void)loadData {
    NSURL *url = [NSURL URLWithString:@"http://10.0.1.42:5000/guests/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask =
    [delegateFreeSession dataTaskWithRequest:request
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                               
                               NSLog(@"Response = %@ %@\n", response, error);
                               
                               if (error == nil) {
                                   [self loadEntries:data];
                               } else {
                                   [UIAlertView popup:[NSString stringWithFormat:@"Dude, there was a problem with loading data.\n\n%@", error]];
                               }
                               
                               [self stopActivity];
                           }];
    [dataTask resume];
}

- (void)loadEntries:(NSData*)data {
    NSError *error = nil;
    _entries = [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                 error:&error];
    if (error == nil) {
        [self.tableView reloadData];
    } else {
        [UIAlertView popup:[NSString stringWithFormat:@"Dude, JSON data problems!\n\n%@", error]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *keys = [_entries allKeys];
    _selectedEntry = _entries[keys[indexPath.row]];
    cell.textLabel.text = _selectedEntry[@"name"];
    if (_selectedEntry[@"date"] == nil)
        _selectedEntry[@"date"] = @"Movember 13, 1953";
    cell.detailTextLabel.text =  _selectedEntry[@"date"];
    
    return cell;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].
    MessageViewController *msgCtrl = [segue destinationViewController];
    
    // Pass the selected object to the new view controller.
    msgCtrl.entry = _selectedEntry;
}

@end
