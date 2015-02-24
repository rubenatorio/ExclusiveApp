//
//  ShipInventoryViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ShipInventoryViewController.h"
#import "ViewAllOrdersViewController.h"

@interface ShipInventoryViewController ()

@end

@implementation ShipInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    
    if ([[segue identifier] isEqualToString:@"CreateShippingOrder"])
    {
        NSEntityDescription *entity = [[self.shippingOrdersFetchedController fetchRequest] entity];
        
        ShippingOrder *shippingOrder = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
        
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

-(void) updateLabels
{
    //self.beingShippedLabel.text = [NSString stringWithFormat:@"%f",itemsPrice ];
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
