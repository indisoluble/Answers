//
//  IAWCloudantSyncDatabaseURL.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
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
        IAWLogError(@"File %@.%@ not found",
                    IAWCLOUDANTSYNCDATABASEURL_FILE_NAME, IAWCLOUDANTSYNCDATABASEURL_FILE_EXT);
        
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!dic)
    {
        IAWLogError(@"File %@.%@ can not be parsed to a dictionary",
                    IAWCLOUDANTSYNCDATABASEURL_FILE_NAME, IAWCLOUDANTSYNCDATABASEURL_FILE_EXT);
        
        return nil;
    }
    
    NSString *value = [dic valueForKey:IAWCLOUDANTSYNCDATABASEURL_FILE_URLKEY];
    if (!value)
    {
        IAWLogError(@"Key %@ not found in dictionary %@", IAWCLOUDANTSYNCDATABASEURL_FILE_URLKEY, dic);
        
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:value];
    if (!url)
    {
        IAWLogError(@"%@ is not a valid URL", value);
        
        return nil;
    }
    
    return url;
}

@end
