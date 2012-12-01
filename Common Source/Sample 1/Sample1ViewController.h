//
//  Sample1ViewController.h
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface Sample1ViewController : UITableViewController <ZBarReaderDelegate>
@property (nonatomic,strong) IBOutlet UIToolbar* Sample1Toolbar;
- (IBAction)scanPressed:(id)sender;
@end
