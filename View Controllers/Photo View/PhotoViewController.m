//
//  PhotoViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "PhotoViewController.h"

#import "PhotoObject.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

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
    self.title = @"Photo";
    
    arr1 = [[NSMutableArray alloc] init];
    arr2 = [[NSMutableArray alloc] init];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    [self setFont];
    [self getAllData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
//    [self ChangeDateFromat];
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ChangeDateFromat
{
       NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MMM dd YY"];
    NSString *str = [df stringFromDate:[NSDate date]];
    lblDate1.text = str;
    lblDate2.text = str;
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
  
       int kMaxResolution  = 500;
    
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark - IBAction Events -

-(IBAction)addPhotoBtn_click:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:appTitle delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pick from Camera",@"Pick from Photo Album", nil];
    [actionsheet showInView:appDelegate.window];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex){
        
    }else if (buttonIndex==0){
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker;
            @autoreleasepool {
               picker = [[UIImagePickerController alloc] init];
            }
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            picker.allowsEditing = NO;
            picker.delegate = self;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QuickFitness" message:@"Camera not Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }else if (buttonIndex==1){
        UIImagePickerController *picker;
        @autoreleasepool {
            picker = [[UIImagePickerController alloc] init];
        }
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}
-(IBAction)previousBtnForDate1:(id)sender
{
    if(selectedIndexfordate1 >0){
        if(arr1.count > 1){
            if(selectedIndexfordate1 == arr1.count){
                selectedIndexfordate1-=2;
            }
            else{
                selectedIndexfordate1--;
            }
            PhotoObject *po = [arr1 objectAtIndex:selectedIndexfordate1];
            lblDate1.text = [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
            [imgVw1 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
       }
    }
}

-(IBAction)nextBtnForDate1:(id)sender
{
    if(selectedIndexfordate1 < arr1.count){
        if(arr1.count > 1){
            if(selectedIndexfordate1 == 0){
                selectedIndexfordate1++;
            }
        }
        PhotoObject *po = [arr1 objectAtIndex:selectedIndexfordate1];
        lblDate1.text = [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
        [imgVw1 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
        selectedIndexfordate1++;
    }
}

-(IBAction)previousBtnForDate2:(id)sender
{
    if(selectedIndexfordate2 >0){
        if(arr1.count > 1){
            if(selectedIndexfordate2 == arr2.count){
                selectedIndexfordate2-=2;
            }
            else{
                selectedIndexfordate2--;
            }
            PhotoObject *po = [arr2 objectAtIndex:selectedIndexfordate2];
            lblDate2.text = [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
            [imgVw2 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
        }
    }
}

-(IBAction)nextBtnForDate2:(id)sender
{
    if(selectedIndexfordate2 < arr2.count){
        if(arr1.count > 1){
            if(selectedIndexfordate2 == 0){
                selectedIndexfordate2++;
            }
        }
        PhotoObject *po = [arr2 objectAtIndex:selectedIndexfordate2];
        lblDate2.text = [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
        [imgVw2 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
        selectedIndexfordate2++;
    }
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *tempIMage = ((UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    imgVw2.image = [self scaleAndRotateImage:tempIMage];
    
    [self saveImageInDocumentDirectoryWithImage:imgVw2.image];
}

#pragma mark - Custom Events -

-(void)setFont
{
    lblDate1.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
    lblDate2.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
}

-(BOOL)saveImageInDocumentDirectoryWithImage:(UIImage *)Image
{
    @autoreleasepool {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"MMM dd YY"];
        NSString *imageName = [NSString stringWithFormat:@"%@%d",[formater stringFromDate:[NSDate date]],appDelegate.UserId];
//        NSString *imageName = [NSString stringWithFormat:@"profilePic%d",appDelegate.UserId];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"temp"];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:path])
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSString *savedImagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
        
        NSData *imageData = [[NSData alloc] init];
        @autoreleasepool
        {
            imageData = UIImagePNGRepresentation(Image);
            [imageData writeToFile:savedImagePath atomically:YES];
        }
        imageData = nil;
        
        NSString * str = [NSString stringWithFormat:@"SELECT Count(*) FROM PhotoMaster Where CreatedDate = '%@' AND userId=%d", imageName,appDelegate.UserId];
        rs = [db executeQuery:str];
        [rs next];
        int RecordCount = [rs intForColumnIndex:0];
        
        if(RecordCount==0){
            str = [NSString stringWithFormat:@"Insert into PhotoMaster('CreatedDate', 'ImagePath' ,'UserId') values('%@', '%@', '%d')", imageName, savedImagePath, appDelegate.UserId];
            [db executeUpdate:str];
        }
        [self getAllData];
        return true;
    }
}

-(void)getAllData
{
    [arr1 removeAllObjects];
    [arr2 removeAllObjects];
    NSString * str = [NSString stringWithFormat:@"SELECT * FROM PhotoMaster where UserId=%d",appDelegate.UserId];
    rs = [db executeQuery:str];
    while ([rs next]) {
        PhotoObject *po = [[PhotoObject alloc] init];
        po.Id = [rs intForColumnIndex:0];
        po.strDate = [rs stringForColumnIndex:1];
        po.strImagePath = [rs stringForColumnIndex:2];
        [arr1 addObject:po];
        [arr2 addObject:po];
    }

    PhotoObject *po;
    if(arr1.count > 0)
    {
        po = [arr1 objectAtIndex:0]; //[po.strDate uppercaseString];
        lblDate1.text =  [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
        [imgVw1 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
    }
    selectedIndexfordate1 = 0;
    
    if(arr2.count > 0)
    {
        po = [arr2 objectAtIndex:arr2.count-1];
    }
    selectedIndexfordate2 = arr2.count;
    
    lblDate2.text = [[po.strDate uppercaseString] substringToIndex:[[po.strDate uppercaseString] length] - 1];
    [imgVw2 setImage:[UIImage imageWithContentsOfFile:po.strImagePath]];
    
    if(arr1.count == 0 && arr2.count == 0)
    {
        TopVw.hidden = TRUE;
        lblMessage.hidden = FALSE;
    }
    else
    {
        TopVw.hidden = FALSE;
        lblMessage.hidden = TRUE;
    }
}

#pragma mark - orientation Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return FALSE;
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
