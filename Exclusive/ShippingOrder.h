//
//  ShippingOrder.h
//  Exclusive
//
//  Created by Ruben Flores on 2/24/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface ShippingOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * order_value;
@property (nonatomic, retain) NSDate * date_shipped;
@property (nonatomic, retain) NSSet *items;
@end

@interface ShippingOrder (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
