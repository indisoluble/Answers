//
//  IAWModelAnswerTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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

@end
