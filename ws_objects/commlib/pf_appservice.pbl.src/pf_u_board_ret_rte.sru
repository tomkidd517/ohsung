﻿$PBExportHeader$pf_u_board_ret_rte.sru
$PBExportComments$게시물 조회용 사용자 오브젝트 입니다. 게시물 리스트와 게시 내용을 확인할 수 있습니다.
forward
global type pf_u_board_ret_rte from pf_u_userobject
end type
type dw_list from pf_u_datawindow within pf_u_board_ret_rte
end type
type dw_mast from pf_u_datawindow within pf_u_board_ret_rte
end type
type cb_refresh from pf_u_commandbutton within pf_u_board_ret_rte
end type
end forward

global type pf_u_board_ret_rte from pf_u_userobject
integer width = 3328
integer height = 2036
event ue_retrieve ( )
dw_list dw_list
dw_mast dw_mast
cb_refresh cb_refresh
end type
global pf_u_board_ret_rte pf_u_board_ret_rte

type variables
string is_board_no = '0000001'

pf_n_dwrescale inv_rescale

end variables

event ue_retrieve();datetime ldtm_today
pf_n_userrole lnv_userrole
lnv_userrole = gnv_session.of_get('userrole')

ldtm_today = pf_f_getdbmsdatetime()

dw_list.reset()
dw_list.retrieve(gnv_session.is_sys_id, is_board_no, lnv_userrole.is_userrole[], ldtm_today)

end event

on pf_u_board_ret_rte.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_mast=create dw_mast
this.cb_refresh=create cb_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_mast
this.Control[iCurrent+3]=this.cb_refresh
end on

on pf_u_board_ret_rte.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_mast)
destroy(this.cb_refresh)
end on

event resize;call super::resize;dw_list.width = newwidth - dw_list.x * 2
dw_list.height = newheight - dw_list.y - pixelstounits(1, ypixelstounits!)

cb_refresh.x = dw_list.x + dw_list.width - cb_refresh.width - pixelstounits(6, xpixelstounits!)

end event

event pfe_postopen;call super::pfe_postopen;dw_mast.settransobject(sqlca)
dw_list.settransobject(sqlca)

if dw_mast.retrieve(gnv_session.is_sys_id, is_board_no) = 0 then
	messagebox('알림', 'board_no 속성을 확인하세요')
	//close(parent)
end if

this.event ue_retrieve()

end event

event constructor;call super::constructor;choose case pf_f_getdbmstype(sqlca)
	// Oracle
	case 'Oracle'
		dw_list.dataobject = 'pf_d_board_ret_01_oracle'
	// Other
	case else
		dw_list.dataobject = 'pf_d_board_ret_01_asa'
end choose

inv_rescale = create pf_n_dwrescale
inv_rescale.of_register(dw_list)

end event

type p_background from pf_u_userobject`p_background within pf_u_board_ret_rte
end type

type dw_list from pf_u_datawindow within pf_u_board_ret_rte
integer x = 37
integer y = 100
integer width = 3255
integer height = 1908
integer taborder = 10
boolean bringtotop = true
string dataobject = "pf_d_board_ret_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
end type

event doubleclicked;call super::doubleclicked;if row = 0 then return

string ls_board_no, ls_log_yn
long ll_docu_no

ls_board_no = this.getitemstring(row, 'board_no')
ll_docu_no = this.getitemnumber(row, 'docu_no')
ls_log_yn = dw_mast.getitemstring(1, 'make_log_yn')
if isnull(ls_log_yn) then ls_log_yn = 'N'

openwithparm(pf_w_board_doc_view_rte, ls_board_no + '~t' + string(ll_docu_no) + '~t' + ls_log_yn)

end event

event resize;call super::resize;inv_rescale.of_resize(this.width, this.height)

end event

type dw_mast from pf_u_datawindow within pf_u_board_ret_rte
integer x = 37
integer width = 2834
integer height = 96
integer taborder = 10
boolean bringtotop = true
string dataobject = "pf_d_board_ret_02"
boolean border = false
boolean applydesign = false
boolean useborder = false
boolean scaletoright = true
end type

type cb_refresh from pf_u_commandbutton within pf_u_board_ret_rte
integer x = 2958
integer width = 338
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string text = "Refresh"
boolean fixedtoright = true
end type

event clicked;call super::clicked;parent.post event ue_retrieve()

end event

