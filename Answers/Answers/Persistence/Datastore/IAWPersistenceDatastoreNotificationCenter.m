//
//  IAWPersistenceDatastoreNotificationCenter.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
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

#import "IAWPersistenceDatastoreNotificationCenter.h"

#import "IAWLog.h"



NSString * const kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification";

NSString * const kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification";
NSString * const kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyReplaced = @"kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyReplaced";
NSString * const kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyNext = @"kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyNext";

NSString * const kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification";

NSString * const kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification = @"kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification";

NSString * const kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification = @"kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification";



@interface IAWPersistenceDatastoreNotificationCenter ()

@property (strong, nonatomic, readonly) NSNotificationCenter *notificationCenter;

@end



@implementation IAWPersistenceDatastoreNotificationCenter

#pragma mark - Init object
- (id)init
{
    return [self initWithNotificationCenter:nil];
}

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenterOrNil
{
    self = [super init];
    if (self)
    {
        _notificationCenter = (notificationCenterOrNil ? notificationCenterOrNil : [NSNotificationCenter defaultCenter]);
    }
    
    return self;
}


#pragma mark - Public methods
- (void)addDidCreateDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    IAWLogInfo(@"Add observer: %@", observer);
    
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                  object:sender];
}

- (void)removeDidCreateDocumentNotificationObserver:(id)observer sender:(id)sender
{
    IAWLogInfo(@"Remove observer: %@", observer);
    
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                     object:sender];
}

- (void)postDidCreateDocumentNotificationWithSender:(id)sender
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                           object:sender];
}

- (void)addDidReplaceDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    IAWLogInfo(@"Add observer: %@", observer);
    
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification
                                  object:sender];
}

- (void)removeDidReplaceDocumentNotificationObserver:(id)observer sender:(id)sender
{
    IAWLogInfo(@"Remove observer: %@", observer);
    
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification
                                     object:sender];
}

- (void)postDidReplaceDocumentNotificationWithSender:(id)sender
                                    replacedDocument:(id)replacedDocument
                                        nextDocument:(id)nextDocument
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    NSDictionary *userInfo = @{kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyNext:
                                   nextDocument,
                               kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotificationUserInfoKeyReplaced:
                                   replacedDocument};
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification
                                           object:sender
                                         userInfo:userInfo];
}

- (void)addDidDeleteDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    IAWLogInfo(@"Add observer: %@", observer);
    
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification
                                  object:sender];
}

- (void)removeDidDeleteDocumentNotificationObserver:(id)observer sender:(id)sender
{
    IAWLogInfo(@"Remove observer: %@", observer);
    
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification
                                     object:sender];
}

- (void)postDidDeleteDocumentNotificationWithSender:(id)sender
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification
                                           object:sender];
}

- (void)addDidDeleteDocumentListNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    IAWLogInfo(@"Add observer: %@", observer);
    
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification
                                  object:sender];
}

- (void)removeDidDeleteDocumentListNotificationObserver:(id)observer sender:(id)sender
{
    IAWLogInfo(@"Remove observer: %@", observer);
    
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification
                                     object:sender];
}

- (void)postDidDeleteDocumentListNotificationWithSender:(id)sender
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification
                                           object:sender];
}

- (void)addDidRefreshDocumentsNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    IAWLogInfo(@"Add observer: %@", observer);
    
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                  object:sender];
}

- (void)removeDidRefreshDocumentsNotificationObserver:(id)observer sender:(id)sender
{
    IAWLogInfo(@"Remove observer: %@", observer);
    
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                     object:sender];
}

- (void)postDidRefreshDocumentsNotificationWithSender:(id)sender
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                           object:sender];
}


#pragma mark - Public class methods
+ (instancetype)notificationCenter
{
    return [[[self class] alloc] init];
}

@end
