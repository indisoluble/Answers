//
//  IAWCloudantSyncDatabaseURL.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncDatabaseURL.h"

#import "IAWLog.h"



#define IAWCLOUDANTSYNCDATABASEURL_FILE_NAME    @"cloudantAnswersDatabaseURL"
#define IAWCLOUDANTSYNCDATABASEURL_FILE_EXT     @"plist"
#define IAWCLOUDANTSYNCDATABASEURL_FILE_URLKEY  @"url"



@interface IAWCloudantSyncDatabaseURL ()

@end



@implementation IAWCloudantSyncDatabaseURL

#pragma mark - Public class methods
+ (NSURL *)cloudantDatabaseURLOrNil
{
    NSString *path = [[NSBundle mainBundle] pathForResource:IAWCLOUDANTSYNCDATABASEURL_FILE_NAME
                                                     ofType:IAWCLOUDANTSYNCDATABASEURL_FILE_EXT];
    if (!path)
    {
        IAWLogWarn(@"File %@.%@ not found",
                   IAWCLOUDANTSYNCDATABASEURL_FILE_NAME, IAWCLOUDANTSYNCDATABASEURL_FILE_EXT);
        
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!dic)
    {
        IAWLogWarn(@"File %@.%@ can not be parsed to a dictionary",
                   IAWCLOUDANTSYNCDATABASEURL_FILE_NAME, IAWCLOUDANTSYNCDATABASEURL_FILE_EXT);
        
        return nil;
    }
    
    NSString *value = [dic valueForKey:IAWCLOUDANTSYNCDATABASEURL_FILE_URLKEY];
    if (!value)
    {
        IAWLogWarn(@"Key %@ not found in dictionary %@", IAWCLOUDANTSYNCDATABASEURL_FILE_URLKEY, dic);
        
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:value];
    if (!url)
    {
        IAWLogWarn(@"%@ is not a valid URL", value);
        
        return nil;
    }
    
    return url;
}

@end
