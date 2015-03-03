//
//  constants.h
//  Exclusive
//
//  Created by Ruben Flores on 3/1/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#ifndef Exclusive_constants_h
#define Exclusive_constants_h

typedef enum {ORDER_PROCESSING, ORDER_SHIPPING, ORDER_RECEIVED} orderStatus;

/*
 *  This typedef allows is to make sure that we can
 *  identify which pieces of inventory are ready to be sold
 */
typedef enum { PROCESSING, WAITING, SHIPPING, READY } status;

typedef enum { CLOSED, OPEN } batchState;

typedef enum { TOP, BOTTOM, SHOES, ACCESSORY, ELECTRONIC} category;




#endif
