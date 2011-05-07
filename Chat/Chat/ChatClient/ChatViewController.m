    //
//  ChatViewController.m
//  TestSocketIO
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

#import "ChatViewController.h"
#import "LocationInfo.h"
#import "CoreLocationManager.h"
#import "ChatTableViewCell.h"
#import "RTLabel.h"
#import "WebViewController.h"
#import "StatusTableViewCell.h"

@interface ChatViewController()
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)onLoginButtonPressed:(id)sender;
- (void)onLogoutButtonPressed:(id)sender;
- (void)checkInToLocation;
@end

@implementation ChatViewController
@synthesize inputField, tableView, conversationArray, client;
@synthesize inputBarBg, loginViewController, loginButtonItem, logoutButtonItem;

#define INPUTFIELD_HEIGHT 44

- (void)dealloc {
    
    [self.logoutButtonItem release];
    [self.loginButtonItem release];
    [self.loginViewController release];
    [self.inputBarBg release];
    [self.tableView release];
    [self.conversationArray release];
    [self.inputView release];
    [self.client release];
    [super dealloc];
}

- (id)init
{
	self = [super init];
	if (self)
	{
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20]];
		[titleLabel setText:@"ChatLah"];
		[self.navigationItem setTitleView:titleLabel];
		[titleLabel release];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height-INPUTFIELD_HEIGHT)];
		[self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:self.tableView];
		[self.tableView release];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
        self.inputBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y+self.tableView.frame.size.height,[self.view bounds].size.width,INPUTFIELD_HEIGHT)];
        [self.inputBarBg setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:self.inputBarBg];
        [self.inputBarBg release];
        [self.inputBarBg  setImage:[[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:22]];
        [self.inputBarBg setUserInteractionEnabled:YES];
        
		self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(22,0,[self.view bounds].size.width-30,INPUTFIELD_HEIGHT)];
		[self.inputBarBg addSubview:self.inputField];
		[self.inputField release];
        [self.inputField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[self.inputField setReturnKeyType:UIReturnKeySend];
		[self.inputField setDelegate:self];
        [self.inputField setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20]];
        [self.inputField setTextColor:[UIColor colorWithWhite:0.15 alpha:1]];
        [self.inputField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.inputField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.inputField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,61,36)];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateHighlighted];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"button_white.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
        [[loginButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14]];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
        self.loginButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
        [loginButton release];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(onLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,61,36)];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateHighlighted];
        [logoutButton setBackgroundImage:[[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
        [logoutButton setBackgroundImage:[[UIImage imageNamed:@"button_white.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
        [[logoutButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14]];
        [logoutButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
        self.logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
        [logoutButton release];
        [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(onLogoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.conversationArray = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationUpdated:) name:@"kNotif_NewLocationUpdated" object:nil];

	}
	return self;
}

#pragma mark connection

- (void)connect
{
    if (!self.client)
    {
        self.client = [[SocketIoClient alloc] initWithHost:SOCKETIO_HOST port:SOCKETIO_PORT];
        [self.client setDelegate:self];
    }
    [self.client connect];
}

- (void)disconnect
{
    [self.client disconnect];
}

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    
    
    NSMutableDictionary *command = [NSMutableDictionary dictionary];
    [command setObject:@"login" forKey:@"command"];
    [command setObject:username forKey:@"username"];
    [command setObject:password forKey:@"password"];
    
    NSString *commandString = [command JSONString]; //[self.jsonParser stringWithObject:command];
    [client send:commandString isJSON:NO];
    //[client send:@"Hello Socket.IO" isJSON:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unregisterForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    if (!hasLoggedIn)
    {
        //[self onLoginButtonPressed:nil];
    }
}

#pragma mark login/logout

- (void)onLoginButtonPressed:(id)sender
{
    if (!self.loginViewController)
    {
        self.loginViewController = [[LoginViewController alloc] init];
        [self.loginViewController setDelegate:self];
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    }
    
    [self.navigationController presentModalViewController:navController animated:YES];

}

- (void)onLogoutButtonPressed:(id)sender
{
    NSMutableDictionary *command = [NSMutableDictionary dictionary];
    [command setObject:@"message" forKey:@"command"];
    [command setObject:@"/logout" forKey:@"message"];
    NSString *commandString = [command JSONString]; //[jsonParser stringWithObject:command];
    [self.client send:commandString isJSON:NO];
    
    [self.navigationItem setRightBarButtonItem:loginButtonItem animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (hasLoggedIn)
    {
        NSString *text = [textField text];
        
        NSMutableDictionary *command = [NSMutableDictionary dictionary];
        [command setObject:@"message" forKey:@"command"];
        [command setObject:text forKey:@"message"];
        NSString *commandString = [command JSONString]; //[jsonParser stringWithObject:command];
        [self.client send:commandString isJSON:NO];
        
        [textField setText:@""];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Login required"];
        [alertView addButtonWithTitle:@"OK"];
        [alertView show];
        [alertView release];
    }
	
	
	return YES;
}

#pragma mark location

- (void)onLocationUpdated:(NSNotification*)note
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkInToLocation) object:nil];
    [self performSelector:@selector(checkInToLocation) withObject:nil afterDelay:3];
}

- (void)checkInToLocation
{
    LocationInfo *locationInfo = [[CoreLocationManager defaultManager] locationInfo];
    if ([locationInfo locAvailable])
    {
        NSString *checkinString = [NSString stringWithFormat:@"%f,%f", locationInfo.coordinate.latitude, locationInfo.coordinate.longitude];
        
        NSMutableDictionary *command = [NSMutableDictionary dictionary];
        [command setObject:@"checkin" forKey:@"command"];
        [command setObject:checkinString forKey:@"latlng"];
        NSString *commandString = [command JSONString];//[jsonParser stringWithObject:command];
        [self.client send:commandString isJSON:NO];
    }
}

#pragma mark socket IO delegates

- (void)socketIoClientDidConnect:(SocketIoClient *)client 
{
    NSLog(@"Connected.");
    
    if (hasLoggedIn)
    {
        [self.navigationItem setRightBarButtonItem:logoutButtonItem animated:YES];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:loginButtonItem animated:YES];
    }
    
    NSString *text = @"<font kern=0 color=#0d7000>&gt;&gt;&gt;&gt; connected</font>";
    NSMutableDictionary *newContent = [NSMutableDictionary dictionary];
    [newContent setObject:text forKey:@"text"];
    [self.conversationArray addObject:newContent];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.conversationArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"])
    {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        [self loginWithUsername:username password:password];
    }

}

- (void)socketIoClientDidDisconnect:(SocketIoClient *)client 
{
    NSLog(@"Disconnected.");
    
    NSString *text = @"<font kern=0 color=#870000>&gt;&gt;&gt;&gt; disconnected</font>";
    NSMutableDictionary *newContent = [NSMutableDictionary dictionary];
    [newContent setObject:text forKey:@"text"];
    [self.conversationArray addObject:newContent];
    [self.tableView reloadData];

    
    [self.navigationItem setRightBarButtonItem:nil];
    [self.client connect];
}

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON 
{
    NSLog(@"Received: %@", message);
	if (message)
	{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"])
        {
            NSString *loginMessage = [NSString stringWithFormat:@"%@ meow meow!", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
            if ([message rangeOfString:loginMessage].location!=NSNotFound)
            {
                hasLoggedIn = YES;
                if (self.navigationController.visibleViewController==self.loginViewController)
                {
                    [self.loginViewController connected];
                }
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkInToLocation) object:nil];
                [self performSelector:@selector(checkInToLocation) withObject:nil afterDelay:6];
                
                if (self.navigationController.visibleViewController==self)
                {
                    [inputField becomeFirstResponder];
                }
                
                
                [self.navigationItem setRightBarButtonItem:logoutButtonItem animated:YES];
            }
        }
        
        NSArray *words = [message componentsSeparatedByString:@" "];
        BOOL isSpeech = NO;
        for (NSString *word in words)
        {
            if ([word rangeOfString:@"@"].location==0)
            {
                isSpeech = YES;
                NSString *newWord = [NSString stringWithFormat:@"<font color=black>%@</font>", word];
                message = [message stringByReplacingOccurrencesOfString:word withString:newWord];
            }
        }
        
        // parse iframe
        if ([message rangeOfString:@"<iframe"].location!=NSNotFound)
        {
            int start = [message rangeOfString:@"<iframe"].location;
            NSString *tmp = [message substringFromIndex:start];
            int end = [tmp rangeOfString:@"/>"].location+2;
    
            NSString *link = nil;
            NSString *iframe = [message substringWithRange:NSMakeRange(start, end)];
            if ([iframe rangeOfString:@"src"].location!=NSNotFound)
            {
                NSArray *parts = [iframe componentsSeparatedByString:@" "];
                for (NSString *part in parts)
                {
                    if ([part rangeOfString:@"src"].location!=NSNotFound)
                    {
                        NSArray *moreparts = [part componentsSeparatedByString:@"'"];
                        link = [moreparts objectAtIndex:1];
                    }
                }
            }
            if (link)
            {
                NSString *newLink = [NSString stringWithFormat:@"<a href='%@'>%@</a>", link, link];
                message = [message stringByReplacingOccurrencesOfString:iframe withString:newLink];
            }
        }
        
        /*
        if (!isSpeech)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
            {
                message = [NSString stringWithFormat:@"<font face='HelveticaNeue-CondensedBold' size=24 color='#9d907b'>%@</font>", message];
            }
            else
            {
                message = [NSString stringWithFormat:@"<font face='HelveticaNeue-CondensedBold' size=16 color='#9d907b'>%@</font>", message];
            }
            
        }*/
        
        
        NSMutableDictionary *newContent = [NSMutableDictionary dictionary];
        [newContent setObject:message forKey:@"text"];
        if (isSpeech)
        {
            [newContent setObject:[NSNumber numberWithInt:CellType_Chat] forKey:@"cell_type"];
        }
        
        [self.conversationArray addObject:newContent];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.conversationArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES; //UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark keyboard

- (void)keyboardWillShow:(NSNotification*)note
{    
    NSDictionary* info = [note userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    keyboardEndFrame = [self.view convertRect:keyboardEndFrame fromView:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, keyboardEndFrame.size.height, 0)];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardEndFrame.size.height, 0)];
    [self.inputBarBg setTransform:CGAffineTransformMakeTranslation(0, -1*keyboardEndFrame.size.height)];
    
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)note
{
    NSDictionary* info = [note userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.inputBarBg setTransform:CGAffineTransformMakeTranslation(0,0)];
    [UIView commitAnimations];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conversationArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *info = [self.conversationArray objectAtIndex:indexPath.row];
    CellType cellType = [[info objectForKey:@"cell_type"] intValue];
    if ([info objectForKey:@"content_height"])
    {
        return [[info objectForKey:@"content_height"] intValue] + 10;
    }
    else
    {
        RTLabel *label;
        if (cellType==CellType_Chat)
        {
            label = [ChatTableViewCell label];
        }
        else
        {
            label = [StatusTableViewCell label];
        }
        //CGSize optimumSize = [[info objectForKey:@"text"] sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width,1000)];
        [label setText:[info objectForKey:@"text"]];
        CGSize optimumSize = [label optimumSize];        
        [info setObject:[NSNumber numberWithInt:optimumSize.height+5] forKey:@"content_height"];
        //NSLog(@".%@........ %i",[info objectForKey:@"text"], [[info objectForKey:@"content_height"] intValue] + 10);
        return [[info objectForKey:@"content_height"] intValue] + 10;
        
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *info = [self.conversationArray objectAtIndex:indexPath.row];
    CellType cellType = [[info objectForKey:@"cell_type"] intValue];
    if (cellType==CellType_Chat)
    {
        static NSString *identifier = @"ChatTableViewCell";
        ChatTableViewCell *cell = (ChatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            [cell.contentLabel setDelegate:self];
        }
        
        [cell setCellContent:info];
        return cell;
    }
    else
    {
        static NSString *identifier = @"StatusTableViewCell";
        StatusTableViewCell *cell = (StatusTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[StatusTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            [cell.contentLabel setDelegate:self];
        }
        
        [cell setCellContent:info];
        return cell;
    }
    
    
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString rangeOfString:@"http"].location==NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"http://take.my/chattodo/%@", urlString];
    }
    WebViewController *webViewController = [[WebViewController alloc] init];
    [webViewController.titleLabel setText:urlString];
    [webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        [navController setModalPresentationStyle:UIModalPresentationFormSheet];
        [self.navigationController presentModalViewController:navController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
}

@end
