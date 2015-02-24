//
//  PopSegue.m
//  Exclusive
//
//  Created by Ruben Flores on 2/23/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "PopSegue.h"

@implementation PopSegue

- (void)perform
{
    [[[self sourceViewController] navigationController] popToRootViewControllerAnimated:YES];
}

@end
