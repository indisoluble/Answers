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



#define IAWMODELQUESTIONTESTS_QUESTIONTEXT  @"This is a question"



@interface IAWModelQuestionTests : XCTestCase

@property (strong, nonatomic) IAWMockPersistenceDatastore *mockDatastore;

@end



@implementation IAWModelQuestionTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mockDatastore = [[IAWMockPersistenceDatastore alloc] init];
    self.mockDatastore.resultCreateDocument = (id<IAWPersistenceDatastoreDocumentProtocol>)@"document";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockDatastore = nil;
    
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

@end
