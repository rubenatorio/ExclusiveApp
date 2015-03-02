//
//  AwaitingConfirmationCollectionViewCell.m
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "AwaitingConfirmationCollectionViewCell.h"

@implementation AwaitingConfirmationCollectionViewCell

-(void) configureSelfWithShippingOrder:(ShippingOrder *) shippingOrder {
    
    NSString *orderID = [shippingOrder.objectID.URIRepresentation absoluteString];
    
    NSLog(@"%@" , orderID);
    
    NSString *dateShipped = [NSDateFormatter localizedStringFromDate:shippingOrder.date_shipped
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    
    NSString *totalValue = [NSString stringWithFormat:@"$%.02f", [shippingOrder.order_value doubleValue]];
    
    self.orderIdLabel.text = orderID;
    self.dateShippedLabel.text = dateShipped;
    self.totalValueLabel.text = totalValue;
}

-(void) setColorAtIndex:(int) index {
    
    float red, green, blue;
    
    int remainder = index % 4;
    
    switch (remainder)
    {
        case 0:
            red = 17;
            green = 208;
            blue = 226;
            break;
            
        case 1:
            red = 255;
            green = 178;
            blue = 16;
            break;
        case 2:
            red = 38;
            green = 90;
            blue = 231;
            break;
        case 3:
            red = 255;
            green = 129;
            blue = 16;
            break;
            
        default:
            red = 0;
            green = 0;
            blue = 0;
            break;
    }
    
    [self setBackgroundColor:[UIColor colorWithRed:red/255.0
                                             green:green/255.0
                                              blue:blue/255.0
                                             alpha:1]];
}

@end
