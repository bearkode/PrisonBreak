/*
 *  EffectShadersViewController.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 2..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */



#import <UIKit/UIKit.h>


@interface EffectShadersViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView *mShaderPicker;
}

@end
