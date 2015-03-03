//
//  InitialFetchViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "InitialFetchViewController.h"
#import "ModelController.h"

@interface InitialFetchViewController ()

@end

@implementation InitialFetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    [self.continueButton setHidden:YES];
    
    [self fetchDataFromParse];
}

- (IBAction)ayyButton:(id)sender {
    [self.delegate didFinishFetchingData];
}

-(void) fetchDataFromParse {
        
    [[ModelController sharedController] fetchDataFromParseCompletition:^(BOOL success){
        
        if (success)
            [self.delegate didFinishFetchingData];
        else
            abort();
    }];
}

@end
