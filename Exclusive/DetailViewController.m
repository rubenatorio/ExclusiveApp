//
//  DetailViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "DetailViewController.h"
#import "AddItemViewController.h"
#import "AppDelegate.h"
#import "DetailCollectionViewCell.h"

@interface DetailViewController ()

@property (nonatomic, strong) UIBarButtonItem *trashButton;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSFetchedResultsController *itemResultsController;

@property (nonatomic, strong) ModelController * modelController;

@end

@implementation DetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES;
    
    _trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                 target:self
                                                                 action:@selector(deleteItem)];
    
    _modelController = [ModelController sharedController];
    
    _itemResultsController = [_modelController itemResultsController];
    
    _itemResultsController.delegate = self;
}

/*
 *  check if the user should have editing capabilities over the current receipt
 */
- (void)checkLock {
    if ([self.batch.open boolValue])
    {
        self.closeReceiptButton.hidden = NO;
        [self.navigationItem setRightBarButtonItem:self.addItemButton animated:YES];
    }
    else
    {
        self.closeReceiptButton.hidden = YES;
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [self updateLabels];
    
    [self checkLock];
}

/*
 *  This method is responsible for deleting the UICollectionViewCell
 *  selected and also remove it from the batch
 */
-(void)deleteItem {
    if (_currentIndexPath != nil) //If we have a cell to remove
    {
        [_modelController removeItemFromBatch:self.batch atIndexPath:_currentIndexPath];
    
        // We must reload the data to make sure the cells are redisplayed correctly
        [self.collectionView reloadData];
        [self collectionView:self.collectionView didDeselectItemAtIndexPath:_currentIndexPath];
        [self updateLabels];
    }
}

/*
 *  This method is responsible for updating the data labels from the main view
 */
-(void) updateLabels {
    double itemsPrice;
    
    for (Item * theItem in [[self.batch items] allObjects])
        itemsPrice += [theItem.price_paid doubleValue];
    
    self.totalItemsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.batch.items count]];
    self.itemsValueLabel.text = [NSString stringWithFormat:@"$%.2f",itemsPrice ];
}

/*
 *  Ask user if they are sure they want to publish the receipts
 *  to allow inventory to be shipped.
 */

- (IBAction)closeReceipt:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                 alertControllerWithTitle:@"Publish"
                                 message:@"are you sure you want to close this receipt?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Publish"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [self publish];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


/*
 *  INVARIANT CHECK:
 *  This method's purpose is to check the congruency of our model to this point.
 *  System should inform the user that it will check the data to make sure everything is
 *  valid.
 */

-(void) publish {
    [_modelController publishBatch:self.batch];
    
    [self checkLock];
}

#pragma mark AddItemViewControllerDelegate

/*
 *  Commit the batch changes into the context
 */
-(void) didCreateNewItem:(Item *)theItem {
    [_modelController addItem:theItem toBatch:self.batch];
    
    [self.collectionView reloadData];
    [self updateLabels];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* We need to assign ourselves as the next view controller's delegate
       to allow us to dismiss it when the user is done interacting with it */
    if ([[segue identifier] isEqualToString:@"addItemModal"])
    {
        AddItemViewController *vc = (AddItemViewController*)[segue destinationViewController];
        
        // Receive updates for when the user has finished populating the item to add
        vc.delegate = self;
        
        // Create new managed object for the user to populate
        vc.item = [_modelController createItemRecord];
    }
}

#pragma mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.batch items] count];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // The main storyboard contains a prototype cell class (See DetailCell class)
    
    DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell"
                                                                            forIndexPath:indexPath];
    
    Item * theItem = [self.batch.items.allObjects objectAtIndex:indexPath.row];
    
    [cell configureSelfWithItem:theItem];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationItem setRightBarButtonItem:_trashButton animated:YES];
    
    _currentIndexPath = indexPath;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationItem setRightBarButtonItem:self.addItemButton animated:YES];
    _currentIndexPath = indexPath;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.batch.open boolValue]) return NO;
    
    return ([[collectionView indexPathsForSelectedItems] count] > 0) ? NO : YES;
}

#pragma mark - Managing the detail item

- (void)setBatch:(Batch*)newDetailItem {
    if (_batch != newDetailItem)
    {
        _batch = newDetailItem;
    }
}

@end
