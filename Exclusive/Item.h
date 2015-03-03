//
//  Item.h
//  Exclusive
//
//  Created by Ruben Flores on 3/2/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Batch, ShippingOrder;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * date_purchased;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * is_new;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * on_layaway;
@property (nonatomic, retain) NSNumber * price_paid;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * parse_id;
@property (nonatomic, retain) Batch *batch;
@property (nonatomic, retain) ShippingOrder *shippingOrder;

@end
