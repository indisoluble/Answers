//
//  IAWModelObjectTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IAWModelObject.h"

#import "IAWMockPersistenceDatastore.h"



#define IAWMODELOBJECTTESTS_TYPETEXT    @"type"
#define IAWMODELOBJECTTESTS_OTHERKEY    @"otherKey"
#define IAWMODELOBJECTTESTS_OTHERVALUE  @"otherValue"



@interface IAWModelObjectTests : XCTestCase

@property (strong, nonatomic) IAWMockPersistenceDatastore *mockDatastore;

@end



@implementation IAWModelObjectTests

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
    XCTAssertNil([[IAWModelObject alloc] init], @"A document is mandatory");
}

- (void)testInitWithoutADocumentFails
{
    XCTAssertNil([[IAWModelObject alloc] initWithDocument:nil], @"A document is mandatory");
}

- (void)testCreateWithObjectTypeSetToNilFails
{
    IAWModelObject *oneObject = [IAWModelObject createObjectWithType:nil
                                                                data:@{}
                                                         inDatastore:self.mockDatastore
                                                               error:nil];
    
    XCTAssertTrue((oneObject == nil) && !self.mockDatastore.didCreateDocument,
                  @"The type is mandatory. No document should be created");
}

- (void)testCreateWithEmptyObjectTypeFails
{
    IAWModelObject *oneObject = [IAWModelObject createObjectWithType:@""
                                                                data:@{}
                                                         inDatastore:self.mockDatastore
                                                               error:nil];
    
    XCTAssertTrue((oneObject == nil) && !self.mockDatastore.didCreateDocument,
                  @"An empty string is not a valid type. No document should be created");
}

- (void)testCreateWithDataSetToNilFails
{
    IAWModelObject *oneObject = [IAWModelObject createObjectWithType:IAWMODELOBJECTTESTS_TYPETEXT
                                                                data:nil
                                                         inDatastore:self.mockDatastore
                                                               error:nil];
    
    XCTAssertTrue((oneObject == nil) && !self.mockDatastore.didCreateDocument,
                  @"Data is mandatory. No document should be created");
}

- (void)testCreateFailsIfDataContainsInvalidKey
{
    IAWModelObject *oneObject = [IAWModelObject createObjectWithType:IAWMODELOBJECTTESTS_TYPETEXT
                                                                data:@{kIAWModelObjectKeyType: IAWMODELOBJECTTESTS_TYPETEXT}
                                                         inDatastore:self.mockDatastore
                                                               error:nil];
    
    XCTAssertTrue((oneObject == nil) && !self.mockDatastore.didCreateDocument,
                  @"Data can not inform the type. No document should be created");
}

- (void)testCreateReturnNilIfDocumentIsNotCreated
{
    self.mockDatastore.resultCreateDocument = nil;
    
    IAWModelObject *oneObject = [IAWModelObject createObjectWithType:IAWMODELOBJECTTESTS_TYPETEXT
                                                                data:@{}
                                                         inDatastore:self.mockDatastore
                                                               error:nil];
    
    XCTAssertTrue((oneObject == nil) && self.mockDatastore.didCreateDocument,
                  @"It tries to create a document but it fails and no object is returned at the end");
}

- (void)testCreateDocumentUsesTheDataProvided
{
    [IAWModelObject createObjectWithType:IAWMODELOBJECTTESTS_TYPETEXT
                                    data:@{IAWMODELOBJECTTESTS_OTHERKEY: IAWMODELOBJECTTESTS_OTHERVALUE}
                             inDatastore:self.mockDatastore
                                   error:nil];
    
    XCTAssertTrue([self.mockDatastore.dictionaryForDocument objectForKey:kIAWModelObjectKeyType] &&
                  [self.mockDatastore.dictionaryForDocument objectForKey:IAWMODELOBJECTTESTS_OTHERKEY],
                  @"The new document must include the type as well as the values in the data: %@",
                  self.mockDatastore.dictionaryForDocument);
}

@end
