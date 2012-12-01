//
//  Sample3ViewController.h
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface Sample3ViewController : UIViewController <ZBarReaderViewDelegate>
@property (nonatomic,strong) IBOutlet ZBarReaderView* readerView;
@end
