//
//  ChatViewController.h
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

#import <UIKit/UIKit.h>
#import "SocketIoClient.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "RTLabel.h"

typedef enum
{
    CellType_Status = 0,
    CellType_Chat = 1
} CellType;

@interface ChatViewController : UIViewController < RTLabelDelegate ,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, SocketIoClientDelegate, LoginViewControllerDelegate>{
	UITextField *inputField;
	UITableView *tableView;
    NSMutableArray *conversationArray;
	SocketIoClient *client;
    UIImageView *inputBarBg;
    BOOL hasLoggedIn;
    LoginViewController *loginViewController;
    UIBarButtonItem *loginButtonItem, *logoutButtonItem;
}
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *conversationArray;
@property (nonatomic, retain) SocketIoClient *client;
@property (nonatomic, retain) UIImageView *inputBarBg;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) UIBarButtonItem *loginButtonItem, *logoutButtonItem;

- (void)loginWithUsername:(NSString*)username password:(NSString*)password;
- (void)connect;
- (void)disconnect;

@end
