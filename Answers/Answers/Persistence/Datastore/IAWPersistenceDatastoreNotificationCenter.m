//
//  IAWPersistenceDatastoreNotificationCenter.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreNotificationCenter.h"



NSString * const kIAWPersistenceDatastoreNotificationCenterDidChangeNotification = @"kIAWPersistenceDatastoreNotificationCenterDidChangeNotification";



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
- (void)addDidChangeNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender
{
    [self.notificationCenter addObserver:observer
                                selector:aSelector
                                    name:kIAWPersistenceDatastoreNotificationCenterDidChangeNotification
                                  object:sender];
}

- (void)removeDidChangeNotificationObserver:(id)observer sender:(id)sender
{
    [self.notificationCenter removeObserver:observer
                                       name:kIAWPersistenceDatastoreNotificationCenterDidChangeNotification
                                     object:sender];
}

- (void)postDidChangeNotificationWithSender:(id)sender
{
    [self.notificationCenter postNotificationName:kIAWPersistenceDatastoreNotificationCenterDidChangeNotification
                                           object:sender];
}


#pragma mark - Public class methods
+ (instancetype)notificationCenter
{
    return [[[self class] alloc] init];
}

@end
