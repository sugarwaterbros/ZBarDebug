//
//  Sample5ViewController.h
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/12/02.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface Sample5ViewController : UIViewController <ZBarReaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) IBOutlet ZBarReaderView* readerView;
@property (nonatomic,strong) IBOutlet UITableView* tableView;
@end
