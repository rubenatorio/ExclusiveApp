//
//  Batch.h
//  Exclusive
//
//  Created by Ruben Flores on 2/22/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

typedef enum { CLOSED, OPEN } batchState;

@interface Batch : NSManagedObject

@property (nonatomic, retain) NSNumber * amount_spent;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * total_items;
@property (nonatomic, retain) NSNumber * open;
@property (nonatomic, retain) NSSet *items;
@end

@interface Batch (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
