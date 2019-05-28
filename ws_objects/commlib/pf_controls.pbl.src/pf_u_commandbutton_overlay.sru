$PBExportHeader$pf_u_commandbutton_overlay.sru
$PBExportComments$내부사용 용도입니다. 사용하지 마십시오.
forward
global type pf_u_commandbutton_overlay from picture
end type
end forward

global type pf_u_commandbutton_overlay from picture
integer width = 206
integer height = 88
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "..\img\controls\u_commandbutton\webst_btn.gif"
boolean focusrectangle = false
event mousemove pbm_mousemove
event pfe_mouseleave ( )
event pfe_mouseover ( )
event pfe_lbuttonup pbm_lbuttonup
event pfe_lbuttondown pbm_lbuttondown
event timer pbm_timer
end type
global pf_u_commandbutton_overlay pf_u_commandbutton_overlay

type prototypes
function boolean ReleaseCapture() library "user32.dll"
function long SetCapture(long hWnd) library "user32.dll"

Function Boolean TrackMouseEvent(Ref pf_s_TRACKMOUSEEVENT lpTrackMouseEvent) Library 'user32.dll' alias for "TrackMouseEvent;Ansi" 
Function Long GetLastError() Library 'Kernel32.dll' 

end prototypes

type variables
Constant string MOUSEOVER_SURFIX = "_hover"
Constant string CLICKED_SURFIX =  "_clicked"
Constant string DISABLED_SURFIX = "_disabled"

private:
	window iw_parent
	commandbutton icb_parent
	pf_n_timing inv_timer
	pf_s_point istr_point

	string is_picturename
	string is_normal_img
	string is_mouseover_img
	string is_clicked_img
	string is_disabled_img
	boolean ib_mouseover
	boolean ib_OnceOpened = false

end variables

forward prototypes
public function integer of_setpicturename (string as_picturename)
public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath)
public function string of_getclassname ()
public subroutine of_setenabled (boolean ab_enabled)
public subroutine of_setvisible (boolean ab_visible)
public subroutine of_settext (string as_text)
end prototypes

event mousemove;if ib_mouseover = false then
	ib_mouseover = true
	this.event pfe_mouseover()
	inv_timer.of_start()
end if

end event

event pfe_mouseleave();if isnull(this.picturename) or this.picturename = '' then return

if icb_parent.enabled = true then
	this.picturename = is_normal_img
end if

end event

event pfe_mouseover();if isnull(this.picturename) or this.picturename = '' then return

if icb_parent.enabled = true then
	this.picturename = is_mouseover_img
end if

end event

event pfe_lbuttonup;if isnull(this.picturename) or this.picturename = '' then return

// 로직에서 Disable 처리된 버튼 확인로직 추가
if icb_parent.enabled = true then
	if ib_mouseover = true then
		this.picturename = is_mouseover_img
	end if
end if

end event

event pfe_lbuttondown;if isnull(this.picturename) or this.picturename = '' then return

if icb_parent.enabled = true then
	this.picturename = is_clicked_img
end if

end event

event timer;if gnv_extfunc.GetCursorPos(istr_point) then
	if gnv_extfunc.ScreenToClient(handle(this), istr_point) then
		if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(this.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(this.height, yunitstopixels!) then
		else
			ib_mouseover = false
			inv_timer.stop()
			this.post event pfe_mouseleave()
		end if
	end if
end if

end event

public function integer of_setpicturename (string as_picturename);long ll_lastpos
string ls_picture_dir, ls_picture_name, ls_picture_ext

if isnull(as_picturename) or as_picturename = '' then
	is_picturename = ''
	is_normal_img = ''
	is_mouseover_img = ''
	is_clicked_img = ''
	is_disabled_img = ''
	this.picturename = ''
	return 0
end if

//if is_picturename = as_picturename then return 0
is_normal_img = pf_f_getimagepathappeon(as_picturename)

ll_lastpos = lastpos(is_normal_img, "\")
if ll_lastpos > 0 then
	ls_picture_dir = left(is_normal_img, ll_lastpos)
	ls_picture_name = mid(is_normal_img, ll_lastpos + 1)
else
	ls_picture_dir = ""
	ls_picture_name = is_normal_img
end if

ll_lastpos = lastpos(ls_picture_name, ".")
if ll_lastpos > 0 then
	ls_picture_ext = mid(ls_picture_name, ll_lastpos)
	ls_picture_name = left(ls_picture_name, ll_lastpos - 1)
else
	ls_picture_ext = ""
end if

// 일반 이미지
this.of_checkandcreateimage('normal', is_normal_img)

// 마우스 오버 이미지
is_mouseover_img = ls_picture_dir + ls_picture_name + MOUSEOVER_SURFIX + ls_picture_ext
this.of_checkandcreateimage('mouseover', is_mouseover_img)

// 클릭된 이미지
is_clicked_img = ls_picture_dir + ls_picture_name + CLICKED_SURFIX + ls_picture_ext
this.of_checkandcreateimage('clicked', is_clicked_img)

// 비활성된 이미지
is_disabled_img = ls_picture_dir + ls_picture_name + DISABLED_SURFIX + ls_picture_ext
this.of_checkandcreateimage('disabled', is_disabled_img)

is_picturename = as_picturename
if icb_parent.enabled = true then
	this.picturename = ''
	this.picturename = is_normal_img
else
	this.enabled = false
	this.picturename = is_disabled_img
end if

return 1

end function

public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath);// 기 생성된 버튼 이미지가 있으면 바로 사용
string ls_ctrlname, ls_text, ls_facename, ls_imagepath, ls_btntext
long ll_find, ll_new, ll_width, ll_height, ll_textsize

ls_ctrlname = iw_parent.classname() + '.' + icb_parent.classname() + '.' + as_imagetype
ls_btntext = icb_parent.text
ls_btntext = pf_f_replaceall(ls_btntext, '~t', '')
ls_btntext = pf_f_replaceall(ls_btntext, '~r~n', '')

ll_find = gnv_session.ids_btnrepo.find("ctrlname='" + ls_ctrlname + "'", 1, gnv_session.ids_btnrepo.rowcount())
if ll_find > 0 then
	ls_text = gnv_session.ids_btnrepo.getitemstring(ll_find, 'text')
	ll_width = gnv_session.ids_btnrepo.getitemnumber(ll_find, 'width')
	ll_height = gnv_session.ids_btnrepo.getitemnumber(ll_find, 'height')
	ls_facename = gnv_session.ids_btnrepo.getitemstring(ll_find, 'facename')
	ll_textsize = gnv_session.ids_btnrepo.getitemnumber(ll_find, 'textsize')
	ls_imagepath = gnv_session.ids_btnrepo.getitemstring(ll_find, 'imagepath')
	
	if ls_text = ls_btntext and ll_width = icb_parent.width and ll_height = icb_parent.height and ls_facename = icb_parent.facename and ll_textsize = icb_parent.textsize and fileexists(ls_imagepath) then
		choose case as_imagetype
			case 'normal'
				is_normal_img = ls_imagepath
			case 'mouseover'
				is_mouseover_img = ls_imagepath
			case 'clicked'
				is_clicked_img = ls_imagepath
			case 'disabled'
				is_disabled_img = ls_imagepath
		end choose
		
		return 1
	end if
end if

// 임시로 사용될 파일명, 파워빌더 12 이상부터 PNG 포맷 사용 가능
string ls_tempfilepath

ls_tempfilepath = gnv_extfunc.of_getpowerframetemppath() + gnv_extfunc.of_getuniqpicturename(icb_parent) + "_" + as_imagetype + ".jpg"
//ls_tempfilepath = gnv_extfunc.of_getpowerframetemppath() + gnv_extfunc.of_getuniqpicturename(icb_parent) + "_" + as_imagetype + ".bmp"

// 임시파일 신규 생성
ulong lul_fontcolor
string ls_prefixiconfile

lul_fontcolor = icb_parent.dynamic of_getfontcolor(as_imagetype)

ls_prefixiconfile = icb_parent.dynamic of_getprefixiconfile()
ls_prefixiconfile = pf_f_getimagepathappeon(ls_prefixiconfile)

choose case as_imagetype
	case 'normal'
		gnv_extfunc.of_createcommandbuttonoverlayimage(icb_parent, is_normal_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
		is_normal_img = ls_tempfilepath
	case 'mouseover'
		gnv_extfunc.of_createcommandbuttonoverlayimage(icb_parent, is_mouseover_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
		is_mouseover_img = ls_tempfilepath
	case 'clicked'
		gnv_extfunc.of_createcommandbuttonoverlayimage(icb_parent, is_clicked_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
		is_clicked_img = ls_tempfilepath
	case 'disabled'
		gnv_extfunc.of_createcommandbuttonoverlayimage(icb_parent, is_disabled_img, ls_tempfilepath, lul_fontcolor, ls_prefixiconfile)
		is_disabled_img = ls_tempfilepath
end choose

// 생성된 이미지 정보 보관
if ll_find = 0 then
	ll_find = gnv_session.ids_btnrepo.insertrow(0)
end if

gnv_session.ids_btnrepo.setitem(ll_find, 'ctrlname', ls_ctrlname)
gnv_session.ids_btnrepo.setitem(ll_find, 'text', ls_btntext)
gnv_session.ids_btnrepo.setitem(ll_find, 'width', icb_parent.width)
gnv_session.ids_btnrepo.setitem(ll_find, 'height', icb_parent.height)
gnv_session.ids_btnrepo.setitem(ll_find, 'facename', icb_parent.facename)
gnv_session.ids_btnrepo.setitem(ll_find, 'textsize', icb_parent.textsize)
gnv_session.ids_btnrepo.setitem(ll_find, 'imagepath', ls_tempfilepath)

return 1

end function

public function string of_getclassname ();return 'pf_u_commandbutton_overlay'

end function

public subroutine of_setenabled (boolean ab_enabled);choose case ab_enabled
	case true
		this.picturename = is_normal_img
	case false
		this.picturename = is_disabled_img
end choose

this.enabled = ab_enabled
return

end subroutine

public subroutine of_setvisible (boolean ab_visible);this.visible = ab_visible

end subroutine

public subroutine of_settext (string as_text);this.of_setpicturename(is_picturename)

end subroutine

on pf_u_commandbutton_overlay.create
end on

on pf_u_commandbutton_overlay.destroy
end on

event constructor;if gnv_appmgr.is_clienttype <> 'PB' then
	if ib_OnceOpened = true then return
end if

// damn it! this constructor event runs twice when using openuserobject()
if isvalid(icb_parent) then return 0

// get parent object
string ls_imagefile

icb_parent = gnv_session.of_get('pf_u_commandbutton.parentbutton')
iw_parent = gnv_session.of_get('pf_u_commandbutton.parentwindow')
ls_imagefile = gnv_session.of_getstring('pf_u_commandbutton.buttonimagefile')

this.width = icb_parent.width
this.height = icb_parent.height

// set picturename
if ls_imagefile <> '' then
	this.picturename = ls_imagefile
end if

// init each button picture names
this.of_setpicturename(this.picturename)

// mouseover monitor
inv_timer = create pf_n_timing
inv_timer.of_initialize(this)

if gnv_appmgr.is_clienttype <> 'PB' then
	ib_OnceOpened = true
end if

return 0

end event

event destructor;if isvalid(inv_timer) then
	destroy inv_timer
end if

end event

event clicked;if isvalid(icb_parent) then
	icb_parent.event clicked()
end if

end event

