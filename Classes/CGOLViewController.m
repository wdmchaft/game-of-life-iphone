//
//  CGOLViewController.m
//  CGOL
//
//  Created by Vince Martínez on 26/12/2010.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "CGOLViewController.h"

@implementation CGOLViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    grid = [[GameOfLife alloc] initWithRows:20 andColumns:20];
    gridView.backgroundColor = [UIColor blackColor];
    [self initializeCellGrid];
    [self populateGridView];
    [super viewDidLoad];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Interface – User Input

- (IBAction)tickPressed:(UIButton *)sender{
    int height = gridView.bounds.size.height;
    int width = gridView.bounds.size.width;
    float columns = width / 20;
    NSString * str = [[NSString alloc] initWithFormat:@"width: %d, height: %d, columns: %.f", width, height, columns];
    [textView setText:str];
    [self tick];
    
}

- (IBAction)clearPressed:(UIButton *)sender{
    [textView setText:@""];
}

- (IBAction)startPressed:(UIButton *)sender{
    if(!grid){
        [self loadGame];
    }
}

#pragma mark Private methods

- (void) loadGame{
    NSLog(@"Loading game:");
}

- (void) tick{
    [grid tick];
    [self drawGrid];
}
- (void)drawGrid{
    int _row = 0;
    int _column = 0;
    for(NSArray * row in cellGrid){
        _column = 0;
        for( UIView *item in row){

            [self updateBlockAtRow:_row andColumn:_column];
            _column++;
        }
        _row++;
    }
}

- (void)createGrid{
    if(!cellGrid){
        [self initializeCellGrid];
    }
    for(int _row = 0; _row <= [grid rows]; _row++){
        NSMutableArray *gridRow = [[NSMutableArray alloc] init];
        for(int _column = 0; _column <= [grid columns]; _column++){
            CGRect _block = CGRectMake((_column*15)+1, (_row*15)+1, 14, 14);
            UIView *view = [[UIView alloc] initWithFrame:_block];
            
            // Add tap gesture to toggle alive / dead
            [view addGestureRecognizer: [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(toggleViewState:)]];
            
            if([grid isAliveAtRow:_row andColumn:_column]){
                [self makeBlockAlive:view];
            }
            else{
                [self makeBlockDead:view];
            }
            [gridRow addObject:view];
        }
        
        [cellGrid addObject:gridRow];
        
    }
}

- (void)initializeCellGrid{
    [cellGrid release];
    cellGrid = [[NSMutableArray alloc] init];
    [self createGrid];
}

- (void)populateGridView{
    if ([[gridView subviews] count] > 0 ){
        NSLog(@"Subviews exist: %d", [[gridView subviews]count]);
    }
    for (int y = 0; y < [grid rows]; y++) {
		for (int x = 0; x < [grid columns]; x++) {
			[gridView addSubview:[self cellViewAtRow:y andColumn:x]];
        }
	}
}

- (UIView *) cellViewAtRow:(int)r andColumn:(int)c{
    return [[cellGrid objectAtIndex:r] objectAtIndex:c];
}

- (void) updateBlockAtRow:(int)r andColumn:(int)c{
    UIView * block = [[cellGrid objectAtIndex:r] objectAtIndex:c];
    if(!block) return;
    
    if([grid isAliveAtRow:r andColumn:c]){
        [self makeBlockAlive: block];
    }
    else {
        [self makeBlockDead:block];
    }

}

- (int) getCellRow:(UIView *)cell{
    double row = round(cell.frame.origin.y/15);
	return row;
}
- (int) getCellColumn:(UIView *)cell{
    double column = round(cell.frame.origin.x/15);
    return column;
}



- (void) makeBlockAlive:(UIView *)view{
    view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
}
- (void) makeBlockDead:(UIView *)view{
    view.backgroundColor = [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1];
}

- (void) createLifeInRow:(int)r andColumn:(int)c{
    [grid createLifeAtRow:r andColumn:c];
}
- (void) killLifeInRow:(int)r andColumn:(int)c{
    
}

- (void) toggleViewState:(UITapGestureRecognizer *)tapGesture{
    /*
     * Toggle this value in the grid and repaint it. 
     */
    UIView *view = tapGesture.view;
    int row = [self getCellRow:view];
    int column = [self getCellColumn:view];
    [grid toggleAtRow:row andColumn:column];
    [self updateBlockAtRow:row andColumn:column];
}
@end
