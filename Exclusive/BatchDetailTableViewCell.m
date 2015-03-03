//
//  BatchDetailTableViewCell.m
//  Exclusive
//
//  Created by Ruben Flores on 2/28/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "BatchDetailTableViewCell.h"

@implementation BatchDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureSelfWithBatch:(Batch*) theBatch {
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:theBatch.date
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    
    NSString *amountString = [@" @ $" stringByAppendingString:[NSString stringWithFormat:@"%.02f", [theBatch.amount_spent doubleValue]]];
    
    self.dateLabel.text = dateString;
    self.priceLabel.text = amountString;
    
    BOOL setHidden = ([theBatch.open boolValue]) ? NO : YES;
    
    self.openLabel.hidden = setHidden;
}


@end
