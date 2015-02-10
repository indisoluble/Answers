//
//  IAWPersistenceDatastoreNotificationCenter.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreNotificationCenter.h"



NSString * const kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification";
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
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                  object:sender];
}

- (void)removeDidCreateDocumentNotificationObserver:(id)observer sender:(id)sender
{
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                     object:sender];
}

- (void)postDidCreateDocumentNotificationWithSender:(id)sender
{
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification
                                           object:sender];
}

- (void)addDidRefreshDocumentsNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                  object:sender];
}

- (void)removeDidRefreshDocumentsNotificationObserver:(id)observer sender:(id)sender
{
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                     object:sender];
}

- (void)postDidRefreshDocumentsNotificationWithSender:(id)sender
{
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidRefreshDocumentsNotification
                                           object:sender];
}


#pragma mark - Public class methods
+ (instancetype)notificationCenter
{
    return [[[self class] alloc] init];
}

@end
