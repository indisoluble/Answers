//
//  IAWModelAnswerTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/03/2015.
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

#import "IAWModelAnswer.h"

#import "IAWMockPersistenceDatastore.h"



@interface IAWModelAnswerTests : XCTestCase

@property (strong, nonatomic) NSString *oneQuestionText;
@property (strong, nonatomic) NSSet *oneOptionSet;

@property (strong, nonatomic) IAWMockPersistenceDatastore *mockDatastore;

@end



@implementation IAWModelAnswerTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.oneQuestionText = @"This is a question";
    self.oneOptionSet = [NSSet setWithObject:@"This is an option"];
    
    self.mockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    self.mockDatastore.resultCreateDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockDatastore = nil;
    
    self.oneOptionSet = nil;
    self.oneQuestionText = nil;
    
    [super tearDown];
}

- (void)testSimpleInitFails
{
    XCTAssertNil([[IAWModelAnswer alloc] init], @"'init' should fail");
}

- (void)testCreateWithQuestionTextSetToNilFails
{
    IAWModelAnswer *answer = [IAWModelAnswer createAnswerWithText:nil
                                                          options:self.oneOptionSet
                                                      inDatastore:self.mockDatastore
                                                            error:nil];
    
    XCTAssertTrue((answer == nil) && !self.mockDatastore.didCreateDocument,
                  @"The text is mandatory. No document should be created");
}

- (void)testCreateWithEmptyQuestionTextFails
{
    IAWModelAnswer *answer = [IAWModelAnswer createAnswerWithText:@""
                                                          options:self.oneOptionSet
                                                      inDatastore:self.mockDatastore
                                                            error:nil];
    
    XCTAssertTrue((answer == nil) && !self.mockDatastore.didCreateDocument,
                  @"An empty string is not a valid question. No document should be created");
}

- (void)testCreateWithOptionsSetToNilFails
{
    IAWModelAnswer *answer = [IAWModelAnswer createAnswerWithText:self.oneQuestionText
                                                          options:nil
                                                      inDatastore:self.mockDatastore
                                                            error:nil];
    
    XCTAssertTrue((answer == nil) && !self.mockDatastore.didCreateDocument,
                  @"The options are mandatory. No document should be created");
}

- (void)testCreateWithAnEmptyOptionFails
{
    IAWModelAnswer *answer = [IAWModelAnswer createAnswerWithText:self.oneQuestionText
                                                          options:[NSSet setWithObjects:@"No empty", @" ", nil]
                                                      inDatastore:self.mockDatastore
                                                            error:nil];
    
    XCTAssertTrue((answer == nil) && !self.mockDatastore.didCreateDocument,
                  @"The options are mandatory. No document should be created");
}

- (void)testCreateReturnNilIfDocumentIsNotCreated
{
    self.mockDatastore.resultCreateDocument = nil;
    
    IAWModelAnswer *answer = [IAWModelAnswer createAnswerWithText:self.oneQuestionText
                                                          options:self.oneOptionSet
                                                      inDatastore:self.mockDatastore
                                                            error:nil];
    
    XCTAssertTrue((answer == nil) && self.mockDatastore.didCreateDocument,
                  @"It tries to create a document but it fails and no answer is returned at the end");
}

- (void)testDeleteWithAnswerSetToNilFails
{
    BOOL result = [IAWModelAnswer deleteAnswer:nil inDatastore:self.mockDatastore error:nil];
    
    XCTAssertFalse(result, @"No answer can be deleted if the answer is not supplied");
}

- (void)testDeleteWithAnswerSetToNilDoesNotCallDatastore
{
    [IAWModelAnswer deleteAnswer:nil inDatastore:self.mockDatastore error:nil];
    
    XCTAssertFalse(self.mockDatastore.didDeleteDocument,
                   @"If no answer is informed, it should not try to delete anything");
}

@end
