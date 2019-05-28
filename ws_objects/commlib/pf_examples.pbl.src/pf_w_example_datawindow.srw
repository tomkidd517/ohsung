$PBExportHeader$pf_w_example_datawindow.srw
forward
global type pf_w_example_datawindow from pf_w_sheet
end type
type cb_close from pf_u_commandbutton within pf_w_example_datawindow
end type
type dw_freeform from pf_u_datawindow within pf_w_example_datawindow
end type
type dw_grid from pf_u_datawindow within pf_w_example_datawindow
end type
type dw_tabular from pf_u_datawindow within pf_w_example_datawindow
end type
type dw_condition from pf_u_datawindow within pf_w_example_datawindow
end type
type ddlb_target from dropdownlistbox within pf_w_example_datawindow
end type
type cb_1 from commandbutton within pf_w_example_datawindow
end type
type cb_2 from commandbutton within pf_w_example_datawindow
end type
type cb_3 from commandbutton within pf_w_example_datawindow
end type
type cb_4 from commandbutton within pf_w_example_datawindow
end type
type cb_5 from commandbutton within pf_w_example_datawindow
end type
type cb_6 from commandbutton within pf_w_example_datawindow
end type
type cb_7 from commandbutton within pf_w_example_datawindow
end type
type st_1 from statictext within pf_w_example_datawindow
end type
type st_2 from statictext within pf_w_example_datawindow
end type
type cb_8 from commandbutton within pf_w_example_datawindow
end type
type cb_10 from commandbutton within pf_w_example_datawindow
end type
type cb_9 from commandbutton within pf_w_example_datawindow
end type
type st_3 from pf_u_splitbar_vertical within pf_w_example_datawindow
end type
end forward

global type pf_w_example_datawindow from pf_w_sheet
string title = "데이터윈도우 샘플 윈도우"
cb_close cb_close
dw_freeform dw_freeform
dw_grid dw_grid
dw_tabular dw_tabular
dw_condition dw_condition
ddlb_target ddlb_target
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
st_1 st_1
st_2 st_2
cb_8 cb_8
cb_10 cb_10
cb_9 cb_9
st_3 st_3
end type
global pf_w_example_datawindow pf_w_example_datawindow

type variables

end variables

forward prototypes
public function pf_u_datawindow of_gettargetdatawindow ()
public subroutine of_insertrow (pf_u_datawindow ldw_target, long al_rows)
end prototypes

public function pf_u_datawindow of_gettargetdatawindow ();string ls_target
pf_u_datawindow ldw_target

ls_target = ddlb_target.text

choose case ls_target
	case 'Freeform'
		ldw_target = dw_freeform
	case 'Grid'
		ldw_target = dw_grid
	case 'Tabular'
		ldw_target = dw_tabular
end choose

return ldw_target

end function

public subroutine of_insertrow (pf_u_datawindow ldw_target, long al_rows);long i

for i = 1 to al_rows
	ldw_target.insertrow(0)
next

end subroutine

on pf_w_example_datawindow.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_freeform=create dw_freeform
this.dw_grid=create dw_grid
this.dw_tabular=create dw_tabular
this.dw_condition=create dw_condition
this.ddlb_target=create ddlb_target
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.st_1=create st_1
this.st_2=create st_2
this.cb_8=create cb_8
this.cb_10=create cb_10
this.cb_9=create cb_9
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_freeform
this.Control[iCurrent+3]=this.dw_grid
this.Control[iCurrent+4]=this.dw_tabular
this.Control[iCurrent+5]=this.dw_condition
this.Control[iCurrent+6]=this.ddlb_target
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.cb_4
this.Control[iCurrent+11]=this.cb_5
this.Control[iCurrent+12]=this.cb_6
this.Control[iCurrent+13]=this.cb_7
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.cb_8
this.Control[iCurrent+17]=this.cb_10
this.Control[iCurrent+18]=this.cb_9
this.Control[iCurrent+19]=this.st_3
end on

on pf_w_example_datawindow.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_freeform)
destroy(this.dw_grid)
destroy(this.dw_tabular)
destroy(this.dw_condition)
destroy(this.ddlb_target)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_8)
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.st_3)
end on

event open;call super::open;dw_freeform.settransobject(sqlca)
dw_grid.settransobject(sqlca)
dw_tabular.settransobject(sqlca)

end event

event pfe_postopen;call super::pfe_postopen;integer i

dw_condition.insertrow(0)
dw_freeform.insertrow(0)

for i = 1 to 30
	dw_grid.insertrow(0)
	dw_tabular.insertrow(0)
next

ddlb_target.text = 'Grid'

end event

type ln_templeft from pf_w_sheet`ln_templeft within pf_w_example_datawindow
end type

type ln_tempright from pf_w_sheet`ln_tempright within pf_w_example_datawindow
end type

type ln_temptop from pf_w_sheet`ln_temptop within pf_w_example_datawindow
end type

type ln_tempbuttom from pf_w_sheet`ln_tempbuttom within pf_w_example_datawindow
end type

type ln_tempbutton from pf_w_sheet`ln_tempbutton within pf_w_example_datawindow
end type

type ln_tempstart from pf_w_sheet`ln_tempstart within pf_w_example_datawindow
end type

type cb_close from pf_u_commandbutton within pf_w_example_datawindow
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

type dw_freeform from pf_u_datawindow within pf_w_example_datawindow
integer x = 2409
integer y = 140
integer width = 2135
integer height = 1188
integer taborder = 40
boolean bringtotop = true
string title = "Presentation Style = Freeform"
string dataobject = "pf_d_com_code_mst_03"
boolean applydesign = false
boolean singlerowselection = false
boolean alternativerowcolor = false
boolean dworesize = true
boolean popupmenu = false
boolean useborder = false
boolean displaytitleontop = true
boolean addcolumnpadding = false
boolean confirmupdateonrowchange = false
boolean scaletoright = true
end type

type dw_grid from pf_u_datawindow within pf_w_example_datawindow
integer x = 649
integer y = 416
integer width = 1737
integer height = 1812
integer taborder = 50
boolean bringtotop = true
string title = "Presentation Style = Grid"
string dataobject = "pf_d_com_code_mst_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = false
boolean singlerowselection = false
boolean alternativerowcolor = false
boolean popupmenu = false
boolean useborder = false
boolean displaytitleontop = true
boolean scaletobottom = true
end type

type dw_tabular from pf_u_datawindow within pf_w_example_datawindow
integer x = 2409
integer y = 1352
integer width = 2135
integer height = 872
integer taborder = 60
boolean bringtotop = true
string title = "Presentation Style = Tabular"
string dataobject = "pf_d_com_code_mst_05_nouse"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = false
boolean singlerowselection = false
boolean alternativerowcolor = false
boolean popupmenu = false
boolean useborder = false
boolean scaletoright = true
boolean scaletobottom = true
end type

type dw_condition from pf_u_datawindow within pf_w_example_datawindow
integer x = 649
integer y = 140
integer width = 1737
integer height = 252
integer taborder = 50
boolean bringtotop = true
string title = "Presentation Style = Search Criteria"
string dataobject = "pf_d_com_code_mst_01"
boolean issearchcondition = true
boolean displaytitleontop = true
end type

type ddlb_target from dropdownlistbox within pf_w_example_datawindow
integer x = 46
integer y = 220
integer width = 549
integer height = 476
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20066866
string item[] = {"Freeform","Grid","Tabular"}
end type

type cb_1 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 452
integer width = 549
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "Apply Design"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.applydesign = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_2 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 576
integer width = 549
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "SingleRowSelection"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.singlerowselection = true
ldw_target.multirowselection = false
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_3 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 700
integer width = 549
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "MultiRowSelection"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.singlerowselection = false
ldw_target.multirowselection = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_4 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 824
integer width = 549
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "SortByHeader"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.sortbyheader = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_5 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 948
integer width = 549
integer height = 104
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "UseBorder"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.useborder = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_6 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 1072
integer width = 549
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "PasteClipboard"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.pasteClipboard = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_7 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 1196
integer width = 549
integer height = 104
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "PopupMenu"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.popupmenu = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type st_1 from statictext within pf_w_example_datawindow
integer x = 41
integer y = 368
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 25123896
string text = "Datawindow Options"
boolean focusrectangle = false
end type

type st_2 from statictext within pf_w_example_datawindow
integer x = 41
integer y = 140
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 25123896
string text = "Target Datawindow"
boolean focusrectangle = false
end type

type cb_8 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 1444
integer width = 549
integer height = 104
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "Chg Dataobject"
end type

event clicked;//dw_grid.dataobject = 'pf_d_com_code_mst_03'

// 데이터윈도우 오브젝트를 변경한 후 디자인을 적용하려면
// 아래와 같이 함수 호출로 Dataobject 설정
dw_grid.of_setdataobject('pf_d_com_code_mst_03')

dw_grid.insertrow(0)

end event

type cb_10 from commandbutton within pf_w_example_datawindow
integer x = 46
integer y = 1320
integer width = 553
integer height = 104
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "AddColumnPadding"
end type

event clicked;pf_u_datawindow ldw_target

ldw_target = of_gettargetdatawindow()
ldw_target.addcolumnpadding = true
ldw_target.of_setdataobject(ldw_target.dataobject)
of_insertrow(ldw_target, 50)

end event

type cb_9 from commandbutton within pf_w_example_datawindow
boolean visible = false
integer x = 46
integer y = 1568
integer width = 549
integer height = 104
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "call dll func"
end type

event clicked;//string ls_filename[]
//
//ls_filename[1] = "C:\Users\haan\Pictures\ie_error.jpg"
//ls_filename[2] = "C:\Users\haan\Pictures\ie_plugin.png"
//ls_filename[3] = "C:\Users\haan\Pictures\LicenseHistory.png"
//
//if gnv_extfunc.pf_createmultipagetiff(ls_filename, upperbound(ls_filename), "c:\temp\example.tiff") = 1 then
//	// 성공
//else
//	// 실패
//end if
//
////gnv_extfunc.testBuildMPage("c:\temp\hqdefault.jpg", "c:\temp\hqdefault.tiff", 24);


// OZ-eForm 추출 JSON이미지 파일
//string ls_jsondata, ls_encoded
//integer li_filenum
//long li_pos, li_lastpos
//
//li_filenum = FileOpen("c:\temp\jsondata.txt", TextMode!, Read!, LockRead!) //, Append!, EncodingUTF8!)
//if li_filenum = -1 then return
//
//FileReadEx(li_filenum, ls_jsondata)
//FileClose(li_filenum)
//
//li_pos = pos(ls_jsondata, ';base64,')
//li_lastpos = lastpos(ls_jsondata, '","imgurl":"')
//
//ls_encoded = mid(ls_jsondata, li_pos + 8, li_lastpos - (li_pos + 8))
//
//// Base64 Decode
//pf_n_cryptoapi lnv_crypto
//blob lblb_decoded
//
//lblb_decoded = lnv_crypto.of_decode64(ls_encoded)
//
//// Create png file
//li_filenum = FileOpen("c:\temp\sign.png", StreamMode! , Write!, LockWrite!, Replace!)
//if li_filenum = -1 then return
//
//FileWriteEx(li_filenum, lblb_decoded)
//FileClose(li_filenum)





end event

type st_3 from pf_u_splitbar_vertical within pf_w_example_datawindow
integer x = 2386
integer y = 144
integer height = 2076
boolean bringtotop = true
string leftdragobject = "dw_condition; dw_grid"
string rightdragobject = "dw_freeform; dw_tabular"
end type

