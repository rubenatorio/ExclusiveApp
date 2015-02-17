//
//  FormViewControllerPrototype.h
//  Exclusive
//
//  Created by Ruben Flores on 2/17/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FormViewControllerDelegate <NSObject>

@required
-(void) didObtainDataFromUser:(NSDictionary *) dictionary;

@end

@interface FormViewControllerPrototype : UIViewController

@property (nonatomic, assign) int index;

@property (nonatomic, strong) id<FormViewControllerDelegate> delegate;

@end
