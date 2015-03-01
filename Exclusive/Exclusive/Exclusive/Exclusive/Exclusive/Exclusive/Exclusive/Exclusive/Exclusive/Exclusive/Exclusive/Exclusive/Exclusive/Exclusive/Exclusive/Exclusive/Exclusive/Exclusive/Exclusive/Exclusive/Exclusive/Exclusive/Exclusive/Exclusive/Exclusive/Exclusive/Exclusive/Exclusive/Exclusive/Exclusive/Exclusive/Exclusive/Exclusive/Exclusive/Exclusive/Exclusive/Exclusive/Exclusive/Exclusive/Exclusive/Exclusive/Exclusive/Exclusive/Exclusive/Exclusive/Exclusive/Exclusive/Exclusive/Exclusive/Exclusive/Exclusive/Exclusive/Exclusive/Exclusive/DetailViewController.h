//
//  DetailViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"
#import "ModelController.h"

/* 
 *  The purpose of this view controller is to allow an authorized user to add a batch item.
 *  A batch represents a receipt for a speific amount spent on inventory.
 *
 *  This View controller is responsible for presenting the Item records and its important information
 *  to the user. as the user is itemizing every item that was purchased.
 *
 *  The view contorller shold also implement a method for being able to add an item to the current batch
 *  to help obtain a full itemized list of all that was purchased on that receipt.
 *
 *  A modal view controller will be displayed to prompt the user for more detailed information about a 
 *  specific item being added to the batch.
 */

@interface DetailViewController : UIViewController <NSFetchedResultsControllerDelegate,AddItemViewControllerDelegate,
                                                    UICollectionViewDataSource, UICollectionViewDelegate>

/* Pointer to the batch record that will be displayed and manipulated */
@property (strong, nonatomic) Batch *batch;
/* Outlet to allow us to trigger segues from the storyboard */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItemButton;
/* This outlet property will be used to present the Batch items data to the user */
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UILabel *totalItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *closeReceiptButton;

@end

