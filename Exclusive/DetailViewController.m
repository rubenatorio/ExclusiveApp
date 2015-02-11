//
//  DetailViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "DetailViewController.h"
#import "AddItemViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

/*
 *  This function allows us to set the batch object
 *  that we will use to display detailed data
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* We need to assign ourselves as the next view controller's delegate
       to allow us to dismiss it when the user is done interacting with it */
    if ([[segue identifier] isEqualToString:@"addItemModal"])
    {
        AddItemViewController *vc = (AddItemViewController*)[segue destinationViewController];
        vc.delegate = self;
    }
}

#pragma mark AddItemViewControllerDelegate

-(void) dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
