//
//  AknowledgeOrderViewController.h
//  Exclusive
//
//  Created by Ruben Flores on 2/27/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol AcknowledgeOrderViewControllerDelegate <NSObject>

-(void) didFinish;
-(void) userCancelled;

@end

@interface AcknowledgeOrderViewController : UIViewController <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) id<AcknowledgeOrderViewControllerDelegate> delegate;

-(void) setAwaitingConfirmation:(NSArray *)awaitingConfirmation;

@end
