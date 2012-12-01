//
//  Sample3ViewController.m
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import "Sample3ViewController.h"

/* ZBarReaderView ONLY no other parts */

@implementation Sample3ViewController

@synthesize readerView = _readerView;

#pragma mark - ZBarReaderDelegate

- (void)readerView:(ZBarReaderView*)view
	didReadSymbols:(ZBarSymbolSet*)syms
		 fromImage:(UIImage*)img
{
	NSLog(@"Sample3:readerView:didReadSymbols:fromImage:");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	NSLog(@"Sample3:viewDidLoad");
    [super viewDidLoad];
	
	// ZBar: the delegate receives decode results
	_readerView.readerDelegate = self;
	
	// ZBar: ensure initial camera orientation is correctly set
	UIApplication *app = [UIApplication sharedApplication];
	[_readerView willRotateToInterfaceOrientation:app.statusBarOrientation duration: 0];
}

- (void)viewDidUnload
{
	NSLog(@"Sample3:viewDidUnload");
    [super viewDidUnload];
	
	_readerView.readerDelegate = nil;
#ifdef	NOARC
	[_readerView release];
#endif	/*NOARC*/
	_readerView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// ZBar: run the reader when the view is visible
	NSLog(@"Sample3:viewDidAppear: start");
	[_readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	// ZBar: stop the reader
	NSLog(@"Sample3:viewWillDisappear: stop");
	[_readerView stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
