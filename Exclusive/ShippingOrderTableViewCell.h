//
//  ShippingOrderTableViewCell.h
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingOrder.h"

@interface ShippingOrderTableViewCell : UITableViewCell

-(void) configureSelfWithShippingOrder:(ShippingOrder *) shippingOrder;

@end
