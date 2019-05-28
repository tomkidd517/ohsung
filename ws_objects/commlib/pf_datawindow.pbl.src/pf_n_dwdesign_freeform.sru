﻿$PBExportHeader$pf_n_dwdesign_freeform.sru
$PBExportComments$Freeform 스타일 데이터윈도우 디자인 처리용 NVO 입니다.
forward
global type pf_n_dwdesign_freeform from pf_n_dwdesign
end type
end forward

global type pf_n_dwdesign_freeform from pf_n_dwdesign
end type
global pf_n_dwdesign_freeform pf_n_dwdesign_freeform

type variables
protected:
	// instance for border
	pf_u_statictext iln_top
	pf_u_statictext iln_bottom
	pf_u_statictext iln_left
	pf_u_statictext iln_right
	long il_borderhndl[4]
	
	// original height of detail band
	long il_detailheight
	
public:
	long BorderTopColor = RGB(193,180,158)
	long BorderBottomColor = RGB(243,243,243)
	long BorderLeftColor = RGB(243,243,243)
	long BorderRightColor = RGB(243,243,243)
	
	long DatawindowBackgroundColor = RGB(255,255,255)

	long ColumnBorderColor = RGB(230,230,230)
	long TextBackgroundColor = RGB(240,236,229)
	long DisabledColumnBackgroundColor = RGB(239,239,241)
	long EditableColumnBackgroundColor = RGB(255,255,255)
	long GetFocusedColumnBackgroundColor = RGB(255,237,194)
	long GetFocusedColumnBorderColor = RGB(255,182,102)
	
	long CellBorderBackColor = RGB(255,255,255)
	long CellBorderColor = RGB(210,210,210)
	long CellBorderThickNess = 1		// Pixel
	long CellLeftRightGap = 4		// Pixel
	long CellTopBottomGap = 4		// Pixel
	long MaxSingleRowHeight = 30		// Pixel
	
	// 비활성 컬럼 컬러 적용 여부
	boolean SetDisabledColumnBackgroundColor = true

	// 입력 가능한 컬럼 테두리 표시 여부
	boolean EditableColumnBorder = true

end variables

forward prototypes
public function integer of_applydesign ()
public function string of_getclassname ()
public function integer of_drawcustomborder ()
public function integer of_getfontsize (string as_fontface, integer ai_fontheight, integer ai_fontweight, ref pf_s_size astr_fontsize)
public function long of_carriagereturncount (string as_searchstr)
public subroutine of_setmaxsinglerowheight (long al_rowheight)
end prototypes

public function integer of_applydesign ();if not isvalid(idw_target) then return -1

string ls_error
pf_n_syntaxbuffer lnv_newsyntax, lnv_modsyntax
lnv_newsyntax = create pf_n_syntaxbuffer
lnv_modsyntax = create pf_n_syntaxbuffer

long ll_objcnt, i, ll_pos
long ll_xpos, ll_ypos, ll_width, ll_height
string ls_objects[]
string ls_objtype, ls_editstyle
string ls_border, ls_band
string ls_visible, ls_protect
string ls_bgcolor, ls_colbgcolor
string ls_tag, ls_bandcolor, ls_cellbgcolor

string ls_newborder[]
long ll_bordercnt

long ll_cellxpos, ll_cellypos
long ll_cellwidth, ll_cellheight

pf_s_size lstr_fontsize
string ls_fontface, ls_filename
integer li_fontheight, li_fontweight
string ls_dwsyntaxdata
long ll_crcnt

il_detailheight = long(idw_target.describe("Datawindow.Detail.Height"))
ls_dwsyntaxdata = idw_target.describe("datawindow.syntax.data")	

ll_objcnt = pf_f_parsetoarray(idw_target.describe("Datawindow.Objects"), "~t", ls_objects[])
for i = 1 to ll_objcnt
	
	// 컬럼 타입이 Column, Text, Compute 인 경우만 디자인 적용
	ls_objtype = idw_target.describe(ls_objects[i] + ".Type")
	if not (ls_objtype = "column" or ls_objtype = "text" or ls_objtype = "compute") then continue
	
	// 화면에 위치 하지 않는 컨트롤 제외
	ls_band = idw_target.describe(ls_objects[i] + ".Band")
	if ls_band = "?" or ls_band = "!" then continue
	
	ls_editstyle = idw_target.describe(ls_objects[i] + ".Edit.Style")
	ls_tag = lower(idw_target.describe(ls_objects[i] + ".Tag"))
	ls_border = idw_target.describe(ls_objects[i] + ".Border")
	ls_bandcolor = idw_target.describe("Datawindow." + ls_band + ".Color")
	
	// get visible property(Trim trailing and leading space)
	ls_visible = idw_target.describe(ls_objects[i] + ".Visible")
	if left(ls_visible, 1) = '"' and right(ls_visible, 1) = '"' then
		ls_visible = mid(ls_visible, 2, len(ls_visible) - 2)
	end if
	
	// get column background color
	ls_bgcolor = idw_target.describe(ls_objects[i] + ".Background.Color")
	if ls_bgcolor = '!' then ls_bgcolor=string(553648127)
	if left(ls_bgcolor, 1) = '"' and right(ls_bgcolor, 1) = '"' then
		ls_bgcolor = of_fixescapechar(mid(ls_bgcolor, 2, len(ls_bgcolor) - 2))
	end if
	
	// Background.Color = Transparent 인 경우만 Background 디자인(Protect 속성과 연계해서 처리됨)
	ls_colbgcolor = ''
	if ls_objtype = "column" or ls_objtype = "compute" then
		// 536870912 = 0x 20 00 00 00 Transparency bit = 1, RGB-bytes designate BLACK (Red=0, Green=0, Blue=0)
		// 553648127 = 0x 20 FF FF FF Transparency bit = 1, RGB-bytes designate WHITE (Red=255, Green=255, Blue=255)
		if SetDisabledColumnBackgroundColor = true and (left(ls_bgcolor, 9) = '553648127' or left(ls_bgcolor, 9) = '536870912') then
			if pos(ls_bgcolor, '~t') = 0 then
				ls_protect = idw_target.describe(ls_objects[i] + ".Protect")
				ll_pos = pos(ls_protect, '~t')
				if ll_pos > 0 then
					ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
					ls_colbgcolor = ls_bgcolor + of_getinnersyntax('~tIf(Long(Describe("Evaluate(~~~"" + "' + ls_protect + '" + "~~~", " + String(GetRow()) + ")")) = 0 And Long(Describe("' + ls_objects[i] + '.TabSequence")) > 0, If(Describe("pf_getfocusedcolumn_t.text") = "' + ls_objects[i] + '", ' + string(GetFocusedColumnBackgroundColor) + ', ' + string(EditableColumnBackgroundColor) + '), ' + string(DisabledColumnBackgroundColor) + ')')
				else
					ls_colbgcolor = ls_bgcolor + of_getinnersyntax('~tIf(Long(Describe("' + ls_objects[i] + '.Protect")) = 0 And Long(Describe("' + ls_objects[i] + '.TabSequence")) > 0, If(Describe("pf_getfocusedcolumn_t.text") = "' + ls_objects[i] + '", ' + string(GetFocusedColumnBackgroundColor) + ', ' + string(EditableColumnBackgroundColor) + '), ' + string(DisabledColumnBackgroundColor) + ')')
				end if
				
				if ls_editstyle <> 'checkbox' and ls_editstyle <> 'radiobuttons' then
					lnv_modsyntax.of_append(ls_objects[i] + '.Background.Mode="0"')
					lnv_modsyntax.of_append(ls_objects[i] + '.Background.Color="' + ls_colbgcolor + '"')
				end if
			end if
		else
			//ls_colbgcolor = ls_bgcolor
		end if
	end if
	
	// Border Style = 2(Box) 인 경우 표형태의 디자인 수행
	if ls_border = '2' then
		
		ll_cellxpos = long(idw_target.describe(ls_objects[i] + ".x")) - long(pixelstounits(CellBorderThickNess, XPixelsToUnits!))
		ll_cellypos = long(idw_target.describe(ls_objects[i] + ".y")) - long(pixelstounits(CellBorderThickNess, YPixelsToUnits!))
		ll_cellwidth = long(idw_target.describe(ls_objects[i] + ".width")) + long(pixelstounits(CellBorderThickNess * 2, XPixelsToUnits!))
		ll_cellheight = long(idw_target.describe(ls_objects[i] + ".height")) + long(pixelstounits(CellBorderThickNess * 2, YPixelsToUnits!))
		
		// Cell Border 처리
		choose case ls_objtype
			case 'text'
				ls_cellbgcolor = string(TextBackgroundColor)
			case 'column', 'compute'
				if ls_colbgcolor <> '' then
					ls_cellbgcolor = ls_colbgcolor
				else
					ls_cellbgcolor = ls_bgcolor
				end if
		end choose
		
		lnv_newsyntax.of_append('rectangle(band=' + ls_band + ' x="' +String(ll_cellxpos) + '" y="' + string(ll_cellypos) + '" height="' + string(ll_cellheight) + '"' + ' width="' + string(ll_cellwidth) + '" name='  + ls_objects[i] + '_cellborder  visible="' + ls_visible + '" brush.hatch="6" brush.color="' + ls_cellbgcolor + '"' +  &
									' pen.style="0" pen.width="' + string(PixelsToUnits(CellBorderThickNess, YPixelsToUnits!)) + '" pen.color="' + string(CellBorderColor) + '" background.mode="1" background.color="553648127" )')
		
		// Border 제외 Cell 영역
		ll_cellxpos += long(pixelstounits(CellBorderThickNess, XPixelsToUnits!))
		ll_cellypos += long(pixelstounits(CellBorderThickNess, YPixelsToUnits!))
		ll_cellwidth -= long(pixelstounits(CellBorderThickNess * 2, XPixelsToUnits!))
		ll_cellheight -= long(pixelstounits(CellBorderThickNess * 2, YPixelsToUnits!))
		
		// 오브젝트 타입별로 컬럼 디자인 처리
		choose case ls_objtype
			case 'text'
				ls_fontface = idw_target.describe(ls_objects[i] + ".Font.Face")
				li_fontheight = integer(idw_target.describe(ls_objects[i] + ".Font.Height"))
				li_fontweight = integer(idw_target.describe(ls_objects[i] + ".Font.Weight"))
				
				this.of_getfontsize(ls_fontface, li_fontheight, li_fontweight, lstr_fontsize)
				
				// Carriage Return 있는 경우 Font Height *= CR
				ll_crcnt = this.of_carriagereturncount(idw_target.describe(ls_objects[i] + ".Text"))
				if ll_crcnt > 0 then
					lstr_fontsize.height *= ll_crcnt + 1
				end if
				
				// XPOS, WIDTH 설정
				ll_xpos = ll_cellxpos + pixelstounits(CellLeftRightGap, xpixelstounits!)
				ll_width = ll_cellwidth - pixelstounits(CellLeftRightGap * 2, xpixelstounits!)
				
				// YPOS, HEIGHT 설정(Column Tag에 verticalcenter=no 문구가 있으면 가운데 정렬 안 함)
				if match(ls_tag, 'verticalcenter *= *no') = true then
					ll_ypos = ll_cellypos
					ll_height = ll_cellheight
				else
					ll_ypos = ll_cellypos + (ll_cellheight - lstr_fontsize.height) / 2
					ll_height = lstr_fontsize.height
				end if
				
				lnv_modsyntax.of_append(ls_objects[i] + ".Border=~"0~"")
				lnv_modsyntax.of_append(ls_objects[i] + '.X="' + string(ll_xpos) + '"')
				lnv_modsyntax.of_append(ls_objects[i] + '.Y="' + string(ll_ypos) + '"')
				lnv_modsyntax.of_append(ls_objects[i] + '.width="' + string(ll_width) + '"')
				lnv_modsyntax.of_append(ls_objects[i] + '.height="' + string(ll_height) + '"')
				
			case 'column', 'compute'
				ls_fontface = idw_target.describe(ls_objects[i] + ".Font.Face")
				li_fontheight = integer(idw_target.describe(ls_objects[i] + ".Font.Height"))
				li_fontweight = integer(idw_target.describe(ls_objects[i] + ".Font.Weight"))
				
				this.of_getfontsize(ls_fontface, li_fontheight, li_fontweight, lstr_fontsize)
				
				ll_xpos = ll_cellxpos + pixelstounits(CellLeftRightGap, xpixelstounits!)
				ll_width = ll_cellwidth - pixelstounits(CellLeftRightGap * 2, xpixelstounits!)
				
				// YPOS, HEIGHT 설정(Column Tag에 verticalcenter=no 문구가 있으면 가운데 정렬 안 함)
				if match(ls_tag, 'verticalcenter *= *no') = true then
					ll_ypos = ll_cellypos
					ll_height = lstr_fontsize.height
				else
					choose case ll_cellheight
						// 셀이 기본 사이즈보다 높이가 큰 경우 VerticalCenter 처리 안 함(Multi-Line Column 로 인식함)
						case is > pixelstounits(MaxSingleRowHeight, ypixelstounits!)
							ll_ypos = ll_cellypos + pixelstounits(CellTopBottomGap, ypixelstounits!)
							ll_height = ll_cellheight - pixelstounits(CellTopBottomGap + 1, ypixelstounits!)
							
						// 셀이 기본 사이즈보다 작은 경우 VAlign 처리
						case else
							ll_ypos = ll_cellypos + (ll_cellheight - lstr_fontsize.height) / 2
							ll_height = lstr_fontsize.height
					end choose
				end if
				
				// 컬럼 CALENDAR ICON 처리
				if match(ls_tag, 'posticon *= *calendar') = true then
					ls_filename = "..\img\commonuse\icon_calendar.jpg"
					
					lnv_newsyntax.of_append(&
					'bitmap(band=' + ls_band + ' filename="' + ls_filename + '" x="' + string(ll_xpos + ll_width - 73) + '" y="' + string(ll_ypos + ((ll_height - 64) / 2)) + '" height="64" width="73" border="0" name=p_' + ls_objects[i] + '_comcalendar pointer="HyperLink!" visible="' + ls_visible + '" )')
					lnv_modsyntax.of_append(ls_objects[i] + '.width="' + string(ll_width - 73 - pixelstounits(4, xpixelstounits!)) + '"')
					
				// 컬럼 YEARMONTH ICON 처리
				elseif match(ls_tag, 'posticon *= *yearmonth') = true then
					ls_filename = "..\img\commonuse\icon_calendar.jpg"
					
					lnv_newsyntax.of_append(&
					'bitmap(band=' + ls_band + ' filename="' + ls_filename + '" x="' + string(ll_xpos + ll_width - 73) + '" y="' + string(ll_ypos + ((ll_height - 64) / 2)) + '" height="64" width="73" border="0" name=p_' + ls_objects[i] + '_comyearmonth pointer="HyperLink!" visible="' + ls_visible + '" )')
					lnv_modsyntax.of_append(ls_objects[i] + '.width="' + string(ll_width - 73 - pixelstounits(4, xpixelstounits!)) + '"')
					
				// 컬럼 POPUP ICON 처리
				elseif match(ls_tag, 'posticon *= *popup') = true then
					ls_filename = "..\img\commonuse\icon_popup.jpg"
					
					lnv_newsyntax.of_append(&
					'bitmap(band=' + ls_band + ' filename="' + ls_filename + '" x="' + string(ll_xpos + ll_width - 73) + '" y="' + string(ll_ypos + ((ll_height - 64) / 2)) + '" height="64" width="73" border="0" name=p_' + ls_objects[i] + '_compopup pointer="HyperLink!" visible="' + ls_visible + '" )')
					lnv_modsyntax.of_append(ls_objects[i] + '.width="' + string(ll_width - 73 - pixelstounits(4, xpixelstounits!)) + '"')
				else
					lnv_modsyntax.of_append(ls_objects[i] + '.width="' + string(ll_width) + '"')
				end if
				
				lnv_modsyntax.of_append(ls_objects[i] + ".Border=~"0~"")
				lnv_modsyntax.of_append(ls_objects[i] + '.X="' + string(ll_xpos) + '"')
				lnv_modsyntax.of_append(ls_objects[i] + '.Y="' + string(ll_ypos) + '"')
				lnv_modsyntax.of_append(ls_objects[i] + '.height="' + string(ll_height) + '"')
				
				if ls_editstyle = 'dddw' or ls_editstyle = 'ddlb' then
					if ll_cellheight > ll_height + pixelstounits(2, ypixelstounits!) then
						ll_xpos = ll_xpos - pixelstounits(1, xpixelstounits!)
						ll_ypos = ll_ypos - pixelstounits(1, ypixelstounits!)
						ll_width = ll_width + pixelstounits(1, xpixelstounits!)
						ll_height = ll_height + pixelstounits(1, ypixelstounits!)
						
						lnv_modsyntax.of_append('create line(band=detail x1="' + string(ll_xpos) + '" y1="' + string(ll_ypos) + '" x2="' + string(ll_xpos + ll_width + pixelstounits(1, xpixelstounits!)) + '" y2="' + string(ll_ypos) + '"  name=' + ls_objects[i] + '_border1' + ' visible="' + ls_visible + '" pen.style="0" pen.width="5" pen.color="' + ls_cellbgcolor + '"  background.mode="2" background.color="33554432" )')
						lnv_modsyntax.of_append('create line(band=detail x1="' + string(ll_xpos) + '" y1="' + string(ll_ypos + ll_height) + '" x2="' + string(ll_xpos + ll_width + pixelstounits(1, xpixelstounits!)) + '" y2="' + string(ll_ypos + ll_height) + '"  name=' + ls_objects[i] + '_border2' + ' visible="' + ls_visible + '" pen.style="0" pen.width="5" pen.color="' + ls_cellbgcolor + '"  background.mode="2" background.color="33554432" )')
						lnv_modsyntax.of_append('create line(band=detail x1="' + string(ll_xpos) + '" y1="' + string(ll_ypos) + '" x2="' + string(ll_xpos) + '" y2="' + string(ll_ypos + ll_height + pixelstounits(1, ypixelstounits!)) + '"  name=' + ls_objects[i] + '_border3' + ' visible="' + ls_visible + '" pen.style="0" pen.width="5" pen.color="' + ls_cellbgcolor + '"  background.mode="2" background.color="33554432" )')
						lnv_modsyntax.of_append('create line(band=detail x1="' + string(ll_xpos + ll_width) + '" y1="' + string(ll_ypos) + '" x2="' + string(ll_xpos + ll_width) + '" y2="' + string(ll_ypos + ll_height + pixelstounits(1, ypixelstounits!)) + '"  name=' + ls_objects[i] + '_border4' + ' visible="' + ls_visible + '" pen.style="0" pen.width="5" pen.color="' + ls_cellbgcolor + '"  background.mode="2" background.color="33554432" )')
					end if
				end if
		end choose
	end if
next

// Highlight get focused column
if EditableColumnBorder then
	lnv_newsyntax.of_append('line(band=detail x1="0" y1="0" x2="0" y2="0" name=l_getfocused_border_top visible="-" pen.style="0" pen.width="5" pen.color="' + string(GetFocusedColumnBorderColor) + '"  background.mode="1" background.color="553648127" )')
	lnv_newsyntax.of_append('line(band=detail x1="0" y1="0" x2="0" y2="0" name=l_getfocused_border_left visible="-" pen.style="0" pen.width="5" pen.color="' + string(GetFocusedColumnBorderColor) + '"  background.mode="1" background.color="553648127" )')
	lnv_newsyntax.of_append('line(band=detail x1="0" y1="0" x2="0" y2="0" name=l_getfocused_border_right visible="-" pen.style="0" pen.width="5" pen.color="' + string(GetFocusedColumnBorderColor) + '"  background.mode="1" background.color="553648127" )')
	lnv_newsyntax.of_append('line(band=detail x1="0" y1="0" x2="0" y2="0" name=l_getfocused_border_bottom visible="-" pen.style="0" pen.width="5" pen.color="' + string(GetFocusedColumnBorderColor) + '"  background.mode="1" background.color="553648127" )')
end if

// datawindow background color 설정
lnv_modsyntax.of_append('Datawindow.Color="' + string(DatawindowBackgroundColor) + '"')

// Modify datawindow syntax 
ls_error = idw_target.Modify(lnv_modsyntax.of_tostring())
if len(ls_error) > 0 then
	::clipboard(lnv_modsyntax.of_tostring())
	messagebox("Error", idw_target.classname() + " Syntax Modification Failure!! : " + ls_error)
	return -1
end if

string ls_newsyntax, ls_dwsyntax
string ls_findstr[] = { "groupbox(", "column(name", "compute(name", "text(name" }
long ll_minpos = 2147483647

ls_newsyntax = trim(lnv_newsyntax.of_tostring())
if ls_newsyntax <> '' then
	ls_dwsyntax = idw_target.describe("datawindow.syntax")
	
	for i = 1 to upperbound(ls_findstr)
		ll_pos = pos(ls_dwsyntax, ls_findstr[i])
		if ll_pos > 0 then
			if ll_pos < ll_minpos then ll_minpos = ll_pos
		end if
	next
	
	if ll_minpos > 0 then
		ls_dwsyntax = replace(ls_dwsyntax, ll_minpos, 0, ls_newsyntax)		
		if len(ls_dwsyntaxdata) > 9 Then ls_dwsyntax = replace(ls_dwsyntax, ll_minpos, 0, ls_dwsyntaxdata)					
		if idw_target.Create(ls_dwsyntax, ls_error) = -1 then
			::clipboard(idw_target.classname() + "~r~n" + ls_dwsyntax)
			messagebox("Error", idw_target.classname() + " Syntax Modification(Create) Failure!! : " + ls_error)
			return -1
		end if
		this.of_resetdwdisplayorder(idw_target.classname())
	end if
end if

return 1

end function

public function string of_getclassname ();return 'pf_n_dwdesign_freeform'

end function

public function integer of_drawcustomborder ();// backup message object before OpenUserObject()
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

long ll_x, ll_y
long ll_width, ll_height

// top line
if not isvalid(iln_top) then
	if idw_target.border = true then
		ll_x = idw_target.x
		ll_y = idw_target.y
		ll_width = idw_target.width
		ll_height = pixelstounits(1, ypixelstounits!)
	else
		ll_x = idw_target.x - pixelstounits(1, xpixelstounits!)
		ll_y = idw_target.y - pixelstounits(1, ypixelstounits!)
		ll_width = idw_target.width + pixelstounits(2, xpixelstounits!)
		ll_height = pixelstounits(1, ypixelstounits!)
	end if
	
	if iw_parent.openuserobject(iln_top, ll_x + pixelstounits(1, xpixelstounits!), ll_y) = 1 then
		iln_top.width = ll_width - pixelstounits(2, xpixelstounits!)
		iln_top.height = ll_height
		iln_top.backcolor = BorderTopColor
	end if
	
	if igo_parent.typeof() = userobject! then
		il_borderhndl[1] = gnv_extfunc.getparent(handle(iln_top))
		gnv_extfunc.setparent(handle(iln_top), handle(igo_parent))
	end if
end if

// bottom line
if not isvalid(iln_bottom) then
	if idw_target.border = true then
		ll_x = idw_target.x
		ll_y = idw_target.y + idw_target.height - pixelstounits(1, ypixelstounits!)
		ll_width = idw_target.width
		ll_height = pixelstounits(1, ypixelstounits!)
	else
		ll_x = idw_target.x - pixelstounits(1, xpixelstounits!)
		ll_y = idw_target.y + idw_target.height
		ll_width = idw_target.width + pixelstounits(2, xpixelstounits!)
		ll_height = pixelstounits(1, ypixelstounits!)
	end if
	
	if iw_parent.openuserobject(iln_bottom, ll_x + pixelstounits(1, xpixelstounits!), ll_y) = 1 then
		iln_bottom.width = ll_width - pixelstounits(2, xpixelstounits!)
		iln_bottom.height = ll_height
		iln_bottom.backcolor = BorderBottomColor
	end if
	
	if igo_parent.typeof() = userobject! then
		il_borderhndl[2] = gnv_extfunc.getparent(handle(iln_bottom))
		gnv_extfunc.setparent(handle(iln_bottom), handle(igo_parent))
	end if
end if

// left line
if not isvalid(iln_left) then
	iln_left = create pf_u_statictext
	
	if idw_target.border = true then
		iln_left.x = idw_target.x
		iln_left.y = idw_target.y
		iln_left.width = pixelstounits(1, xpixelstounits!)
		iln_left.height = idw_target.height
	else
		iln_left.x = idw_target.x - pixelstounits(1, xpixelstounits!)
		iln_left.y = idw_target.y - pixelstounits(1, ypixelstounits!)
		iln_left.width = pixelstounits(1, xpixelstounits!)
		iln_left.height = idw_target.height + pixelstounits(2, ypixelstounits!)
	end if
	
	iln_left.backcolor = BorderLeftColor
	iw_parent.openuserobject(iln_left, iln_left.x, iln_left.y)
	
	if igo_parent.typeof() = userobject! then
		il_borderhndl[3] = gnv_extfunc.getparent(handle(iln_left))
		gnv_extfunc.setparent(handle(iln_left), handle(igo_parent))
	end if
end if

// right line
if not isvalid(iln_right) then
	iln_right = create pf_u_statictext
	
	if idw_target.border = true then
		iln_right.x = idw_target.x + idw_target.width - pixelstounits(1, xpixelstounits!)
		iln_right.y = idw_target.y
		iln_right.width = pixelstounits(1, xpixelstounits!)
		iln_right.height = idw_target.height
	else
		iln_right.x = idw_target.x + idw_target.width
		iln_right.y = idw_target.y - pixelstounits(1, ypixelstounits!)
		iln_right.width = pixelstounits(1, xpixelstounits!)
		iln_right.height = idw_target.height + pixelstounits(2, ypixelstounits!)
	end if
	
	iln_right.backcolor = BorderRightColor
	iw_parent.openuserobject(iln_right, iln_right.x, iln_right.y)
	
	if igo_parent.typeof() = userobject! then
		il_borderhndl[4] = gnv_extfunc.getparent(handle(iln_right))
		gnv_extfunc.setparent(handle(iln_right), handle(igo_parent))
	end if
end if

iln_top.visible = idw_target.visible
iln_bottom.visible = idw_target.visible
iln_left.visible = idw_target.visible
iln_right.visible = idw_target.visible

if idw_target.border = true then
	idw_target.border = false
	idw_target.x += pixelstounits(1, xpixelstounits!)
	idw_target.y += pixelstounits(1, ypixelstounits!)
	idw_target.width -= pixelstounits(2, xpixelstounits!)
	idw_target.height -= pixelstounits(2, ypixelstounits!)
end if

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

return 1

end function

public function integer of_getfontsize (string as_fontface, integer ai_fontheight, integer ai_fontweight, ref pf_s_size astr_fontsize);// 폰트 사이즈(Width, Height) 를 구합니다
// 계산 속도 향상을 위해 이미 산출된 값은 캐시합니다

string ls_cachekey

// 해당 폰트가 캐시된 상태면 계산된 값만 참조합니다
ls_cachekey = "FontSizeRepo=" + as_fontface + "~t" + string(ai_fontheight) + "~t" + string(ai_fontweight)

// 윈도우 단독 실행을 위한 임시 코드
if not isvalid(gnv_session) then
	gnv_session = create pf_n_appsession
end if

if gnv_session.of_containskey(ls_cachekey) then
	astr_fontsize = gnv_session.of_get(ls_cachekey)
	return 1
end if

// 폰트 사이즈가 - 인경우 + 로 변경( -9 ==> 9 )
if ai_fontheight < 0 then
	ai_fontheight *= -1
end if

// 폰트사이즈 구하기 API  호출
gnv_extfunc.pf_gettextsizeW(handle(this), " ", as_fontface, ai_fontheight, ai_fontweight, astr_fontsize)

// Pixel 을 PBUnit 으로 변경
astr_fontsize.width = pixelstounits(astr_fontsize.width, xpixelstounits!)
astr_fontsize.height = pixelstounits(astr_fontsize.height, ypixelstounits!)

// 계산된 폰트 사이즈 보관
gnv_session.of_put(ls_cachekey, astr_fontsize)

return 1

end function

public function long of_carriagereturncount (string as_searchstr);// 문자열안에 CarriageReturn 값을 카운트 합니다.

long ll_pos, ll_crcnt

ll_pos = pos(as_searchstr, '~r~n')
do while ll_pos > 0
	ll_crcnt ++
	ll_pos = pos(as_searchstr, '~r~n', ll_pos + 1)
loop

return ll_crcnt

end function

public subroutine of_setmaxsinglerowheight (long al_rowheight);// 컬럼 디자인 작업 시 해당 컬럼이
// Single Row 인지 Multi Row인지 판단하는 기준값을 설정합니다. (Pixel 단위)
MaxSingleRowHeight = al_rowheight

end subroutine

on pf_n_dwdesign_freeform.create
call super::create
end on

on pf_n_dwdesign_freeform.destroy
call super::destroy
end on

event move;call super::move;if isvalid(iln_top) then
	iln_top.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_top.y = ypos - pixelstounits(1, ypixelstounits!)
end if

if isvalid(iln_bottom) then
	iln_bottom.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_bottom.y = ypos + idw_target.height + pixelstounits(1, ypixelstounits!)
end if

if isvalid(iln_left) then
	iln_left.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_left.y = ypos - pixelstounits(1, ypixelstounits!)
end if

if isvalid(iln_right) then
	iln_right.x = xpos + idw_target.width + pixelstounits(1, xpixelstounits!)
	iln_right.y = ypos - pixelstounits(1, ypixelstounits!)
end if

end event

event resize;call super::resize;// 상단 Border 사이즈
if isvalid(iln_top) then
	iln_top.width = idw_target.width + pixelstounits(2, xpixelstounits!)
end if

// 하단 Border 사이즈
if isvalid(iln_bottom) then
	iln_bottom.y = idw_target.y + idw_target.height
	iln_bottom.width = idw_target.width + pixelstounits(2, xpixelstounits!)
end if

// 좌측 Border 사이즈
if isvalid(iln_left) then
	iln_left.height = idw_target.height + pixelstounits(2, ypixelstounits!)
end if

// 우측 Border 사이즈
if isvalid(iln_right) then
	iln_right.x = idw_target.x + idw_target.width
	iln_right.height = idw_target.height + pixelstounits(2, ypixelstounits!)
end if

long ll_row
ll_row = idw_target.getrow()

// Resize시 Freeform datawindow는 Height를 데이터윈도우와 맞춰서
// Click시 Runtime 오류를 방지한다 (Detail 범위를 벗어나면 Row = 0이 됨)
if il_detailheight < idw_target.height then
	idw_target.modify("Datawindow.Detail.Height='" + string(idw_target.height) + "'")
else
	// 상하 스크롤바 생성을 막기 위한 Detail Height 조정작업
	if long(idw_target.describe("Datawindow.Detail.Height")) <> il_detailheight then
		idw_target.modify("Datawindow.Detail.Height='" + string(il_detailheight) + "'")
	end if
end if

// Datawindow.Detail.Height를 Modify 할 경우 CurrentRow가 1로 초기화되는 증상 있음. 
// 원래 행으로 이동 로직 추가.
if idw_target.getrow() <> ll_row then
	idw_target.scrolltorow(ll_row)
	idw_target.setrow(ll_row)
end if

end event

event destructor;call super::destructor;// Appeon 에서 Popup 윈도우는 CloseUserObject 를 수행하면 클라이언트가 멈추는 현상 있음
// (Appeon2016Build1119 버전은 CloseUserObject 호출 안하면 오류발생됨)

//if gnv_appmgr.is_clienttype <> 'PB' then return

if isvalid(iln_top) then
	if igo_parent.typeof() = userobject! then gnv_extfunc.setparent(handle(iln_top), il_borderhndl[1])
	iw_parent.CloseUserObject(iln_top)
	destroy iln_top
end if

if isvalid(iln_bottom) then
	if igo_parent.typeof() = userobject! then gnv_extfunc.setparent(handle(iln_bottom), il_borderhndl[2])
	iw_parent.CloseUserObject(iln_bottom)
	destroy iln_bottom
end if

if isvalid(iln_left) then
	if igo_parent.typeof() = userobject! then gnv_extfunc.setparent(handle(iln_left), il_borderhndl[3])
	iw_parent.CloseUserObject(iln_left)
	destroy iln_left
end if

if isvalid(iln_right) then
	if igo_parent.typeof() = userobject! then gnv_extfunc.setparent(handle(iln_right), il_borderhndl[4])
	iw_parent.CloseUserObject(iln_right)
	destroy iln_right
end if

end event

event pfe_visiblechanged;call super::pfe_visiblechanged;if isvalid(iln_top) then
	iln_top.visible = idw_target.visible
end if

if isvalid(iln_bottom) then
	iln_bottom.visible = idw_target.visible
end if

if isvalid(iln_left) then
	iln_left.visible = idw_target.visible
end if

if isvalid(iln_right) then
	iln_right.visible = idw_target.visible
end if

end event

event itemfocuschanged;call super::itemfocuschanged;if not isvalid(idw_target) then return
if row = 0 then return

long ll_xpos, ll_ypos, ll_width, ll_height
string ls_syntax, ls_error, ls_cellborder

if string(dwo.type) = 'column' then
	if EditableColumnBorder = true then
		ls_cellborder = string(dwo.name) + '_cellborder'
		ll_xpos = long(idw_target.describe(ls_cellborder + ".x"))
		if ll_xpos > 0 then
			ll_ypos = long(idw_target.describe(ls_cellborder + ".y"))
			ll_width = long(idw_target.describe(ls_cellborder + ".width"))
			ll_height = long(idw_target.describe(ls_cellborder + ".height"))
			
			ll_xpos += pixelstounits(1, xpixelstounits!)
			ll_ypos += pixelstounits(1, ypixelstounits!)
			ll_width -= pixelstounits(3, xpixelstounits!)
			ll_height -= pixelstounits(3, ypixelstounits!)
			
			ls_syntax += "l_getfocused_border_top.x1='" + string(ll_xpos) + "' l_getfocused_border_top.x2='" + string(ll_xpos + ll_width) + "'~r~n"
			ls_syntax += "l_getfocused_border_top.y1='" + string(ll_ypos) + "' l_getfocused_border_top.y2='" + string(ll_ypos) + "'~r~n"
			
			ls_syntax += "l_getfocused_border_left.x1='" + string(ll_xpos) + "' l_getfocused_border_left.x2='" + string(ll_xpos) + "'~r~n"
			ls_syntax += "l_getfocused_border_left.y1='" + string(ll_ypos) + "' l_getfocused_border_left.y2='" + string(ll_ypos + ll_height) + "'~r~n"
			
			ls_syntax += "l_getfocused_border_right.x1='" + string(ll_xpos + ll_width) + "' l_getfocused_border_right.x2='" + string(ll_xpos + ll_width) + "'~r~n"
			ls_syntax += "l_getfocused_border_right.y1='" + string(ll_ypos) + "' l_getfocused_border_right.y2='" + string(ll_ypos + ll_height + pixelstounits(1, ypixelstounits!)) + "'~r~n"
			
			ls_syntax += "l_getfocused_border_bottom.x1='" + string(ll_xpos) + "' l_getfocused_border_bottom.x2='" + string(ll_xpos + ll_width + pixelstounits(1, xpixelstounits!)) + "'~r~n"
			ls_syntax += "l_getfocused_border_bottom.y1='" + string(ll_ypos + ll_height) + "' l_getfocused_border_bottom.y2='" + string(ll_ypos + ll_height) + "'~r~n"
		end if
		
		ls_error = idw_target.modify(ls_syntax)
//		if len(ls_error) > 0 then
//			::clipboard(ls_syntax)
//			messagebox('itemfocuschanged', ls_error)
//		end if
	end if
end if

end event

event getfocus;call super::getfocus;if isvalid(idw_target) then
	if EditableColumnBorder = true then
		idw_target.modify("l_getfocused_border_top.visible='0~tif(getrow() = currentrow(), 1, 0)'")
		idw_target.modify("l_getfocused_border_left.visible='0~tif(getrow() = currentrow(), 1, 0)'")
		idw_target.modify("l_getfocused_border_right.visible='0~tif(getrow() = currentrow(), 1, 0)'")
		idw_target.modify("l_getfocused_border_bottom.visible='0~tif(getrow() = currentrow(), 1, 0)'")
	end if
end if

end event

event losefocus;call super::losefocus;if isvalid(idw_target) then
	if EditableColumnBorder = true then
		idw_target.modify("l_getfocused_border_top.visible='0'")
		idw_target.modify("l_getfocused_border_left.visible='0'")
		idw_target.modify("l_getfocused_border_right.visible='0'")
		idw_target.modify("l_getfocused_border_bottom.visible='0'")
		idw_target.setredraw(true)
	end if
end if

end event

