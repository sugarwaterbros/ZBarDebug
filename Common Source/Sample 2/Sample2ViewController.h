//
//  Sample2ViewController.h
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface Sample2ViewController : UIViewController <ZBarReaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) IBOutlet ZBarReaderView* readerView;
@property (nonatomic,strong) IBOutlet UITableView* tableView;
@end
