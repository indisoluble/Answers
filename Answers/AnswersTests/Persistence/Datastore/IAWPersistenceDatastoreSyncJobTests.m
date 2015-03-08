//
//  IAWPersistenceDatastoreSyncJobTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
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

- (void)testCompletionHandlerIsCalledAfterReplicationFinishes
{
    XCTestExpectation *completionHandlerCalledExpectation = [self expectationWithDescription:@"Completion Handler called"];
    
    [self.syncJob startWithCompletionHandler:^{
        [completionHandlerCalledExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

- (void)testCompletionHandlerIsCalledIfJobIsStartedTwice
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
