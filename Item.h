//
//  Item.h
//  Exclusive
//
//  Created by Ruben Flores on 2/22/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 *  This typedef allows is to make sure that we can 
 *  identify which pieces of inventory are ready to be sold
 */
typedef enum { PROCESSING, WAITING, SHIPPING, READY } status;

@class Batch;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * available;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * date_purchased;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * is_new;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * on_layaway;
@property (nonatomic, retain) NSNumber * price_paid;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Batch *batch;

@end
