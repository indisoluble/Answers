//
//  IAWModelQuestionTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IAWModelQuestion+ErrorBuilder.h"

#import "IAWMockPersistenceDatastore.h"
#import "IAWMockPersistenceDatastoreIndexManager.h"
#import "IAWMockPersistenceDatastoreDocument.h"



#define IAWMODELQUESTIONTESTS_QUESTIONTEXT  @"This is a question"
#define IAWMODELQUESTIONTESTS_OPTION        @"This is an option"



@interface IAWModelQuestionTests : XCTestCase

@property (strong, nonatomic) IAWModelQuestion *mockQuestion;
@property (strong, nonatomic) IAWMockPersistenceDatastore *mockDatastore;
@property (strong, nonatomic) IAWMockPersistenceDatastoreIndexManager *mockIndexManager;

@end



@implementation IAWModelQuestionTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    IAWMockPersistenceDatastore *otherMockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    IAWMockPersistenceDatastoreIndexManager *otherIndexManager = [[IAWMockPersistenceDatastoreIndexManager alloc] init];
    [IAWModelQuestion createQuestionWithText:IAWMODELQUESTIONTESTS_QUESTIONTEXT
                                 inDatastore:otherMockDatastore
                           usingIndexManager:otherIndexManager
                                       error:nil];
    IAWMockPersistenceDatastoreDocument *mockDocument = [[IAWMockPersistenceDatastoreDocument alloc] init];
    mockDocument.mockDictionary = otherMockDatastore.dictionaryForCreatedDocument;
    
    self.mockQuestion = [[IAWModelQuestion alloc] initWithDocument:mockDocument];
    
    self.mockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    self.mockDatastore.resultCreateDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
    self.mockDatastore.resultReplaceDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
    
    self.mockIndexManager = [[IAWMockPersistenceDatastoreIndexManager alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockIndexManager = nil;
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
                                                        usingIndexManager:self.mockIndexManager
                                                                    error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didCreateDocument,
                  @"The text is mandatory. No document should be created");
}

- (void)testCreateWithEmptyQuestionTextFails
{
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:@""
                                                              inDatastore:self.mockDatastore
                                                        usingIndexManager:self.mockIndexManager
                                                                    error:nil];
    
    XCTAssertTrue((question == nil) && !self.mockDatastore.didCreateDocument,
                  @"An empty string is not a valid question. No document should be created");
}

- (void)testCreateFailsIfQuestionAlreadyExists
{
    self.mockIndexManager.resultQuery = @[self.mockQuestion];
    
    NSError *error = nil;
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:IAWMODELQUESTIONTESTS_QUESTIONTEXT
                                                              inDatastore:self.mockDatastore
                                                        usingIndexManager:self.mockIndexManager
                                                                    error:&error];
    
    XCTAssertTrue((question == nil) &&
                  [IAWModelQuestion isErrorQuestionTextInUse:error] &&
                  !self.mockDatastore.didCreateDocument,
                  @"A new question can not be created if the index manager returns that "
                  "there is a document with the same text already");
}

- (void)testCreateReturnNilIfDocumentIsNotCreated
{
    self.mockDatastore.resultCreateDocument = nil;
    
    IAWModelQuestion *question = [IAWModelQuestion createQuestionWithText:IAWMODELQUESTIONTESTS_QUESTIONTEXT
                                                              inDatastore:self.mockDatastore
                                                        usingIndexManager:self.mockIndexManager
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

- (void)testDeleteWithQuestionSetToNilFails
{
    BOOL result = [IAWModelQuestion deleteQuestion:nil inDatastore:self.mockDatastore error:nil];
    
    XCTAssertFalse(result, @"No question can be deleted if the question is not supplied");
}

- (void)testDeleteWithQuestionSetToNilDoesNotCallDatastore
{
    [IAWModelQuestion deleteQuestion:nil inDatastore:self.mockDatastore error:nil];
    
    XCTAssertFalse(self.mockDatastore.didDeleteDocument,
                   @"If no answer is informed, it should not try to delete anything");
}

@end
