//
//  navController.m
//  SeeMD
//
//  Created by iCoderz_Avinash on 10/26/12.
//
//

#import "navController.h"

@interface navController ()

@end


@implementation navController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    [self.topViewController shouldAutorotate];
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
   return [self.topViewController supportedInterfaceOrientations];
}

@end
