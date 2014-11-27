//
//  MessageViewController.m
//  PizzaPyGuestbook
//
//  Created by Roger on 11/27/14.
//  Copyright (c) 2014 radj. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellAuthor.textLabel.text = _entry[@"name"];
    _cellAuthor.detailTextLabel.text = _entry[@"date"];
    _textMessage.text = _entry[@"message"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
