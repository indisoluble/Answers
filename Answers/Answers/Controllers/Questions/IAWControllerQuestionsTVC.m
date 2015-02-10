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

#import "IAWLog.h"



NSString * const kIAWControllerQuestionsTVCCellID = @"QuestionCell";



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
        _allQuestions = [IAWControllerQuestionsTVC allQuestionsInDatastore:self.datastore];
    }
    
    return _allQuestions;
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
    
    [self addRefreshControl];
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
    return [self.allQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIAWControllerQuestionsTVCCellID
                                                            forIndexPath:indexPath];
    
    IAWModelQuestion *oneQuestion = self.allQuestions[indexPath.row];
    cell.textLabel.text = oneQuestion.questionText;
    
    return cell;
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
    [self.datastore.notificationCenter addDidCreateDocumentNotificationObserver:self
                                                                       selector:@selector(manageDidCreateDocumentNotification:)
                                                                         sender:self.datastore];
    [self.datastore.notificationCenter addDidRefreshDocumentsNotificationObserver:self
                                                                         selector:@selector(manageDidRefreshDocumentsNotification:)
                                                                           sender:self.datastore];
}

- (void)removeDatastoreObservers
{
    [self.datastore.notificationCenter removeDidCreateDocumentNotificationObserver:self
                                                                            sender:self.datastore];
    [self.datastore.notificationCenter removeDidRefreshDocumentsNotificationObserver:self
                                                                              sender:self.datastore];
}

- (void)manageDidCreateDocumentNotification:(NSNotification *)notification
{
    [self releaseAllQuestions];
    
    [self.tableView reloadData];
}

- (void)manageDidRefreshDocumentsNotification:(NSNotification *)notification
{
    [self manageDidCreateDocumentNotification:nil];
    
    [self.refreshControl endRefreshing];
}

- (void)addQuestionWithText:(NSString *)questionText
{
    IAWModelQuestion *oneQuestion = [[IAWModelQuestion alloc] initWithQuestionText:questionText];
    if (!oneQuestion)
    {
        IAWLogDebug(@"Question instance not created");
        
        return;
    }
    
    NSError *error = nil;
    if (![self.datastore createDocument:oneQuestion error:&error])
    {
        IAWLogError(@"Error: %@", error);
    }
}

- (void)releaseAllQuestions
{
    _allQuestions = nil;
}


#pragma mark - Private class methods
+ (NSArray *)allQuestionsInDatastore:(IAWPersistenceDatastore *)datastore
{
    NSArray *allDocuments = [datastore allDocuments];
    
    NSMutableArray *allQuestions = [NSMutableArray arrayWithCapacity:[allDocuments count]];
    for (id<IAWPersistenceDocumentProtocol> oneDocument in allDocuments)
    {
        [allQuestions addObject:[IAWModelQuestion questionWithDictionary:[oneDocument dictionary]]];
    }
    
    return allQuestions;
}

@end
