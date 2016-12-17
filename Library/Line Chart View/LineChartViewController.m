
#import "LineChartViewController.h"
#import "JSONKit.h"

#define kGapBetweenTwoPoint 140

@implementation LineChartViewController

- (id)init:(NSMutableArray*)arrData withXLabels:(NSMutableArray *)arrXlabels
{
	self = [super init];
	if (self)
	{
//		[self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [self.view setBackgroundColor:[UIColor clearColor]];
		[self setTitle:@"Line Chart"];
		
//		_lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,10,[self.view bounds].size.width-20,[self.view bounds].size.height-20)];
        if(arrData.count < 5)
        {
            _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0,0, kGapBetweenTwoPoint*4, 300)];
        }
        else{
            _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0,0, kGapBetweenTwoPoint*arrData.count, 300)];
        }
        
		[_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		_lineChartView.minValue = 0;
		_lineChartView.maxValue = 100;
		[self.view addSubview:_lineChartView];
		
		NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_linechart_data.json"];
		NSString *jsonString = [NSString stringWithContentsOfFile:sampleFile encoding:NSUTF8StringEncoding error:nil];
		
        NSDictionary *sampleInfo = [jsonString objectFromJSONString];
        
        NSMutableArray *components = [NSMutableArray array];
		for (int i=0; i< 1; i++)
		{
//			NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
			PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
//			[component setTitle:[point objectForKey:@"title"]];
//			[component setPoints:[point objectForKey:@"data"]];
            [component setPoints:arrData];
			[component setShouldLabelValues:NO];
			
			if (i==0)
			{
				[component setColour:PCColorYellow];
			}
			else if (i==1)
			{
				[component setColour:PCColorGreen];
			}
			
			[components addObject:component];
		}
		[_lineChartView setComponents:components];
		[_lineChartView setXLabels:arrXlabels];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self.lineChartView setNeedsDisplay];
    return YES;
}

@end
