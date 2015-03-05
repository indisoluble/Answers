//
//  IAWControllerQuestionsTVC.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 31/01/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

#import "IAWControllerQuestionsTVC.h"

#import "IAWControllerAddAnswerTVC.h"

#import "IAWModel.h"

#import "IAWLog.h"

#import "UITableViewCell+ControllerQuestionsCell.h"



@interface IAWControllerQuestionsTVC ()
{
    IAWPersistenceDatastore *_datastore;
    NSArray *_allQuestions;
}

@property (strong, nonatomic, readonly) IAWPersistenceDatastore *datastore;
@property (strong, nonatomic, readonly) NSArray *allQuestions;

@end



@implementation IAWControllerQuestionsTVC

#pragma mark - Synthesize properties
- (IAWPersistenceDatastore *)datastore
{
    if (!_datastore)
    {
        _datastore = [IAWPersistenceDatastore datastore];
    }
    
    return _datastore;
}

- (NSArray *)allQuestions
{
    if (!_allQuestions)
    {
        _allQuestions = [IAWModelQuestion allQuestionsInIndexManager:self.datastore.indexManager];
    }
    
    return _allQuestions;
}


#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [IAWControllerQuestionsTVC removeDatastoreObserver:self usingDatastore:_datastore];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDatastoreObservers];
    
    [self addRefreshControl];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] &&
        [segue.destinationViewController isKindOfClass:[IAWControllerAddAnswerTVC class]])
    {
        [self prepareForSegueAddAnswerTVC:segue.destinationViewController withCell:sender];
    }
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIAWControllerQuestionsTVCCellID
                                                            forIndexPath:indexPath];
    
    IAWModelQuestion *oneQuestion = self.allQuestions[indexPath.row];
    
    [cell configureWithQuestion:oneQuestion inIndexManager:self.datastore.indexManager];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IAWModelQuestion *oneQuestion = self.allQuestions[indexPath.row];
    
    NSError *error = nil;
    if (![self.datastore deleteDocument:oneQuestion.document error:&error])
    {
        IAWLogError(@"Question %@ not deleted: %@", oneQuestion, error);
    }
}


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
- (void)addRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self.datastore
                       action:@selector(refreshDocuments)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)addDatastoreObservers
{
    IAWPersistenceDatastoreNotificationCenter *notificationCenter = self.datastore.notificationCenter;
    
    [notificationCenter addDidCreateDocumentNotificationObserver:self
                                                        selector:@selector(manageDidCreateDocumentNotification:)
                                                          sender:self.datastore];
    [notificationCenter addDidReplaceDocumentNotificationObserver:self
                                                         selector:@selector(manageDidCreateDocumentNotification:)
                                                           sender:self.datastore];
    [notificationCenter addDidDeleteDocumentNotificationObserver:self
                                                        selector:@selector(manageDidCreateDocumentNotification:)
                                                          sender:self.datastore];
    [notificationCenter addDidRefreshDocumentsNotificationObserver:self
                                                          selector:@selector(manageDidRefreshDocumentsNotification:)
                                                            sender:self.datastore];
}

- (void)manageDidCreateDocumentNotification:(NSNotification *)notification
{
    IAWLogDebug(@"Received notification: %@", notification);
    
    [self releaseAllQuestions];
    
    [self.tableView reloadData];
}

- (void)manageDidRefreshDocumentsNotification:(NSNotification *)notification
{
    IAWLogDebug(@"Received notification: %@", notification);
    
    [self manageDidCreateDocumentNotification:nil];
    
    [self.refreshControl endRefreshing];
}

- (void)releaseAllQuestions
{
    _allQuestions = nil;
}

- (void)addQuestionWithText:(NSString *)questionText
{
    NSError *error = nil;
    IAWModelQuestion *oneQuestion = [IAWModelQuestion createQuestionWithText:questionText
                                                                 inDatastore:self.datastore
                                                                       error:&error];
    if (!oneQuestion)
    {
        IAWLogError(@"Error: %@", error);
    }
}

- (void)prepareForSegueAddAnswerTVC:(IAWControllerAddAnswerTVC *)addAnswerTVC
                           withCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    IAWModelQuestion *oneQuestion = self.allQuestions[indexPath.row];
    
    [addAnswerTVC useQuestion:oneQuestion inDatastore:self.datastore];
}


#pragma mark - Private methods
+ (void)removeDatastoreObserver:(id)observer usingDatastore:(IAWPersistenceDatastore *)datastore
{
    IAWPersistenceDatastoreNotificationCenter *notificationCenter = datastore.notificationCenter;
    
    [notificationCenter removeDidCreateDocumentNotificationObserver:observer sender:datastore];
    [notificationCenter removeDidReplaceDocumentNotificationObserver:observer sender:datastore];
    [notificationCenter removeDidDeleteDocumentNotificationObserver:observer sender:datastore];
    [notificationCenter removeDidRefreshDocumentsNotificationObserver:observer sender:datastore];
}

@end
