//
//  NSSurferViewController.h
//  Surfer
//
//  Created by Rodrigo Ramele on 01/02/14.
//  Copyright (c) 2014 Baufest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSSurferViewController : UIViewController <UISearchBarDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    int fadecounter;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchKeyword;
@property (weak, nonatomic) IBOutlet UITextField *labelText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)addNewPassword:(id)sender;

- (IBAction)showAlert:(id)sender;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;

@property (strong, nonatomic) NSTimer *nsTimer;

@end
