/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class MainWindowController;

@interface ApplicationDelegate: NSObject < NSApplicationDelegate >
{
@protected
    
    BOOL                   updating;
    MainWindowController * mainWindowController;
    NSArray              * packages;

@private
    
    id r1;
    id r2;
}

@property( assign, readwrite ) BOOL      updating;
@property( retain, readwrite ) NSArray * packages;

@end
