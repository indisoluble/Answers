//
//  IAWPersistenceDatastoreReplicatorProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol IAWPersistenceDatastoreReplicatorDelegate;



@protocol IAWPersistenceDatastoreReplicatorProtocol <NSObject>

@property (weak, nonatomic) id<IAWPersistenceDatastoreReplicatorDelegate> delegate;

- (BOOL)startWithError:(NSError **)error;

@end



@protocol IAWPersistenceDatastoreReplicatorDelegate <NSObject>

- (void)datastoreReplicatorDidComplete:(id<IAWPersistenceDatastoreReplicatorProtocol>)repicator;
- (void)datastoreReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)repicator
           didFailWithError:(NSError *)error;

@end
