//
//  ShipInventoryViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ShipInventoryViewController.h"
#import "ViewAllOrdersViewController.h"
#import "AppDelegate.h"

@interface ShipInventoryViewController ()

@property (strong, nonatomic) NSArray * shippedOrders;
@property (strong, nonatomic) NSArray * awaitingConfirmation;
@property (strong, nonatomic) NSArray * shippableObjects;
@property (assign, nonatomic) BOOL dataChanged;

@end

@implementation ShipInventoryViewController

- (void)fetchData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectModel *model = [appDelegate managedObjectModel];
    
    _shippedOrders = [self.managedObjectContext executeFetchRequest:[model fetchRequestTemplateForName:@"OrdersShipped"]
                                                              error:nil];
    _awaitingConfirmation = [self.managedObjectContext executeFetchRequest:[model fetchRequestTemplateForName:@"AwaitingConfimation"]
                                                                             error:nil];
    _shippableObjects = [self.managedObjectContext executeFetchRequest:[model fetchRequestTemplateForName:@"ReadyToShip"]
                                                                         error:nil];
    _dataChanged = NO;
    
    NSLog(@"%@", [[model fetchRequestTemplateForName:@"OrdersShipped"] description]);
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self updateLabels];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    
    if ([[segue identifier] isEqualToString:@"CreateShippingOrder"])
    {
        NSEntityDescription *entity = [[self.shippingOrdersFetchedController fetchRequest] entity];
        
        ShippingOrder *shippingOrder = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                                     inManagedObjectContext:self.managedObjectContext];
        
        // Since Core-data doesnt support enums natively.......
        shippingOrder.status = [NSNumber numberWithInt:ORDER_PROCESSING];
        
        CreateShippingOrderViewController *vc = (CreateShippingOrderViewController*)[segue destinationViewController];
        
        vc.delegate = self;
        vc.shippingOrder = shippingOrder;
    }
    
    if ([[segue identifier] isEqualToString:@"ViewAllShippingOrders"])
    {
        ViewAllOrdersViewController *vc = (ViewAllOrdersViewController *) [segue destinationViewController];
        
        vc.shippingOrdersFetchedController = self.shippingOrdersFetchedController;
    }
}

/*
 *  This method is responsible for updating the data labels from the main view
 */
-(void) updateLabels
{
    if (_dataChanged)
        [self fetchData];
    
    self.shippedOrdersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippedOrders count]];
    self.awatingConfirmationLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_awaitingConfirmation count]];
    self.shippableItemsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_shippableObjects count]];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)shippingOrdersFetchedController
{
    if (_shippingOrdersFetchedController != nil) {
        return _shippingOrdersFetchedController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingOrder"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_shipped" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.shippingOrdersFetchedController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.shippingOrdersFetchedController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _shippingOrdersFetchedController;
}


#pragma mark CreateShippingOrderDelegate

-(void) userDidCancelShippingOrder:(ShippingOrder *) shippingOrder
{
    [self.managedObjectContext deleteObject:shippingOrder];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    error = nil;
    if (![self.shippingOrdersFetchedController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didCreateNewShippingOrder:(ShippingOrder *)shippingOrder
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    error = nil;
    if (![self.shippingOrdersFetchedController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"Succesfully created shipping order with %lu items", (unsigned long)[shippingOrder.items count]);
    
    _dataChanged = YES;
    
    [self updateLabels];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
