//
//  StatusTableViewCell.m
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

#import "StatusTableViewCell.h"


@implementation StatusTableViewCell
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentLabel = [StatusTableViewCell label];
        [self.contentView addSubview:self.contentLabel];
        //[self.contentLabel setNumberOfLines:0];
        /*
        typeIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,30)];
        [typeIndicatorView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        [self.contentView addSubview:typeIndicatorView];
        [typeIndicatorView release];
        */
        //[self.contentView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    CGRect frame2 = [typeIndicatorView frame];
    frame2.size.height = self.frame.size.height;
    [typeIndicatorView setFrame:frame2];*/
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

+ (RTLabel*)label
{
    RTLabel *label;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        label = [[RTLabel alloc] initWithFrame:CGRectMake(10,5,768-20,100)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:20]];
    }
    else
    {
        label = [[RTLabel alloc] initWithFrame:CGRectMake(10,5,300,100)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:14]];
    }
    [label setTextColor:[UIColor colorWithWhite:0 alpha:1]];
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
	[linkAttributes setObject:@"#111111" forKey:@"color"];
    [linkAttributes setObject:@"HelveticaNeue-Italic" forKey:@"face"];
	[linkAttributes setObject:@"1" forKey:@"underline"];
	
	NSMutableDictionary *selectedLinkAttributes = [NSMutableDictionary dictionary];
	[selectedLinkAttributes setObject:@"#333333" forKey:@"color"];
    [selectedLinkAttributes setObject:@"HelveticaNeue-Italic" forKey:@"face"];
	[selectedLinkAttributes setObject:@"2" forKey:@"underline"];
    
    [label setLinkAttributes:linkAttributes];
	[label setSelectedLinkAttributes:selectedLinkAttributes];
    
    return [label autorelease];
}

@end
