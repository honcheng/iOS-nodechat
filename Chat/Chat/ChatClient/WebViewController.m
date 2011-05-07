//
//  WebViewController.m
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

#import "WebViewController.h"


@implementation WebViewController
@synthesize webView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:self.webView];
        [self.webView release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,61,36)];
            [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateHighlighted];
            [doneButton setTitle:@"Done" forState:UIControlStateNormal];
            [doneButton setBackgroundImage:[[UIImage imageNamed:@"button_black.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
            [doneButton setBackgroundImage:[[UIImage imageNamed:@"button_white.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
            [[doneButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14]];
            [doneButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
            [doneButton release];
            [self.navigationItem setRightBarButtonItem:doneButtonItem];
            [doneButton addTarget:self action:@selector(onDoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

            [self.navigationItem setLeftBarButtonItem:nil];
        }
    }
    return self;
}

- (void)onDoneButtonPressed:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.webView release];
    [super dealloc];
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
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
