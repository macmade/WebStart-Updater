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

#import "InstallController.h"
#import "ApplicationDelegate.h"

@interface InstallController( Private )

- ( void )nextInstall: ( NLEvent * )event;
- ( void )installPackage: ( NSUInteger )index;

@end

@implementation InstallController( Private )

- ( void )installStart: ( NLEvent * )event
{
    ( void )event;
    
    [ installButton setEnabled: NO ];
}

- ( void )nextInstall: ( NLEvent * )event
{
    NSAlert  * alert;
    
    ( void )event;
    
    [ installer release ];
    
    currentPackage++;
    
    if( [ packages count ] > currentPackage )
    {
        [ self installPackage: currentPackage ];
    }
    else
    {
        [ [ NSUserDefaults standardUserDefaults ] setObject: versions forKey: @"versions" ];
        [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
        alert = [ [ NSAlert alloc ] init ];
        
        [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setUpdating: NO ];
            
        [ alert addButtonWithTitle:  NSLocalizedString( @"Quit", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"Done", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"InstallDone", nil ) ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSInformationalAlertStyle ];
        [ alert runModal ];
        
        [ alert release ];
        [ installer release ];
        [ NSApp terminate: nil ];
    }
}

- ( void )installPackage: ( NSUInteger )index
{
    NSAlert  * alert;
    NSURL    * url;
    NSString * path;
    
    [ title setStringValue: [ NSString stringWithFormat: NSLocalizedString( @"UpdateInstallTitle", nil ), index + 1, [ packages count ] ] ];
    
    url  = [ packages objectAtIndex: index ];
    path = [ NSString stringWithFormat: @"%@/Downloads/%@", NSHomeDirectory(), [ url lastPathComponent ] ];
    
    if( [ [ NSFileManager defaultManager ] fileExistsAtPath: path ] == YES )
    {
        installer = [ [ NLUIInstaller alloc ] initWithPackage: path ];
        
        [ installer addEventListener: @"InstallerComplete" target: self selector: @selector( nextInstall: ) ];
        [ installer addEventListener: @"InstallerStart"    target: self selector: @selector( installStart: ) ];
        
        installer.phaseText   = installPhase;
        installer.statusText  = installStatus;
        installer.progressBar = progressBar;
        
        [ installer install ];
    }
    else
    {
        alert = [ [ NSAlert alloc ] init ];
        
        [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setUpdating: NO ];
            
        [ alert addButtonWithTitle:  NSLocalizedString( @"Quit", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"Error", nil ) ];
        [ alert setInformativeText:  [ NSString stringWithFormat: NSLocalizedString( @"InstallError", nil ), [ url lastPathComponent ] ] ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSWarningAlertStyle ];
        [ alert runModal ];
        
        [ alert release ];
        [ installer release ];
        [ NSApp terminate: nil ];
    }
}

@end

@implementation InstallController

@synthesize tabView;
@synthesize progressBar;
@synthesize title;
@synthesize installPhase;
@synthesize installStatus;
@synthesize packages;
@synthesize versions;
@synthesize installButton;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ installer     release ];
    [ tabView       release ];
    [ progressBar   release ];
    [ title         release ];
    [ installStatus release ];
    [ installPhase  release ];
    [ packages      release ];
    [ versions      release ];
    [ installButton release ];
    
    [ super dealloc ];
}

- ( void )install
{
    if( [ packages count ] == 0 )
    {
        [ NSApp terminate: nil ];
    }
    
    currentPackage = 0;
    
    [ self installPackage: currentPackage ];
}

- ( IBAction )install: ( id )sender
{
    ( void )sender;
    
    [ self install ];
}

@end
