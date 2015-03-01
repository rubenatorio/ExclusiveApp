#import "CreateShippingOrderViewController.h"
#import "DetailCollectionViewCell.h"
#import "ModelController.h"

@interface CreateShippingOrderViewController()

@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (nonatomic, strong) NSFetchedResultsController *waitingItemsResultsController;

@property (nonatomic, strong) ModelController * modelController;

@end

@implementation CreateShippingOrderViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.allowsMultipleSelection = YES;
    
    _selectedItems = [NSMutableArray arrayWithObjects:nil];
    
    //Obtain the batch FetchedResultsController from the model controller
    
    _modelController = [ModelController sharedController];
    
    _waitingItemsResultsController = [_modelController waitingItemsFetchedController];
    
    _waitingItemsResultsController.delegate = self;
    
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

-(void) viewWillAppear:(BOOL)animated {
    _modelController = [ModelController sharedController];
    
    _waitingItemsResultsController = [_modelController waitingItemsFetchedController];
    
    [self.collectionView reloadData];
    
    [self updateLabels];
}

-(void) updateLabels {
    double orderValue = 0;
    int totalItems = 0;
    
    // If the user has selected items to add
    if (_selectedItems && [_selectedItems count] > 0)
    {
        for (Item *theItem in _selectedItems)
        {
            totalItems++;
            orderValue += [theItem.price_paid doubleValue];
        }
    }
    
    self.itemsToShipLabel.text = [NSString stringWithFormat:@"%d", totalItems];
    self.orderValueLabel.text = [NSString stringWithFormat:@"$%.2f", orderValue];
}

-(IBAction)cancel:(id)sender {
    [self.delegate userDidCancelShippingOrder:self.shippingOrder];
}

-(void)userConfirmed {
    NSArray *selectedItemsIndexes = [self.collectionView indexPathsForSelectedItems];
    
    double itemsPrice;
    
    for (NSIndexPath *indexPath in selectedItemsIndexes)
    {
        Item *theItem = [_waitingItemsResultsController objectAtIndexPath:indexPath];
        
        theItem.status = [NSNumber numberWithInt:SHIPPING];
        
        [self.shippingOrder addItemsObject: theItem];
        
        itemsPrice += [theItem.price_paid doubleValue];
    }
    
    self.shippingOrder.order_value = [NSNumber numberWithDouble:itemsPrice];
    
    self.shippingOrder.date_shipped = [NSDate date];
    
    // Since Core-data doesnt support enums natively.......
    self.shippingOrder.status = [NSNumber numberWithInt:ORDER_SHIPPING];
    
    [self.delegate didCreateNewShippingOrder: self.shippingOrder];
}

-(IBAction)confirmOrder:(id)sender {
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

#pragma mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [_waitingItemsResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // The main storyboard contains a prototype cell class (See DetailCell class)
    
    DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell"
                                                                                forIndexPath:indexPath];
    
    Item * theItem = [_waitingItemsResultsController objectAtIndexPath:indexPath];
    
    [cell configureSelfWithItem:theItem];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems addObject:[_waitingItemsResultsController objectAtIndexPath:indexPath]];
    [self updateLabels];
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems removeObject:[_waitingItemsResultsController objectAtIndexPath:indexPath]];
    [self updateLabels];
}

@end
