//
//  NSSurferViewController.m
//  Surfer
//
//  Created by Rodrigo Ramele on 01/02/14.
//  Copyright (c) 2014 Baufest. All rights reserved.
//

#import "NSSurferViewController.h"
#import "NSSurferAppDelegate.h"
#import "Password.h"

@interface NSSurferViewController ()

@end

@implementation NSSurferViewController

@synthesize nsTimer;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchKeyword.hidden = YES;
    
    self.searchKeyword.delegate = self;
    
    // I need the link to the managed object context.
    self.managedObjectContext = [(NSSurferAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (Password*) loadPassword:(NSString*)keyword
{
    NSLog(@"Load passwords from DataBase");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Password" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    NSArray *passwords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    
    if ( [passwords count] > 0)
    {
        for (Password *password in passwords)
        {
            
            NSLog(@"Reading: %@ - %@", [password username], [password value]);
            
            if ( [[password label] isEqualToString:keyword])
            {
                NSLog(@"Keyword Found!");
                return password;
            }
        }
    }
    
    return nil;
}

- (IBAction)addNewPassword:(id)sender {

    Password *password;
    
    password = [self loadPassword:self.searchKeyword.text];
    
    if (password == nil) {
    
        // Add a new magazine
        password = [NSEntityDescription insertNewObjectForEntityForName:@"Password" inManagedObjectContext:self.managedObjectContext];
    }
    
    
    if (password != nil)
    {
        NSLog(@"Successfully created/updated a new password entity.");
        
        [password setValue:self.usernameText.text];
        [password setLabel:self.labelText.text];
        [password setPin:self.passwordText.text];
        
        NSError *savingError = nil;
    
        if ( [self.managedObjectContext save:&savingError] == YES )
        {
            NSLog(@"Successfully saved the udated entity.");
            
            [self hide];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Key succesfully stored."
                                                            message:@"We'll keep your secret."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            
            [alert show];
        
        } else {
            NSLog(@"Failed to save this entity.");
        }
    }


}

- (IBAction)showAlert:(id)sender {
    
    /**
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Testing Actions"
                                                    message:@"Hello Brother!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    
    [alert show];
     **/
    
    // Validate the user...
    // Make sure camera is available
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Camera Unavailable"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
         [alert show];
    }
    
    if (self.imagePicker == nil)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    
    self.searchKeyword.alpha = 1.0f;
    self.searchKeyword.text = @"";
    
    
    [self hide];
    
    self.searchKeyword.hidden = NO;
}


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // Reset everything if the user wants to search for another word.
    [self hide];
    
    self.searchKeyword.alpha = 1.0f;
    self.searchKeyword.hidden = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchKeyword resignFirstResponder];
    
    self.labelText.hidden = self.usernameText.hidden = self.passwordText.hidden = self.addButton.hidden=    self.searchKeyword.hidden = NO;
    
    self.labelText.enabled = self.usernameText.enabled = self.passwordText.enabled = YES;

    [nsTimer invalidate];
    
    fadecounter = 10;
    
    if (![self loadPasswords:self.searchKeyword.text])
    {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Key not found!"
                                                    message:@"Write down your secret."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    
        [alert show];
        
        self.labelText.alpha = self.usernameText.alpha = self.passwordText.alpha = self.addButton.alpha= 1.0f;
        
        nsTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }
    else
    {
        nsTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fadeout) userInfo:nil repeats:YES];
    }
    
    
}


-(void)fadeout
{
    
    self.labelText.alpha = self.usernameText.alpha = self.passwordText.alpha = self.addButton.alpha=    self.searchKeyword.alpha-0.1;
    
    self.searchKeyword.alpha=self.searchKeyword.alpha-0.1;
    
    NSLog(@"hidding...%d", fadecounter--);
    
    if (fadecounter<0)
    {
        [nsTimer invalidate];
    }
    
}


-(void)hide
{
    self.labelText.hidden = self.usernameText.hidden = self.passwordText.hidden = self.addButton.hidden=    self.searchKeyword.hidden = YES;
    
    [self.labelText setText:@""];
    [self.usernameText setText:@""];
    [self.passwordText setText:@""];
    
    self.labelText.enabled = self.usernameText.enabled = self.passwordText.enabled = NO;
    
    NSLog(@"hidding...");
    
    [nsTimer invalidate];
    
}

-(BOOL)loadPasswords:(NSString*) keyword
{
    NSLog(@"Load passwords from DataBase");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Password" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    NSArray *passwords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    
    if ( [passwords count] > 0)
    {
        for (Password *password in passwords)
        {

            NSLog(@"Reading: %@ - %@", [password username], [password value]);
            
            if ( [[password label] isEqualToString:keyword])
            {
                NSLog(@"Keyword Found!");
                
                [self.labelText setText:[password label]];
                [self.usernameText setText:[password value]];
                [self.passwordText setText:[password pin]];
                
                return YES;
                
            }
            
            //[magazineCovers addObject:retrievedMagazineEntity];
            
            //[retrievedMagazineEntity release];
        }
    }
    
    return NO;
    
}


/**
-(void)fetchVocabularies
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Password"];
    
    NSString *cacheName = [@"Password" stringByAppendingString:@"Cache"];
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil cacheName:cacheName];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
}
 **/


@end
