//
//  IAWPersistenceDatastoreSyncJobTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IAWPersistenceDatastoreSyncJob.h"

#import "IAWMockPersistenceDatastoreReplicator.h"



@interface IAWPersistenceDatastoreSyncJobTests : XCTestCase

@property (strong, nonatomic) IAWPersistenceDatastoreSyncJob *syncJob;
@property (strong, nonatomic) IAWMockPersistenceDatastoreReplicator *mockReplicator;

@end



@implementation IAWPersistenceDatastoreSyncJobTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mockReplicator = [[IAWMockPersistenceDatastoreReplicator alloc] init];
    self.mockReplicator.resultStart = YES;
    self.mockReplicator.resultReplication = YES;
    
    self.syncJob = [IAWPersistenceDatastoreSyncJob syncJobWithReplicator:self.mockReplicator];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.syncJob = nil;
    
    self.mockReplicator = nil;
    
    [super tearDown];
}

- (void)testSimpleInitFails
{
    XCTAssertNil([[IAWPersistenceDatastoreSyncJob alloc] init], @"A replicator is mandatory");
}

- (void)testInitWithoutAReplicatorFails
{
    XCTAssertNil([[IAWPersistenceDatastoreSyncJob alloc] initWithReplicator:nil], @"A replicator is mandatory");
}

- (void)testCompletionHandlerIsCalledIfReplicationCanNotBeStarted
{
    self.mockReplicator.resultStart = NO;
    
    XCTestExpectation *completionHandlerCalledExpectation = [self expectationWithDescription:@"Completion Handler called"];
    
    [self.syncJob startWithCompletionHandler:^{
        [completionHandlerCalledExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

- (void)testCompletionHandlerIsCalledIfReplicationSucceeds
{
    XCTestExpectation *completionHandlerCalledExpectation = [self expectationWithDescription:@"Completion Handler called"];
    
    [self.syncJob startWithCompletionHandler:^{
        [completionHandlerCalledExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

- (void)testCompletionHandlerIsCalledIfReplicationFails
{
    self.mockReplicator.resultReplication = NO;
    
    XCTestExpectation *completionHandlerCalledExpectation = [self expectationWithDescription:@"Completion Handler called"];
    
    [self.syncJob startWithCompletionHandler:^{
        [completionHandlerCalledExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

- (void)testCompletionHandlerIsCallIfJobIsStartedTwice
{
    [self.syncJob startWithCompletionHandler:^{
        // Do nothing
    }];
    
    XCTestExpectation *completionHandlerCalledExpectation = [self expectationWithDescription:@"Completion Handler called"];
    
    [self.syncJob startWithCompletionHandler:^{
        [completionHandlerCalledExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

@end
