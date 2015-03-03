//
//  LoginViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialFetchViewController.h"

@interface LoginViewController : UIViewController <InitialFetchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *formImageView;

@end
