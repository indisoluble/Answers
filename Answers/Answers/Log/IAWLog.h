//
//  IAWLog.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 04/02/2015.
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

#ifndef Answers_IAWLog_h
#define Answers_IAWLog_h

#import "IAWLogFormatter.h"



static const DDLogLevel ddLogLevel = DDLogLevelVerbose;



#define IAWLogPrepareLogger()   [[DDASLLogger sharedInstance] setLogFormatter:[IAWLogFormatter logFormatter]]; \
                                [DDLog addLogger:[DDASLLogger sharedInstance]]; \
                                [[DDTTYLogger sharedInstance] setLogFormatter:[IAWLogFormatter logFormatter]]; \
                                [DDLog addLogger:[DDTTYLogger sharedInstance]];

#define IAWLogError(...)    DDLogError(__VA_ARGS__)
#define IAWLogWarn(...)     DDLogWarn(__VA_ARGS__)
#define IAWLogInfo(...)     DDLogInfo(__VA_ARGS__)
#define IAWLogDebug(...)    DDLogDebug(__VA_ARGS__)
#define IAWLogVerbose(...)  DDLogVerbose(__VA_ARGS__)

#endif
