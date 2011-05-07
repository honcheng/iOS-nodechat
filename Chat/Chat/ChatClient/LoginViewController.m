//
//  LoginViewController.m
//  Chat
//
/**
 * Copyright (c) 2010 Muh Hon Cheng
 * Created by honcheng on 1/6/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize usernameField, passwordField, delegate;
@synthesize activityIndicatorView;
@synthesize activityButtonItem, loginButtonItem;

- (void)dealloc
{
    [self.loginButtonItem release];
    [self.activityButtonItem release];
    [self.activityIndicatorView release];
    [self.usernameField release];
    [self.passwordField release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        [self.view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20]];
		[titleLabel setText:@"ChatLah"];
		[self.navigationItem setTitleView:titleLabel];
		[titleLabel release];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,61,36)];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateHighlighted];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_black.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_white.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
        [[loginButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14]];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
        self.loginButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
        [loginButton release];
        [self.navigationItem setRightBarButtonItem:self.loginButtonItem];
        [loginButton addTarget:self action:@selector(onLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,61,36)];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"button_white.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
        [[cancelButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14]];
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        [cancelButton release];
        [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
        [cancelButton addTarget:self action:@selector(onCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
        [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        self.activityButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
        [self.activityIndicatorView release];
        
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(20,50,[self.view bounds].size.width-40,40)];
        [self.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.usernameField setReturnKeyType:UIReturnKeyNext];
        [self.usernameField setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        [self.view addSubview:self.usernameField];
        [self.usernameField release];
        [self.usernameField setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.usernameField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.usernameField setPlaceholder:@"Title"];
        [self.usernameField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self.usernameField setDelegate:self];
        [self.usernameField setTextColor:[UIColor colorWithWhite:0.15 alpha:1]];
        [self.usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.usernameField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20,100,[self.view bounds].size.width-40,40)];
        [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.passwordField setReturnKeyType:UIReturnKeyDone];
        [self.passwordField setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        [self.view addSubview:self.passwordField];
        [self.passwordField release];
        [self.passwordField setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.passwordField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.passwordField setPlaceholder:@"Subtitle"];
        [self.passwordField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self.passwordField setDelegate:self];
        [self.passwordField setSecureTextEntry:YES];
        [self.passwordField setTextColor:[UIColor colorWithWhite:0.15 alpha:1]];
        [self.passwordField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"])
        {
            [self.usernameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"password"])
        {
            [self.passwordField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        }

    }
    
    return self;
}

- (void)onCancelButtonPressed:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)onLoginButtonPressed:(id)sender
{
    NSString *username = [self.usernameField text];
    NSString *password = [self.passwordField text];
    
    if ([username length]>0 && [password length]>0)
    {
        [self.activityIndicatorView startAnimating];
        [self.navigationItem setRightBarButtonItem:self.activityButtonItem];
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        
        NSString *username = [self.usernameField text];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [delegate loginWithUsername:username password:password];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Missing required field"];
        [alertView setMessage:@"Please enter a username and password"];
        [alertView addButtonWithTitle:@"OK"];
        [alertView show];
        [alertView release];
    }
}

- (void)connected
{
    [self.activityIndicatorView stopAnimating];
    [self.navigationItem setRightBarButtonItem:self.loginButtonItem];
    
    NSString *username = [self.usernameField text];
    NSString *password = [self.passwordField text];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.usernameField becomeFirstResponder];
    
    /*
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"])
    {
        [self onLoginButtonPressed:nil];
    }*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.usernameField)
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [self onLoginButtonPressed:textField];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
