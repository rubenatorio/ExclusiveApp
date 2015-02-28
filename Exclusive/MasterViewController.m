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
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Create Purchase Receipt"
                                                     message:@"Enter amount spent:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *amountTextField = [alert textFieldAtIndex:0];
    
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [alert addButtonWithTitle:@"Done"];
    [alert show];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [_modelController removeBatchAtIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Batch *batch = [_batchResultsController objectAtIndexPath:indexPath];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:batch.date
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    
    NSString *amountString = [@" @ $" stringByAppendingString:[batch.amount_spent stringValue]];
    
    cell.textLabel.text = [dateString stringByAppendingString: amountString];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        UITextField *amountTextField = [alertView textFieldAtIndex:0];
            
        [_modelController createNewBatchWithPrice: [NSNumber numberWithDouble:[amountTextField.text doubleValue]]];
    }
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
@end
