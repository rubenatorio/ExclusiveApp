//
//  InitialFetchViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol InitialFetchViewControllerDelegate <NSObject>

-(void) didFinishFetchingData;

@end

@interface InitialFetchViewController : UIViewController

@property (weak, nonatomic) id<InitialFetchViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
