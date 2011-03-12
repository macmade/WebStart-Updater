/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ApplicationDelegate.h"
#import "MainWindowController.h"

@implementation ApplicationDelegate

@synthesize updating;
@synthesize packages;

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    ( void )notification;
    
    mainWindowController = [ MainWindowController new ];
    
    [ mainWindowController.window center ];
    [ mainWindowController showWindow: nil ];
    [ NSApp activateIgnoringOtherApps: YES ];
}

- ( void )dealloc
{
    [ mainWindowController release ];
    
    [ super dealloc ];
}

- ( NSApplicationTerminateReply )applicationShouldTerminate: ( NSApplication * )sender
{
    NSAlert  * alert;
    NSURL    * url;
    NSString * path;
    
    ( void )sender;
    
    if( updating == YES )
    {
        alert = [ [ NSAlert alloc ] init ];
        
        [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setUpdating: NO ];
            
        [ alert addButtonWithTitle:  NSLocalizedString( @"OK", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"UpdateProgress", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"UpdateProgressText", nil ) ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSInformationalAlertStyle ];
        [ alert runModal ];
        
        [ alert release ];
        
        return NSTerminateCancel;
    }
    
    if( [ packages count ] > 0 )
    {
        for( url in packages )
        {
            path = [ NSString stringWithFormat: @"%@/Downloads/%@", NSHomeDirectory(), [ url lastPathComponent ] ];
            
            if( [ [ NSFileManager defaultManager ] fileExistsAtPath: path ] )
            {
                [ [ NSFileManager defaultManager ] removeItemAtPath: path error: NULL ];
            }
        }
    }
    
    
    return NSTerminateNow;
}

@end
