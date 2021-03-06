//
//  ShippingOrder.h
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface ShippingOrder : NSManagedObject

@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSDate * date_shipped;
@property (nonatomic, retain) NSNumber * order_value;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * parse_id;
@property (nonatomic, retain) NSSet *items;
@end

@interface ShippingOrder (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
