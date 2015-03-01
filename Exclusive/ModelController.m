//
//  ModelController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/26/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ModelController.h"
#import "AppDelegate.h"

@interface ModelController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *localContext;
@property (nonatomic, strong) NSFetchedResultsController *batchResultsController;
@property (nonatomic, strong) NSFetchedResultsController *itemResultsController;
@property (nonatomic, strong) NSFetchedResultsController *shippingOrderResultsController;
@property (nonatomic, strong) NSFetchedResultsController *waitingItemsResultsController;

@end

@implementation ModelController

#pragma mark Singleton Initialization

- (id) init {
    if (self = [super init])
    {
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _localContext = [_appDelegate managedObjectContext];
    }
    return self;
}

+ (ModelController *) sharedController{
    
    static ModelController *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ModelController alloc] init];
    });
    return _sharedInstance;
}

#pragma mark Batch Management

-(void) deleteBatch:(Batch *) batch{
    
}

-(void) publishBatch:(Batch*) batch{
    for (Item * theItem in batch.items.allObjects)
        theItem.status = [NSNumber numberWithInt:WAITING];
    
    batch.open = [NSNumber numberWithBool:NO];
    
    [self saveLocalContext];
}

-(void) createNewBatchWithPrice:(NSNumber *) amountSpent{
    
    Batch *batch = [NSEntityDescription insertNewObjectForEntityForName:@"Batch" inManagedObjectContext:_localContext];
    
    batch.date = [NSDate date];
    batch.amount_spent = amountSpent;
    
    [self saveLocalContext];
}

-(void) removeBatchAtIndexPath:(NSIndexPath *) indexPath{
    [_localContext deleteObject:[_batchResultsController objectAtIndexPath:indexPath]];
    
    [self saveLocalContext];
}

-(NSFetchedResultsController *)batchResultsController{
    if (_batchResultsController != nil)
        return _batchResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Batch" inManagedObjectContext:_localContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    _batchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:_localContext
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"Master"];
    
    NSError *error = nil;
    if (![_batchResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _batchResultsController;
}

#pragma mark Item Management

-(Item *) createItemRecord {
    
    //Create item record to be added and modified
    Item *theItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                  inManagedObjectContext:_localContext];
    return theItem;
}

-(NSFetchedResultsController *)itemResultsController{
    if (_itemResultsController != nil)
        return _itemResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:_localContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price_paid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    

    _itemResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                managedObjectContext:_localContext
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:@"Master"];
    
    NSError *error = nil;
    if (![_itemResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _itemResultsController;
}

-(void) addItem:(Item *) theItem toBatch:(Batch *) batch{
    // The Item class has a property for setting
    // the relationship between the item and
    // the batch on which it was purchased
    theItem.batch = batch;
    
    // Since Core-data doesnt support enums natively.......
    theItem.status = [NSNumber numberWithInt:PROCESSING];
    
    // Add the item pointer to the batch which owns it
    [batch addItemsObject:theItem];
    
    NSLog(@"Batch has: %lu items", (unsigned long)[[batch items] count]);
    
    [self saveLocalContext];
}

-(void) removeItemFromBatch:(Batch *) batch atIndexPath:(NSIndexPath *) indexPath{
    Item * theItem = [batch.items.allObjects objectAtIndex:indexPath.row];
    
    [batch removeItemsObject:theItem];
    
    [self saveLocalContext];
}

-(void) deleteItemFromBatch:(Batch *) theBatch atIndexPath:(NSIndexPath *) indexPath{
    Item * theItem = [theBatch.items.allObjects objectAtIndex:indexPath.row];
    
    [theBatch removeItemsObject:theItem];
    
    [self saveLocalContext];
}

#pragma mark ShippingOrder Management

- (NSFetchedResultsController *) shippingOrderResultsController {
    if (_shippingOrderResultsController != nil)
        return _shippingOrderResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShippingOrder"
                                              inManagedObjectContext:_localContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_shipped" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _shippingOrderResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:_localContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:@"Master"];
    NSError *error = nil;
    if (![_shippingOrderResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _shippingOrderResultsController;
}

- (NSFetchedResultsController *) waitingItemsFetchedController {
    
    if (_waitingItemsResultsController != nil)
        return _waitingItemsResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:_localContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %i", WAITING];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price_paid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _waitingItemsResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:_localContext
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:@"Master"];

    NSError *error = nil;
    if (![_waitingItemsResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _waitingItemsResultsController;
}

-(ShippingOrder *) createShippingOrder {
    
    ShippingOrder *shippingOrder = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingOrder"
                                                                 inManagedObjectContext:_localContext];
    
    // Since Core-data doesnt support enums natively.......
    shippingOrder.status = [NSNumber numberWithInt:ORDER_PROCESSING];
    
    shippingOrder.date_created = [NSDate date];
    
    return shippingOrder;
}

-(void) deleteShippingOrder:(ShippingOrder *) shippingOrder {
    
    [_localContext deleteObject:shippingOrder];
    
    [self saveLocalContext];
}

#pragma mark FetchResult Templates

-(NSArray *) fetchShippedOrders {
    return [_localContext executeFetchRequest:[[_appDelegate managedObjectModel] fetchRequestTemplateForName:@"OrdersShipped"] error:nil];
}

-(NSArray *) fetchAwaitingConfirmation {
    return [_localContext executeFetchRequest:[[_appDelegate managedObjectModel] fetchRequestTemplateForName:@"AwaitingConfimation"] error:nil];
}

-(NSArray *) fetchShippableItems {
    return [_localContext executeFetchRequest:[[_appDelegate managedObjectModel] fetchRequestTemplateForName:@"ReadyToShip"] error:nil];
   
}


#pragma mark NSNotifications

-(void) shippedOrder:(ShippingOrder *) shippingOrder {
    
    NSLog(@"POSTING NOTIFICATION");
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:shippingOrder
                                                         forKey:@"shippingOrder"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShippingOrderShipped" object:self userInfo:dataDict];
    
}

#pragma Local context management

- (void) saveLocalContext{
    // Save the context.
    NSError *error = nil;
    if (![_localContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
