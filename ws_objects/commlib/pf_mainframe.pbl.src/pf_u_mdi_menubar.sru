﻿$PBExportHeader$pf_u_mdi_menubar.sru
forward
global type pf_u_mdi_menubar from pf_u_userobject
end type
type dw_menubar from pf_u_datawindow within pf_u_mdi_menubar
end type
type hsb_1 from pf_u_hscrollbar within pf_u_mdi_menubar
end type
end forward

global type pf_u_mdi_menubar from pf_u_userobject
integer width = 3163
integer height = 120
string text = ""
boolean scaletoright = true
event pfe_menuselected ( string as_menu_id )
dw_menubar dw_menubar
hsb_1 hsb_1
end type
global pf_u_mdi_menubar pf_u_mdi_menubar

type variables
constant long NORMAL_TEXTCOLOR = rgb(119, 119, 119)
constant long MOUSEOVER_TEXTCOLOR = rgb(11, 20, 115)
constant long CLICKED_TEXTCOLOR = 0
constant long DISABLED_TEXTCOLOR = 0

private:
	pf_n_rolemenu inv_menu
	integer ii_selectedmenuseq
	long il_maxwidth

public:
	long MenuBarBackgroundColor = rgb(22,2,0)
	long FirstMenuStartXPos = 0 // pixels
	string MenuTextFontFace = "맑은 고딕" /*TOP메뉴 ,서브메뉴 폰트*/
	integer MenuTextFontSize = -9/*TOP메뉴 ,서브메뉴 폰트 SIZE*/
	integer MenuTextFontWeight = 700
	
	long MenuTextFontColor = rgb(184,184,184) /*TOP메뉴 폰트 기본 색상*/
	long MenuTextMoveOverColor =rgb(0,0,0)
	long MenuTextClickedColor = rgb(141,141,141)
	long MenuTextDisabledColor = rgb(0,0,0)
	long MenuTextBackColor = 553648127 // transparent
	
	string MenuDelimiterImage = "..\img\mainframe\u_mdi_menubar\menu_delimiter1.jpg"
	long MenuDelimiterHeight = 12 // pixels
	long MenuDelimiterWidth = 2 // pixels  //Top 메뉴 분리기호 폭*/
	boolean MenuDelimiterAtTheBeginning = false /*분리기호 처음부터 표시할지 여부(표시안함(False), 표시(true))*/
	boolean DisplayMenuIcon = false /* Top메뉴 아이콘 표시 여부(표시안함(false))*/
	long GapBetweenMenuItems = 20 // pixels /*분리기호 간격 */
	
	long SelectedMenuFontColor = rgb(240,236,229)//org =>rgb(141,141,141) /* TOP 메뉴 선택시 폰트색상*/
	long SelectedMenuBackColor = 4675428//org=>1073741824 // window background /* TOP 메뉴 선택시 메뉴 배경색상*/

end variables

forward prototypes
public function integer of_drawmenu (string as_parent_menu)
public function long of_getmenuwidth ()
public function integer of_initializemenu ()
public function string of_getclassname ()
end prototypes

public function integer of_drawmenu (string as_parent_menu);long ll_menucnt, ll_xpos, ll_ypos, ll_menugap, ll_textwidth, ll_textheight, i
long ll_bgxpos, ll_bgwidth
string ls_menu_id, ls_pgm_id, ls_pgm_name, ls_pgm_icon
pf_n_syntaxbuffer lnv_syntax
pf_s_size lstr_textsize

dw_menubar.setredraw(false)
dw_menubar.post setredraw(true)

// 데이터윈도우 초기화
dw_menubar.dataobject = dw_menubar.dataobject
ii_selectedmenuseq = 0

// Parent PgmNo 가 없는 경우 Default 값 처리(=최상단 메뉴)
if isnull(as_parent_menu) or as_parent_menu = '' then
	as_parent_menu = '00000'
end if

// 권한이 따른 메뉴 가져오기
ll_menucnt = inv_menu.of_getmenudata('parent', as_parent_menu)

// 데이터윈도우 Syntax 작성
lnv_syntax = create pf_n_syntaxbuffer
ll_xpos = pixelstounits(FirstMenuStartXPos, xpixelstounits!)
ll_menugap = pixelstounits(GapBetweenMenuItems, xpixelstounits!)

// 데이터윈도우 백그라운드 컬러
lnv_syntax.of_append('DataWindow.Header.Color="' + string(MenuBarBackgroundColor) + '"')
lnv_syntax.of_append('DataWindow.Header.Height="' + string(dw_menubar.height) + '"')

// 최초 메뉴 구분자
if ll_menucnt > 0 then
	if MenuDelimiterAtTheBeginning = true then
		// 메뉴 구분자 생성
		if len(MenuDelimiterImage) > 0 then
			ll_xpos += ll_textwidth + ll_menugap
			ll_ypos = (dw_menubar.height - pixelstounits(MenuDelimiterHeight, ypixelstounits!)) / 2
			lnv_syntax.of_append('create bitmap(band=header filename="' + MenuDelimiterImage + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(pixelstounits(MenuDelimiterHeight, ypixelstounits!)) + '" width="' + string(pixelstounits(MenuDelimiterWidth, xpixelstounits!)) + '" border="0"  name=p_menudist_' + string(i, '00') +  ' tag="" visible="1" )')
			ll_xpos += pixelstounits(MenuDelimiterWidth, xpixelstounits!)
		end if
	end if
end if

for i = 1 to ll_menucnt
	ll_bgxpos = ll_xpos
	ll_xpos += ll_menugap
	
	ls_menu_id = inv_menu.ids_menudata.getitemstring(i, 'menu_id')
	ls_pgm_id = inv_menu.ids_menudata.getitemstring(i, 'pgm_id')
	ls_pgm_name = inv_menu.ids_menudata.getitemstring(i, 'pgm_name')
	ls_pgm_icon = inv_menu.ids_menudata.getitemstring(i, 'pgm_icon')
	
	// 텍스트 사이즈 구하기
	if MenuTextFontSize < 0 then MenuTextFontSize *= -1
	gnv_extfunc.pf_gettextsizeW(handle(this), ls_pgm_name, MenuTextFontFace, MenuTextFontSize, MenuTextFontWeight, lstr_textsize)
	ll_textwidth = pixelstounits(lstr_textsize.width, xpixelstounits!)
	ll_textheight = pixelstounits(lstr_textsize.height, ypixelstounits!)
	
	// 텍스트 사이즈를 기준으로 상하 가운데 정렬
	ll_ypos = (dw_menubar.height - ll_textheight) / 2
	
	// 메뉴 아이콘 생성
	if len(ls_pgm_icon) > 0 and DisplayMenuIcon = true then
		// ASA Database 사용 시 '\' 값을 제대로 못 가져옴
		// 따라서 Database 에 경로를 '/'로 구분해서 입력하고 가져와서 '\'로 Replace 한다
		ls_pgm_icon = pf_f_replaceall(ls_pgm_icon, '/', '\')
		lnv_syntax.of_append('create bitmap(band=header filename="' + ls_pgm_icon + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_textheight) + '" width="' + string(ll_textheight * 4 / 3) + '" border="0"  name=p_menu_' + string(i, '00') +  ' tag="' + ls_menu_id + '" pointer="HyperLink!" visible="1" )')
		ll_xpos += (ll_textheight * 4 / 3) * 1.2
	end if
	
	// 메뉴 텍스트 생성
	// font.charset : 0 = ANSI;1 = The default character set for the specified font;2 = Symbol;128 = Shift JIS;255 = OEM
	// font.family : 0 = AnyFont;1 = Roman;2 = Swiss;3 = Modern;4 = Script;5 = Decorative
	// font.pitch : 0 = The default pitch for your system;1 = Fixed;2 = Variable
	if MenuTextFontSize > 0 then MenuTextFontSize *= -1
	lnv_syntax.of_append('create text(band=header alignment="2" text="' + ls_pgm_name + '" border="0" color="' + string(MenuTextFontColor) + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="76" width="' + string(ll_textwidth) + '"  html.valueishtml="0"  name=t_menu_' + string(i, '00') + ' tag="' + ls_menu_id + '" pointer="HyperLink!" visible="1"  font.face="' + MenuTextFontFace + '" font.height="' + string(MenuTextFontSize) + '" font.weight="' + string(MenuTextFontWeight) + '"  font.family="0" font.pitch="0" font.charset="1" background.mode="2" background.color="' + string(MenuTextBackColor) + '" )')
	ll_xpos += ll_textwidth + ll_menugap
	
	// 백그라운드용 텍스트 생성
	ll_bgxpos += pixelstounits(1, xpixelstounits!)
	ll_bgwidth = ll_xpos - ll_bgxpos - pixelstounits(1, xpixelstounits!)
	lnv_syntax.of_put(lnv_syntax.of_size() - 1, 'create text(band=header alignment="2" text="" border="0" color="33554432" x="' + string(ll_bgxpos) + '" y="0" height="' + string(dw_menubar.height) + '" width="' + string(ll_bgwidth) + '" html.valueishtml="0"  name=t_menubg_' + string(i, '00') + ' tag="' + ls_menu_id + '" visible="1"  font.face="굴림" font.height="-9" font.weight="400"  font.family="1" font.pitch="2" font.charset="1" background.mode="1" background.color="' + string(MenuTextBackColor) + '" )')
	
	// 메뉴 구분자 생성
	if len(MenuDelimiterImage) > 0 then
		ll_ypos = (dw_menubar.height - pixelstounits(MenuDelimiterHeight, ypixelstounits!)) / 2
		lnv_syntax.of_append('create bitmap(band=header filename="' + MenuDelimiterImage + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(pixelstounits(MenuDelimiterHeight, ypixelstounits!)) + '" width="' + string(pixelstounits(MenuDelimiterWidth, xpixelstounits!)) + '" border="0"  name=p_menudist_' + string(i, '00') +  ' tag="" visible="1" )')
		ll_xpos += pixelstounits(MenuDelimiterWidth, xpixelstounits!)
	end if
next

// 메뉴 길이(width) 보관
il_maxwidth = ll_xpos

// 데이터윈도우 생성
string ls_error
if lnv_syntax.of_size() > 0 then
	ls_error = dw_menubar.modify(lnv_syntax.of_tostring())
	if len(ls_error) > 0 then
		::clipboard(lnv_syntax.of_tostring())
		messagebox(dw_menubar.classname() + '.of_drawmenu() Error!!', ls_error)
		return -1
	end if
end if

// 메뉴 좌표 초기화
if dw_menubar.x <> 0 then dw_menubar.x = 0

// 리사이즈 수행
this.event resize(0, this.width, this.height)

return ll_menucnt

end function

public function long of_getmenuwidth ();return il_maxwidth

end function

public function integer of_initializemenu ();// 현재 표시된 메뉴를 초기화 합니다

// 데이터윈도우 초기화
dw_menubar.dataobject = dw_menubar.dataobject

// inv_menu 초기화
if isvalid(inv_menu) then
	destroy inv_menu
	inv_menu = create pf_n_rolemenu
end if

// 현재 선택된 메뉴 초기화
ii_selectedmenuseq = 0

// 컨트롤 좌표 초기화
if hsb_1.visible = true then hsb_1.visible = false
if dw_menubar.x <> 0 then dw_menubar.x = 0

return 0

end function

public function string of_getclassname ();return 'pf_u_mdi_menubar'

end function

on pf_u_mdi_menubar.create
int iCurrent
call super::create
this.dw_menubar=create dw_menubar
this.hsb_1=create hsb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menubar
this.Control[iCurrent+2]=this.hsb_1
end on

on pf_u_mdi_menubar.destroy
call super::destroy
destroy(this.dw_menubar)
destroy(this.hsb_1)
end on

event destructor;call super::destructor;if isvalid(inv_menu) then
	destroy inv_menu
end if

end event

event resize;call super::resize;dw_menubar.height = newheight
hsb_1.x = newwidth - hsb_1.width

if il_maxwidth > newwidth then
	hsb_1.y = (newheight - hsb_1.height) / 2
	hsb_1.visible = true
else
	dw_menubar.x = 0
	hsb_1.visible = false
end if

end event

event pfe_postopen;call super::pfe_postopen;inv_menu = create pf_n_rolemenu

end event

type p_background from pf_u_userobject`p_background within pf_u_mdi_menubar
end type

type dw_menubar from pf_u_datawindow within pf_u_mdi_menubar
integer width = 29938
integer height = 120
integer taborder = 10
boolean bringtotop = true
string dataobject = "pf_d_mdi_sheettab_disp"
boolean border = false
boolean applydesign = false
boolean singlerowselection = false
boolean useborder = false
end type

event clicked;call super::clicked;pf_n_syntaxbuffer lnv_syntax
lnv_syntax = create pf_n_syntaxbuffer
string ls_menu_id
integer li_colseq

if left(dwo.name, 7) = 'p_menu_' or left(dwo.name, 7) = 't_menu_' or left(dwo.name, 9) = 't_menubg_' then
	if ii_selectedmenuseq > 0 then
		if MenuTextBackColor = 553648127 then
			lnv_syntax.of_append('t_menu_' + string(ii_selectedmenuseq, '00') + '.Background.Mode=1')
			lnv_syntax.of_append('t_menubg_' + string(ii_selectedmenuseq, '00') + '.Background.Mode=1')
		end if
		
		lnv_syntax.of_append('t_menu_' + string(ii_selectedmenuseq, '00') + '.Background.Color=' + string(MenuTextBackColor))
		lnv_syntax.of_append('t_menubg_' + string(ii_selectedmenuseq, '00') + '.Background.Color=' + string(MenuTextBackColor))
		lnv_syntax.of_append('t_menu_' + string(ii_selectedmenuseq, '00') + '.Color=' + string(MenuTextFontColor))
		
		ii_selectedmenuseq = 0
	end if
	
	li_colseq = integer(right(dwo.name, 2))

	lnv_syntax.of_append('t_menu_' + string(li_colseq, '00') + '.Background.Mode=0')
	lnv_syntax.of_append('t_menubg_' + string(li_colseq, '00') + '.Background.Mode=0')
	lnv_syntax.of_append('t_menu_' + string(li_colseq, '00') + '.Background.Color=' + string(SelectedMenuBackColor))
	lnv_syntax.of_append('t_menubg_' + string(li_colseq, '00') + '.Background.Color=' + string(SelectedMenuBackColor))
	lnv_syntax.of_append('t_menu_' + string(li_colseq, '00') + '.Color=' + string(SelectedMenuFontColor))
	ii_selectedmenuseq = li_colseq
	
	ls_menu_id = this.describe('t_menu_' + string(li_colseq, '00') + '.Tag')
	parent.post event pfe_menuselected(ls_menu_id)
end if

string ls_error

if lnv_syntax.of_size() > 0 then
	ls_error = this.modify(lnv_syntax.of_tostring())
	if len(ls_error) > 0 then
		::clipboard(lnv_syntax.of_tostring())
		messagebox(this.classname() + '.of_clicked() Error!!', ls_error)
		return -1
	end if
end if

end event

type hsb_1 from pf_u_hscrollbar within pf_u_mdi_menubar
integer x = 2994
integer y = 12
integer width = 165
integer height = 100
boolean bringtotop = true
boolean stdheight = false
integer minposition = 1
integer maxposition = 100
integer position = 1
boolean fixedtoright = true
end type

event lineleft;call super::lineleft;if dw_menubar.x + 500 > 0 then
	dw_menubar.x = 0
else
	dw_menubar.x += 500
end if

end event

event lineright;call super::lineright;long ll_max

ll_max = (il_maxwidth - parent.width + this.width) * -1
if dw_menubar.x - 500 > ll_max then
	dw_menubar.x -= 500
else
	dw_menubar.x = ll_max
end if

end event

