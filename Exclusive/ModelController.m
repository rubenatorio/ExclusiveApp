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
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;
@property (nonatomic, strong) NSFetchedResultsController *batchResultsController;
@property (nonatomic, strong) NSFetchedResultsController *itemResultsController;
@property (nonatomic, strong) NSFetchedResultsController *shippingOrderResultsController;
@property (nonatomic, strong) NSFetchedResultsController *waitingItemsResultsController;

@end


@implementation ModelController


#pragma mark Singleton Initialization

- (void)contextHasChanged:(NSNotification*)notification  {
    if ([notification object] == _localContext) return;
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(contextHasChanged:)
                               withObject:notification
                            waitUntilDone:YES];
        return;
    }
    
    [_localContext mergeChangesFromContextDidSaveNotification:notification];
}

- (id) init {
    if (self = [super init])
    {
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _localContext = [_appDelegate managedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextHasChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
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

-(NSArray*) registeredObjects {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Batch" inManagedObjectContext:_localContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return [_localContext executeFetchRequest:fetchRequest error:nil];
}


#pragma mark PARSE Sync

-(void) fetchDataFromParseCompletition:(fetchCompleted)completittion {
    
    // Fetch all ITEMS, BATCHES, SHIPPING ORDERS
    [self fetchAllObjectsFromParseWithCompletion:^(NSMutableDictionary *records) {
        
        // DATA HAS BEEN PARSED PROCESS TO CORE DATA
        //NSLog(@"ASASJASASKAJSASJAKSJAKSJAKSAJSKAJSAKSJA%@", [records description]);
        
        BOOL success = (records) ? YES : NO;
        
        completittion(success);
        
    }];
    
}


#pragma mark Private asynchronous methods

- (NSMutableDictionary *)getPFObjects {
    
    NSMutableDictionary *objectRecords = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSArray *batches;
    NSArray *shippingOrders;
    NSArray *items;
    
    // Some long running task you want on another thread
    
    PFQuery *batchQuery = [PFQuery queryWithClassName:@"Batch"];
    [batchQuery whereKeyExists:@"objectId"];
    
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery whereKeyExists:@"objectId"];
    
    PFQuery *shippingOrderQuery = [PFQuery queryWithClassName:@"ShippingOrder"];
    [shippingOrderQuery whereKeyExists:@"objectId"];
    
    batches = [batchQuery findObjects];
    items = [itemQuery findObjects];
    shippingOrders = [shippingOrderQuery findObjects];
    
    // Index values to the dictionary
    
    [objectRecords setObject:batches forKey:@"Batches"];
    [objectRecords setObject:items forKey:@"Items"];
    [objectRecords setObject:shippingOrders forKey:@"ShippingOrders"];
    return objectRecords;
}

- (void)fetchAllObjectsFromParseWithCompletion:(void(^)(NSMutableDictionary *records))completition {
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _backgroundContext = [[NSManagedObjectContext alloc] init];
        
        [_backgroundContext setPersistentStoreCoordinator:[_appDelegate persistentStoreCoordinator]];
        
        // FETCH ALL PARSE OBJECTS
        NSLog(@"Fetching all Parse data......");
        NSMutableDictionary *objectRecords = [self getPFObjects];
        
        //TRANSFORM TO CORE DATA OBJECTS
        NSLog(@"Migrating parse data into core data...");
        NSMutableDictionary * modifiedObjects = [self transformToCoreDataObjects: objectRecords inContext:_backgroundContext];
        
        //COMMIT CHANGES
        NSLog(@"SAVING BACKGROUND CONTEXT");
        [self saveBackgroundContext];
        
        //RELATE CORE DATA OBJECTS
        NSLog(@"Creating object relationships");
        [self relateModifiedObjects:modifiedObjects];
        
        //COMMIT CHANGES
        NSLog(@"SAVING BACKGROUND CONTEXT");
        [self saveBackgroundContext];
        
        
        // FOR STYLIC REASONS...... LULZ
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"Going back to main thread");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completition) {
                completition(objectRecords);
            }
        });
    });

    
}

-(NSMutableDictionary *) transformToCoreDataObjects:(NSMutableDictionary *) objectRecords inContext:(NSManagedObjectContext *) context{
    
    NSMutableDictionary * coreDataObjects = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    
    // Create Batch Objects
    
    NSMutableArray * batchObjects = [NSMutableArray arrayWithObjects: nil];
    
    
    
    for (PFObject *pfobject in [objectRecords objectForKey:@"Batches"])
    {
        Batch *theBatch = [self createBatchFromPFObject:pfobject inContext:context];
        
        [batchObjects addObject:theBatch];
        
    }
    
    // Create Item Objects
    
    NSMutableArray * itemObjects = [NSMutableArray arrayWithObjects: nil];
    
    for (PFObject *pfobject in [objectRecords objectForKey:@"Items"])
        [itemObjects addObject:[self createItemFromPFObject:pfobject inContext:context]];
    
    // Create ShippingOrder Objects
    
    NSMutableArray * shippingOrderObjects = [NSMutableArray arrayWithObjects: nil];
    
    for (PFObject *pfobject in [objectRecords objectForKey:@"ShippingOrders"])
        [shippingOrderObjects addObject:[self createShippingOrderFromPFObject:pfobject inContext:context]];
    
    
    // Index values to the dictionary
    
    [coreDataObjects setObject:batchObjects forKey:@"Batches"];
    [coreDataObjects setObject:itemObjects forKey:@"Items"];
    [coreDataObjects setObject:shippingOrderObjects forKey:@"ShippingOrders"];
    
    return coreDataObjects;
    
}

-(void) relateModifiedObjects:(NSMutableDictionary *) modifiedObjects {
    
    NSMutableArray * batchObjects = [modifiedObjects valueForKey:@"Batches"];
    NSMutableArray * itemObjects = [modifiedObjects valueForKey:@"Items"];
    NSMutableArray * shippingOrderObjects = [modifiedObjects valueForKey:@"ShippingOrders"];
    
    for (Batch * currentBatch in batchObjects)
    {
        
        // iterate through all items and see which belong to this batch
        for (Item * currentItem in itemObjects)
        {
            PFObject *currentParseItem = [PFQuery getObjectOfClass:@"Item" objectId:currentItem.parse_id];
            PFObject * __batch = [currentParseItem valueForKey:@"batch"];
            
            // Realationship match!
            if ([currentBatch.parse_id isEqualToString:[__batch objectId]])
             {
                 [currentBatch addItemsObject:currentItem];
                 [currentItem setBatch:currentBatch];
             }
        }
        
        
    }
    
    for (ShippingOrder * currentOrder in shippingOrderObjects)
    {
        // iterate through all items and see which belong to this batch
        for (Item * currentItem in itemObjects)
        {
            PFObject *currentParseItem = [PFQuery getObjectOfClass:@"Item" objectId:currentItem.parse_id];
            PFObject * __order = [currentParseItem valueForKey:@"ShippingOrder"];
            
            // Realationship match!
            if ([currentOrder.parse_id isEqualToString:[__order objectId]])
            {
                [currentOrder addItemsObject:currentItem];
                [currentItem setShippingOrder:currentOrder];
            }
        }
    }

}


#pragma mark PARSE -> CORE DATA ON BACKGROUND CONTEXT

-(Batch *) createBatchFromPFObject:(PFObject *) pfobject inContext:(NSManagedObjectContext *) context{
    
    Batch * batch;
    
    batch = [NSEntityDescription insertNewObjectForEntityForName:@"Batch"
                                          inManagedObjectContext:_backgroundContext];
    
    // Populate with Parse object data
    
    batch.parse_id = [pfobject objectId];
    batch.date = [pfobject createdAt];
    batch.amount_spent = [pfobject valueForKey:@"amount_spent"];
    batch.total_items = [pfobject valueForKey:@"total_items"];
    batch.open = [pfobject valueForKey:@"open"];
    
    return batch;
}

-(Item *) createItemFromPFObject:(PFObject *) pfobject inContext:(NSManagedObjectContext *) context{
   
    Item * item;
    
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                          inManagedObjectContext:_backgroundContext];
    
    // Populate with Parse object data
    
    item.parse_id = [pfobject objectId];
    item.date_purchased = [pfobject createdAt];
    item.brand = [pfobject valueForKey:@"brand"];
    item.category = [pfobject valueForKey:@"category"];
    item.is_new = [pfobject valueForKey:@"is_new"];
    item.location = [pfobject valueForKey:@"location"];
    item.on_layaway = [pfobject valueForKey:@"on_layaway"];
    item.price_paid = [pfobject valueForKey:@"price_paid"];
    item.size = [pfobject valueForKey:@"size"];
    item.status = [pfobject valueForKey:@"status"];
    
    PFFile *imageFile = [pfobject valueForKey:@"image"];
    
    // Synchronous Call
    NSLog(@"DOWNLOADING IMAGE");
    item.image = [imageFile getData];
    
    return item;
}

-(ShippingOrder *) createShippingOrderFromPFObject:(PFObject *) pfobject inContext:(NSManagedObjectContext *) context{
    
    ShippingOrder * shippingOrder;
    
    shippingOrder = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingOrder"
                                          inManagedObjectContext:_backgroundContext];
    
    // Populate with Parse object data
    
    shippingOrder.parse_id = [pfobject objectId];
    shippingOrder.date_created = [pfobject createdAt];
    shippingOrder.date_shipped = [pfobject valueForKey:@"date_shipped"];
    shippingOrder.order_value = [pfobject valueForKey:@"order_value"];
    shippingOrder.status = [pfobject valueForKey:@"status"];
    
    return shippingOrder;
}


#pragma mark Batch Management

-(void) deleteBatch:(Batch *) batch {
    
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
    batch.open = [NSNumber numberWithBool:YES];
    
    [self saveLocalContext];
}

-(void) removeBatchAtIndexPath:(NSIndexPath *) indexPath{
    [_localContext deleteObject:[_batchResultsController objectAtIndexPath:indexPath]];
    
    [self saveLocalContext];
}

-(NSFetchedResultsController *)batchResultsController {
    
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

-(void) acknowledgeShippingOrder:(ShippingOrder *) shippingOrder {
    
    shippingOrder.status = [NSNumber numberWithInt:ORDER_RECEIVED];
    
    for (Item *theItem in shippingOrder.items)
        theItem.status = [NSNumber numberWithInt:READY];
    
    [self saveLocalContext];
    
    //boradcast notification that order was received
    
    [self didAcknowledgeOrder:shippingOrder];
    
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
    
    NSLog(@"POSTING NOTIFICATION SHIPPING ORDER");
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:shippingOrder
                                                         forKey:@"shippingOrder"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShippingOrderShipped" object:self userInfo:dataDict];
    
}

-(void) didAcknowledgeOrder:(ShippingOrder *) shippingOrder {
    
    NSLog(@"POSTING NOTIFICATION ACKNOWLEDGED ORDER");
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:shippingOrder
                                                         forKey:@"shippingOrder"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShippingOrderAcknowledged" object:self userInfo:dataDict];
    
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

- (void) saveBackgroundContext{
    // Save the context.
    NSError *error = nil;
    if (![_backgroundContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


@end
