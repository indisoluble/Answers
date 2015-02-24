//
//  IAWPersistenceDatastoreNotificationCenter.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreNotificationCenter.h"

#import "IAWLog.h"



NSString * const kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidCreateDocumentNotification";
NSString * const kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification";
NSString * const kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification = @"kIAWPersistenceDatastoreNotificationCenterDidDeleteDocumentNotification";
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
{
    IAWLogInfo(@"Post with sender: %@", sender);
    
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidReplaceDocumentNotification
                                           object:sender];
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
