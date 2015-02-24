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

@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES;
    
    _trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                 target:self
                                                                 action:@selector(deleteItem)];
}

/*
 *  check if the user should have editing capabilities over the current receipt
 */
- (void)checkLock
{
    if ([self.detailItem.open boolValue])
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

-(void) viewWillAppear:(BOOL)animated
{
    [self updateLabels];
    
    [self checkLock];
}

-(void) viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [appDelegate managedObjectContext];
}

/*
 *  This method is responsible for deleting the UICollectionViewCell
 *  selected and also remove it from the batch
 */
-(void)deleteItem
{
    if (_currentIndexPath != nil) //If we have a cell to remove
    {
        Item * theItem = [self.detailItem.items.allObjects objectAtIndex:_currentIndexPath.row];
    
        [self.detailItem removeItemsObject:theItem];
    
        // Save the context.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    
        // We must reload the data to make sure the cells are redisplayed correctly
        [self.collectionView reloadData];
        [self collectionView:self.collectionView didDeselectItemAtIndexPath:_currentIndexPath];
        [self updateLabels];
    }
}

/*
 *  This method is responsible for updating the data labels from the main view
 */
-(void) updateLabels
{
    double itemsPrice;
    
    for (Item * theItem in [[self.detailItem items] allObjects])
        itemsPrice += [theItem.price_paid doubleValue];
    
    self.totalItemsLabel.text = [NSString stringWithFormat:@"%lu Items", (unsigned long)[self.detailItem.items count]];
    self.itemsValueLabel.text = [NSString stringWithFormat:@"$%.2f",itemsPrice ];
}

/*
 *  Ask user if they are sure they want to publish the receipts
 *  to allow inventory to be shipped.
 */

- (IBAction)closeReceipt:(id)sender
{
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

-(void) publish
{
    for (Item * theItem in self.detailItem.items.allObjects)
    {
        theItem.status = [NSNumber numberWithInt:WAITING];
    }
    
    self.detailItem.open = [NSNumber numberWithBool:NO];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self checkLock];
    
    //TODO: Push changes into server 
}

#pragma mark AddItemViewControllerDelegate

/*
 *  Commit the batch changes into the context
 */
-(void) didCreateNewItem:(Item *)theItem
{
    // The Item class has a property for setting
    // the relationship between the item and
    // the batch on which it was purchased
    theItem.batch = self.detailItem;
    
    // Since Core-data doesnt support enums natively.......
    theItem.status = [NSNumber numberWithInt:PROCESSING];
    
    // Add the item pointer to the batch which owns it
    [self.detailItem addItemsObject:theItem];
    
    NSLog(@"Batch has: %lu items", (unsigned long)[[self.detailItem items] count]);
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.collectionView reloadData];
    [self updateLabels];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price_paid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (Item *)createItemRecord {
    //Create item record to be added and modified
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    Item *theItem = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    return theItem;
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
        vc.item = [self createItemRecord];
    }
}

#pragma mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.detailItem items] count];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // The main storyboard contains a prototype cell class (See DetailCell class)
    
    DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell"
                                                                            forIndexPath:indexPath];
    
    Item * theItem = [self.detailItem.items.allObjects objectAtIndex:indexPath.row];
    
    cell.brandLabel.text = theItem.brand;
    cell.sizeLabel.text = theItem.size;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", theItem.price_paid];
    cell.imageView.image = [UIImage imageWithData:theItem.image];
    cell.imageView.contentMode  = UIViewContentModeScaleAspectFit;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem setRightBarButtonItem:_trashButton animated:YES];
    
    _currentIndexPath = indexPath;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndexPath = indexPath;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.detailItem.open boolValue]) return NO;
    
    return ([[collectionView indexPathsForSelectedItems] count] > 0) ? NO : YES;
}

#pragma mark - Managing the detail item

/*
 *  This function allows us to set the batch object
 *  that we will use to display detailed data
 *
 *  @params:
 *
 *  newDetailItem: a batch object used for creating new purchased
 *                 inventory items on the batch.
 */

- (void)setDetailItem:(Batch*)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
    }
}

@end
