/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        MainWindowController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "MainWindowController.h"

@implementation MainWindowController

@synthesize checkView;
@synthesize downloadView;
@synthesize installView;
@synthesize tabView;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"MainWindow" ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ checkView    release ];
    [ downloadView release ];
    [ installView  release ];
    [ tabView      release ];
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ tabView addView: checkView    title: NSLocalizedString( @"TabCheck", nil ) ];
    [ tabView addView: downloadView title: NSLocalizedString( @"TabDownload", nil ) ];
    [ tabView addView: installView  title: NSLocalizedString( @"TabInstall", nil ) ];
    [ tabView.control setEnabled: YES forSegment: 0 ];
    [ tabView.control setEnabled: NO  forSegment: 1 ];
    [ tabView.control setEnabled: NO  forSegment: 2 ];
}

@end
