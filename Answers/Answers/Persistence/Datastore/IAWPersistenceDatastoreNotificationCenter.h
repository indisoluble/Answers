//
//  IAWPersistenceDatastoreNotificationCenter.h
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

#import <Foundation/Foundation.h>



extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification;
extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification;
extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification;
extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentListNotification;
extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification;



@interface IAWPersistenceDatastoreNotificationCenter : NSObject

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenterOrNil;

- (void)addDidCreateDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidCreateDocumentNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidCreateDocumentNotificationWithSender:(id)sender;

- (void)addDidReplaceDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidReplaceDocumentNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidReplaceDocumentNotificationWithSender:(id)sender;

- (void)addDidDeleteDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidDeleteDocumentNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidDeleteDocumentNotificationWithSender:(id)sender;

- (void)addDidDeleteDocumentListNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidDeleteDocumentListNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidDeleteDocumentListNotificationWithSender:(id)sender;

- (void)addDidRefreshDocumentsNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidRefreshDocumentsNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidRefreshDocumentsNotificationWithSender:(id)sender;

+ (instancetype)notificationCenter;

@end
