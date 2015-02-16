//
//  DetailViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Batch.h"
#import "AddItemViewController.h"

@interface DetailViewController : UIViewController <NSFetchedResultsControllerDelegate,AddItemViewControllerDelegate,
                                                    UICollectionViewDataSource, UICollectionViewDelegate>

/* Pointer to the batch record that will be displayed and manipulated */
@property (strong, nonatomic) Batch *detailItem;
/* Outlet to allow us to trigger segues from the storyboard */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItemButton;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

