//
//  InitialFetchViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "InitialFetchViewController.h"

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
    
    // Fetch all ITEMS, BATCHES, SHIPPING ORDERS
    // Commit into local context
    
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKeyExists:@"objectId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Succesfully Retreived %lu items" , (unsigned long)[objects count]);
            
            NSLog(@"%@", [objects description]);
            
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            
            [self.continueButton setHidden:NO];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

@end
