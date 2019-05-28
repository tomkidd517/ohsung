﻿$PBExportHeader$pf_u_webbrowser.sru
$PBExportComments$파워프레임용 OLE WebBrowser 컨트롤 입니다.
forward
global type pf_u_webbrowser from olecustomcontrol
end type
end forward

global type pf_u_webbrowser from olecustomcontrol
integer width = 2053
integer height = 1316
boolean border = false
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "pf_u_webbrowser.udo"
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20395836
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( boolean activedocument,  ref boolean cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
event setphishingfilterstatus ( long phishingfilterstatus )
event newprocess ( long lcauseflag,  oleobject pwb2,  ref boolean cancel )
event redirectxdomainblocked ( oleobject pdisp,  any starturl,  any redirecturl,  any frame,  any statuscode )
event type boolean pfe_ispowerframecontrol ( )
event resize pbm_size
event pfe_postopen ( )
end type
global pf_u_webbrowser pf_u_webbrowser

type variables
constant integer OLECMDEXECOPT_DODEFAULT			= 0
constant integer OLECMDEXECOPT_PROMPTUSER			= 1
constant integer OLECMDEXECOPT_DONTPROMPTUSER	= 2
constant integer OLECMDEXECOPT_SHOWHELP			= 3

constant integer OLECMDID_OPEN					= 1
constant integer OLECMDID_NEW						= 2
constant integer OLECMDID_SAVE					= 3
constant integer OLECMDID_SAVEAS					= 4
constant integer OLECMDID_SAVECOPYAS			= 5
constant integer OLECMDID_PRINT					= 6
constant integer OLECMDID_PRINTPREVIEW			= 7
constant integer OLECMDID_PAGESETUP				= 8
constant integer OLECMDID_SPELL					= 9
constant integer OLECMDID_PROPERTIES			= 10
constant integer OLECMDID_CUT						= 11
constant integer OLECMDID_COPY					= 12
constant integer OLECMDID_PASTE					= 13
constant integer OLECMDID_PASTESPECIAL			= 14
constant integer OLECMDID_UNDO					= 15
constant integer OLECMDID_REDO					= 16
constant integer OLECMDID_SELECTALL				= 17
constant integer OLECMDID_CLEARSELECTION		= 18
constant integer OLECMDID_ZOOM					= 19
constant integer OLECMDID_GETZOOMRANGE			= 20
constant integer OLECMDID_UPDATECOMMANDS		= 21
constant integer OLECMDID_REFRESH				= 22
constant integer OLECMDID_STOP					= 23
constant integer OLECMDID_HIDETOOLBARS			= 24
constant integer OLECMDID_SETPROGRESSMAX		= 25
constant integer OLECMDID_SETPROGRESSPOS		= 26
constant integer OLECMDID_SETPROGRESSTEXT		= 27
constant integer OLECMDID_SETTITLE				= 28
constant integer OLECMDID_SETDOWNLOADSTATE	= 29
constant integer OLECMDID_STOPDOWNLOAD			= 30
constant integer OLECMDID_ONTOOLBARACTIVATED	= 31
constant integer OLECMDID_FIND					= 32
constant integer OLECMDID_DELETE					= 33
constant integer OLECMDID_HTTPEQUIV				= 34
constant integer OLECMDID_HTTPEQUIV_DONE		= 35
constant integer OLECMDID_ENABLE_INTERACTION	= 36
constant integer OLECMDID_ONUNLOAD				= 37
constant integer OLECMDID_PROPERTYBAG2			= 38
constant integer OLECMDID_PREREFRESH			= 39
constant integer OLECMDID_SHOWSCRIPTERROR        = 40 
constant integer OLECMDID_SHOWMESSAGE            = 41 
constant integer OLECMDID_SHOWFIND               = 42 
constant integer OLECMDID_SHOWPAGESETUP          = 43 
constant integer OLECMDID_SHOWPRINT              = 44 
constant integer OLECMDID_CLOSE                  = 45 
constant integer OLECMDID_ALLOWUILESSSAVEAS      = 46 
constant integer OLECMDID_DONTDOWNLOADCSS        = 47 
constant integer OLECMDID_UPDATEPAGESTATUS       = 48 
constant integer OLECMDID_PRINT2                 = 49 
constant integer OLECMDID_PRINTPREVIEW2          = 50 
constant integer OLECMDID_SETPRINTTEMPLATE       = 51 
constant integer OLECMDID_GETPRINTTEMPLATE       = 52 
constant integer OLECMDID_PAGEACTIONBLOCKED      = 55
constant integer OLECMDID_PAGEACTIONUIQUERY      = 56
constant integer OLECMDID_FOCUSVIEWCONTROLS      = 57
constant integer OLECMDID_FOCUSVIEWCONTROLSQUERY = 58
constant integer OLECMDID_SHOWPAGEACTIONMENU     = 59
constant integer OLECMDID_ADDTRAVELENTRY         = 60
constant integer OLECMDID_UPDATETRAVELENTRY      = 61
constant integer OLECMDID_UPDATEBACKFORWARDSTATE = 62
constant integer OLECMDID_OPTICAL_ZOOM           = 63
constant integer OLECMDID_OPTICAL_GETZOOMRANGE   = 64
constant integer OLECMDID_WINDOWSTATECHANGED     = 65
constant integer OLECMDID_ACTIVEXINSTALLSCOPE    = 66

private:
	window iw_parent
	
public:
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_getclassname ()
public function string of_execscript (string as_script)
public function long of_navigate (string as_url)
public subroutine of_refresh ()
public subroutine of_resize (integer ai_newwidth, integer ai_newheight)
public subroutine of_execwb (integer command_id, integer execution_option)
public subroutine of_execwb_pagesetup ()
public subroutine of_execwb_print (boolean ab_prompt)
public subroutine of_execwb_printpreview ()
public subroutine of_execwb_save ()
public subroutine of_execwb_saveas ()
public function string of_getdocumenthtml ()
public function string of_geturl ()
public subroutine of_getback ()
public subroutine of_goforward ()
public subroutine of_gohome ()
public subroutine of_gosearch ()
public subroutine of_pastehtml (string as_html)
public subroutine of_setdocumenthtml (string as_html)
public subroutine of_setsilentmode (boolean ab_silent)
public subroutine of_stopnavigate ()
public subroutine of_setdesignmode (boolean ab_switch)
public function string of_getreadystate ()
public subroutine of_documentcommand (string as_command, boolean ab_userinterface, string as_value)
end prototypes

event type boolean pfe_ispowerframecontrol();return true

end event

public function string of_getclassname ();return 'pf_u_webbrowser'

end function

public function string of_execscript (string as_script);//return string(this.object.document.parentwindow.execscript(as_script, "JavaScript"))
return string(this.object.document.parentwindow.eval(as_script))

end function

public function long of_navigate (string as_url);//S_OK = The operation was successful.
//E_INVALIDARG = One or more parameters are invalid.
//E_OUTOFMEMORY = Out of memory.
//E_FAIL = The operation failed.

string ls_oldurl
long ll_rc

setpointer(HourGlass!)
post setpointer(Arrow!)

ls_oldurl = this.of_geturl()
ll_rc = long(this.object.Navigate2(as_url))

// Wait for Document to start loading
do while ls_oldurl = this.of_geturl()
	yield()
loop

// Wait for Document to finish loading
do while this.object.Busy
	yield()
loop

// Wait for Document to get ready
do until this.of_getreadystate() = "complete"
	yield()
loop

this.setfocus()
//gnv_extfunc.sleep(5000)
return ll_rc

end function

public subroutine of_refresh ();// refresh current page
this.object.Refresh()

end subroutine

public subroutine of_resize (integer ai_newwidth, integer ai_newheight);// resize the control
this.Resize(ai_newwidth, ai_newheight)

// adjust object size to match control size
this.SetRedraw(False)
this.Object.Width = UnitsToPixels(ai_newwidth, XUnitsToPixels!)
this.Object.Height = UnitsToPixels(ai_newheight, YUnitsToPixels!)
this.SetRedraw(True)

end subroutine

public subroutine of_execwb (integer command_id, integer execution_option);// execute web browser command
this.object.ExecWB(command_id, execution_option, AsStatement!)

end subroutine

public subroutine of_execwb_pagesetup ();// Open Page Setup window
this.of_execwb(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public subroutine of_execwb_print (boolean ab_prompt);// open print dialog
If ab_prompt Then
	this.of_execwb(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER)
Else
	this.of_execwb(OLECMDID_PRINT, OLECMDEXECOPT_DODEFAULT)
End If

end subroutine

public subroutine of_execwb_printpreview ();// Open Print Preview window
this.of_execwb(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public subroutine of_execwb_save ();// save the current document
this.of_execwb(OLECMDID_SAVE, OLECMDEXECOPT_DODEFAULT)

end subroutine

public subroutine of_execwb_saveas ();// open saveas dialog
//this.of_execwb(OLECMDID_SAVEAS, OLECMDEXECOPT_DODEFAULT)
this.of_execwb(OLECMDID_SAVEAS, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public function string of_getdocumenthtml ();// return the webpage HTML source
return string(this.Object.Document.documentElement.InnerHTML)

end function

public function string of_geturl ();// return the current URL

if not isnull(this.Object.LocationURL) then
	return string(this.Object.LocationURL)
else
	return ''
end if

end function

public subroutine of_getback ();// go back one page
this.object.goBack()

end subroutine

public subroutine of_goforward ();// go forward one page
this.object.goForward()

end subroutine

public subroutine of_gohome ();// go to home page
this.object.goHome()

end subroutine

public subroutine of_gosearch ();// go to search page
this.object.goSearch()

end subroutine

public subroutine of_pastehtml (string as_html);// insert passed HTML into the selected range

OleObject range

range = this.Object.Document.selection.createRange()
range.pasteHTML(as_Html)
range.collapse(false)
range.select()

end subroutine

public subroutine of_setdocumenthtml (string as_html);// set the webpage HTML source

this.Object.Document.Open()
this.Object.Document.Write(as_html)
this.Object.Document.Close()

end subroutine

public subroutine of_setsilentmode (boolean ab_silent);// This function toggles the Silent property which represents the
// property ScriptErrorsSuppressed of the underlying IE browser.

If ab_silent Then
	this.Object.Silent = True
Else
	this.Object.Silent = False
End If

end subroutine

public subroutine of_stopnavigate ();// stop current navigate
this.object.Stop()

end subroutine

public subroutine of_setdesignmode (boolean ab_switch);// set design mode

choose case ab_switch
	case true
		this.Object.Document.designMode = "on"
	case false
		this.Object.Document.designMode = "off"
end choose

end subroutine

public function string of_getreadystate ();// "loading", "interactive", "complete"
if isnull(this.object.document) then
	return 'loading'
else
	return string(this.object.document.readyState)
end if

end function

public subroutine of_documentcommand (string as_command, boolean ab_userinterface, string as_value);// Execute document command
// as_command: document command
// as_userinterface: with choice of popup/nopopup
// as_value: parameter value

this.Object.Document.ExecCommand(as_Command, ab_UserInterface, as_value)

end subroutine

on pf_u_webbrowser.create
end on

on pf_u_webbrowser.destroy
end on

event constructor;// get parent object
iw_parent = pf_f_getparentwindow(this)

// initial resizing
this.event resize(0, this.width, this.height)

// call postopen event
this.post event pfe_postopen()

end event

event error;action = ExceptionIgnore!

end event

event externalexception;action = ExceptionIgnore!

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
02pf_u_webbrowser.bin 
2900000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000037f35ab001d1f2db00000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f0000000037f35ab001d1f2db37f35ab001d1f2db000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Affffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c00002e68000022010000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c00002e68000022010000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12pf_u_webbrowser.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
