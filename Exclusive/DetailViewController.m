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

@end

@implementation DetailViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLabels];
    self.collectionView.allowsMultipleSelection = YES;
}

-(void) viewWillAppear:(BOOL)animated
{

}

-(void) updateLabels
{
    double itemsPrice;
    
    for (Item * theItem in [[self.detailItem items] allObjects])
    {
        itemsPrice += [theItem.price_paid doubleValue];
    }
    
    self.totalItemsLabel.text = [NSString stringWithFormat:@"%lu Items", (unsigned long)[self.detailItem.items count]];
    self.itemsValueLabel.text = [NSString stringWithFormat:@"$%.2f",itemsPrice ];
}

- (IBAction)closeReceipt:(id)sender
{
    
}

#pragma mark AddItemViewControllerDelegate

-(void) didCreateNewItem:(Item *)theItem
{
    // The Item class has a property for setting
    // the relationship between the item and
    // the batch on which it was purchased
    theItem.batch = self.detailItem;
    
    // DEBUG
    NSLog(@"%@",[theItem description]);
    
    
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
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (Item *)createItemRecord {
    //Create item record to be added and modified
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [appDelegate managedObjectContext];
    
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
    
    Item * theItem = [self.detailItem.items.allObjects objectAtIndex:indexPath.row];
    //NSLog(@"%@",[theItem description]);
    
    NSLog(@"AYYYYYY LMAOOOO");
    
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // animate the cell user tapped on

    
    [UIView animateWithDuration:0.8
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor lightGrayColor]];
                     }
                     completion:nil];
    
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Item * theItem = [self.detailItem.items.allObjects objectAtIndex:indexPath.row];
    //NSLog(@"%@",[theItem description]);
    
    NSLog(@"AYYYYYY LMAOOOO");
    
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // animate the cell user tapped on
    
    
    [UIView animateWithDuration:0.8
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil];
    
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[collectionView indexPathsForSelectedItems] count] > 0) ? NO : YES;
}



@end
