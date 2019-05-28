﻿$PBExportHeader$pf_u_commandbutton.sru
$PBExportComments$파워프레임용 CommandButton 컨트롤 입니다.
forward
global type pf_u_commandbutton from commandbutton
end type
end forward

global type pf_u_commandbutton from commandbutton
integer width = 402
integer height = 112
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string pointer = "HyperLink!"
event type boolean pfe_ispowerframecontrol ( )
event pfe_textchanged pbm_settext
event pfe_visiblechanged pbm_showwindow
event move pbm_move
event resize pbm_size
event pfe_postopen ( )
event pfe_enablechanged pbm_enable
event pfe_setredraw pbm_setredraw
end type
global pf_u_commandbutton pf_u_commandbutton

type prototypes
Function long SetWindowRgn(long hWnd, long hRgn, boolean bRedraw) Library "user32.dll"
Function long CreateRectRgn(long x1, long y1, long x2, long y2) Library "gdi32.dll"



//    dc.SetBkColor(RGB(100,100,255));   //Setting the Text Background color
//    dc.SetTextColor(RGB(255,0,0));     //Setting the Text Color

end prototypes

type variables
private:
	window iw_parent
	pf_u_commandbutton_overlay iuo_overlay
	integer ii_referencedobjectcnt
	boolean ib_OnceOpened = false
	boolean ib_isVisible = false

public:
	powerobject ipo_referencedobject[]

	string PowerTipText
	boolean ApplyDesign = True
	string	PrefixIconFile
	string ButtonImageFile
	ulong FontColor = RGB(66,66,66)
	ulong MouseOverFontColor = RGB(44,44,44)
	ulong DiabledFontColor = RGB(153,153,153)
	//ulong FontColor = RGB(70,70,70)
	//ulong MouseOverFontColor = RGB(237,119,15)
	//ulong DiabledFontColor = RGB(153,153,153)
	
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom
	
	string ReferencedObject
	string OnClickCallEvent
	string DatawindowAction
	
end variables

forward prototypes
public function string of_getclassname ()
public function unsignedlong of_getfontcolor (string as_mode)
public subroutine of_settext (string as_text)
public subroutine of_setvisible (boolean ab_visible)
public subroutine of_setenabled (boolean ab_enabled)
public function string of_getprefixiconfile ()
end prototypes

event type boolean pfe_ispowerframecontrol();return true

end event

event pfe_textchanged;if isvalid(iuo_overlay) then
	iuo_overlay.of_settext(this.text)
end if

end event

event pfe_visiblechanged;if isvalid(iuo_overlay) then
	iuo_overlay.of_setvisible(this.visible)
	this.setposition(Behind!, iuo_overlay)
end if

end event

event move;if isvalid(iuo_overlay) then
	iuo_overlay.x = xpos
	iuo_overlay.y = ypos
end if

end event

event resize;if isvalid(iuo_overlay) then
	iuo_overlay.post of_settext(this.text)
end if

end event

event pfe_postopen();// get referenced object
string ls_refobj[]
integer li_objcnt, i

if isnull(ReferencedObject) then return
if ReferencedObject = '' then return

li_objcnt = pf_f_parsetoarray(ReferencedObject, ';', ls_refobj)
for i = 1 to li_objcnt
	if len(ls_refobj[i]) > 0 then
		ii_referencedobjectcnt ++
		ls_refobj[i] = trim(ls_refobj[i])
		choose case lower(ls_refobj[i])
			case 'this'
				ipo_referencedobject[ii_referencedobjectcnt] = this
			case 'parent'
				ipo_referencedobject[ii_referencedobjectcnt] = parent
			case iw_parent.classname()
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent
			case else
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent.dynamic of_getwindowobjectbyname(ls_refobj[i])
				if not isvalid(ipo_referencedobject[ii_referencedobjectcnt]) then
					messagebox('[' + this.classname() + '] 알림', '[' + ls_refobj[i] + '] 참조 오브젝트가 존재하지 않습니다')
				end if
		end choose
	end if
next

end event

event pfe_enablechanged;if isvalid(iuo_overlay) then
	iuo_overlay.of_setenabled(this.enabled)
end if

end event

event pfe_setredraw;// 
if isvalid(iuo_overlay) then
	iuo_overlay.of_setvisible(this.visible)
	this.setposition(Behind!, iuo_overlay)
end if

end event

public function string of_getclassname ();return 'pf_u_commandbutton'

end function

public function unsignedlong of_getfontcolor (string as_mode);ulong ll_fontcolor

choose case lower(as_mode)
	case 'normal'
		ll_fontcolor = this.FontColor
	case 'mouseover', 'clicked'
		ll_fontcolor = this.MouseOverFontColor
	case 'disabled'
		ll_fontcolor = this.DiabledFontColor
end choose

return ll_fontcolor

end function

public subroutine of_settext (string as_text);this.text = as_text

if gnv_appmgr.is_clienttype = 'WEB' then 
	this.event pfe_textchanged(as_text)
end if

end subroutine

public subroutine of_setvisible (boolean ab_visible);if this.visible = ab_visible then return

this.visible = ab_visible
if gnv_appmgr.is_clienttype = 'WEB' then 
	this.event pfe_visiblechanged(ab_visible, 0)
end if

end subroutine

public subroutine of_setenabled (boolean ab_enabled);this.enabled = ab_enabled

if gnv_appmgr.is_clienttype = 'WEB' then 
	this.event pfe_enablechanged(ab_enabled)
end if

end subroutine

public function string of_getprefixiconfile ();return PrefixIconFile

end function

on pf_u_commandbutton.create
end on

on pf_u_commandbutton.destroy
end on

event constructor;if gnv_appmgr.is_clienttype <> 'PB' then
	if ib_OnceOpened = true then return
end if

// remember visible property
ib_isVisible = this.visible

// get parent window
iw_parent = pf_f_getparentwindow(this)

// apply design of commandbutton
if ApplyDesign = true then
	
	// backup message object before OpenUserObject()
	message lm_backup
	lm_backup = create message
	lm_backup.Handle = message.Handle
	lm_backup.Number = message.Number
	lm_backup.WordParm = message.WordParm
	lm_backup.LongParm = message.LongParm
	lm_backup.DoubleParm = message.DoubleParm
	lm_backup.StringParm = message.StringParm
	lm_backup.PowerObjectParm = message.PowerObjectParm
	lm_backup.Processed = message.Processed
	lm_backup.ReturnValue = message.ReturnValue
	
	//iw_parent.OpenUserObjectWithParm(iuo_overlay, this, this.x +1, this.y +1)
	if not isvalid(gnv_session) then gnv_session = create pf_n_appsession
	gnv_session.of_put('pf_u_commandbutton.parentbutton', this)
	gnv_session.of_put('pf_u_commandbutton.parentwindow', iw_parent)
	gnv_session.of_put('pf_u_commandbutton.buttonimagefile', ButtonImageFile)
	iw_parent.OpenUserObject(iuo_overlay, this.x +1, this.y +1)
	if parent.typeof() = userobject! then
		gnv_extfunc.setparent(handle(iuo_overlay), handle(parent))
		iuo_overlay.move(this.x +1, this.y +1)
	end if
	
	//iuo_overlay.setposition(totop!)
	iuo_overlay.bringtotop = true
	if this.bringtotop = true then
		this.bringtotop = false
		this.setposition(behind!, iuo_overlay)
	end if
	
	iuo_overlay.of_setvisible(this.visible)
	iuo_overlay.of_setenabled(this.enabled)
	iuo_overlay.powertiptext = this.powertiptext
	
	// restore message object
	message.Handle = lm_backup.Handle
	message.Number = lm_backup.Number
	message.WordParm = lm_backup.WordParm
	message.LongParm = lm_backup.LongParm
	message.DoubleParm = lm_backup.DoubleParm
	message.StringParm = lm_backup.StringParm
	message.PowerObjectParm = lm_backup.PowerObjectParm
	message.Processed = lm_backup.Processed
	message.ReturnValue = lm_backup.ReturnValue
end if

//// properties monitor
//this.of_setpropertywatcher('true')
//inv_propmon.of_register('enabled', 'pfe_enablechanged')
//inv_propmon.of_register('visible', 'pfe_visiblechanged')
//inv_propmon.of_register('text', 'pfe_textchanged')

if gnv_appmgr.is_clienttype <> 'PB' then
	ib_OnceOpened = true
end if

// postopen event
this.post event pfe_postopen()

end event

event destructor;//this.of_setpropertywatcher('false')

if isvalid(iuo_overlay) then
	// Appeon 에서 Popup 윈도우는 CloseUserObject 를 수행하면 
	// 클라이언트가 멈추는 현상 있음
	// (Appeon2016Build1119 버전은 CloseUserObject 호출 안하면 오류발생됨)
	//if gnv_appmgr.is_clienttype = 'PB' then
		iw_parent.CloseUserObject(iuo_overlay)
	//end if
	destroy iuo_overlay
end if

end event

event clicked;integer i

// 참조 오브젝트가 선언된 경우 해당 오브젝트의 이벤트를 호출합니다
if ii_referencedobjectcnt > 0 then
	for i = 1 to ii_referencedobjectcnt
		if len(OnClickCallEvent) > 0 then
			if not isvalid(ipo_referencedobject[i]) then continue
			if ipo_referencedobject[i].triggerevent(OnClickCallEvent) = -1 then exit
		end if
	next
end if

// 참조 오브젝트가 데이터윈도우인 경우 해당 오브젝트의 ACTION 서비스를 호출합니다
if ii_referencedobjectcnt > 0 then
	for i = 1 to ii_referencedobjectcnt
		if not isvalid(ipo_referencedobject[i]) then continue
		if ipo_referencedobject[i].typeof() = datawindow! then
			if len(DatawindowAction) > 0 then
				if ipo_referencedobject[i].triggerevent('pfe_ispowerframecontrol') = 1 then
					if ipo_referencedobject[i].dynamic of_getclassname() = 'pf_u_datawindow' then
						pf_u_datawindow ldw_ref
						ldw_ref = ipo_referencedobject[i]
						if isvalid(ldw_ref.inv_action) then
							ldw_ref.inv_action.of_datawindowaction(DatawindowAction)
						end if
					end if
				end if
			end if
		end if
	next
end if

end event

