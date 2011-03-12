/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      MainWindowController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       MainWindowController
 * @abstract    ...
 */
@interface MainWindowController: NSWindowController
{
@protected
    
    NSView               * checkView;
    NSView               * downloadView;
    NSView               * installView;
    NLUISegmentedTabView * tabView;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NSView               * checkView;
@property( nonatomic, retain ) IBOutlet NSView               * downloadView;
@property( nonatomic, retain ) IBOutlet NSView               * installView;
@property( nonatomic, retain ) IBOutlet NLUISegmentedTabView * tabView;

@end
