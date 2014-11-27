//
//  SubmitViewController.h
//  PizzaPyGuestbook
//
//  Created by Roger on 11/27/14.
//  Copyright (c) 2014 radj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fieldName;
@property (weak, nonatomic) IBOutlet UITextView *textMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
