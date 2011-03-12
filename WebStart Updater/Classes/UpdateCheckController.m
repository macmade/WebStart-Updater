/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        UpdateCheckController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "UpdateCheckController.h"
#import "DownloadController.h"
#import "InstallController.h"
#import "ApplicationDelegate.h"

typedef struct
{
    NSUInteger major;
    NSUInteger minor;
    NSUInteger bugfix;
    NSUInteger revision;
}
SWVersion;

@interface UpdateCheckController( Private )

- ( void )getVersions;
- ( void )checkVersions;
- ( NSComparisonResult )compareVersion: ( NSString * ) v1 withVersion: ( NSString * )v2;
- ( void )getVersion: ( SWVersion * )version FromString: ( NSString * )versionString;

@end

@implementation UpdateCheckController( Private )

- ( void )getVersions
{
    NSURLRequest    * request;
    NSURLConnection * connection;
    
    request    = [ NSURLRequest requestWithURL: [ NSURL URLWithString: @"http://www.eosgarden.com/downloads/updates/webstart-104/Versions.plist" ] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 60 ];
    connection = [ [ NSURLConnection alloc ] initWithRequest: request delegate: self ];
}

- ( void )getVersion: ( SWVersion * )version FromString: ( NSString * )versionString
{
    NSString * rev;
    NSRange    range;
    
    version->major    = 0;
    version->minor    = 0;
    version->bugfix   = 0;
    version->revision = 0;
    
    range = [ versionString rangeOfString: @"+r" ];
    
    if( range.location != NSNotFound )
    {
        rev               = [ versionString substringFromIndex: range.location + 2 ];
        versionString     = [ versionString substringToIndex: range.location ];
        version->revision = ( NSUInteger )[ rev integerValue ];
    }
    
    range = [ versionString rangeOfString: @"." ];
    
    if( range.location == NSNotFound )
    {
        version->major = ( NSUInteger )[ versionString integerValue ];
    }
    else
    {
        version->major = ( NSUInteger )[ [ versionString substringToIndex: range.location ] integerValue ];
        versionString  = [ versionString substringFromIndex: range.location + 1 ];
        
        range = [ versionString rangeOfString: @"." ];
        
        if( range.location == NSNotFound )
        {
            version->minor = ( NSUInteger )[ versionString integerValue ];
        }
        else
        {
            version->minor  = ( NSUInteger )[ versionString integerValue ];
            version->bugfix = ( NSUInteger )[ [ versionString substringFromIndex: range.location + 1 ] integerValue ];
        }
    }
}

- ( NSComparisonResult )compareVersion: ( NSString * ) v1 withVersion: ( NSString * )v2
{
    SWVersion version1;
    SWVersion version2;
    
    [ self getVersion: &version1 FromString: v1 ];
    [ self getVersion: &version2 FromString: v2 ];
    
    if( version1.major > version2.major )
    {
        return NSOrderedAscending;
    }
    else if( version1.major < version2.major )
    {
        return NSOrderedDescending;
    }
    
    if( version1.minor > version2.minor )
    {
        return NSOrderedAscending;
    }
    else if( version1.minor < version2.minor )
    {
        return NSOrderedDescending;
    }
    
    if( version1.bugfix > version2.bugfix )
    {
        return NSOrderedAscending;
    }
    else if( version1.bugfix < version2.bugfix )
    {
        return NSOrderedDescending;
    }
    
    if( version1.revision > version2.revision )
    {
        return NSOrderedAscending;
    }
    else if( version1.revision < version2.revision )
    {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- ( void )checkVersions
{
    NSAlert        * alert;
    NSString       * soft;
    NSString       * version;
    NSString       * newVersion;
    NSURL          * packageUrl;
    BOOL             update;
    
    update = NO;
    
    for( soft in newVersions )
    {
        version = [ versions objectForKey: soft ];
        
        if( version == nil )
        {
            newVersion = [ newVersions objectForKey: soft ];
            update     = YES;
            packageUrl = [ NSURL URLWithString: [ NSString stringWithFormat: @"http://www.eosgarden.com/downloads/updates/webstart-104/%@-%@.pkg", soft, newVersion ] ];
            
            [ packages addObject: packageUrl ];
        }
        else
        {
            newVersion = [ newVersions objectForKey: soft ];
            
            if( newVersions != nil && [ self compareVersion: version withVersion: newVersion ] ==  NSOrderedDescending )
            {
                update     = YES;
                packageUrl = [ NSURL URLWithString: [ NSString stringWithFormat: @"http://www.eosgarden.com/downloads/updates/webstart-104/%@-%@.pkg", soft, newVersion ] ];
                
                [ packages addObject: packageUrl ];
            }
        }
    }
    
    alert = [ [ NSAlert alloc ] init ];
        
    NSBeep();
    
    if( update == YES )
    {
        [ tableView reloadData ];
        
        [ NSApp beginSheet:     updatePanel
                modalForWindow: mainWindow
                modalDelegate:  self
                didEndSelector: @selector( sheetDidEnd: returnCode: contextInfo: )
                contextInfo:    nil
        ];
    }
    else
    {
        [ NSApp beginSheet:     noUpdatePanel
                modalForWindow: mainWindow
                modalDelegate:  self
                didEndSelector: @selector( sheetDidEnd: returnCode: contextInfo: )
                contextInfo:    nil
        ];
    }
}

@end

@implementation UpdateCheckController

@synthesize tabView;
@synthesize progressBar;
@synthesize downloadController;
@synthesize installController;
@synthesize noUpdatePanel;
@synthesize updatePanel;
@synthesize mainWindow;
@synthesize tableView;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        [ [ NSUserDefaults standardUserDefaults ] registerDefaults: [ NSDictionary dictionaryWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"Versions" ofType: @"plist" ] ] ];
        
        data      = [ [ NSMutableData dataWithCapacity: 4096 ] retain ];
        versions  = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"versions" ] retain ];
        packages  = [ [ NSMutableArray arrayWithCapacity: 50 ] retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ versions           release ];
    [ newVersions        release ];
    [ data               release ];
    [ tabView            release ];
    [ progressBar        release ];
    [ downloadController release ];
    [ installController  release ];
    [ packages           release ];
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ self getVersions ];
    [ progressBar startAnimation: nil ];
    [ tableView setDataSource: self ];
}

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )aTableView
{
    ( void )aTableView;
    
    return [ packages count ];
}

- ( id )tableView: ( NSTableView * )aTableView objectValueForTableColumn: ( NSTableColumn * )column row:( NSInteger )rowIndex
{
    NSRange    range;
    NSString * package;
    NSString * soft;
    NSString * version;
    
    ( void )aTableView;
    
    package = [ [ ( NSURL * )[ packages objectAtIndex: rowIndex ] lastPathComponent ] stringByDeletingPathExtension ];
    range   = [ package rangeOfString: @"-" options: NSBackwardsSearch ];
    soft    = [ package substringToIndex: range.location ];
    version = [ package substringFromIndex: range.location + 1 ];
    
    if( [ [ column identifier ] isEqualToString: @"soft" ] )
    {
        return soft;
    }
    else if( [ [ column identifier ] isEqualToString: @"version" ] )
    {
    
        return version;
    }
    
    return nil;
}

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo
{
    ( void )sheet;
    ( void )contextInfo;
    
    if( returnCode == 2 )
    {
        [ tabView selectView: 1 ];
        [ tabView.control setEnabled: NO  forSegment: 0 ];
        [ tabView.control setEnabled: YES forSegment: 1 ];
        [ tabView.control setEnabled: NO  forSegment: 2 ];
        [ downloadController setPackages: packages ];
        [ downloadController download ];
        [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setUpdating: YES ];
        [ ( ApplicationDelegate * )( [ ( NSApplication * )NSApp delegate ] ) setPackages: packages ];
        [ installController setVersions: newVersions ];
    }
}

- ( void )connection: ( NSURLConnection * )connection didReceiveResponse: ( NSURLResponse * )response
{
    ( void )connection;
    ( void )response;
}

- ( void )connection: ( NSURLConnection * )connection didReceiveData: ( NSData * )webData
{
    ( void )connection;
    
    [ data appendData: webData ];
}

- ( void )connectionDidFinishLoading: ( NSURLConnection * )connection
{
    NSAlert            * alert;
    NSPropertyListFormat format;
   
    ( void )connection;
    
    [ progressBar stopAnimation: nil ];
    
    newVersions = [ NSPropertyListSerialization propertyListFromData: data mutabilityOption: NSPropertyListImmutable format: &format errorDescription: nil ];
    
    if( newVersions == nil )
    {
        alert = [ [ NSAlert alloc ] init ];
            
        [ alert addButtonWithTitle:  NSLocalizedString( @"Quit", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"Error", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"PlistError", nil ) ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSWarningAlertStyle ];
        [ alert runModal ];
        
        [ alert release ];
        [ NSApp terminate: nil ];
        }
        
        [ newVersions retain ];
        [ self checkVersions ];
}

- ( void )connection: ( NSURLConnection * )connection didFailWithError: ( NSError * )error
{
    NSAlert * alert;
    
    ( void )connection;
    ( void )error;
    
    alert = [ [ NSAlert alloc ] init ];
        
    [ alert addButtonWithTitle:  NSLocalizedString( @"Quit", nil ) ];
    [ alert setMessageText:      NSLocalizedString( @"Error", nil ) ];
    [ alert setInformativeText:  [ error localizedDescription ] ];
    
    NSBeep();
    
    [ alert setAlertStyle: NSWarningAlertStyle ];
    [ alert runModal ];
    
    [ alert release ];
    [ NSApp terminate: nil ];
}

- ( NSCachedURLResponse * )connection: ( NSURLConnection * )connection willCacheResponse: ( NSCachedURLResponse * )cachedResponse
{
    ( void )connection;
    ( void )cachedResponse;
    
    return nil;
}

- ( IBAction )cancelUpdate: ( id )sender
{
    [ updatePanel orderOut: sender ];
    [ NSApp endSheet: updatePanel returnCode: 1 ];
    [ NSApp terminate: sender ];
}

- ( IBAction )quitUpdater: ( id )sender
{
    [ noUpdatePanel orderOut: sender ];
    [ NSApp endSheet: noUpdatePanel returnCode: 0 ];
    [ NSApp terminate: sender ];
}

- ( IBAction )performUpdate: ( id )sender
{
    [ updatePanel orderOut: sender ];
    [ NSApp endSheet: updatePanel returnCode: 2 ];
}

@end
