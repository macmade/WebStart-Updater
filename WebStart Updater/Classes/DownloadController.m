/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        DownloadController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "DownloadController.h"
#import "ApplicationDelegate.h"

@interface DownloadController( Private )

- ( void )nextDownload: ( NLEvent * )event;
- ( void )downloadError: ( NLEvent * )event;
- ( void )downloadURL: ( NSUInteger )index;

@end

@implementation DownloadController( Private )

- ( void )downloadError: ( NLEvent * )event
{
    NSAlert * alert;
    NSURL   * url;
    
    ( void )event;
    
    alert = [ [ NSAlert alloc ] init ];
    url   = [ packages objectAtIndex: currentURL ];
    
    [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setUpdating: NO ];
            
    [ alert addButtonWithTitle:  NSLocalizedString( @"Quit", nil ) ];
    [ alert setMessageText:      NSLocalizedString( @"Error", nil ) ];
    [ alert setInformativeText:  [ NSString stringWithFormat: NSLocalizedString( @"DownloadError", nil ), [ url lastPathComponent ] ] ];
    
    NSBeep();
    
    [ alert setAlertStyle: NSWarningAlertStyle ];
    [ alert runModal ];
    
    [ alert release ];
    [ downloader release ];
    [ NSApp terminate: nil ];
}

- ( void )nextDownload: ( NLEvent * )event
{
    ( void )event;
    
    [ downloader release ];
    
    currentURL++;
    
    if( [ packages count ] > currentURL )
    {
        [ self downloadURL: currentURL ];
    }
    else
    {
        [ installController setPackages: packages ];
        [ tabView selectView: 2 ];
        [ tabView.control setEnabled: NO  forSegment: 0 ];
        [ tabView.control setEnabled: NO  forSegment: 1 ];
        [ tabView.control setEnabled: YES forSegment: 2 ];
        [ installController install ];
    }
}

- ( void )downloadURL: ( NSUInteger )index
{
    [ title setStringValue: [ NSString stringWithFormat: NSLocalizedString( @"UpdateDownloadTitle", nil ), index + 1, [ packages count ] ] ];
    
    downloader = [ [ NLUIURLDownloader alloc ] initWithURL: [ packages objectAtIndex: index ] ];
    
    [ downloader addEventListener: @"DownloadComplete" target: self selector: @selector( nextDownload: ) ];
    [ downloader addEventListener: @"DownloadError"    target: self selector: @selector( downloadError: ) ];
    
    downloader.displayErrors     = NO;
    downloader.progressBar       = progressBar;
    downloader.statusText        = statusText;
    downloader.speedText         = speedText;
    downloader.timeRemainingText = timeRemainingText;
    
    [ downloader start ];
}

@end

@implementation DownloadController

@synthesize tabView;
@synthesize progressBar;
@synthesize title;
@synthesize statusText;
@synthesize speedText;
@synthesize timeRemainingText;
@synthesize installController;
@synthesize packages;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ downloader        release ];
    [ tabView           release ];
    [ progressBar       release ];
    [ title             release ];
    [ statusText        release ];
    [ speedText         release ];
    [ timeRemainingText release ];
    [ installController release ];
    [ packages          release ];
    
    [ super dealloc ];
}

- ( void )download
{
    if( [ packages count ] == 0 )
    {
        [ NSApp terminate: nil ];
    }
    
    currentURL = 0;
    
    [ self downloadURL: currentURL ];
}

@end
