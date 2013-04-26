//
//  IOPMenuViewController.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPMenuTableViewController.h"
#import "IOPRadioViewController.h"
#import "UIViewController+SlideMenu.h"
#import "UIImage+Block.h"

@interface IOPMenuTableViewController ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation IOPMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"MenuContent" ofType:@"plist"];
		NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dictionaryPath];
		self.data = data;
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    
    self.tableView.rowHeight = 50.0f;//kTableViewCellHeight
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

}

- (UIImage *)_backgroundImage
{
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage imageWithSize:CGSizeMake(1.0f, 50.0f) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            CGRect bottomLine = rect;
            bottomLine.origin.y += CGRectGetHeight(bottomLine)-1.0f;
            bottomLine.size.height = 1.0f;
			
            [[UIColor colorWithWhite:.35f alpha:1.0f] setFill];
            //UIRectFill(bottomLine);
            
            CGRect topLine = rect;
            topLine.size.height = 1.0f;
            [[UIColor colorWithWhite:.8f alpha:1.0f] setFill];
            //UIRectFill(topLine);
        }];
    });
    
    return toReturn;
}

- (UIImage *)_selectedBackgroundImage
{
    __block typeof(UIImage) *_weakBackgroundImage = [self _backgroundImage];
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage imageWithSize:CGSizeMake(1.0f, 50.0f) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            [[[UIColor blackColor] colorWithAlphaComponent:.25f] setFill];
            UIRectFill(rect);
            
            [_weakBackgroundImage drawInRect:rect];
			
			CGFloat startColorComps[] = {.0f, .0f, .0f, .9f};
			CGFloat endColorComps[] = {.0f, .0f, .0f, .0f};
			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			
			CGColorRef startColor = CGColorCreate(colorSpace, startColorComps);
			CGColorRef endColor = CGColorCreate(colorSpace, endColorComps);
			
            
			CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
			CFArrayAppendValue(colors, startColor);
			CFArrayAppendValue(colors, endColor);
			
			CGGradientRef _glossGradientRef = CGGradientCreateWithColors(colorSpace, colors, NULL);
			
            CGColorSpaceRelease(colorSpace);
			CFRelease(colors);
			CFRelease(endColor);
			CFRelease(startColor);

            
            //
            CGFloat gradientHeight = 6.0f;
            CGRect gradientRect = rect;
            gradientRect.size.height = gradientHeight;
            
            CGPoint startPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)};
            CGPoint endPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect)};
            CGContextDrawLinearGradient(ctx, _glossGradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
            
            gradientRect = rect;
            gradientRect.origin.y += (CGRectGetHeight(gradientRect)-gradientHeight);
            gradientRect.size.height = gradientHeight;
            
            startPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)};
            endPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect)};
            
            CGContextSetAlpha(ctx, .2f);
            CGContextDrawLinearGradient(ctx, _glossGradientRef, endPoint, startPoint, kCGGradientDrawsAfterEndLocation);
			CGGradientRelease(_glossGradientRef);
			
        }];
    });
    
    return toReturn;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.data objectForKey:@"Sections"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.data objectForKey:@"Sections"] objectAtIndex:section] objectForKey:@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:section];
	return [[sectionDictionary objectForKey:@"cells"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
        UIImageView *iv = [UIImageView new];
        iv.image = [self _backgroundImage];
        
        UIImageView *siv = [UIImageView new];
        siv.image = [self _selectedBackgroundImage];
        
        cell.backgroundView = iv;
        cell.selectedBackgroundView = siv;
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.highlightedTextColor = [UIColor lightTextColor];
		
    }    
	
    // Configure the cell...
	NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:indexPath.section];
	cell.textLabel.text =  [[[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:indexPath.section];
	NSDictionary *channelInfo = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    IOPRadioViewController *rvc = [[IOPRadioViewController alloc] init];
    rvc.channelInfo = channelInfo;
    
    [self.containerViewController dismissMenuViewController:YES andPresentViewController:rvc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0f;
}

@end
