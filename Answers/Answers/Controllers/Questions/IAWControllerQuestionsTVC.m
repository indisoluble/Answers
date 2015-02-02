//
//  IAWControllerQuestionsTVC.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 31/01/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

#import "IAWControllerQuestionsTVC.h"

#import "IAWPersistence.h"



@interface IAWControllerQuestionsTVC ()
{
    IAWPersistenceDatastoreDecorator *_datastore;
}

@property (strong, nonatomic, readonly) IAWPersistenceDatastoreDecorator *datastore;

@end



@implementation IAWControllerQuestionsTVC

#pragma mark - Synthesize properties
- (IAWPersistenceDatastoreDecorator *)datastore
{
    if (!_datastore)
    {
        _datastore = [IAWPersistenceDatastoreDecorator datastore];
    }
    
    return _datastore;
}


#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addDatastoreObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeDatastoreObservers];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


#pragma mark - Actions
- (IBAction)addQuestionButtonPressed:(id)sender
{
    __block UIAlertView *alertView = nil;
    __weak IAWControllerQuestionsTVC *weakSelf = self;
    
    void (^addQuestionAction)(void) = ^(void)
    {
        __strong IAWControllerQuestionsTVC *strongSelf = weakSelf;
        if (strongSelf)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            [strongSelf addQuestionWithText:textField.text];
        }
    };
    
    RIButtonItem *createItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"Add", @"Add") action:addQuestionAction];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", @"Cancel")];
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add new question", @"Add new question")
                                           message:NSLocalizedString(@"Type a question", @"Type a question")
                                  cancelButtonItem:cancelItem
                                  otherButtonItems:createItem, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}


#pragma mark - Private methods
- (void)addDatastoreObservers
{
    [self.datastore.notificationCenter addDidChangeNotificationObserver:self
                                                               selector:@selector(manageDidChangeNotification:)
                                                                 sender:self.datastore];
}

- (void)removeDatastoreObservers
{
    [self.datastore.notificationCenter removeDidChangeNotificationObserver:self
                                                                    sender:self.datastore];
}

- (void)manageDidChangeNotification:(NSNotification *)notification
{
    NSLog(@"Notification: %@", notification);
}

- (void)addQuestionWithText:(NSString *)questionText
{
    IAWModelQuestion *oneQuestion = [[IAWModelQuestion alloc] initWithQuestionText:questionText];
    if (!oneQuestion)
    {
        NSLog(@"Question instance not created");
        
        return;
    }
    
    NSError *error = nil;
    if (![self.datastore createDocument:oneQuestion error:&error])
    {
        NSLog(@"Error: %@", error);
    }
}

@end
