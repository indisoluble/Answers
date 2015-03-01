//
//  IAWControllerAddAnswerTVC.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 21/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

#import "IAWControllerAddAnswerTVC.h"

#import "IAWLog.h"



NSString * const kIAWControllerAddAnswerTVCCellID = @"OptionCell";



@interface IAWControllerAddAnswerTVC ()
{
    id<IAWPersistenceDatastoreProtocol> _datastore;
}

@property (strong, nonatomic) id<IAWPersistenceDatastoreProtocol> datastore;

@property (strong, nonatomic) IAWModelQuestion *questionOrNil;
@property (strong, nonatomic, readonly) NSArray *allOptions;

@property (strong, nonatomic, readonly) NSString *orgTitle;

@end



@implementation IAWControllerAddAnswerTVC

#pragma mark - Synthesize properties
- (id<IAWPersistenceDatastoreProtocol>)datastore
{
    if (!_datastore)
    {
        _datastore = [IAWPersistenceDatastoreDummy datastore];
    }
    
    return _datastore;
}

- (void)setDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
{
    _datastore = (datastore ? datastore : [IAWPersistenceDatastoreDummy datastore]);
}

- (void)setQuestionOrNil:(IAWModelQuestion *)questionOrNil
{
    _questionOrNil = questionOrNil;
    
    _allOptions = (_questionOrNil ?
                   [[_questionOrNil.options allObjects] sortedArrayUsingSelector:@selector(compare:)] :
                   @[]);
}


#pragma mark - Init object
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _datastore = nil;
        
        _questionOrNil = nil;
        _allOptions = nil;
        
        _orgTitle = self.title;
    }
    
    return self;
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
    
    [self addRightBarButtonItems];
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIAWControllerAddAnswerTVCCellID
                                                            forIndexPath:indexPath];
    
    NSString *oneOption = self.allOptions[indexPath.row];
    cell.textLabel.text = oneOption;
    
    return cell;
}


#pragma mark - Public methods
- (void)useQuestion:(IAWModelQuestion *)question
        inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
{
    self.datastore = datastore;
    
    self.questionOrNil = question;
    
    self.title = (self.questionOrNil ? self.questionOrNil.questionText : self.orgTitle);
    if ([self isViewLoaded])
    {
        [self.tableView reloadData];
    }
}


#pragma mark - Private methods
- (void)addRightBarButtonItems
{
    self.navigationItem.rightBarButtonItems = @[[self addBarButtonItem], [self saveBarButtonItem]];
}

- (UIBarButtonItem *)saveBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                          target:self
                                                                          action:@selector(saveAnswerButtonPressed)];
    
    return item;
}

- (UIBarButtonItem *)addBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addOptionButtonPressed)];
    
    return item;
}

- (void)saveAnswerButtonPressed
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    NSMutableArray *selectedOptions = [NSMutableArray arrayWithCapacity:[selectedRows count]];
    for (NSIndexPath *oneIndexPath in selectedRows)
    {
        [selectedOptions addObject:self.allOptions[oneIndexPath.row]];
    }
    
    [self createAnswerWithOptions:[NSSet setWithArray:selectedOptions]];
}

- (void)addOptionButtonPressed
{
    __block UIAlertView *alertView = nil;
    __weak IAWControllerAddAnswerTVC *weakSelf = self;
    
    void (^addQuestionAction)(void) = ^(void)
    {
        __strong IAWControllerAddAnswerTVC *strongSelf = weakSelf;
        if (strongSelf)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            [strongSelf addOptionWithText:textField.text];
        }
    };
    
    RIButtonItem *createItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"Add", @"Add") action:addQuestionAction];
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", @"Cancel")];
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add option", @"Add option")
                                           message:NSLocalizedString(@"Type an option", @"Type an option")
                                  cancelButtonItem:cancelItem
                                  otherButtonItems:createItem, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (void)addOptionWithText:(NSString *)optionText
{
    if (!self.questionOrNil)
    {
        IAWLogError(@"No question informed");
        
        return;
    }
    
    NSError *error = nil;
    IAWModelQuestion *oneQuestion = [IAWModelQuestion replaceQuestion:self.questionOrNil
                                                       byAddingOption:optionText
                                                          inDatastore:self.datastore
                                                                error:&error];
    if (!oneQuestion)
    {
        IAWLogError(@"Error: %@", error);
        
        return;
    }
    
    self.questionOrNil = oneQuestion;
    
    [self.tableView reloadData];
}

- (void)createAnswerWithOptions:(NSSet *)options
{
    if (!self.questionOrNil)
    {
        IAWLogError(@"No question informed");
        
        return;
    }
    
    NSError *error = nil;
    IAWModelAnswer *oneAnswer = [IAWModelAnswer createAnswerWithText:self.questionOrNil.questionText
                                                             options:options
                                                         inDatastore:self.datastore
                                                               error:&error];
    if (!oneAnswer)
    {
        IAWLogError(@"Error: %@", error);
        
        return;
    }
    
    [self popThisViewController];
}

- (void)popThisViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
