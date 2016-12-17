//
//  ProfileViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "UpdateProfileViewController.h"

@interface UpdateProfileViewController ()
{
    BOOL    pageControlIsChangingPage;

}
@end

@implementation UpdateProfileViewController
@synthesize objUserInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    isfirst = YES;
    isfirst1 = YES;
    @autoreleasepool {
        arrAge = [[NSMutableArray alloc] init];
        arrWeight = [[NSMutableArray alloc] init];
        arrGoalweight = [[NSMutableArray alloc]init];
        arrHeight = [[NSMutableArray alloc] init];
        arrFixedHeight  =[[NSMutableArray alloc]init];
        arrFixedWeight = [[NSMutableArray alloc]init];
        arrFixedGoalWeight = [[NSMutableArray alloc]init];
        arrLoadData = [[NSMutableArray alloc] init];
        arrHeightInch = [[NSMutableArray alloc] init];
        arrFixedGoalWeight = [[NSMutableArray alloc] init];

    }
    
    scrollMain.scrollEnabled = YES;
    scrollMain.pagingEnabled = YES;
    scrollMain.clipsToBounds = NO;
    [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width*5, 0)];
    [scrGlobal setContentSize:CGSizeMake(scrGlobal.frame.size.width, 600)];
    
    [self setFonts];
    [self loadArrs];
    @autoreleasepool {
        ap = [[KSAdvancedPicker alloc] initWithFrame:pickerVw.frame];
        ap1 = [[KSAdvancedPicker alloc] initWithFrame:HeightPickerVw.frame];
        ap2 = [[KSAdvancedPicker alloc] initWithFrame:WeightPickerVw.frame];
        ap3 = [[KSAdvancedPicker alloc] initWithFrame:goalWeightPickerVw.frame];
    }
  
    
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
        isBtnKGClicked = FALSE;
        isBtnGoalKGClicked = FALSE;
        [btnKG setTitle:@"<KG>" forState:UIControlStateNormal];
        [btnGoalKG setTitle:@"<KG>" forState:UIControlStateNormal];
    }
    else{
        isBtnKGClicked = TRUE;
        isBtnGoalKGClicked = TRUE;
        [btnKG setTitle:@"<POUND>" forState:UIControlStateNormal];
        [btnGoalKG setTitle:@"<POUND>" forState:UIControlStateNormal];
    }
    
    if([objUserInfo.strheightType isEqualToString:@"FT"]){
         isBtnCMClicked = FALSE;
        [btnCM setTitle:@"<CM>" forState:UIControlStateNormal];
        
    }else{
         isBtnCMClicked = TRUE;
        [btnCM setTitle:@"<FT>" forState:UIControlStateNormal];
    }
    [self initHeights];
    [self initWeightVw];
    [self loadWeightVw];
    [self loadHeightVw];
    [self loadGoalWeightVw];
    
    //-----------
    UIImageView *IMgBg;
    @autoreleasepool {
        if(appDelegate.isIphone5){
            IMgBg  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-5, 216, 50)];
        }else{
            IMgBg  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-10, 216, 50)];
        }
    }
    IMgBg.backgroundColor = [UIColor lightGrayColor];
    IMgBg.alpha = 0.4;
    [pickerVw addSubview:IMgBg];
    
    UIImageView *IMgBg1;
    @autoreleasepool {
        if(appDelegate.isIphone5){
            IMgBg1  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-5, 216, 50)];
        }else{
            IMgBg1  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-10, 216, 50)];
        }
    }
    IMgBg1.backgroundColor = [UIColor lightGrayColor];
    IMgBg1.alpha = 0.4;
    [HeightPickerVw addSubview:IMgBg1];
    
    UIImageView *IMgBg2;
    @autoreleasepool {
        if(appDelegate.isIphone5){
            IMgBg2  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-5, 216, 50)];
        }else{
            IMgBg2  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-10, 216, 50)];
        }
    }
    IMgBg2.backgroundColor = [UIColor lightGrayColor];
    IMgBg2.alpha = 0.4;
    [WeightPickerVw addSubview:IMgBg2];
    
    UIImageView *IMgBg3;
    @autoreleasepool {
        if(appDelegate.isIphone5){
            IMgBg3  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-5, 216, 50)];
        }else{
            IMgBg3  = [[UIImageView alloc] initWithFrame:CGRectMake(0, (pickerVw.frame.size.height/2)-10, 216, 50)];
        }
    }
    IMgBg3.backgroundColor = [UIColor lightGrayColor];
    IMgBg3.alpha = 0.4;
    [goalWeightPickerVw addSubview:IMgBg3];
    //-------------
    
    @autoreleasepool {
        if(!imgPicker)
        {
            imgPicker = [[UIImagePickerController alloc]init];
            imgPicker.delegate= self;
        }
    }
   
    [self loadAgeVw];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:124.0/255.0 green:207.0/255.0 blue:144.0/255.0 alpha:1.0];
        pageController.pageIndicatorTintColor = [UIColor whiteColor];
    }
//    [switchMF setOnImage:[UIImage imageNamed:@"Switch_man.png"]];
//    [switchMF setOffImage:[UIImage imageNamed:@"Switch_woman.png"]];
    appDelegate.CurrentSwitchName = @"Switch_Man_Woman.png";
    [_mySwitch setOn:YES];
    
    txtName.text = objUserInfo.strName;
    if([objUserInfo.strSex isEqualToString:@"Male"]){
        [_mySwitch setOn:FALSE];
    }else{
        [_mySwitch setOn:TRUE];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kHelveticaNeueThin size:kFontSize25], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Topbar_5.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSString *ImageURL = [ProfilePath stringByAppendingPathComponent:objUserInfo.strImageUrl];
    imgUserPhoto.image = [UIImage imageWithContentsOfFile:ImageURL];
    
    [ap selectRow:[objUserInfo.strAge intValue]-1 inComponent:0 animated:YES];
   
    if([objUserInfo.strWeightType isEqualToString:@"LBS"])
    {
        [ap2 selectRow:[self convertKGtoLBS:[objUserInfo.strWeight floatValue]]-1 inComponent:0 animated:YES];
        [ap3 selectRow:[self convertKGtoLBS:[objUserInfo.strGoalWeight floatValue]]-1 inComponent:0 animated:YES];
    }else
    {
        [ap2 selectRow:[objUserInfo.strWeight intValue]-1 inComponent:0 animated:YES];
        [ap3 selectRow:[objUserInfo.strGoalWeight intValue]-1 inComponent:0 animated:YES];
    }
    
    if([objUserInfo.strheightType isEqualToString:@"FT"]){
        
        //NSString *str =  [self convertCmToFT:[objUserInfo.strHeight intValue]];
        for(int h=0;h<arrHeight.count;h++){
            
            if([objUserInfo.strHeight isEqualToString:[arrHeightInch objectAtIndex:h]]){
                [ap1 selectRow:h inComponent:0 animated:YES];
                break;
            }
        }
        
    }else{
         [ap1 selectRow:[objUserInfo.strHeight intValue]-1 inComponent:0 animated:YES];
    }
    //[self CalculateCurrentBMI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)CalculateCurrentBMI
{
    float nHeightVal;
    
    if([objUserInfo.strheightType isEqualToString:@"FT"]){
        
        NSArray *arr = [objUserInfo.strHeight componentsSeparatedByString:@" "];
        nHeightVal = [self convertFtToCm:[[arr objectAtIndex:0]intValue] :[[arr objectAtIndex:2]intValue]]/100;
    }else{
        nHeightVal = [objUserInfo.strHeight floatValue]/100;
    }
    
    BMI = [objUserInfo.strWeight floatValue]/(nHeightVal * nHeightVal);
    BMIDigit.text = [NSString stringWithFormat:@"%d",BMI];
    if(BMI<18.5){
        BMILevel.text = @"Underweight";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imgStick.frame = CGRectMake(90, imgStick.frame.origin.y, imgStick.frame.size.width, imgStick.frame.size.height);
//        imgLevel.image = [UIImage imageNamed:@"Yellow_Bmi.png"];
        [UIView commitAnimations];
       
    }else if (BMI>=18.5 && BMI<25){
        BMILevel.text = @"Healthy";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imgStick.frame = CGRectMake(130, imgStick.frame.origin.y, imgStick.frame.size.width, imgStick.frame.size.height);
//        imgLevel.image = [UIImage imageNamed:@"Green_Bmi.png"];

        [UIView commitAnimations];
        
    }else if(BMI >=25.0 && BMI< 30){
        BMILevel.text = @"Overweight";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imgStick.frame = CGRectMake(170, imgStick.frame.origin.y, imgStick.frame.size.width, imgStick.frame.size.height);
//        imgLevel.image = [UIImage imageNamed:@"Green_Bmi.png"];
        [UIView commitAnimations];
    }
    else if (BMI>=30 && BMI<39){
        BMILevel.text = @"Obese";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imgStick.frame = CGRectMake(194, imgStick.frame.origin.y, imgStick.frame.size.width, imgStick.frame.size.height);
//        imgLevel.image = [UIImage imageNamed:@"Red_Bmi.png"];
        [UIView commitAnimations];
       
    }
    else if (BMI>=39){
        BMILevel.text = @"Extremely Obese";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        imgStick.frame = CGRectMake(230, imgStick.frame.origin.y, imgStick.frame.size.width, imgStick.frame.size.height);
//        imgLevel.image = [UIImage imageNamed:@"Red_Bmi.png"];
        [UIView commitAnimations];
    }
}
#pragma mark - UIText Field Delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtName resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    objUserInfo.strName = textField.text;
}

#pragma mark - Custom Methods -

-(void)loadArrs
{
    [arrAge removeAllObjects];
    for(int i=1; i<100; i++){
        [arrAge addObject:[NSString stringWithFormat:@"%d YEAR", i]];
    }
}

-(void)setFonts
{
    txtName.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    lblGender.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    
    lblBMI.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize23];
    BMIDigit.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize23];
    BMILevel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize23];
    
    lblAgeTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    lblHeightTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    lblWeightTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    lblTakePhotoTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    
   // btnCM.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
   // btnKG.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
}

#pragma mark - KSAdvancedPickerDataSource -

- (NSInteger)numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker
{
    return 1;
}

- (CGFloat)heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker
{
    return 55;
}

- (CGFloat)advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component
{
    CGFloat width = picker.frame.size.width;
    return round(width);
}

- (NSInteger)advancedPicker:(KSAdvancedPicker *)picker numberOfRowsInComponent:(NSInteger)component
{
    if(picker == ap)
        return arrAge.count;
    else if (picker == ap1) {
        if(isBtnCMClicked)
            return arrHeight.count;
        else
            return arrHeightInch.count;
    }
    else if (picker == ap2)
        return arrWeight.count;
    else if (picker == ap3)
        return arrGoalweight.count;
    else
        return 0;
    
}

- (UIView *)advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component inRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize45];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)advancedPicker:(KSAdvancedPicker *)picker setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component
{    
    UILabel *label = (UILabel *) view;
    if(picker == ap)
        if(row<arrAge.count) {
            label.text = [arrAge objectAtIndex:row];
        } else {
            return;
        }
        else if (picker == ap1) {
            if(isBtnCMClicked) {
                if(row<arrHeight.count)
                    label.text = [NSString stringWithFormat:@"%d CM",row];
            }
            else {
                if(row<arrHeightInch.count)
                    label.text = [NSString stringWithFormat:@"%d FT %d IN",row/12+1,row%12];
            }
        }
        else if (picker == ap2) {
        if(isBtnKGClicked) {
            label.text = [NSString stringWithFormat:@"%d KG", row+1];
        } else {
            label.text = [NSString stringWithFormat:@"%d LBS", row+1];
        }
    }
    else if (picker == ap3)
        label.text = [arrGoalweight objectAtIndex:row];
}

#pragma mark - KSAdvancedPickerDelegate -

- (void)advancedPicker:(KSAdvancedPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(picker == ap){
        if(row<arrAge.count)
            objUserInfo.strAge = [arrAge objectAtIndex:row];
    }
    else if(picker == ap1){
        if(row<arrFixedHeight.count) {
            if(isBtnCMClicked) {
                if(row<arrHeight.count)
                    objUserInfo.strHeight = [arrHeight objectAtIndex:row]; }
            else {
                if(row<arrHeightInch.count)
                objUserInfo.strHeight = [arrHeightInch objectAtIndex:row]; }
        }
    }

    else if(picker == ap2){
        if(row<arrFixedWeight.count) {
            
            if(isBtnKGClicked){
                objUserInfo.strWeight = [NSString stringWithFormat:@"%d KG", row+1];
            }
            else {
                objUserInfo.strWeight = [NSString stringWithFormat:@"%.2f KG",[self convertLBStoKG:row+1]];
            }
        }
    }else if (picker == ap3){
         if(row<arrFixedGoalWeight.count)
             objUserInfo.strGoalWeight = [arrFixedGoalWeight objectAtIndex:row];
    }
    [self CalculateCurrentBMI];
}


#pragma mark - ScrollView Events -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlIsChangingPage = NO;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlIsChangingPage)
        return;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageController.currentPage = page;
    
}
- (void)realCalculate {
    
    int row1 = [ap1 selectedRowInComponent:0];
    if(isBtnCMClicked) {
        objUserInfo.strheightType= @"CM";
        objUserInfo.strHeight =  [NSString stringWithFormat:@"%d CM",row1];
    }
    else {
        objUserInfo.strheightType= @"FT";
        objUserInfo.strHeight = [NSString stringWithFormat:@"%d FT %d IN",row1/12+1,row1%12];
    }
    int row;
    row = [ap2 selectedRowInComponent:0];
    
    if(isBtnKGClicked) {
        objUserInfo.strWeight = [NSString stringWithFormat:@"%d KG", row+1];
    } else {
        objUserInfo.strWeight = [NSString stringWithFormat:@"%.2f KG",[self convertLBStoKG:row+1]];
    }
    [self CalculateCurrentBMI];
}

-(void)loadAgeVw
{
    //[arrLoadData removeAllObjects];
    [arrAge removeAllObjects];
    for(int i=1; i<100; i++){
        [arrAge addObject:[NSString stringWithFormat:@"%d YEAR", i]];
    }
   // [arrLoadData addObjectsFromArray:arrAge];

    ap.frame = pickerVw.frame;
    ap.dataSource = self;
    ap.delegate = self;
//    [ap selectRow:4 inComponent:0 animated:YES];
    [pickerVw addSubview:ap];
    
    [ap reloadData];
}
-(void)loadHeightVw
{
   // [arrLoadData addObjectsFromArray:arrHeight];
    ap1.frame = HeightPickerVw.frame;
    ap1.dataSource = self;
    ap1.delegate = self;
    [HeightPickerVw addSubview:ap1];
    
    [ap1 reloadData];
    if(isfirst == NO)
    {
        [self realCalculate];

    }
    isfirst = NO;
}
- (void) initHeights {
    for(int i=1;i<250;i++)
    {
        [arrHeight addObject:[NSString stringWithFormat:@"%d CM", i]];
        [arrFixedHeight addObject:[NSString stringWithFormat:@"%d CM", i]];
        // [arrLoadData addObject:[NSString stringWithFormat:@"%d CM", i]];
    }
    for(int i=1;i<9;i++)
    {
        for(int j=0;j<12;j++)
        {
            [arrHeightInch addObject:[NSString stringWithFormat:@"%d FT %d IN", i, j]];
            [arrFixedHeightInch addObject:[NSString stringWithFormat:@"%f CM",[self convertFtToCm:i :j]]];
            //[arrLoadData addObject:[NSString stringWithFormat:@"%d FT %d IN", i, j]];
        }
    }
}
- (void) initWeightVw {
    if(isBtnKGClicked){
                for(int i=1; i<350; i++){
                    [arrWeight addObject:[NSString stringWithFormat:@"%d KG", i]];
                    [arrFixedWeight addObject:[NSString stringWithFormat:@"%d KG", i]];
        
                }
            }
            else{
                for(int i=1; i<350; i++){
                    [arrWeight addObject:[NSString stringWithFormat:@"%d LBS", i]];
                    [arrFixedWeight addObject:[NSString stringWithFormat:@"%.2f KG",[self convertLBStoKG:i]]];
                }
            }
}
-(void)loadWeightVw
{
    btnKG.enabled = NO;
//    [arrWeight removeAllObjects];
//    [arrFixedWeight removeAllObjects];
//    if(isBtnKGClicked){
//        for(int i=1; i<350; i++){
//            [arrWeight addObject:[NSString stringWithFormat:@"%d KG", i]];
//            [arrFixedWeight addObject:[NSString stringWithFormat:@"%d KG", i]];
//            
//        }
//    }
//    else{
//        for(int i=1; i<350; i++){
//            [arrWeight addObject:[NSString stringWithFormat:@"%d LBS", i]];
//            [arrFixedWeight addObject:[NSString stringWithFormat:@"%.2f KG",[self convertLBStoKG:i]]];
//        }
//    }

    ap2.frame = WeightPickerVw.frame;
    ap2.dataSource = self;
    ap2.delegate = self;
   [WeightPickerVw addSubview:ap2];
    
    [ap2 reloadDataWithCompletion:^{
        btnKG.enabled = YES;
    }];
    
    if(isfirst1 == NO)
    {
        [self realCalculate];

    }
    isfirst1 = NO;
}
-(void)loadGoalWeightVw
{
    [arrGoalweight removeAllObjects];
    [arrFixedGoalWeight removeAllObjects];
    if(isBtnGoalKGClicked){
        for(int i=1; i<350; i++){
            [arrGoalweight addObject:[NSString stringWithFormat:@"%d KG", i]];
            [arrFixedGoalWeight addObject:[NSString stringWithFormat:@"%d KG", i]];
        }
    }
    else{
        for(int i=1; i<350; i++){
            [arrGoalweight addObject:[NSString stringWithFormat:@"%d LBS", i]];
            [arrFixedGoalWeight addObject:[NSString stringWithFormat:@"%.2f KG",[self convertLBStoKG:i]]];
        }
    }
    
    ap3.frame = goalWeightPickerVw.frame;
    ap3.dataSource = self;
    ap3.delegate = self;
    [goalWeightPickerVw addSubview:ap3];
    
    [ap3 reloadData];
}
#pragma mark - Conversion Formula
-(float)convertFtToCm:(int)ft :(int)inc
{
    float cm;
    inc = inc+ ft*12;
    cm = inc * 2.54;
    return cm;
}
-(NSString *)convertCmToFT : (int)cm
{
    NSString *strFt;
    float inch = ceilf(cm/2.54);
    float ft =  inch/12;
    
    int intpart = (int)ft;
    double decpart =  ft - intpart;
    
    int inchPart = ceil(decpart*10);
    
    strFt = [NSString stringWithFormat:@"%d FT %d IN",intpart,inchPart];
    
    return strFt;
}
-(float)convertLBStoKG :(float)lbs
{
    float nKG;
    nKG = lbs * 0.45359237;
    return nKG;
}
-(float)convertKGtoLBS :(float)kg
{
    float nLBS;
    nLBS = kg  * 2.205;
    return nLBS;
}

#pragma mark - IBAction Events -
-(IBAction)btnBack:(id)sender
{
    [scrollMain setContentOffset:CGPointMake(0, 0)];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDone:(id)sender
{
    [self saveImageInDocumentDirectoryWithImage:imgUserPhoto.image];
    [scrollMain setContentOffset:CGPointMake(0, 0)];
    [txtName resignFirstResponder];
    [[NSUserDefaults standardUserDefaults]setObject:objUserInfo.strGoalWeight forKey:@"MyGoalWeight"];
    [DBController updateUserInfo:objUserInfo];
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
        
        [DBController updateUserGoal:[NSString stringWithFormat:@"%0.0f",[self convertKGtoLBS:[objUserInfo.strWeight floatValue]]] withWeightType:objUserInfo.strWeightType withUserId:appDelegate.UserId];
        
    }else {
         [DBController updateUserGoal:objUserInfo.strWeight withWeightType:objUserInfo.strWeightType withUserId:appDelegate.UserId];
    }
    [appDelegate alertMessage:@"Your Profile Updated Successfully"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pageCtrlChanged:(id)sender {
    
    CGFloat pageWidth = scrollMain.frame.size.width;
    CGFloat x = pageController.currentPage * pageWidth;
    //[_scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, _scrollView.frame.size.height) animated:YES];
    [scrollMain setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(IBAction)takePhotoBtn_click:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:appTitle delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pick from Camera",@"Pick from Photo Album", nil];
    [actionsheet showInView:appDelegate.window];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
     [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    if(buttonIndex == actionSheet.cancelButtonIndex){
        
    }else if (buttonIndex==0){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [self presentViewController:imgPicker animated:YES completion:nil];
        }else{
            [appDelegate alertMessage:NSLocalizedString(@"Camera not found",nil)];
        }
    }else if (buttonIndex==1){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
    }
}

-(IBAction) onChange:(DGSwitch *)theSwitch {
    if (theSwitch.on) {
       
         NSLog(@"Female");
//        strMaleFemale = @"Male";
        objUserInfo.strSex = @"Female";
        objUserInfo.strModelType = @"Male";
        objUserInfo.strVoiceType = @"Male";
        [[NSUserDefaults standardUserDefaults]setObject:@"MenModel" forKey:@"ModelType"];
        [[NSUserDefaults standardUserDefaults]setObject:@"MenSound" forKey:@"SoundType"];

    } else {
        NSLog(@"Male");
//        strMaleFemale = @"Female";.........
        objUserInfo.strSex = @"Male";
        objUserInfo.strModelType = @"Female";
        objUserInfo.strVoiceType = @"Female";
        [[NSUserDefaults standardUserDefaults]setObject:@"WomenModel" forKey:@"ModelType"];
        [[NSUserDefaults standardUserDefaults]setObject:@"WomenSound" forKey:@"SoundType"];
    }
}
-(IBAction)weightBtn_click:(id)sender
{
    UIButton *btn = sender;
    
    if([btn.titleLabel.text isEqualToString:@"<KG>"]){
        isBtnKGClicked = TRUE;
        isBtnGoalKGClicked = TRUE;
        [btn setTitle:@"<POUNDS>" forState:UIControlStateNormal];
        objUserInfo.strWeightType = @"KG";
    }
    else{
        isBtnKGClicked = FALSE;
         isBtnGoalKGClicked = FALSE;
        [btn setTitle:@"<KG>" forState:UIControlStateNormal];
        objUserInfo.strWeightType = @"LBS";
        
    }
    [self loadWeightVw];  [self loadGoalWeightVw];
}

-(IBAction)heightBtn_click:(id)sender
{
    UIButton *btn = sender;
    
    if([btn.titleLabel.text isEqualToString:@"<CM>"]){
        isBtnCMClicked = TRUE;
        [btn setTitle:@"<FT/IN>" forState:UIControlStateNormal];
        objUserInfo.strheightType = @"CM";
    }
    else{
        isBtnCMClicked = FALSE;
        [btn setTitle:@"<CM>" forState:UIControlStateNormal];
        objUserInfo.strheightType = @"FT";
    }
    [self loadHeightVw];
}
-(IBAction)goalWeightBtn_click:(id)sender
{
    UIButton *btn = sender;
    
    if([btn.titleLabel.text isEqualToString:@"<KG>"]){
        isBtnGoalKGClicked = TRUE;
        [btn setTitle:@"<POUNDS>" forState:UIControlStateNormal];
    }
    else{
        isBtnGoalKGClicked = FALSE;
        [btn setTitle:@"<KG>" forState:UIControlStateNormal];
    }
    [self loadGoalWeightVw];
}

#pragma mark - ImagePicker Delegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *imgTemp = ((UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    UIImage *croppedImage = [self squareImageWithImage:imgTemp scaledToSize:CGSizeMake(200, 200)];
    imgUserPhoto.image = [self scaleAndRotateImage:croppedImage];
    [self saveImageInDocumentDirectoryWithImage:imgUserPhoto.image];

}

- (UIImage *)cropImage:(UIImage*)image andFrame:(CGRect)rect {
    
    //Note : rec is nothing but the image frame which u want to crop exactly.
    
    rect = CGRectMake(rect.origin.x*image.scale,
                      rect.origin.y*image.scale,
                      rect.size.width*image.scale,
                      rect.size.height*image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:0
                                    orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(BOOL)saveImageInDocumentDirectoryWithImage:(UIImage *)Image
{
    @autoreleasepool {
        
        NSString *imageName = objUserInfo.strImageUrl;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Profile"];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:path])
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSString *savedImagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
//        strImagePath = savedImagePath;
        objUserInfo.strImageUrl = imageName;
        
        NSData *imageData = [[NSData alloc] init];
        @autoreleasepool
        {
            imageData = UIImagePNGRepresentation(Image);
            [imageData writeToFile:savedImagePath atomically:YES];
        }
        imageData = nil;
        
        return true;
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
//    CGFloat width = 340;
//    CGFloat height = 340;
    
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

#pragma mark - orientation Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return FALSE;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
