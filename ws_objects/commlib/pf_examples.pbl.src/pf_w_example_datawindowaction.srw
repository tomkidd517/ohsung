﻿$PBExportHeader$pf_w_example_datawindowaction.srw
forward
global type pf_w_example_datawindowaction from pf_w_sheet
end type
type cb_close from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type dw_2 from pf_u_datawindow within pf_w_example_datawindowaction
end type
type dw_1 from pf_u_datawindow within pf_w_example_datawindowaction
end type
type cb_1 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type dw_3 from pf_u_datawindow within pf_w_example_datawindowaction
end type
type dw_4 from pf_u_datawindow within pf_w_example_datawindowaction
end type
type cb_2 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_3 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_4 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_5 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_6 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_7 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_8 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
type cb_9 from pf_u_commandbutton within pf_w_example_datawindowaction
end type
end forward

global type pf_w_example_datawindowaction from pf_w_sheet
string title = "웹 에디터 샘플 윈도우"
cb_close cb_close
dw_2 dw_2
dw_1 dw_1
cb_1 cb_1
dw_3 dw_3
dw_4 dw_4
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
cb_8 cb_8
cb_9 cb_9
end type
global pf_w_example_datawindowaction pf_w_example_datawindowaction

type variables

end variables

on pf_w_example_datawindowaction.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.cb_8=create cb_8
this.cb_9=create cb_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_3
this.Control[iCurrent+6]=this.dw_4
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.cb_6
this.Control[iCurrent+12]=this.cb_7
this.Control[iCurrent+13]=this.cb_8
this.Control[iCurrent+14]=this.cb_9
end on

on pf_w_example_datawindowaction.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.cb_8)
destroy(this.cb_9)
end on

type ln_templeft from pf_w_sheet`ln_templeft within pf_w_example_datawindowaction
end type

type ln_tempright from pf_w_sheet`ln_tempright within pf_w_example_datawindowaction
end type

type ln_temptop from pf_w_sheet`ln_temptop within pf_w_example_datawindowaction
end type

type ln_tempbuttom from pf_w_sheet`ln_tempbuttom within pf_w_example_datawindowaction
end type

type ln_tempbutton from pf_w_sheet`ln_tempbutton within pf_w_example_datawindowaction
end type

type ln_tempstart from pf_w_sheet`ln_tempstart within pf_w_example_datawindowaction
end type

type cb_close from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 4279
integer y = 32
integer width = 274
integer height = 96
integer taborder = 10
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "닫기"
string powertiptext = "해당 화면을 닫습니다."
boolean applydesign = false
boolean fixedtoright = true
end type

event clicked;call super::clicked;close(parent)
end event

type dw_2 from pf_u_datawindow within pf_w_example_datawindowaction
integer x = 50
integer y = 368
integer width = 2258
integer height = 1852
integer taborder = 20
boolean bringtotop = true
string title = "공통코드 내역"
string dataobject = "pf_d_com_code_mst_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean displaytitleontop = true
boolean datawindowaction = true
string retrievalarguments = "as_sys_id = session.sys_id; as_upper_code_id = dw_1.upper_code_id"
boolean scaletobottom = true
end type

type dw_1 from pf_u_datawindow within pf_w_example_datawindowaction
integer x = 50
integer y = 164
integer width = 2258
integer height = 168
integer taborder = 30
boolean bringtotop = true
string dataobject = "pf_d_com_code_mst_01"
boolean issearchcondition = true
boolean datawindowaction = true
string defaultvaluesoninsertrow = "upper_code_id=~'ROOT~'"
end type

type cb_1 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 2606
integer y = 32
integer width = 274
integer height = 96
integer taborder = 20
boolean bringtotop = true
string text = "조회"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_2"
string datawindowaction = "retrieve"
end type

type dw_3 from pf_u_datawindow within pf_w_example_datawindowaction
integer x = 2350
integer y = 164
integer width = 2199
integer height = 1184
integer taborder = 30
boolean bringtotop = true
string title = "공통코드 상세내역"
string dataobject = "pf_d_com_code_mst_03"
boolean displaytitleontop = true
boolean datawindowaction = true
string uplinkeddatawindow = "dw_2.sharedata"
string retrievalarguments = "as_sys_id = session.sys_id; as_upper_code_id = dw_2.upper_code_id; as_code_id = dw_2.code_id"
string defaultvaluesoninsertrow = "sys_id=session.sys_id; upper_code_id=dw_1.upper_code_id"
boolean scaletoright = true
end type

event doubleclicked;call super::doubleclicked;::clipboard(this.describe("datawindow.syntax"))

end event

type dw_4 from pf_u_datawindow within pf_w_example_datawindowaction
integer x = 2350
integer y = 1376
integer width = 2199
integer height = 844
integer taborder = 40
boolean bringtotop = true
string title = "하위 공통코드 내역"
string dataobject = "pf_d_com_code_mst_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean displaytitleontop = true
boolean datawindowaction = true
string uplinkeddatawindow = "dw_2"
string retrievalarguments = "as_sys_id = session.sys_id; as_upper_code_id = dw_2.code_id; "
string defaultvaluesoninsertrow = "sys_id=session.sys_id; upper_code_id=dw_2.code_id; use_yn=~'Y~'"
boolean scaletoright = true
boolean scaletobottom = true
end type

type cb_2 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 2885
integer y = 32
integer width = 274
integer height = 96
integer taborder = 10
boolean bringtotop = true
string text = "추가"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_3"
string datawindowaction = "insertrow"
end type

type cb_3 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 3163
integer y = 32
integer width = 274
integer height = 96
integer taborder = 20
boolean bringtotop = true
string text = "저장"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_3"
string datawindowaction = "update"
end type

type cb_4 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 3442
integer y = 32
integer width = 274
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "삭제"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_3"
string datawindowaction = "delete"
end type

type cb_5 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 3721
integer y = 32
integer width = 274
integer height = 96
integer taborder = 40
boolean bringtotop = true
string text = "인쇄"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_2"
string datawindowaction = "print"
end type

type cb_6 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 4000
integer y = 32
integer width = 274
integer height = 96
integer taborder = 50
boolean bringtotop = true
string text = "엑셀"
boolean applydesign = false
boolean fixedtoright = true
string referencedobject = "dw_2"
string datawindowaction = "excel"
end type

type cb_7 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 4000
integer y = 1348
integer width = 274
integer height = 96
integer taborder = 40
boolean bringtotop = true
string text = "행추가"
boolean fixedtoright = true
string referencedobject = "dw_4"
string datawindowaction = "insertrow"
end type

type cb_8 from pf_u_commandbutton within pf_w_example_datawindowaction
integer x = 4279
integer y = 1348
integer width = 274
integer height = 96
integer taborder = 50
boolean bringtotop = true
string text = "행삭제"
boolean fixedtoright = true
string referencedobject = "dw_4"
string datawindowaction = "delete"
end type

type cb_9 from pf_u_commandbutton within pf_w_example_datawindowaction
boolean visible = false
integer x = 1833
integer y = 36
integer width = 274
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "PBCOM"
boolean applydesign = false
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 웹환경이 아닌 경우 Return
//if gnv_appmgr.is_clienttype <> 'WEB' then return -1

string ls_clsid, ls_cachedir

//if gnv_appmgr.is_clienttype = 'WEB' then
//	// dll 참조 경로 설정
//	ls_cachedir = appeongetcachedir() + '\plugin'
//	messagebox('setdlldirectory', ls_cachedir)
//	gnv_extfunc.setdlldirectory(ls_cachedir)
//	
//	// com component 등록 처리
//	if RegistryGet("HKEY_CLASSES_ROOT\PB105.n_pbcom.1.0", "CLSID", RegString!, ls_clsid) = -1 then
//		run('regsvr32.exe /s "' + ls_cachedir + '\pbcom.dll"')
//		messagebox('run', 'regsvr32 /s "' + ls_cachedir + '\pbcom.dll"')
//	end if
//end if

oleobject lnv_pbcom
integer li_rc

lnv_pbcom = create oleobject
li_rc = lnv_pbcom.connecttonewobject("penta.n_pbcom.1.2")
if li_rc < 0 then
	messagebox('', 'failed to connect to new object! > ' + string(li_rc))
	return -1
end if

string ls_syntax, ls_data

ls_syntax = dw_2.describe("datawindow.syntax")
ls_data = dw_2.describe("datawindow.data")

li_rc = lnv_pbcom.of_saveas(ls_syntax, ls_data, "c:\temp\saveasascii.txt")
messagebox('returl value', li_rc)

destroy lnv_pbcom

end event

