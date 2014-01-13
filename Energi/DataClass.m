//
//  DataClass.m
//  Energi
//
//  Created by Scott Boyd on 16/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

@synthesize budget;

@synthesize houseID;

@synthesize sourceview;

@synthesize valueArray;

@synthesize colorArray;

@synthesize titleArray;



static DataClass *instance = nil;

+(DataClass *) getInstance{
    @synchronized(self){
        if (instance == nil){
            instance = [DataClass new];
        }
    }
    return instance;
}
@end
