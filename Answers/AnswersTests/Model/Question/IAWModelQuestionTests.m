//
//  IAWModelQuestionTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IAWModelQuestion.h"

#import "IAWMockPersistenceDatastore.h"
#import "IAWMockPersistenceDatastoreDocument.h"



#define IAWMODELQUESTIONTESTS_QUESTIONTEXT  @"This is a question"
#define IAWMODELQUESTIONTESTS_OPTION        @"This is an option"



@interface IAWModelQuestionTests : XCTestCase

@property (strong, nonatomic) IAWModelQuestion *mockQuestion;
@property (strong, nonatomic) IAWMockPersistenceDatastore *mockDatastore;

@end



@implementation IAWModelQuestionTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    IAWMockPersistenceDatastore *otherMockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    [IAWModelQuestion createQuestionWithText:IAWMODELQUESTIONTESTS_QUESTIONTEXT
                                 inDatastore:otherMockDatastore
                                       error:nil];
    IAWMockPersistenceDatastoreDocument *mockDocument = [[IAWMockPersistenceDatastoreDocument alloc] init];
    mockDocument.mockDictionary = otherMockDatastore.dictionaryForCreatedDocument;
    
    self.mockQuestion = [[IAWModelQuestion alloc] initWithDocument:mockDocument];
    
    self.mockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    self.mockDatastore.resultCreateDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
    self.mockDatastore.resultReplaceDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockDatastore = nil;
    self.mockQuestion = nil;
    
    [super tearDown];
}

- (void)testSimpleInitFails
{
    XCTAssertNil([[IAWModelQuestion alloc] init], @"'init' should fail");
}

- (void)testCreateWithQuestionTextSetToNilFails
{
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:nil
                                                              inDatastore:self.mockDatastore
                                                                    error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didCreateDocument,
                  @"The text is mandatory. No document should be created");
}

- (void)testCreateWithEmptyQuestionTextFails
{
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:@""
                                                              inDatastore:self.mockDatastore
                                                                    error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didCreateDocument,
                  @"An empty string is not a valid question. No document should be created");
}

- (void)testCreateReturnNilIfDocumentIsNotCreated
{
    self.mockDatastore.resultCreateDocument = nil;
    
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:IAWMODELQUESTIONTESTS_QUESTIONTEXT
                                                              inDatastore:self.mockDatastore
                                                                    error:nil];
    
    XCTAssertTrue((question == nil) && self.mockDatastore.didCreateDocument,
                  @"It tries to create a document but it fails and no question is returned at the end");
}

- (void)testReplaceWithQuestionSetToNilFails
{
    IAWModelQuestion *question = [IAWModelQuestion replaceQuestion:nil
                                                    byAddingOption:IAWMODELQUESTIONTESTS_OPTION
                                                       inDatastore:self.mockDatastore
                                                             error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didReplaceDocument,
                  @"To replace a question we have to know which question to replace");
}

- (void)testReplaceWithOptionSetToNilFails
{
    IAWModelQuestion *question = [IAWModelQuestion replaceQuestion:self.mockQuestion
                                                    byAddingOption:nil
                                                       inDatastore:self.mockDatastore
                                                             error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didReplaceDocument,
                  @"The option is mandatory. No question should be replaced");
}

- (void)testReplaceWithEmptyOptionFails
{
    IAWModelQuestion *question = [IAWModelQuestion replaceQuestion:self.mockQuestion
                                                    byAddingOption:@""
                                                       inDatastore:self.mockDatastore
                                                             error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didReplaceDocument,
                  @"An empty string is not a valid option. No question should be replaced");
}

- (void)testReplaceReturnNilIfDocumentIsNotReplaced
{
    self.mockDatastore.resultReplaceDocument = nil;
    
    IAWModelQuestion *question = [IAWModelQuestion replaceQuestion:self.mockQuestion
                                                    byAddingOption:IAWMODELQUESTIONTESTS_OPTION
                                                       inDatastore:self.mockDatastore
                                                             error:nil];
    
    XCTAssertTrue((question == nil) && self.mockDatastore.didReplaceDocument,
                  @"It tries to replace a question but it fails and no new document is created at the end");
}

@end
