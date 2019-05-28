﻿$PBExportHeader$pf_n_dwdesign.sru
$PBExportComments$데이터윈도우 디자인용 NVO 입니다. 파워프레임은 각 데이터윈도우 오브젝트의 Presentation Style 별로~r~n디자인용 NVO가 존재하는데 이 NVO들의 Parent 역할을 하는 오브젝트 입니다.
forward
global type pf_n_dwdesign from pf_n_nonvisualobject
end type
end forward

global type pf_n_dwdesign from pf_n_nonvisualobject
event clicked pbm_dwnlbuttonclk
event resize pbm_dwnresize
event rowfocuschanged pbm_dwnrowchange
event rowfocuschanging pbm_dwnrowchanging
event itemchanged pbm_dwnitemchange
event itemerror pbm_dwnitemvalidationerror
event itemfocuschanged pbm_dwnitemchangefocus
event losefocus pbm_dwnkillfocus
event getfocus pbm_dwnsetfocus
event rbuttondown pbm_dwnrbuttondown
event columnmove pbm_dwnmousemove
event move pbm_move
event pfe_visiblechanged ( )
event pfe_dwowidthchanged ( )
event pfe_mouseleave ( )
event pfe_mouseover ( long al_row,  dwobject ao_dwo )
end type
global pf_n_dwdesign pf_n_dwdesign

type variables
protected:
	datawindow idw_target
	graphicobject igo_parent
	window iw_parent

public:
	boolean ib_dataobject_syntax
	
end variables

forward prototypes
public function integer of_applydesign ()
public function string of_getclassname ()
public function integer of_drawcustomborder ()
public function boolean of_modify (pf_n_syntaxbuffer anv_syntax)
public function long of_getdwomaxwidth ()
public function string of_getinnersyntax (string as_syntax)
public function string of_fixescapechar (string as_syntax)
public function string of_getexpvalue (string as_exp, long al_row)
public function integer of_resetdwdisplayorder (string as_classname)
public function string of_getlastobject (string as_band)
public subroutine of_initialize (readonly datawindow adw_datawindow, window aw_parent)
end prototypes

event clicked;// Clicked Event
// 컬럼 테두리 영역 클릭 시 해당 테두리의 컬럼을 선택해줍니다.
if right(dwo.name, 5) = '_rect' then
	string ls_column
	ls_column = string(dwo.name)
	ls_column = left(ls_column, len(ls_column) - 5)
	if long(idw_target.describe(ls_column + ".ID")) > 0 then
		idw_target.setcolumn(ls_column)
	end if
end if

return 0

end event

event resize;// Resize Event
end event

event rowfocuschanged;// RowFocuschanged Event
end event

event rowfocuschanging;// RowFocusChanging Event
end event

event itemchanged;// ItemChanged Event
end event

event itemerror;// itemError Event
end event

event losefocus;// losefocus Event
end event

event getfocus;// getFocus Event
end event

event rbuttondown;// rbuttondown Event
end event

event columnmove;// ColumnMove

end event

event move;// move event

end event

public function integer of_applydesign ();return 0

end function

public function string of_getclassname ();return 'pf_n_dwdesign'

end function

public function integer of_drawcustomborder ();return 0

end function

public function boolean of_modify (pf_n_syntaxbuffer anv_syntax);string ls_error

ls_error = idw_target.Modify(anv_syntax.of_toString())
if len(ls_error) > 0 then
	::clipboard(idw_target.classname() + "~r~n" + anv_syntax.of_toString())
	messagebox("Error", idw_target.classname() + " Syntax Modification Failure!! : " + ls_error)
	return false
end if

return true

end function

public function long of_getdwomaxwidth ();string ls_object, ls_objarr[]
long i, ll_objcnt
long ll_objpos, ll_maxpos

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = pf_f_parsetoarray(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	if ls_objarr[i] = 'p_header_bg' then continue
	if idw_target.describe(ls_objarr[i] + ".Band") = 'header' then
		if idw_target.describe(ls_objarr[i] + ".Visible") = '1' then
			ll_objpos = long(idw_target.describe(ls_objarr[i] + ".X")) + long(idw_target.describe(ls_objarr[i] + ".Width"))
			if ll_maxpos < ll_objpos then
				ll_maxpos = ll_objpos
			end if
		end if
	end if
next

return ll_maxpos

end function

public function string of_getinnersyntax (string as_syntax);long ll_pos
string ls_searchstr[] = { '"', '~"', '~~~"', '~~~~~"', '~~~~~~~~"', '~~~~~~~~~~"', '~~~~~~~~~~~~"', '~~~~~~~~~~~~~~"' }
integer i

// replace double quotation.
for i = 7 to 1 step -1
	ll_pos = pos(as_syntax, ls_searchstr[i])
	do while ll_pos > 0
		as_syntax = replace(as_syntax, ll_pos, len(ls_searchstr[i]), ls_searchstr[i + 1])
		ll_pos = pos(as_syntax, ls_searchstr[i], ll_pos + len(ls_searchstr[i + 1]))
	loop
next

return as_syntax

end function

public function string of_fixescapechar (string as_syntax);long ll_pos
string ls_tilde = "~~"

// double quotation
ll_pos = pos(as_syntax, ls_tilde + ls_tilde + '"')
do while ll_pos > 0
	as_syntax = replace(as_syntax, ll_pos, 3, ls_tilde + ls_tilde + ls_tilde + '"')
	ll_pos = pos(as_syntax, ls_tilde + ls_tilde + '"', ll_pos + 4)
loop

// single quotation
ll_pos = pos(as_syntax, ls_tilde + ls_tilde + "'")
do while ll_pos > 0
	as_syntax = replace(as_syntax, ll_pos, 3, ls_tilde + ls_tilde + ls_tilde + "'")
	ll_pos = pos(as_syntax, ls_tilde + ls_tilde + "'", ll_pos + 4)
loop

return as_syntax

end function

public function string of_getexpvalue (string as_exp, long al_row);string ls_quote = '"', ls_exp

if not isvalid(idw_target) then return ''
if pos(as_exp, '"') > 0 then ls_quote = "'"
ls_exp = 'evaluate(' + ls_quote + as_exp + ls_quote + ',' + string(al_row) + ')'

return string(idw_target.describe(ls_exp))

end function

public function integer of_resetdwdisplayorder (string as_classname);// 윈도우 컨트롤 Display Order를 다시 설정한다
if not isvalid(iw_parent) then return -1

long ll_ctrlcnt
integer i, j
dragobject ldo_upper, ldo_lower, ldo_totop

//ll_ctrlcnt = upperbound(iw_parent.control)
//for i = 1 to ll_ctrlcnt
//	choose case iw_parent.control[i].typeof()
//		case line!, oval!, rectangle!, roundrectangle!
//			continue
//		case else
//			ldo_upper = iw_parent.control[i]
//	end choose
//next
//
//for j = i to ll_ctrlcnt
//	choose case iw_parent.control[j].typeof()
//		case line!, oval!, rectangle!, roundrectangle!
//			continue
//	end choose
//	
//	ldo_lower = iw_parent.control[j]
//	ldo_lower.setposition(behind!, ldo_upper)
//	ldo_upper = ldo_lower
//next
//
//for i = 1 to ll_ctrlcnt
//	choose case iw_parent.control[i].typeof()
//		case line!, oval!, rectangle!, roundrectangle!
//			continue
//	end choose
//	
//	ldo_totop = iw_parent.control[i]
//	if ldo_totop.bringtotop = true then
//		ldo_totop.bringtotop = true
//	end if
//next
//
////ll_ctrlcnt = upperbound(iw_parent.control)
////for i = 1 to ll_ctrlcnt
////	if iw_parent.control[i].classname() = as_classname then
////		if i > 1 then
////			idw_target.setposition(Behind!, iw_parent.control[i - 1])
////		end if
////	end if
////next

window lw_parent
userobject luo_parent
windowobject lwo_control[]

choose case igo_parent.typeof()
	case window!
		lw_parent = igo_parent
		lwo_control = lw_parent.control
	case userobject!
		luo_parent = igo_parent
		lwo_control = luo_parent.control
end choose

ll_ctrlcnt = upperbound(lwo_control)
for i = 1 to ll_ctrlcnt
	choose case lwo_control[i].typeof()
		case line!, oval!, rectangle!, roundrectangle!, mdiclient!
			continue
	end choose
	
	ldo_totop = lwo_control[i]
	if ldo_totop.bringtotop = true then
		ldo_totop.bringtotop = true
	end if
next

return 1

end function

public function string of_getlastobject (string as_band);// 데이터윈도우 오브젝트 중 오른쪽 가장 마지막에 위치한 오브젝트명을 리터합니다
// as_band: 오브젝트를 검색할 밴드(header, detail, summary, footer)
// 리턴값: 오른쪽 가장 마지막 오브젝트명

string ls_object, ls_objarr[]
string ls_lastobj
long i, ll_objcnt
long ll_objpos, ll_maxpos

if isnull(as_band) or as_band = '' then return ''

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = pf_f_parsetoarray(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	if ls_objarr[i] = 'p_header_bg' then continue
	if idw_target.describe(ls_objarr[i] + ".Band") = as_band then
		if idw_target.describe(ls_objarr[i] + ".Visible") = '1' then
			ll_objpos = long(idw_target.describe(ls_objarr[i] + ".X")) + long(idw_target.describe(ls_objarr[i] + ".Width"))
			if ll_maxpos < ll_objpos then
				ll_maxpos = ll_objpos
				ls_lastobj = ls_objarr[i]
			end if
		end if
	end if
next

return ls_lastobj

end function

public subroutine of_initialize (readonly datawindow adw_datawindow, window aw_parent);// parent datawindow / window 등록
idw_target = adw_datawindow
igo_parent = idw_target.getparent()
iw_parent = aw_parent

end subroutine

on pf_n_dwdesign.create
call super::create
end on

on pf_n_dwdesign.destroy
call super::destroy
end on

