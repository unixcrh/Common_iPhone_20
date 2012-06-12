//
//  PPTableViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "PPTableViewController.h"
#import "UITableViewCellUtil.h"
#import "ArrayOfCharacters.h"
#import "LogUtil.h"
#import "DeviceDetection.h"

@interface PPTableViewController ()
@property (assign, nonatomic) BOOL reloading;
@property (assign, nonatomic) BOOL loadingMore;

@end

@implementation PPTableViewController

@synthesize dataList;
@synthesize dataTableView;
@synthesize singleCellImage;
@synthesize firstCellImage;
@synthesize middleCellImage;
@synthesize lastCellImage;


@synthesize singleCellImageName;
@synthesize firstCellImageName;
@synthesize middleCellImageName;
@synthesize lastCellImageName;

@synthesize cellImage;
@synthesize groupData;
@synthesize cellTextLabelColor;
@synthesize accessoryView;
//@synthesize customIndexView;
@synthesize enableCustomIndexView;
@synthesize sectionImage;
@synthesize footerImage;
@synthesize sectionLabel;

@synthesize reloading=_reloading;
@synthesize loadingMore = _loadingMore;
@synthesize refreshHeaderView;
@synthesize refreshFooterView;
@synthesize supportRefreshHeader;
@synthesize supportRefreshFooter;
@synthesize noMoreData = _noMoreData;
@synthesize moreLoadingView;
@synthesize moreRowIndexPath;

@synthesize tableViewFrame;

@synthesize tappedIndexPath;
@synthesize controlRowIndexPath;

@synthesize reloadVisibleCellTimer;
@synthesize enableReloadVisableCellTimer;
@synthesize reloadVisibleCellTimerInterval;
@synthesize tipsLabel = _tipsLabel;

- (void)loadCellFromNib:(NSString*)nibFileNameWithoutSuffix 
{
    [[NSBundle mainBundle] loadNibNamed:nibFileNameWithoutSuffix owner:self options:nil];
}

#pragma Reload Visible Cell Timer

#define DEFAULT_RELOAD_CELL_TIMER_INTERVAL 1

- (void)scheduleReloadVisiableCellTimer:(int)interval
{
    PPDebug(@"<scheduleReloadVisiableCellTimer> interval = %d", interval);    
    self.enableReloadVisableCellTimer = YES;
    self.reloadVisibleCellTimerInterval = interval;
    self.reloadVisibleCellTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(reloadVisiableCell) userInfo:nil repeats:YES];
}

- (void)scheduleReloadVisiableCellTimer
{
    [self scheduleReloadVisiableCellTimer:DEFAULT_RELOAD_CELL_TIMER_INTERVAL];
}

- (void)reloadVisiableCell
{
//    PPDebug(@"<reloadVisiableCell>");
    [self.dataTableView reloadRowsAtIndexPaths:[self.dataTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)checkReloadVisiableCellTimer
{
    if (!enableReloadVisableCellTimer)
        return;
    
    if (self.reloadVisibleCellTimer != nil){
        return;
    }
    else{
        [self scheduleReloadVisiableCellTimer:reloadVisibleCellTimerInterval];
    }
}

- (void)stopReloadVisiableCellTimer
{
    if (self.reloadVisibleCellTimer){
        PPDebug(@"<stopReloadVisiableCellTimer>");
        [self.reloadVisibleCellTimer invalidate];
        self.reloadVisibleCellTimer = nil;
    }
}


#pragma mark Select Row And Section Methods

- (void)resetSelectRowAndSection
{
	selectRow = -1;
	selectSection = -1;
	oldSelectRow = -1;
	oldSelectSection = -1;
}

- (void)updateSelectSectionAndRow:(NSIndexPath*)indexPath
{
	oldSelectRow = selectRow;
	oldSelectSection = selectSection;
	
	selectRow = indexPath.row;
	selectSection = indexPath.section;
}

- (void)reloadForSelectSectionAndRow:(NSIndexPath*)indexPath
{
	if (oldSelectRow != -1 && oldSelectSection != -1){
		// reload previous selected row
		NSArray* oldRowIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:oldSelectRow inSection:oldSelectSection]];
		[dataTableView reloadRowsAtIndexPaths:oldRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	}
	
	// reload new selected row
	[dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];  	
}

#pragma mark Table View Controller


- (void)createRefreshHeaderView
{
    if (!supportRefreshHeader)
        return;
    
    if (refreshHeaderView == nil) {
        self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.dataTableView.bounds.size.height, self.dataTableView.frame.size.width, self.dataTableView.bounds.size.height)] autorelease];
		refreshHeaderView.delegate = self;
		[self.dataTableView addSubview:refreshHeaderView];
    }
    
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];
}

- (void)createRefreshFooterView
{
    if (!supportRefreshFooter)
        return;
    
	if (self.refreshFooterView == nil) {
		refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame: CGRectMake(0.0f, self.dataTableView.contentSize.height, self.dataTableView.frame.size.width, 650)];
		refreshFooterView.delegate = self;
		[self.dataTableView addSubview:refreshFooterView];

		refreshFooterView.hidden = YES;
	}
	
	//  update the last update date
	[refreshFooterView refreshLastUpdatedDate];
}

- (void)setRefreshHeaderViewFrame:(CGRect)frame
{
    self.refreshHeaderView.frame = frame;
}

- (void)setRefreshFooterViewFrame:(CGRect)frame
{
    self.refreshFooterView.frame = frame;
}

- (void)viewDidLoad
{
	dataTableView.delegate = self;
	dataTableView.dataSource = self;
	
	[self resetSelectRowAndSection];	
	[super viewDidLoad];
    [self createRefreshHeaderView];
    [self createRefreshFooterView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.refreshHeaderView = nil;
    self.refreshFooterView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[dataTableView reloadData];	
    [self checkReloadVisiableCellTimer];
        
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopReloadVisiableCellTimer];
    [super viewDidDisappear:animated];
}

- (BOOL)isCellSelected:(NSIndexPath*)indexPath
{
	return (indexPath.row == selectRow && indexPath.section == selectSection);
}

- (int)dataListCountWithMore
{
    int count = [dataList count];
    if (count > 0){
        return count + 1;
    }
    else{
        return count;
    }    
}

- (BOOL)isMoreRow:(int)row
{
    return [dataList count] == row;
}

- (BOOL)isMoreRowIndexPath:(NSIndexPath*)indexPath
{
    if ([moreRowIndexPath isEqual:indexPath])
        return YES;
    else  
        return NO;
}

- (void)updateMoreRowIndexPath
{
    if ([self.dataList count] > 0)
        self.moreRowIndexPath = [NSIndexPath indexPathForRow:[dataList count] inSection:moreRowSection];
    else
        self.moreRowIndexPath = nil;
}

- (void)enableMoreRowAtSection:(int)section
{
    supportMoreRow = YES;
    moreRowSection = section;
    [self updateMoreRowIndexPath];
}

- (NSIndexPath*)modelIndexPathForIndexPath:(NSIndexPath*)indexPath
{
    if (controlRowIndexPath == nil){
        return indexPath;                    
    }    
    
    if ([indexPath isEqual:controlRowIndexPath]){
        return nil;
    }
    
    if (indexPath.section != controlRowIndexPath.section)
        return indexPath;
    
    if (indexPath.row < controlRowIndexPath.row){
        return indexPath;
    }
    else{
        return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
}

- (BOOL)isControlRowIndexPath:(NSIndexPath*)indexPath
{
    return [controlRowIndexPath isEqual:indexPath];
}

- (void)deleteControlRow
{
    // delete control row and tap row
    if (controlRowIndexPath){
        
        [self updateMoreRowIndexPath];
        
        NSIndexPath* indexPathForDelete = [self.controlRowIndexPath retain];
        self.tappedIndexPath = nil;
        self.controlRowIndexPath = nil;
        
        [self.dataTableView beginUpdates];        
        [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataTableView endUpdates];
        
        [indexPathForDelete release];
        
    }    
}

- (int)calcRowCount
{
    int count = [dataList count];
    if (controlRowIndexPath)
        count ++;
    
    if (count > 0 && supportMoreRow)
        count ++;
    
    return  count;
}

- (void)dealloc
{
	[firstCellImageName release];
	[middleCellImageName release];
	[lastCellImageName release];
	[singleCellImageName release];

    [refreshHeaderView release];
    [refreshFooterView release];
    [tappedIndexPath release];
    [controlRowIndexPath release];
    [moreRowIndexPath release];
    [moreLoadingView release];
	[groupData release];
	[dataList release];
	[dataTableView release];
	[firstCellImage release];
	[middleCellImage release];
	[lastCellImage release];
	[cellImage release];
	[singleCellImage release];
	[cellTextLabelColor release];
	[accessoryView release];
//	[customIndexView release];
	[sectionImage release];
	[sectionLabel release];
	[footerImage release];
    [reloadVisibleCellTimer release];
    [_tipsLabel release];
	[super dealloc];
}

#pragma mark Image Methods

- (void)setSingleCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.singleCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	singleImageHeight = image.size.height;
}

- (void)setFirstCellImageByView:(UIImageView*)imageView
{
	self.firstCellImage = imageView;
	firstImageHeight = imageView.image.size.height;
}

- (void)setFirstCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.firstCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	firstImageHeight = image.size.height;
}

- (void)setMiddleCellImageByView:(UIImageView*)imageView
{
	self.middleCellImage = imageView;
	middleImageHeight = imageView.image.size.height;
}

- (void)setMiddleCellImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.middleCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	middleImageHeight = image.size.height;
}

- (void)setLastCellImageByView:(UIImageView*)imageView
{
	self.lastCellImage = imageView;
	lastImageHeight = imageView.image.size.height;
}

- (void)setLastCellImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.lastCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	lastImageHeight = image.size.height;
}

- (void)setCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.cellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	cellImageHeight = image.size.height;
}

- (void)setSectionImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.sectionImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	sectionImageHeight = image.size.height;
	
}

- (void)setFooterImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.footerImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	footerImageHeight = image.size.height;	
}

- (CGFloat)getRowHeight:(int)row totalRow:(int)totalRow
{
	
	if (row == 0 && totalRow == 1)				// single
		return singleImageHeight - 1;
	else if (row == 0)							// first
		return firstImageHeight - 1;
	else if (row == (totalRow - 1))				// last
		return lastImageHeight;
	else
		return middleImageHeight;				// middle
}

- (void)setCellBackground:(UITableViewCell*)cell row:(int)row count:(int)count
{	
	// set background image
	if (row == 0 && count == 1)
		[cell setBackgroundImageByView:singleCellImage];
	else if (row == 0)
		[cell setBackgroundImageByView:firstCellImage];
	else if (row == (count - 1))
		[cell setBackgroundImageByView:lastCellImage];
	else
		[cell setBackgroundImageByView:middleCellImage];	
}

- (UIView*)getSectionView:(UITableView*)tableView section:(int)section
{
	if (sectionImage == nil)
		return nil;
	
	UILabel* textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, sectionImageHeight)] autorelease];
	textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	textLabel.font = [UIFont boldSystemFontOfSize:14];
	textLabel.textColor = [UIColor whiteColor];
	textLabel.backgroundColor = [UIColor clearColor];
	
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:sectionImage.image] autorelease];
	imageView.frame = CGRectMake(0, 0, sectionImage.image.size.width, sectionImage.image.size.height);
	
	UIView* sectionView = [[[UIView alloc] initWithFrame:imageView.frame] autorelease];
	[sectionView addSubview:imageView];
	[sectionView addSubview:textLabel];	
	
	return sectionView;
}

- (UIView*)getFooterView:(UITableView*)tableView section:(int)section
{
	if (footerImage == nil)
		return nil;
	
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:footerImage.image] autorelease];
	return imageView;
}

#pragma mark ScrollView Callbacks for Pull Refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
    if (supportRefreshHeader)
    {
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (supportRefreshFooter) {
        [refreshFooterView egoRefreshScrollViewDidScroll:scrollView];

    }
    
    return;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if (supportRefreshHeader)
    {
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }

    if (supportRefreshFooter) {
        [refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark refreshHeaderView Methods

#pragma mark - For Subclass to re-write
// When "pull down to refresh" in triggered, this function will be called  
- (void) reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource in subclass");  
}

// After finished loading data source, call this method to hide refresh view.
- (void)dataSourceDidFinishLoadingNewData{
	
    if (supportRefreshHeader)
    {
        _reloading = NO;
        [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.dataTableView]; 
    }
}

#pragma mark - For Subclass to re-write
// When "pull down to refresh" in triggered, this function will be called  
- (void) loadMoreTableViewDataSource
{
    NSLog(@"Please override loadMoreTableViewDataSource in subclass");  
}

// After finished loading data source, call this method to hide refresh view.
- (void)dataSourceDidFinishLoadingMoreData{
    if (supportRefreshFooter) {
//        _loadingMore = NO;
        _reloading = NO;
        [refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.dataTableView]; 
    }
}

#pragma mark Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
	return sectionHeader;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_noMoreData) {
        CGFloat height = MAX(self.dataTableView.contentSize.height, self.dataTableView.frame.size.height);
        self.dataTableView.contentSize = CGSizeMake(self.dataTableView.contentSize.width, height);
        refreshFooterView.frame = CGRectMake(0.0f, self.dataTableView.contentSize.height, self.dataTableView.frame.size.width, 650);
        refreshFooterView.hidden = NO;
    }else {
        refreshFooterView.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
	
	// return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
	
	// return [groupData numberOfRowsInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		else
			cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
	cell.accessoryView = accessoryView;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];

	return cell;
	
}

- (void)didSelectMoreRow
{
    NSLog(@"select more row, default implementation");
}

- (void)showTipsOnTableView:(NSString *)text
{ 
    if (self.tipsLabel == nil) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        self.tipsLabel = label;
        [label release];
        [self.tipsLabel setTextAlignment:UITextAlignmentCenter];
        [self.dataTableView addSubview:self.tipsLabel];
        [self.tipsLabel setBackgroundColor:[UIColor clearColor]];
    }
    [self.tipsLabel setText:text];
    [self.tipsLabel setHidden:NO];
}

- (void)hideTipsOnTableView
{
    [self.tipsLabel setHidden:YES];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
	[self reloadTableViewDataSource];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    _loadingMore = YES;
    _reloading = YES;
	[self loadMoreTableViewDataSource];	
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading;
//	return _loadingMore; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{

	return [NSDate date]; // should return date data source was last changed
}

@end
