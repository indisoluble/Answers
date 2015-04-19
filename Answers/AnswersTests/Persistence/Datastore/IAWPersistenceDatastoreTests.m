//
//  IAWPersistenceDatastoreTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 18/04/2015.
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

#import "IAWPersistenceDatastore.h"

#import "IAWPersistenceDatastoreReplicatorFactoryDummy.h"
#import "IAWMockPersistenceDatastoreIndexManager.h"
#import "IAWMockPersistenceDatastoreLocalStorage.h"



@interface IAWPersistenceDatastoreTests : XCTestCase

@property (strong, nonatomic) IAWPersistenceDatastore *datastore;

@property (strong, nonatomic) IAWMockPersistenceDatastoreLocalStorage *mockStorage;

@property (assign, nonatomic) BOOL didReceiveDeleteDocumentListNotification;

@end



@implementation IAWPersistenceDatastoreTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mockStorage = [[IAWMockPersistenceDatastoreLocalStorage alloc] init];
    
    id<IAWPersistenceDatastoreIndexManagerProtocol> indexManager = [[IAWMockPersistenceDatastoreIndexManager alloc] init];
    id<IAWPersistenceDatastoreReplicatorFactoryProtocol> replicatorFactory = [IAWPersistenceDatastoreReplicatorFactoryDummy factory];
    IAWPersistenceDatastoreSyncManager *syncManager = [IAWPersistenceDatastoreSyncManager synchronizationManager];
    IAWPersistenceDatastoreNotificationCenter *notificationCenter =
        [[IAWPersistenceDatastoreNotificationCenter alloc] initWithNotificationCenter:[[NSNotificationCenter alloc] init]];
    
    self.datastore = [[IAWPersistenceDatastore alloc] initWithLocalStorage:self.mockStorage
                                                              indexManager:indexManager
                                                         replicatorFactory:replicatorFactory
                                                               syncManager:syncManager
                                                        notificationCenter:notificationCenter];
    
    self.didReceiveDeleteDocumentListNotification = NO;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.datastore = nil;
    self.mockStorage = nil;
    
    [super tearDown];
}

- (void)testDeleteDocumentListReturnsSuccess
{
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_success;
    
    XCTAssertEqual([self.datastore deleteDocumentList:@[@"document"] error:nil],
                   IAWPersistenceDatastore_deleteDocumentList_resultType_success,
                   @"Return same value as local storage");
}

- (void)testDeleteDocumentListReturnsSomeDocuments
{
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_someDocumentsDeleted;
    
    XCTAssertEqual([self.datastore deleteDocumentList:@[@"document"] error:nil],
                   IAWPersistenceDatastore_deleteDocumentList_resultType_someDocumentsDeleted,
                   @"Return same value as local storage");
}

- (void)testDeleteDocumentListReturnsNoDocument
{
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_noDocumentDeleted;
    
    XCTAssertEqual([self.datastore deleteDocumentList:@[@"document"] error:nil],
                   IAWPersistenceDatastore_deleteDocumentList_resultType_noDocumentDeleted,
                   @"Return same value as local storage");
}

- (void)testDeleteDocumentListPostsNotificationIfSuccess
{
    [self.datastore.notificationCenter addDidDeleteDocumentListNotificationObserver:self
                                                                           selector:@selector(manageDidDeleteDocumentListNotification:)
                                                                             sender:self.datastore];
    
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_success;
    [self.datastore deleteDocumentList:@[@"document"] error:nil];
    
    [self.datastore.notificationCenter removeDidDeleteDocumentListNotificationObserver:self
                                                                                sender:self.datastore];
    
    XCTAssertTrue(self.didReceiveDeleteDocumentListNotification,
                  @"If some documents were deleted, a notification must be received");
}

- (void)testDeleteDocumentListPostsNotificationIfSomeDocumentsWereDeleted
{
    [self.datastore.notificationCenter addDidDeleteDocumentListNotificationObserver:self
                                                                           selector:@selector(manageDidDeleteDocumentListNotification:)
                                                                             sender:self.datastore];
    
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_someDocumentsDeleted;
    [self.datastore deleteDocumentList:@[@"document"] error:nil];
    
    [self.datastore.notificationCenter removeDidDeleteDocumentListNotificationObserver:self
                                                                                sender:self.datastore];
    
    XCTAssertTrue(self.didReceiveDeleteDocumentListNotification,
                  @"If some documents were deleted, a notification must be received");
}

- (void)testDeleteDocumentListDoesNotPostNotificationIfNoDocumentWasDeleted
{
    [self.datastore.notificationCenter addDidDeleteDocumentListNotificationObserver:self
                                                                           selector:@selector(manageDidDeleteDocumentListNotification:)
                                                                             sender:self.datastore];
    
    self.mockStorage.resultDeleteDocumentList = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_noDocumentDeleted;
    [self.datastore deleteDocumentList:@[@"document"] error:nil];
    
    [self.datastore.notificationCenter removeDidDeleteDocumentListNotificationObserver:self
                                                                                sender:self.datastore];
    
    XCTAssertFalse(self.didReceiveDeleteDocumentListNotification,
                   @"If no document is deleted, there is nothing to notificate");

}


#pragma mark - Private methods
- (void)manageDidDeleteDocumentListNotification:(NSNotification *)notification
{
    self.didReceiveDeleteDocumentListNotification = YES;
}

@end
