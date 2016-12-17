//
//  SongListViewController.m
//  Timer
//
//  Created by svp on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongListViewController.h"
#import "SongCell.h"
#import <AVFoundation/AVFoundation.h>

@interface SongListViewController()
@end

@implementation SongListViewController

static bool isEditing;
@synthesize musicPlayer, aryAllSonglist, codedaryallsonglist, tableVw, toolBar, arrDefaultSounds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndex = -1;
    
    lblHeading.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize25];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 21)];
    lblTitle.text = @"SELECT MUSIC TONE OR ADD SONGS FROM iTUNES";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    UIFont* font = [UIFont fontWithName:@"OstrichSans-Medium" size:17.0];
    lblTitle.font = font;
    self.navigationItem.titleView = lblTitle;
    
    UIBarButtonItem *DoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(BtnDone)];
    
    UIBarButtonItem *AddBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(BtnAdd)];
    
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.toolBar.items = [NSArray arrayWithObjects:DoneBtn, spaceBtn, AddBtn, self.editButtonItem, nil];
    [self.editButtonItem setAction:@selector(edit_clicked)];
    
    aryAllSonglist = [[NSMutableArray alloc]init];
    codedaryallsonglist = [[NSMutableArray alloc]init];
    musicPlayer = [[MPMusicPlayerController alloc]init];
    
    arrDefaultSounds  = [[NSMutableArray alloc] initWithObjects:@"alarm",@"Play", @"Birds", @"Classic", nil];
    
    tableVw.backgroundColor = [UIColor clearColor];
    
//    [self BtnAdd];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = FALSE;

//    if([aryAllSonglist count] == 0)
//        [self BtnAdd];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 1.0;
    }
    else{
        return 5.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
        {
            NSMutableArray *arrSavedSongList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSonglist"]];
            if (arrSavedSongList == nil) {
                return 0;
            }
            return [arrSavedSongList count];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        ((SongCell *)cell).lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
        ((SongCell *)cell).lblTitle.textColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [tableVw setTintColor:[UIColor whiteColor]];
    }
    
    MPMediaItem *mediaItem;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    ((SongCell *)cell).lblTitle.text = @"Default 1";
                    break;
                case 1:
                    ((SongCell *)cell).lblTitle.text = @"Default 2";
                    break;
                case 2:
                    ((SongCell *)cell).lblTitle.text = @"Default 3";
                    break;
                case 3:
                    ((SongCell *)cell).lblTitle.text = @"Default 4";
                    break;
                    
                default:
                    break;
            }

            break;
        case 1:
        {
            NSMutableArray *arrSavedSongList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSonglist"]];
            mediaItem = [arrSavedSongList objectAtIndex:indexPath.row];
            
            ((SongCell *)cell).lblTitle.text = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        }
            break;
            
        default:
            break;
    }
    
    
    NSInteger ROW, SECTION;
    
    ROW = selectedIndex%1000;
    SECTION = selectedIndex/1000;
    
    if(indexPath.row == ROW && indexPath.section == SECTION){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return NO;
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = (indexPath.section*1000)+indexPath.row;
    
    BOOL isPlaying;
    isPlaying = appDelegate.audioPlayer.isPlaying;

    if(isPlaying)
        [appDelegate.audioPlayer stop];
    
    switch (indexPath.section) {
        case 0:
            appDelegate.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] pathForResource:[arrDefaultSounds objectAtIndex:indexPath.row] ofType:@"mp3"]]] error:nil];
           
            break;
        case 1:
        {
            NSMutableArray *arrSavedSongList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSonglist"]];
            
            NSURL *anUrl = [[arrSavedSongList objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyAssetURL];
            appDelegate.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:anUrl error:nil];
        }
            break;
            
        default:
            break;
    }
    
    [tableVw reloadData];
    appDelegate.audioPlayer.numberOfLoops = -1;
    if(isPlaying)
        [appDelegate.audioPlayer play];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arrSavedSongList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSonglist"]];
    MPMediaItem *mediaItem = [arrSavedSongList objectAtIndex:indexPath.row];
    
    MPMediaItem *mediaItemSaved = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarmCustom"]];
    if ([[mediaItem valueForProperty:MPMediaItemPropertyTitle] isEqualToString:[mediaItemSaved valueForProperty:MPMediaItemPropertyTitle]]) {
        [[NSUserDefaults standardUserDefaults] setObject:[arrDefaultSounds objectAtIndex:0] forKey:@"defaultSound"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alarmCustom"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    MPMediaItem *currentItem = appDelegate.musicPlayer.nowPlayingItem;
    NSString *strcompare1, *strcompare2;
    strcompare1 = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    strcompare2 = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    if([strcompare1 isEqualToString:strcompare2])
        [appDelegate.musicPlayer stop];
    
    [arrSavedSongList removeObjectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arrSavedSongList] forKey:@"savedSonglist"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.tableVw deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - Custom Methods

-(IBAction)BtnDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)BtnAdd
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

-(IBAction)edit_clicked:(UIButton *)sender{
    isEditing = !isEditing;
    if (isEditing) {
        [sender setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
        self.tableVw.editing = TRUE;
        self.editButtonItem.title = @"Done";
        
    }
    else{
        [sender setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        self.tableVw.editing = FALSE;
        self.editButtonItem.title = @"Edit";
    }
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSInteger compare=0;
    
    NSMutableArray *arrSavedSongList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSonglist"]];
    
    if (arrSavedSongList == nil) {
        arrSavedSongList = [NSMutableArray new];
    }
    
    for (MPMediaItem *mediaItem in mediaItemCollection.items) {
        
        NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL],@"url", 
                                [mediaItem valueForProperty:MPMediaItemPropertyTitle],@"title",nil];
        

        for(int j=0; j < [arrSavedSongList count]; j++)
        {
            NSString *str1, *str2;
            
            str1 = [record objectForKey:@"title"];
            str2 = [[arrSavedSongList objectAtIndex:j] valueForProperty:MPMediaItemPropertyTitle];
            
            if([str1 isEqualToString:str2])
                compare = 1;                
        }
        
        if(compare !=1)
        {
            [arrSavedSongList addObject:mediaItem];
        }
        
        compare = 0;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arrSavedSongList] forKey:@"savedSonglist"];
    
    [self.tableVw reloadData];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
//    [mediaPicker dismissModalViewControllerAnimated:YES];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - orientation Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
}
-(BOOL)shouldAutorotate
{
    return FALSE;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
