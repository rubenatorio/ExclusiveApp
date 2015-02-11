//
//  Item.h
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Batch;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * product_id;
@property (nonatomic, retain) NSNumber * is_new;
@property (nonatomic, retain) NSNumber * price_paid;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSDate * date_purchased;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) Batch *batch;

@end
