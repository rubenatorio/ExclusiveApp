//
//  LoginViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "LoginViewController.h"
#import "InitialFetchViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Used for hidding keyboard
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    
    tapper.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapper];
    
    // swippe up animation
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [self.formImageView addGestureRecognizer:swipeUp];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
}

- (void)nextViewController {
    
    // LOGIN TOKEN
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenLaunched"])
    {
        // show your only-one-time view
        
        InitialFetchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialFetchViewController"];
        
        vc.delegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    else
    {
        [self.userNameTextField setHidden:YES];
        [self.passwordTextField setHidden:YES];
        
        CGRect newFrame = self.formImageView.frame;
        
        newFrame.origin.y -= 1000;    // shift right by 500pts
        
        [UIView animateWithDuration:0.7
                         animations:^{
                             
                             self.formImageView.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                             [self performSegueWithIdentifier:@"UserAuthenticated" sender:self];
                         }];
    }
}

-(void)handleSwipe:(UITapGestureRecognizer *) sender {
    NSLog(@"UP Swipe");
    
    [self authenticate];
}

-(void) authenticate {
    
    [PFUser logInWithUsernameInBackground:self.userNameTextField.text
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error)
                                        {
        
                                            if (user)
                                                [self nextViewController];
                                                
                                             else
                                             {
                                                //Something bad has ocurred
                                                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                         message:errorString
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:@"Ok"
                                                                                               otherButtonTitles:nil, nil];
                                                [errorAlertView show];
                                            }
                                        }];
}

#pragma mark InitialFetchViewControllerDelegate

-(void) didFinishFetchingData {
    
    [self dismissViewControllerAnimated:YES completion:^(){

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"UserAuthenticated" sender:self];
    }];
    
}


@end
