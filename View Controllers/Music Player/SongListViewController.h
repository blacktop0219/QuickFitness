//
//  SongListViewController.h
//  Timer
//
//  Created by svp on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SongListViewController : UIViewController <MPMediaPickerControllerDelegate>
{
    MPMusicPlayerController *musicPlayer;
    NSMutableArray *aryAllSonglist;
    NSMutableArray *codedaryallsonglist;
    
    NSInteger selectedIndex;
    
    IBOutlet UILabel *lblHeading;
}

@property (nonatomic, strong) NSMutableArray *aryAllSonglist;
@property (nonatomic, strong) NSMutableArray *codedaryallsonglist;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) IBOutlet UITableView *tableVw;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray *arrDefaultSounds;

-(IBAction)BtnDone;
-(IBAction)BtnAdd;
-(IBAction)edit_clicked:(UIButton *)sender;

@end
