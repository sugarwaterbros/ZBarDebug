//
//  Sample1ViewController.m
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import "Sample1ViewController.h"
#import "ZBarSDK.h"

/* ZBarReaderViewController works very fine! */

@interface Sample1ViewController ()
@property (nonatomic,strong) NSMutableArray* codes;  // NSString*
@property (nonatomic,strong) NSMutableArray* images; // UIImage*
@property (nonatomic,strong) ZBarReaderViewController* readerView;
@end

@implementation Sample1ViewController
@synthesize Sample1Toolbar = _Sample1Toolbar;

@synthesize codes = _codes;
@synthesize images = _images;
@synthesize readerView = _readerView;

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

- (void) imagePickerController:(UIImagePickerController*)reader
 didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
	UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[_readerView dismissModalViewControllerAnimated:YES];

	ZBarSymbol* symbol = nil;
	for (symbol in results) {
		// EXAMPLE: just grab the first barcode
		break;
	}

	// EXAMPLE: do something useful with the barcode data
	[self.codes addObject:symbol.data];
	[self.images addObject:image];

	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationBottom];
	[self.tableView reloadData];
}

#pragma mark - Toolbar Button Handlers

- (IBAction)scanPressed:(id)sender
{
	NSLog(@"Sample1:scanPressed");
	if (!_readerView) {
		_readerView = [ZBarReaderViewController new];	/* new !!! */
#ifdef	NOARC
		[_readerView retain];
#endif	/*NOARC*/
		_readerView.readerDelegate = self;
		_readerView.supportedOrientationsMask = ZBarOrientationMaskAll;
		[_readerView.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
	}
	[self presentModalViewController:_readerView animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codes count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"Cell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = [self.codes objectAtIndex:indexPath.row];
	cell.imageView.image = [self.images objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setToolbarItems:[_Sample1Toolbar items] animated:YES];
#ifdef	NOARC
	[_Sample1Toolbar release];
#endif	/*NOARC*/
	_Sample1Toolbar = nil;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	_readerView.readerDelegate = nil;
#ifdef	NOARC
	[_codes release];
	[_images release];
	[_readerView release];
#endif	/*NOARC*/
	_codes = _images = nil;
	_readerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
