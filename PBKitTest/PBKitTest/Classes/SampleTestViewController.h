/*
 *  SampleTestViewController.h
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>


@interface SampleTestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    NSArray              *mTestList;
}

@end
