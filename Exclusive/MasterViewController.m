//
//  MasterViewController.m
//  Exclusive
//
//  Created by Ruben Flores on 2/8/15.
//  Copyright (c) 2015 Ruben Flores. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ModelController.h"
#import "BatchDetailTableViewCell.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSFetchedResultsController *batchResultsController;

@property (nonatomic, strong) ModelController * modelController;

@end

@implementation MasterViewController

/*
 *   This function sets up the button for allowing the user to add a batch receipt
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //Obtain the batch FetchedResultsController from the model controller
    
    _modelController = [ModelController sharedController];
    
    _batchResultsController = [_modelController batchResultsController];
    
    _batchResultsController.delegate = self;
}


/*
 *  This function will prompt the user if they want to create a new batch receipt
 *  for adding inventory. A UIAlert will appear to promp the user for the dollar
 *  amount spent on this receipt and it will update the table view in its delegate method
 */

- (void)insertNewObject:(id)sender {
    
    UIAlertController *  alert = [UIAlertController alertControllerWithTitle:@"Create Purchase Receipt"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField)
                                                 {
                                                     textField.placeholder = @"Amount Spent";
                                                     textField.keyboardType = UIKeyboardTypeDecimalPad;

                                                 }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //[alert dismissViewControllerAnimated:YES completion:nil];
                                                          
                             UITextField *amountTextField = [alert.textFields objectAtIndex:0];
                             
                             [_modelController createNewBatchWithPrice: [NSNumber numberWithDouble:[amountTextField.text doubleValue]]];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* This block is responsible for obtaining the batch receipt record 
       at the selected index path and pass it to the destination view
       controller to display its contents */
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Batch *batch = [_batchResultsController objectAtIndexPath:indexPath];
        
        [[segue destinationViewController] setBatch:batch];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_batchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [_batchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BatchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Batch *batch = [_batchResultsController objectAtIndexPath:indexPath];
    
    [cell configureSelfWithBatch:batch];
     
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [_modelController removeBatchAtIndexPath:indexPath];
}

#pragma mark - Fetched results controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Batch *batch = [_batchResultsController objectAtIndexPath:indexPath];
    
    BatchDetailTableViewCell *theCell = (BatchDetailTableViewCell *) cell;
    
    [theCell configureSelfWithBatch:batch];
}
@end
