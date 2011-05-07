//
//  ConversationTableViewCell.m
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

#import "ChatTableViewCell.h"


@implementation ChatTableViewCell
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentLabel = [ChatTableViewCell label];
        [self.contentView addSubview:self.contentLabel];
        //[self.contentLabel setNumberOfLines:0];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setCellContent:(NSMutableDictionary*)content
{
    [self.contentLabel setText:[content objectForKey:@"text"]];
    
    CGRect frame = [self.contentLabel frame];
    frame.size.height = [[content objectForKey:@"content_height"] intValue];
    [self.contentLabel setFrame:frame];
}

+ (RTLabel*)label
{
    RTLabel *label;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        label = [[RTLabel alloc] initWithFrame:CGRectMake(10,5,768-20,100)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:24]];
    }
    else
    {
        label = [[RTLabel alloc] initWithFrame:CGRectMake(10,5,300,100)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
    }
    [label setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
    [label setParagraphReplacement:@""];
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
	//[linkAttributes setObject:@"italic" forKey:@"style"];
	[linkAttributes setObject:@"#111111" forKey:@"color"];
    [linkAttributes setObject:@"HelveticaNeue-CondensedBold" forKey:@"face"];
	[linkAttributes setObject:@"1" forKey:@"underline"];
	
	NSMutableDictionary *selectedLinkAttributes = [NSMutableDictionary dictionary];
	//[selectedLinkAttributes setObject:@"italic" forKey:@"style"];
	[selectedLinkAttributes setObject:@"#333333" forKey:@"color"];
    [selectedLinkAttributes setObject:@"HelveticaNeue-CondensedBold" forKey:@"face"];
	[selectedLinkAttributes setObject:@"2" forKey:@"underline"];
    
    [label setLinkAttributes:linkAttributes];
	[label setSelectedLinkAttributes:selectedLinkAttributes];
    
    return [label autorelease];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
