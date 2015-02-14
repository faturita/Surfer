//
//  Password.h
//  Surfer
//
//  Created by Rodrigo Ramele on 02/02/14.
//  Copyright (c) 2014 Baufest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Password : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * oldvalue;
@property (nonatomic, retain) NSString * pin;
@property (nonatomic, retain) NSString * label;

@end
