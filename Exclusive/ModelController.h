//
//  ModelController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/26/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> 
#import "Batch.h"
#import "Item.h"
#import "ShippingOrder.h"

@protocol ModelControllerGelegate <NSObject>

@end


@interface ModelController : NSObject

+ (ModelController*)sharedController;

- (Item *)createItemRecord;

-(ShippingOrder *) createShippingOrder;

- (NSFetchedResultsController *)batchResultsController;
- (NSFetchedResultsController *)itemResultsController;
- (NSFetchedResultsController *)waitingItemsFetchedController;
- (NSFetchedResultsController *)shippingOrderResultsController;

-(void) saveLocalContext;
-(void) publishBatch:(Batch*) batch;
-(void) deleteBatch:(Batch *) batch;
-(void) shippedOrder:(ShippingOrder *) shippingOrder;
-(void) acknowledgeShippingOrder:(ShippingOrder *) shippingOrder;
-(void) addItem:(Item*) theItem toBatch:(Batch*) batch;
-(void) deleteShippingOrder:(ShippingOrder *) shippingOrder;
-(void) createNewBatchWithPrice:(NSNumber *) amountSpent;
-(void) removeBatchAtIndexPath:(NSIndexPath *) indexPath;
-(void) removeItemFromBatch:(Batch*) batch atIndexPath:(NSIndexPath *) indexPath;

-(NSArray *) fetchShippedOrders;
-(NSArray *) fetchAwaitingConfirmation;
-(NSArray *) fetchShippableItems;

@end
