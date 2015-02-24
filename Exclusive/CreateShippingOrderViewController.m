#import "CreateShippingOrderViewController.h"
#import "DetailCollectionViewCell.h"
#import "Item.h"

@interface CreateShippingOrderViewController()

@end

@implementation CreateShippingOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES;
}



-(void) viewWillAppear:(BOOL)animated
{
    [self updateLabels];
}



/*
 *  This method is responsible for updating the data labels from the main view
 */
-(void) updateLabels
{

}

- (IBAction)cancel:(id)sender
{
    [self.delegate userDidCancelShippingOrder:self.shippingOrder];
}

- (void)userConfirmed
{
    NSArray *selectedItemsIndexes = [self.collectionView indexPathsForSelectedItems];
    
    double itemsPrice;
    
    for (NSIndexPath *indexPath in selectedItemsIndexes)
    {
        Item *theItem = [self.waitingItemsFetchedController objectAtIndexPath:indexPath];
        
        theItem.status = [NSNumber numberWithInt:SHIPPING];
        
        [self.shippingOrder addItemsObject: theItem];
        
        itemsPrice += [theItem.price_paid doubleValue];
    }
    
    self.shippingOrder.order_value = [NSNumber numberWithDouble:itemsPrice];
    
    self.shippingOrder.date_shipped = [NSDate date];
    
    [self.delegate didCreateNewShippingOrder: self.shippingOrder];
}

- (IBAction)confirmOrder:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Create Order:"
                                  message:@"are you sure you want to continue?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [self userConfirmed];
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)waitingItemsFetchedController
{
    if (_waitingItemsFetchedController != nil) {
        return _waitingItemsFetchedController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %i", WAITING];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price_paid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.waitingItemsFetchedController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.waitingItemsFetchedController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _waitingItemsFetchedController;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* We need to assign ourselves as the next view controller's delegate
     to allow us to dismiss it when the user is done interacting with it */
    if ([[segue identifier] isEqualToString:@"addItemModal"])
    {

    }
}

#pragma mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.waitingItemsFetchedController sections][section];
    return [sectionInfo numberOfObjects];
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
    
    Item * theItem = [self.waitingItemsFetchedController objectAtIndexPath:indexPath];
    
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

}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
