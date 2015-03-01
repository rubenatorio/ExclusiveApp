//
//  ShippingOrderTableViewCell.m
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "ShippingOrderTableViewCell.h"

@implementation ShippingOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureSelfWithShippingOrder:(ShippingOrder *)shippingOrder {
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:shippingOrder.date_created
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    
    NSString *amountString = [@" @ $" stringByAppendingString:[NSString stringWithFormat:@"%.02f", [shippingOrder.order_value doubleValue]]];
    
    self.textLabel.text = [dateString stringByAppendingString: amountString];
    
}


@end
