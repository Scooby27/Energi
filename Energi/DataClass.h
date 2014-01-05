//
//  DataClass.h
//  Energi
//
//  Created by Scott Boyd on 16/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject
{
    int budget;
    NSString *username;
}

@property (nonatomic) int budget;

@property (nonatomic, retain) NSString *username;

@property (nonatomic, retain) UIViewController* sourceview;

+(DataClass*)getInstance;

@end
