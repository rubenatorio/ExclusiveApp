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
    
    // Register UICollectionViewCell Styles
    //UINib *cellNib = [UINib nibWithNibName:@"DetailCollectionViewCell" bundle:nil];
    
    //[self.collectionView registerClass:[DetailCollectionViewCell class] forCellWithReuseIdentifier:@"DetailCell"];
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* We need to assign ourselves as the next view controller's delegate
       to allow us to dismiss it when the user is done interacting with it */
    if ([[segue identifier] isEqualToString:@"addItemModal"])
    {
        AddItemViewController *vc = (AddItemViewController*)[segue destinationViewController];
        
        vc.delegate = self;
        
        //Create item record to be added and modified
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                                    
        self.managedObjectContext = [appDelegate managedObjectContext];
                                    
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        
        Item *theItem = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
        
        vc.item = theItem;
    }
}

#pragma mark AddItemViewControllerDelegate

-(void) didCreateNewItem:(Item *)theItem
{
    theItem.batch = self.detailItem;
    
    NSLog(@"%@",[theItem description]);
    //TODO ADD ITEM TO BATCH
    [self.detailItem addItemsObject:theItem];
    
    NSLog(@"Batch has: %lu items", (unsigned long)[[self.detailItem items] count]);
    
    // Save the context.
     NSError *error = nil;
     if (![self.managedObjectContext save:&error]) {
         NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
         abort();
     }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell"
                                                                            forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
