#ifndef Cucumberish_h
#define Cucumberish_h
#import "RaytracerChallengeTests-Swift.h"

@import Cucumberish;

__attribute__((constructor))
void CucumberishInit()
{
    [Cucumberish instance].testTargetSrcRoot = SRC_ROOT;
    [CucumberishInitializer CucumberishSwiftInit];
}
#endif /* Cucumberish_h */
