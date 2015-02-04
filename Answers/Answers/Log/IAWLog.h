//
//  IAWLog.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 04/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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
