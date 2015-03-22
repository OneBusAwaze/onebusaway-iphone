//
//  OBAUser.h
//  org.onebusaway.iphone
//
//  Created by Pho Diep on 3/22/15.
//  Copyright (c) 2015 OneBusAway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface OBAUser : PFUser<PFSubclassing>

@property (strong, nonatomic) NSNumber *points;

- (void)addPoints:(NSInteger)points;

@end
