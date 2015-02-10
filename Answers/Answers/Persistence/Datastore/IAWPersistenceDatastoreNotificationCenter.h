//
//  IAWPersistenceDatastoreNotificationCenter.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification;
extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification;



@interface IAWPersistenceDatastoreNotificationCenter : NSObject

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenterOrNil;

- (void)addDidCreateDocumentNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidCreateDocumentNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidCreateDocumentNotificationWithSender:(id)sender;

- (void)addDidRefreshDocumentsNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidRefreshDocumentsNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidRefreshDocumentsNotificationWithSender:(id)sender;

+ (instancetype)notificationCenter;

@end
