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
#import "UIColor+Extension.h"
#import "KGNoise.h"

@interface IOPNiceHeaderView : UIView
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;
@end

@implementation IOPNiceHeaderView

+ (Class)layerClass { return [CAGradientLayer class]; }

- (CAGradientLayer *)gradientLayer { return (CAGradientLayer *)self.layer; }

@end

CGFloat const kTableViewCellHeight = 50.0f;

@interface IOPMenuTableViewController ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation IOPMenuTableViewController

- (void)loadView
{
    [super loadView];
    
    //
    NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"MenuContent" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dictionaryPath];
    self.data = data;
    
    //
	[self.navigationController setNavigationBarHidden:YES];
	
    //
    self.tableView.rowHeight = kTableViewCellHeight;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithWhite:.15f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:.1f alpha:1.0f];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //
    CGRect tableHeaderViewFrame = self.view.bounds;
    tableHeaderViewFrame = CGRectOffset(tableHeaderViewFrame, .0f, -CGRectGetHeight(tableHeaderViewFrame));
    IOPNiceHeaderView *niceHeaderView = [[IOPNiceHeaderView alloc] initWithFrame:tableHeaderViewFrame];
    NSArray *colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:1.0f].CGColor, (id)[[UIColor blackColor] colorWithAlphaComponent:.0f].CGColor];
    niceHeaderView.gradientLayer.colors = colors;
    UIView *tableHeaderView = [[UIView alloc] init];
    [tableHeaderView addSubview:niceHeaderView];
    self.tableView.tableHeaderView = tableHeaderView;
    
}

- (UIImage *)_backgroundImage
{
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage imageWithSize:CGSizeMake(320.0f, kTableViewCellHeight) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            //
            UIColor *color = [UIColor colorWithWhite:.2f alpha:1.0f];
            color = [color colorWithNoiseWithOpacity:.05f];
            [color setFill];
            UIRectFill(rect);
            
            //
            CGRect topLine = rect;
            topLine.size.height = 1.0f;
            [[UIColor colorWithWhite:1.0f alpha:.2f] setFill];
            UIRectFill(topLine);
        }];
    });
    
    return toReturn;
}

- (UIImage *)_selectedBackgroundImage
{
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage imageWithSize:CGSizeMake(1.0f, kTableViewCellHeight) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            //
            [[[UIColor blackColor] colorWithAlphaComponent:.25f] setFill];
            UIRectFill(rect);
            
            //
            CGRect topLine = rect;
            topLine.size.height = 1.0f;
            [[UIColor colorWithWhite:.1f alpha:1.0f] setFill];
            UIRectFill(topLine);
        }];
    });
    
    return toReturn;
}


- (UIImage *)_viewForHeaderImage
{
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage imageWithSize:CGSizeMake(320.0f, 22.0f) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            //
            UIColor *color = [UIColor colorWithWhite:.3f alpha:1.0f];
            color = [color colorWithNoiseWithOpacity:.05f];
            [color setFill];
            UIRectFill(rect);
            
            //
            CGFloat startColorComps[] = {1.0f, 1.0f, 1.0f, .075f};
			CGFloat endColorComps[] = {1.0f, 1.0f, 1.0f, .0f};
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
            CGRect gradientRect = rect;
            CGPoint endPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)};
            CGPoint startPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect)};
            CGContextDrawLinearGradient(ctx, _glossGradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(_glossGradientRef);
            
            //
            CGRect topLine = rect;
            topLine.size.height = 1.0f;
            [[UIColor colorWithWhite:1.0f alpha:.25f] setFill];
            UIRectFill(topLine);
            
            CGRect bottomLine = rect;
            bottomLine.origin.y += CGRectGetHeight(bottomLine)-1.0f;
            bottomLine.size.height = 1.0f;
            [[UIColor colorWithWhite:.2f alpha:1.0f] setFill];
            UIRectFill(bottomLine);
            
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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
		
        //
        UIImageView *iv = [[UIImageView alloc] initWithImage:[self _backgroundImage]];
        cell.backgroundView = iv;
        
        //
        UIView *selectedBackgroundView = [[UIImageView alloc] initWithImage:[self _selectedBackgroundImage]];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        //
		cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        cell.textLabel.textColor = [UIColor colorWithWhite:.6f alpha:1.0f];
		cell.textLabel.highlightedTextColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
		cell.textLabel.shadowColor = [UIColor blackColor];
		cell.textLabel.shadowOffset = CGSizeMake(.0f, -.7f);
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    
    //
    UIImageView *iv = [[UIImageView alloc] initWithImage:[self _viewForHeaderImage]];
    
    //
    CGFloat padding = 10.0f;
    CGRect rect = iv.bounds;
    rect.origin.x += padding;
    rect.size.width -= padding;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.text = [[[self.data objectForKey:@"Sections"] objectAtIndex:section] objectForKey:@"title"];
    label.textColor = [UIColor colorWithWhite:.65f alpha:1.0f];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(.0f, -.7f);
    [iv addSubview:label];
    
    return iv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return .0f;
    return [self _viewForHeaderImage].size.height;
}

@end
