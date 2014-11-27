//
//  MessageViewController.h
//  PizzaPyGuestbook
//
//  Created by Roger on 11/27/14.
//  Copyright (c) 2014 radj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UITableViewController

@property (strong) NSDictionary *entry;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAuthor;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMessage;
@property (weak, nonatomic) IBOutlet UITextView *textMessage;

@end
