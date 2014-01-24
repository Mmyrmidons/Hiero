//
//  RockyKeyboardViewController.m
//  Hiero
//
//  Created by Dunc on 1/11/14.
//  Copyright (c) 2014 Mmyrmidons. All rights reserved.
//

#import "KeyboardViewController.h"
#import "HieroViewController.h"
#import "GlyphButton.h"
#import "UIStoryboard+ViewControllerById.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController

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

	__block int r = 0;
    __block int z = 0;
	__block int glyphTally = 6;
	
    [[GlyphHelper glyphs] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		GlyphButton *rockyGlyphButton = [[GlyphButton alloc] initWithFrame:CGRectMake(r * 95, (z % 2) * 95, 95, 95)
																			  andKey:key
																		   withColor:[GlyphColor iceColor]];
		
		[self.view addSubview:rockyGlyphButton];
		
        if (++z == glyphTally)
			*stop = YES;
		else {
			NSArray *modArgs = [NSArray arrayWithObjects: [NSExpression expressionForConstantValue:[NSNumber numberWithInteger:z]], [NSExpression expressionForConstantValue:[NSNumber numberWithInteger:2]], nil];
			NSExpression *modExpression =[NSExpression expressionForFunction:@"modulus:by:" arguments:modArgs];

			if (![[modExpression expressionValueWithObject:nil context: nil] boolValue])
				r++;
		}
		
//		if (++z == glyphTally)
//			*stop = YES;
//        else if (!(z % 2))
//            r++;

		[rockyGlyphButton addTarget:self action:@selector(handleGlyphTouch:) forControlEvents:UIControlEventTouchUpInside];
    }];
	
//	[self becomeFirstResponder];
}

- (void)handleGlyphTouch:(id)sender {
	GlyphButton *glyphButton = (GlyphButton *) sender;
	HieroViewController *hieroViewController = (HieroViewController *) self.parentViewController;

	[hieroViewController cloneGlyphButton:glyphButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
	if ([keyPath isEqualToString:@"droppedGlyphs"]) {
		HieroViewController *hieroViewController = (HieroViewController *) object;
		
		NSLog(@"Hi Manny, report dropped glyph count please. Manny says %@. %@ %@", hieroViewController.droppedGlyphs, NSStringFromSelector(_cmd), NSStringFromCGRect(self.view.frame));
	}
}

- (void)copy:(id)sender {
	NSLog(@"Copy Miss Tikky from KeyboardViewController: %@", sender);
}

- (void)hiManny:(id)sender {
	NSLog(@"Hi Manny: %@", sender);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end