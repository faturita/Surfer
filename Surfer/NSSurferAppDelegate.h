//
//  NSSurferAppDelegate.h
//  Surfer
//
//  Created by Rodrigo Ramele on 31/01/14.
//  Copyright (c) 2014 Baufest. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NSSurferViewController;
#import "NSSurferViewController.h"

@interface NSSurferAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSSurferViewController *viewController;

@end
