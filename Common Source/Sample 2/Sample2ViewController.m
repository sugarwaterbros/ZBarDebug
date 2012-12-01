//
//  Sample2ViewController.m
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import "Sample2ViewController.h"

/* Embedded ZBarReaderView like EmbedReader Example */

@interface Sample2ViewController ()
@property (nonatomic,strong) NSMutableArray* codes;  // NSString*
@property (nonatomic,strong) NSMutableArray* images; // UIImage*
@property (nonatomic,strong) ZBarCameraSimulator* cameraSim;
@end

@implementation Sample2ViewController

@synthesize readerView = _readerView;
@synthesize tableView = _tableView;

@synthesize codes = _codes;
@synthesize images = _images;
@synthesize cameraSim = _cameraSim;

- (NSMutableArray*)codes
{
	if (!_codes) {
		_codes = [[NSMutableArray alloc] init];
#ifdef	NOARC
		[_codes retain];
#endif	/*NOARC*/
	}
	return _codes;
}

- (NSMutableArray*)images
{
	if (!_images) {
		_images = [[NSMutableArray alloc] init];
#ifdef	NOARC
		[_images retain];
#endif	/*NOARC*/
	}
	return _images;
}

#pragma mark - ZBarReaderDelegate

- (void)readerView:(ZBarReaderView*)view
	didReadSymbols:(ZBarSymbolSet*)syms
		 fromImage:(UIImage*)img
{
	NSLog(@"Sample2:readerView:didReadSymbols:fromImage:");

	ZBarSymbol* symbol = nil;
	for (symbol in syms) {
		// EXAMPLE: just grab the first barcode
		break;
	}

	[self.codes addObject:symbol.data];
	[self.images addObject:img];

	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationTop];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.codes count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = [self.codes objectAtIndex:indexPath.row];
	cell.imageView.image = [self.images objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Sample2:tableView:didSelectRowAtIndexPath:");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	NSLog(@"Sample2:viewDidLoad");
    [super viewDidLoad];

	// ZBar: the delegate receives decode results
	_readerView.readerDelegate = self;
	
	// ZBar: ensure initial camera orientation is correctly set
	UIApplication *app = [UIApplication sharedApplication];
	[_readerView willRotateToInterfaceOrientation:app.statusBarOrientation duration: 0];

	//  ZBar: you can use this to support the simulator
	if (TARGET_IPHONE_SIMULATOR) {
		_cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
#ifdef	NOARC
		[_cameraSim retain];
#endif	/*NOARC*/
		_cameraSim.readerView = _readerView;
    }
}

- (void)viewDidUnload
{
	NSLog(@"Sample2:viewDidUnload");
	[super viewDidUnload];

#ifdef	NOARC
	[_codes release];
	[_images release];
#endif	/*NOARC*/
	_codes = _images = nil;

	_cameraSim.readerView = nil;
#ifdef	NOARC
	[_cameraSim release];
#endif	/*NOARC*/
	_cameraSim = nil;

	_readerView.readerDelegate = nil;
#ifdef	NOARC
	[_readerView release];
#endif	/*NOARC*/
	_readerView = nil;

#ifdef	NOARC
	[_tableView release];
#endif	/*NOARC*/
	_tableView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// ZBar: run the reader when the view is visible
	NSLog(@"Sample2:viewDidAppear: start");
	[self.readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	// ZBar: stop the reader
	NSLog(@"Sample2:viewWillDisappear: stop");
	[self.readerView stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
