//
//  IAWPersistenceDatastoreDecorator.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreDecorator.h"

#import "IAWPersistenceDatastore.h"



@interface IAWPersistenceDatastoreDecorator ()

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreProtocol> datastore;

@end



@implementation IAWPersistenceDatastoreDecorator

#pragma mark - Init object
- (id)init
{
    return [self initWithDatastore:nil notificationCenter:nil];
}

- (id)initWithDatastore:(id<IAWPersistenceDatastoreProtocol>)datastoreOrNil
     notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenterOrNil
{
    self = [super init];
    if (self)
    {
        _datastore = (datastoreOrNil ?
                      datastoreOrNil :
                      [IAWPersistenceDatastore datastore]);
        _notificationCenter = (notificationCenterOrNil ?
                               notificationCenterOrNil :
                               [IAWPersistenceDatastoreNotificationCenter notificationCenter]);
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreProtocol methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error
{
    BOOL success = [self.datastore createDocument:document error:error];
    if (success)
    {
        [self.notificationCenter postDidChangeNotificationWithSender:self];
    }
    
    return success;
}

- (NSArray *)allDocuments
{
    return [self.datastore allDocuments];
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}

@end
