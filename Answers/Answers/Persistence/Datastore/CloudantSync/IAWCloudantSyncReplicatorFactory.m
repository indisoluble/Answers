//
//  IAWCloudantSyncReplicatorFactory.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncReplicatorFactory.h"

#import "IAWCloudantSyncReplicatorPush.h"
#import "IAWCloudantSyncReplicatorPull.h"



@interface IAWCloudantSyncReplicatorFactory ()

@property (strong, nonatomic, readonly) CDTReplicatorFactory *cloudantReplicatorFactory;
@property (strong, nonatomic, readonly) CDTDatastore *cloudantDatastore;
@property (strong, nonatomic, readonly) NSURL *cloudantURL;

@end



@implementation IAWCloudantSyncReplicatorFactory

#pragma mark - Init object
- (id)init
{
    return [self initWithCloudantFactory:nil datastore:nil url:nil];
}

- (id)initWithCloudantFactory:(CDTReplicatorFactory *)cloudantReplicatorFactory
                    datastore:(CDTDatastore *)cloudantDatastore
                          url:(NSURL *)cloudantURL
{
    self = [super init];
    if (self)
    {
        if (!cloudantReplicatorFactory || !cloudantDatastore || !cloudantURL)
        {
            self = nil;
        }
        else
        {
            _cloudantReplicatorFactory = cloudantReplicatorFactory;
            _cloudantDatastore = cloudantDatastore;
            _cloudantURL = cloudantURL;
        }
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreReplicatorFactoryProtocol methods
- (id<IAWPersistenceDatastoreReplicatorProtocol>)pushReplicator
{
    IAWCloudantSyncReplicatorPush *replicator = [IAWCloudantSyncReplicatorPush replicatorWithFactory:self.cloudantReplicatorFactory
                                                                                              source:self.cloudantDatastore
                                                                                              target:self.cloudantURL];
    
    return replicator;
}

- (id<IAWPersistenceDatastoreReplicatorProtocol>)pullReplicatorWithCompletionHandler:(iawPersistenceDatastoreReplicatorCompletionHandlerType)block
{
    iawCloudantSyncReplicatorPullCompletionHandlerBlockType completionHandler = ^(BOOL success, NSError *error)
    {
        block(success, error);
    };
    
    IAWCloudantSyncReplicatorPull *replicator = [IAWCloudantSyncReplicatorPull replicatorWithFactory:self.cloudantReplicatorFactory
                                                                                              source:self.cloudantDatastore
                                                                                              target:self.cloudantURL
                                                                                   completionHandler:completionHandler];
    
    return replicator;
}


#pragma mark - Public class methods
+ (instancetype)factoryWithCloudantFactory:(CDTReplicatorFactory *)cloudantReplicatorFactory
                                 datastore:(CDTDatastore *)cloudantDatastore
                                       url:(NSURL *)cloudantURL
{
    return [[[self class] alloc] initWithCloudantFactory:cloudantReplicatorFactory
                                               datastore:cloudantDatastore
                                                     url:cloudantURL];
}

@end
