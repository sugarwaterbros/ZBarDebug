//
//  ZBarViewController.m
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import "ZBarViewController.h"

@interface ZBarViewController ()
@property (nonatomic,strong) NSDictionary* samples;
@property (nonatomic,strong) NSArray* labels;
@end

#define KEY_CLASSNAME	@"classname"
#define KEY_COMMENT		@"comment"
#define KEY_KEEPVC		@"keepvc"
#define KEY_CONTROLLER	@"controller"

@implementation ZBarViewController

@synthesize samples = _samples;
@synthesize labels = _labels;

#pragma mark - Sample Table Dictionary

- (NSDictionary*)samples
{
	if (!_samples) {
		_samples = [NSDictionary dictionaryWithObjectsAndKeys:

					[NSMutableDictionary dictionaryWithObjectsAndKeys:
					 @"Sample1ViewController", KEY_CLASSNAME,
					 @"Use ZBarReaderViewController, it's fine!", KEY_COMMENT,
					 [NSNumber numberWithBool:NO], KEY_KEEPVC,
					nil],
					@"Sample 1",

					/* 'Sample2ViewController' and keepvc=NO */
					[NSMutableDictionary dictionaryWithObjectsAndKeys:
					 @"Sample2ViewController", KEY_CLASSNAME,
					 @"ZBarReaderView in xib… crash… my bug?", KEY_COMMENT,
					 [NSNumber numberWithBool:NO], KEY_KEEPVC,
					 nil],
					@"Sample 2",

					[NSMutableDictionary dictionaryWithObjectsAndKeys:
					 @"Sample3ViewController", KEY_CLASSNAME,
					 @"ONLY ZBarReaderView in xib… crash", KEY_COMMENT,
					 [NSNumber numberWithBool:NO], KEY_KEEPVC,
					  nil],
					@"Sample 3",

					/* 'Sample2ViewController' but keepvc=YES */
					[NSMutableDictionary dictionaryWithObjectsAndKeys:
					 @"Sample2ViewController", KEY_CLASSNAME,
					 @"Same as Sample 2 but keep view controller", KEY_COMMENT,
					 [NSNumber numberWithBool:YES],	KEY_KEEPVC,
					 nil],
					@"Sample 4",

					/* keepvc=NO but avoiding in viewWillDisappear */
					[NSMutableDictionary dictionaryWithObjectsAndKeys:
					 @"Sample5ViewController", KEY_CLASSNAME,
					 @"Avoiding in pushed viewController", KEY_COMMENT,
					 [NSNumber numberWithBool:NO], KEY_KEEPVC,
					 nil],
					@"Sample 5",
					
					nil];
#ifdef	NOARC
		[_samples retain];
#endif	/*NOARC*/
	}
	return _samples;
}

- (NSString*)label:(NSInteger)index
{
	if (!_labels) {
		_labels = [[self.samples allKeys] sortedArrayUsingSelector:@selector(compare:)];
#ifdef	NOARC
		[_labels retain];
#endif	/*NOARC*/
	}
	return [_labels objectAtIndex:index];
}

- (NSString*)comment:(NSInteger)index
{
	NSString* label = [self label:index];
	return [[self.samples objectForKey:label] objectForKey:KEY_COMMENT];
}

- (NSString*)classNameFor:(NSString*)label
{
	return [[self.samples objectForKey:label] objectForKey:KEY_CLASSNAME];	
}

- (BOOL)keepVcFor:(NSString*)label
{
	NSMutableDictionary* dictionary = [self.samples objectForKey:label];
	return [[dictionary objectForKey:KEY_KEEPVC] boolValue];
}

- (UIViewController*)controllerFor:(NSString*)label
{
	return [[self.samples objectForKey:label] objectForKey:KEY_CONTROLLER];
}

- (void)setController:(UIViewController*)controller forLabel:(NSString*)label 
{
	NSMutableDictionary* dictionary = [self.samples objectForKey:label];
	[dictionary setObject:controller forKey:KEY_CONTROLLER];
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.samples count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"Cell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
				initWithStyle:UITableViewCellStyleSubtitle
				reuseIdentifier:CellIdentifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [self label:indexPath.row];
	cell.detailTextLabel.text = [self comment:indexPath.row];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSString* label = [self label:indexPath.row];
	NSString* aClassName = [self classNameFor:label];
	if (NSClassFromString(aClassName) == nil) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
		UIAlertView* na = [[UIAlertView alloc] initWithTitle:nil
													 message:@"Not Available"
													delegate:nil
										   cancelButtonTitle:nil
										   otherButtonTitles:@"I know", nil];
		[na show];
		return;
	}

	/* Solution */
	UIViewController* viewController;
	if ([self keepVcFor:label]) {	/* keepvc=YES */
		/* re-use if exist */
		viewController = [self controllerFor:label];
		if (!viewController) {
			/* alloc from nib and keep in dictionary */
			viewController = [[NSClassFromString(aClassName) alloc]
							  initWithNibName:aClassName bundle:nil];
			[self setController:viewController forLabel:label];
		}
	}
	else {	/* keepvc=NO */
		/* always from Nib file (released after pop... will crash) */
		viewController = [[NSClassFromString(aClassName) alloc]
						  initWithNibName:aClassName bundle:nil];		
	}

	viewController.title = label;
#if !defined(NOARC)
	viewController.title = [label stringByAppendingString:@" ARC"];
#endif	/*NOARC*/
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
#if !defined(NOARC)
	self.title = [self.navigationItem.title stringByAppendingString:@" ARC"];
#endif	/*NOARC*/
}

- (void)viewDidUnload
{
	[super viewDidUnload];
#ifdef	NOARC
	[_samples release];
	[_labels release];
#endif	/*NOARC*/
	_samples = nil;
	_labels = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
