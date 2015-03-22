//
//  OBAUser.m
//  org.onebusaway.iphone
//
//  Created by Pho Diep on 3/22/15.
//  Copyright (c) 2015 OneBusAway. All rights reserved.
//

#import "OBAUser.h"

@implementation OBAUser
@dynamic points;
@dynamic displayName;

+ (void)load {
    [self registerSubclass];
}

- (void)addPoints:(NSInteger)points {
    self.points = @(self.points.integerValue + points);
}

@end
