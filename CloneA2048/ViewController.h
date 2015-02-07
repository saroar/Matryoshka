//
//  ViewController.h
//  CloneA2048
//
//  Created by Mattias Jähnke on 2014-05-26.
//  Copyright (c) 2014 Nearedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {

    IBOutlet UIImageView *grdpapa;
    
    IBOutlet UIImageView *grdmama;

    IBOutlet UIImageView *papa;

    IBOutlet UIImageView *mama;

    IBOutlet UIImageView *sister;

    IBOutlet UIImageView *me;
    
    IBOutlet UIImageView *udid;
}


- (IBAction)next:(id)sender;
@end
