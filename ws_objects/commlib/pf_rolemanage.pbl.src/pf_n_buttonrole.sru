﻿$PBExportHeader$pf_n_buttonrole.sru
$PBExportComments$프로그램별 사용자의 버튼 권한을 담당하는 오브젝트 입니다.
forward
global type pf_n_buttonrole from pf_n_nonvisualobject
end type
end forward

global type pf_n_buttonrole from pf_n_nonvisualobject
end type
global pf_n_buttonrole pf_n_buttonrole

type variables
private:
	pf_w_window iw_parent
	windowobject iwo_disabled[]
	
	string is_menu_id
	datastore ids_commbtn
	datastore ids_indivbtn
	
	string is_retbtn[]
	string is_inpbtn[]
	string is_delbtn[]
	string is_updbtn[]
	string is_prtbtn[]
	string is_exebtn[]
	string is_canbtn[]
	string is_xlsbtn[]

public:
	boolean ib_indiv_btn_auth_yn
	boolean ib_comm_btn_auth_yn
	
	boolean ib_retbtn_yn
	boolean ib_inpbtn_yn
	boolean ib_delbtn_yn
	boolean ib_updbtn_yn
	boolean ib_prtbtn_yn
	boolean ib_exebtn_yn
	boolean ib_canbtn_yn
	boolean ib_xlsbtn_yn

end variables

forward prototypes
public function integer of_registerbutton (string as_authtype, string as_btnname)
public function integer of_registerbuttonarr (string as_authtype, string as_btnname[])
public function integer of_authorize ()
public function long of_getwindowcontrols (windowobject awo_input[], ref windowobject awo_output[])
public function integer of_authorizecommonbutton ()
public function string of_findoutcommonbuttontype (string as_buttonid)
public function long of_findstringinarray (readonly string as_stringarr[], readonly string as_findstr)
public function integer of_setenableattr (ref windowobject awo_control, string as_enable_yn)
public function integer of_authorizeindividualbutton ()
public function integer of_setenableattr (ref windowobject awo_control, boolean ab_enabled)
public function boolean of_getenableattr (readonly windowobject awo_control)
public function boolean of_getcolumnmeanvalue (string as_authtype, string as_columnname)
public subroutine of_registerparent (window aw_parent)
end prototypes

public function integer of_registerbutton (string as_authtype, string as_btnname);if isnull(as_btnname) or len(as_btnname) = 0 then return -1

integer li_arrseq

choose case as_authtype
	case 'retrieve'
		li_arrseq = upperbound(is_retbtn) + 1
		is_retbtn[li_arrseq] = as_btnname
	case 'insert', 'input'
		li_arrseq = upperbound(is_inpbtn) + 1
		is_inpbtn[li_arrseq] = as_btnname
	case 'delete'
		li_arrseq = upperbound(is_delbtn) + 1
		is_delbtn[li_arrseq] = as_btnname
	case 'update'
		li_arrseq = upperbound(is_updbtn) + 1
		is_updbtn[li_arrseq] = as_btnname
	case 'print'
		li_arrseq = upperbound(is_prtbtn) + 1
		is_prtbtn[li_arrseq] = as_btnname
	case 'execute'
		li_arrseq = upperbound(is_exebtn) + 1
		is_exebtn[li_arrseq] = as_btnname
	case 'cancel'
		li_arrseq = upperbound(is_canbtn) + 1
		is_canbtn[li_arrseq] = as_btnname
	case 'excel'
		li_arrseq = upperbound(is_xlsbtn) + 1
		is_xlsbtn[li_arrseq] = as_btnname
	case else
		return 0
end choose

return 1

end function

public function integer of_registerbuttonarr (string as_authtype, string as_btnname[]);if isnull(as_btnname) or upperbound(as_btnname) = 0 then return -1

choose case as_authtype
	case 'retrieve'
		is_retbtn = as_btnname
	case 'insert', 'input'
		is_inpbtn = as_btnname
	case 'delete'
		is_delbtn = as_btnname
	case 'update'
		is_updbtn = as_btnname
	case 'print'
		is_prtbtn = as_btnname
	case 'execute'
		is_exebtn = as_btnname
	case 'cancel'
		is_canbtn = as_btnname
	case 'excel'
		is_xlsbtn = as_btnname
	case else
		return 0
end choose

return 1

end function

public function integer of_authorize ();// Sheet 윈도우 버튼의 권한 설정

if isnull(iw_parent) or not isvalid(iw_parent) then return -1

// 공통버튼 권한 처리
if ib_comm_btn_auth_yn then
	this.of_authorizecommonbutton()
end if

// 개별버튼 권한 처리
if ib_indiv_btn_auth_yn then
	this.of_authorizeindividualbutton()
end if

return 1

end function

public function long of_getwindowcontrols (windowobject awo_input[], ref windowobject awo_output[]);long ll_Input, ll_InputCount, ll_OutputCount, ll_Sub, ll_SubCount
userobject luo_UserObject
tab ltb_Tab
windowobject lwo_Empty[], lwo_Sub[]

awo_Output = lwo_Empty

ll_InputCount = UpperBound (awo_Input)
FOR ll_Input = 1 TO ll_InputCount
	// Visible 또는 Enable 속성이 False 인 경우 사용하지 않겠다는 의미로 간주, 관리대상에 넣지 않는다
	IF awo_Input[ll_Input].visible = False OR of_getenableattr(awo_Input[ll_Input]) = False THEN Continue
	
    ll_OutputCount ++
    awo_Output[ll_OutputCount] = awo_Input[ll_Input]
	
    CHOOSE CASE awo_Input[ll_Input].TypeOf()
        CASE UserObject!
            luo_UserObject = awo_Input[ll_Input]
            ll_SubCount = of_getwindowcontrols (luo_UserObject.Control, lwo_Sub)
            FOR ll_Sub = 1 TO ll_SubCount
                ll_OutputCount ++
                awo_Output[ll_OutputCount] = lwo_Sub[ll_Sub]
            NEXT

        CASE Tab!
            ltb_Tab = awo_Input[ll_Input]
            ll_SubCount = of_getwindowcontrols (ltb_Tab.Control, lwo_Sub)
            FOR ll_Sub = 1 TO ll_SubCount
                ll_OutputCount ++
                awo_Output[ll_OutputCount] = lwo_Sub[ll_Sub]
            NEXT
    END CHOOSE
NEXT

RETURN ll_OutputCount

end function

public function integer of_authorizecommonbutton ();integer i, li_objcnt

li_objcnt = upperbound(iw_parent.iwo_control)
for i = 1 to li_objcnt
	choose case this.of_findoutcommonbuttontype(iw_parent.iwo_control[i].classname())
		case 'retrieve'
			of_setenableattr(iw_parent.iwo_control[i], ib_retbtn_yn)
		case 'insert', 'input'
			of_setenableattr(iw_parent.iwo_control[i], ib_inpbtn_yn)
		case 'delete'
			of_setenableattr(iw_parent.iwo_control[i], ib_delbtn_yn)
		case 'update'
			of_setenableattr(iw_parent.iwo_control[i], ib_updbtn_yn)
		case 'print'
			of_setenableattr(iw_parent.iwo_control[i], ib_prtbtn_yn)
		case 'execute'
			of_setenableattr(iw_parent.iwo_control[i], ib_exebtn_yn)
		case 'cancel'
			of_setenableattr(iw_parent.iwo_control[i], ib_canbtn_yn)
		case 'excel'
			of_setenableattr(iw_parent.iwo_control[i], ib_xlsbtn_yn)
	end choose
next

return 1

end function

public function string of_findoutcommonbuttontype (string as_buttonid);// as_button_id 이름으로 등록된 공통버튼을 찾고 그 타입을 리턴한다

// retrieve
if of_findstringinarray(is_retbtn, as_buttonid) > 0 then
	return 'retrieve'
end if

// input
if of_findstringinarray(is_inpbtn, as_buttonid) > 0 then
	return 'input'
end if

// delete
if of_findstringinarray(is_delbtn, as_buttonid) > 0 then
	return 'delete'
end if

// update
if of_findstringinarray(is_updbtn, as_buttonid) > 0 then
	return 'update'
end if

// print
if of_findstringinarray(is_prtbtn, as_buttonid) > 0 then
	return 'print'
end if

// execute
if of_findstringinarray(is_exebtn, as_buttonid) > 0 then
	return 'execute'
end if

// cancel
if of_findstringinarray(is_canbtn, as_buttonid) > 0 then
	return 'cancel'
end if

// excel
if of_findstringinarray(is_xlsbtn, as_buttonid) > 0 then
	return 'excel'
end if

return ''

end function

public function long of_findstringinarray (readonly string as_stringarr[], readonly string as_findstr);long i, ll_maxcnt, ll_retval

ll_maxcnt = upperbound(as_stringarr)
for i = 1 to ll_maxcnt
	if as_stringarr[i] = as_findstr then
		ll_retval = i
		exit
	end if
next

return ll_retval

end function

public function integer of_setenableattr (ref windowobject awo_control, string as_enable_yn);if isnull(awo_control) or not isvalid(awo_control) then return -1
if isnull(as_enable_yn) or as_enable_yn = '' then return -1

boolean lb_enabled

choose case as_enable_yn
	case 'Y'
		lb_enabled = true
	case 'N'
		lb_enabled = false
	case else
		return 0
end choose

return of_setenableattr(awo_control, lb_enabled)

end function

public function integer of_authorizeindividualbutton ();// 개별 오브젝트 권한처리

integer i
string ls_ctrl_id, ls_obj_id, ls_dwc_id
string ls_obj_type, ls_use_yn
long ll_dist_pos

pf_n_hashtable lnv_useyn
windowobject lwo_target
datawindow ldw_target

lnv_useyn = create pf_n_hashtable

// 권한별로 설정된 컨트롤 Enable/Disable 설정 하나로 합치기
for i = 1 to ids_indivbtn.rowcount()
	ls_ctrl_id = ids_indivbtn.getitemstring(i, 'btn_id')
	ls_use_yn = ids_indivbtn.getitemstring(i, 'btn_use_yn')
	if isnull(ls_use_yn) then ls_use_yn = ''
	
	if lnv_useyn.of_containskey(ls_ctrl_id) then
		if lnv_useyn.of_getstring(ls_ctrl_id) <> 'Y' then
			lnv_useyn.of_put(ls_ctrl_id, ls_use_yn)
		end if
	else
		lnv_useyn.of_put(ls_ctrl_id, ls_use_yn)
	end if
next

// 컨트롤 Enable/Disable 처리
for i = 1 to integer(lnv_useyn.of_size())
	ls_ctrl_id = lnv_useyn.of_getkey(i)
	ls_use_yn = lnv_useyn.of_getstring(ls_ctrl_id)
	ll_dist_pos = pos(ls_ctrl_id, ".")
	
	// 윈도우 컨트롤 명칭에 '.' 가 있는 경우 
	// 데이터윈도우안에 포함된 오브젝트 권한 처리
	if ll_dist_pos > 0 then
		ls_obj_id = mid(ls_ctrl_id, ll_dist_pos + 1)
		ls_dwc_id = left(ls_ctrl_id, ll_dist_pos - 1)
	
		lwo_target = iw_parent.of_getwindowobjectbyname(ls_dwc_id)
		if isnull(lwo_target) or not isvalid(lwo_target) then
			messagebox('권한 설정 알림', '잘못된 데이터윈도우 명칭입니다.~r~n[' + ls_dwc_id + ']')
			return -1
		end if
		
		if lwo_target.typeof() <> DataWindow! then
			messagebox('권한 설정 알림', '잘못된 데이터윈도우 명칭입니다(타입).~r~n[' + ls_dwc_id + ']')
			return -1
		end if
		
		ldw_target = lwo_target
		if ls_use_yn = 'N' then
			ls_obj_type = ldw_target.describe(ls_obj_id + ".Type")
			choose case ls_obj_type
				case 'column'
					ldw_target.modify(ls_obj_id + ".Protect=1")
				case 'button'
					ldw_target.modify(ls_obj_id + ".Enabled=False")
			end choose
		end if
	else
		lwo_target = iw_parent.of_getwindowobjectbyname(ls_ctrl_id)
		if isnull(lwo_target) or not isvalid(lwo_target) then
			messagebox('권한 설정 알림', '잘못된 컨트롤 명칭입니다.~r~n[' + ls_ctrl_id + ']')
			return -1
		end if
		
		this.of_setenableattr(lwo_target, ls_use_yn)
	end if
next

return 1

//integer i, j
//string ls_objname
//long ll_objcnt
//boolean lb_found, lb_enable
//
//ll_objcnt = upperbound(iw_parent.iwo_control)
//for i = 1 to ll_objcnt
//	if not isvalid(iw_parent.iwo_control[i]) then
//		messagebox('invalid', string(i))
//		continue
//	end if
//	
//	ls_objname = iw_parent.iwo_control[i].classname()
//	
//	lb_found = false
//	lb_enable = false
//	for j = 1 to ids_indivbtn.rowcount()
//		if ids_indivbtn.getitemstring(j, 'btn_id') = ls_objname then
//			lb_found = true
//			if ids_indivbtn.getitemstring(j, 'btn_use_yn') = 'Y' then
//				lb_enable = true
//				exit
//			end if
//		end if
//	next
//	
//	if lb_found = true then
//		this.of_setenableattr(iw_parent.iwo_control[i], lb_enable)
//	end if
//next
//
//return 1

end function

public function integer of_setenableattr (ref windowobject awo_control, boolean ab_enabled);if isnull(awo_control) or not isvalid(awo_control) then return -1
if isnull(ab_enabled) then return -1

choose case awo_control.typeof()
	case animation!
		animation lanim_control
		lanim_control = awo_control
		lanim_control.enabled = ab_enabled
	case checkbox!
		checkbox lcbx_control
		lcbx_control = awo_control
		lcbx_control.enabled = ab_enabled
	case commandbutton!, picturebutton!
		commandbutton lcb_control
		lcb_control = awo_control
		lcb_control.enabled = ab_enabled
	case datawindow!
		datawindow ldw_control
		ldw_control = awo_control
		ldw_control.enabled = ab_enabled
	case datepicker!
		datepicker ldp_control
		ldp_control = awo_control
		ldp_control.enabled = ab_enabled
	case dropdownlistbox!, dropdownpicturelistbox!
		dropdownlistbox lddlb_control
		lddlb_control = awo_control
		lddlb_control.enabled = ab_enabled
	case graph!
		graph lgr_control
		lgr_control = awo_control
		lgr_control.enabled = ab_enabled
	case groupbox!
		groupbox lgb_control
		lgb_control = awo_control
		lgb_control.enabled = ab_enabled
	case inkedit!
		inkedit lie_control
		lie_control = awo_control
		lie_control.enabled = ab_enabled
	case inkpicture!
		inkpicture lip_control
		lip_control = awo_control
		lip_control.enabled = ab_enabled
	case listbox!, picturelistbox!
		listbox llb_control
		llb_control = awo_control
		llb_control.enabled = ab_enabled
	case listview!
		listview llv_control
		llv_control = awo_control
		llv_control.enabled = ab_enabled
	case monthcalendar!
		monthcalendar lmc_control
		lmc_control = awo_control
		lmc_control.enabled = ab_enabled
	case multilineedit!, editmask!
		multilineedit lmle_control
		lmle_control = awo_control
		lmle_control.enabled = ab_enabled
	case omcontrol!, omcustomcontrol!, omembeddedcontrol!
		omcontrol lomc_control
		lomc_control = awo_control
		lomc_control.enabled = ab_enabled
	case picture!, picturehyperlink!
		picture lp_control
		lp_control = awo_control
		lp_control.enabled = ab_enabled
	case radiobutton!
		radiobutton lrb_control
		lrb_control = awo_control
		lrb_control.enabled = ab_enabled
	case richtextedit!
		richtextedit lrte_control
		lrte_control = awo_control
		lrte_control.enabled = ab_enabled
	case singlelineedit!
		singlelineedit lsle_control
		lsle_control = awo_control
		lsle_control.enabled = ab_enabled
	case statictext!, statichyperlink!
		statictext lst_control
		lst_control = awo_control
		lst_control.enabled = ab_enabled
	case tab!
		tab lt_control
		lt_control = awo_control
		lt_control.enabled = ab_enabled
	case treeview!
		treeview ltv_control
		ltv_control = awo_control
		ltv_control.enabled = ab_enabled
	case userobject!
		userobject luo_control
		luo_control = awo_control
		luo_control.enabled = ab_enabled
	case else
		return 0
end choose

if awo_control.triggerevent("pfe_ispowerframecontrol") = 1 then
	choose case awo_control.dynamic of_getclassname()
		case 'pf_u_commandbutton', 'pf_u_imagebutton', 'pf_u_picture'
			awo_control.dynamic event pfe_enablechanged()
	end choose
end if

long ll_disabled_cnt, i

ll_disabled_cnt = upperbound(iwo_disabled)
choose case ab_enabled
	case true
		for i = 1 to ll_disabled_cnt
			if isnull(iwo_disabled[i]) then continue
			if not isvalid(iwo_disabled[i]) then continue
			if awo_control.classname() = iwo_disabled[i].classname() then
				setnull(iwo_disabled[i])
			end if
		next
	case false
		ll_disabled_cnt ++
		iwo_disabled[ll_disabled_cnt] = awo_control
end choose

return 1

end function

public function boolean of_getenableattr (readonly windowobject awo_control);if isnull(awo_control) or not isvalid(awo_control) then return false

boolean lb_enabled

choose case awo_control.typeof()
	case animation!
		animation lanim_control
		lanim_control = awo_control
		lb_enabled = lanim_control.enabled
	case checkbox!
		checkbox lcbx_control
		lcbx_control = awo_control
		lb_enabled = lcbx_control.enabled
	case commandbutton!, picturebutton!
		commandbutton lcb_control
		lcb_control = awo_control
		lb_enabled = lcb_control.enabled
	case datawindow!
		datawindow ldw_control
		ldw_control = awo_control
		lb_enabled = ldw_control.enabled
	case datepicker!
		datepicker ldp_control
		ldp_control = awo_control
		lb_enabled = ldp_control.enabled
	case dropdownlistbox!, dropdownpicturelistbox!
		dropdownlistbox lddlb_control
		lddlb_control = awo_control
		lb_enabled = lddlb_control.enabled
	case graph!
		graph lgr_control
		lgr_control = awo_control
		lb_enabled = lgr_control.enabled
	case groupbox!
		groupbox lgb_control
		lgb_control = awo_control
		lb_enabled = lgb_control.enabled
	case inkedit!
		inkedit lie_control
		lie_control = awo_control
		lb_enabled = lie_control.enabled
	case inkpicture!
		inkpicture lip_control
		lip_control = awo_control
		lb_enabled = lip_control.enabled
	case listbox!, picturelistbox!
		listbox llb_control
		llb_control = awo_control
		lb_enabled = llb_control.enabled
	case listview!
		listview llv_control
		llv_control = awo_control
		lb_enabled = llv_control.enabled
	case monthcalendar!
		monthcalendar lmc_control
		lmc_control = awo_control
		lb_enabled = lmc_control.enabled
	case multilineedit!, editmask!
		multilineedit lmle_control
		lmle_control = awo_control
		lb_enabled = lmle_control.enabled
	case omcontrol!, omcustomcontrol!, omembeddedcontrol!
		omcontrol lomc_control
		lomc_control = awo_control
		lb_enabled = lomc_control.enabled
	case picture!, picturehyperlink!
		picture lp_control
		lp_control = awo_control
		lb_enabled = lp_control.enabled
	case radiobutton!
		radiobutton lrb_control
		lrb_control = awo_control
		lb_enabled = lrb_control.enabled
	case richtextedit!
		richtextedit lrte_control
		lrte_control = awo_control
		lb_enabled = lrte_control.enabled
	case singlelineedit!
		singlelineedit lsle_control
		lsle_control = awo_control
		lb_enabled = lsle_control.enabled
	case statictext!, statichyperlink!
		statictext lst_control
		lst_control = awo_control
		lb_enabled = lst_control.enabled
	case tab!
		tab lt_control
		lt_control = awo_control
		lb_enabled = lt_control.enabled
	case treeview!
		treeview ltv_control
		ltv_control = awo_control
		lb_enabled = ltv_control.enabled
	case userobject!
		userobject luo_control
		luo_control = awo_control
		lb_enabled = luo_control.enabled
	case else
		return false
end choose

return lb_enabled

end function

public function boolean of_getcolumnmeanvalue (string as_authtype, string as_columnname);// 여러개의 권한을 가지고 있는 경우 YN 컬럼 값의 판별
// 여러행 권한 중 하나라도 'Y' 값이면 'Y' 로 처리 한다

if isnull(as_authtype) or as_authtype = '' then return false
if isnull(as_columnname) or as_columnname = '' then return false
if lower(right(as_columnname, 3)) <> '_yn' then return false

datastore lds_target

choose case as_authtype
	case 'common'
		lds_target = ids_commbtn
	case 'individual'
		lds_target = ids_indivbtn
	case else
		return false
end choose

//string ls_retval
boolean lb_retval

choose case as_columnname
	case 'indiv_btn_auth_yn', 'comm_btn_auth_yn'
		if lds_target.rowcount() = 0 then
			lb_retval = false
		else
			if lds_target.find('if (isnull(' + as_columnname + '), "N", ' + as_columnname + ') <> "Y"', 1, lds_target.rowcount()) > 0 then
				lb_retval = false
			else
				lb_retval = true
			end if
		end if
	case else
		if lds_target.rowcount() = 0 then
			lb_retval = true
		else
			if lds_target.find('if (isnull(' + as_columnname + '), "N", ' + as_columnname + ') = "Y"', 1, lds_target.rowcount()) > 0 then
				lb_retval = true
			else
				lb_retval = false
			end if
		end if
end choose

return lb_retval

end function

public subroutine of_registerparent (window aw_parent);// set parent window
iw_parent = aw_parent
is_menu_id = iw_parent.inv_menudata.is_menu_id

// get common button authority from the database
ids_commbtn.reset()

pf_n_userrole lnv_userrole
lnv_userrole = gnv_session.of_get('userrole')

ids_commbtn.retrieve(gnv_session.is_sys_id, lnv_userrole.is_userrole[], is_menu_id, string(gnv_session.idtm_login, 'YYYYMMDD'))
ib_comm_btn_auth_yn = of_getcolumnmeanvalue('common', 'comm_btn_auth_yn')

if ib_comm_btn_auth_yn then
	ib_retbtn_yn = of_getcolumnmeanvalue('common', 'retrieve_auth_yn')
	
	ib_inpbtn_yn = of_getcolumnmeanvalue('common', 'input_auth_yn')
	ib_delbtn_yn = of_getcolumnmeanvalue('common', 'delete_auth_yn')
	ib_updbtn_yn = of_getcolumnmeanvalue('common', 'update_auth_yn')
	ib_prtbtn_yn = of_getcolumnmeanvalue('common', 'print_auth_yn')
	ib_exebtn_yn = of_getcolumnmeanvalue('common', 'execute_auth_yn')
	ib_canbtn_yn = of_getcolumnmeanvalue('common', 'cancel_auth_yn')
	ib_xlsbtn_yn = of_getcolumnmeanvalue('common', 'excel_auth_yn')
end if

// get individual button authority from database
ids_indivbtn.reset()

ib_indiv_btn_auth_yn = of_getcolumnmeanvalue('common', 'indiv_btn_auth_yn')
if ib_indiv_btn_auth_yn then
	ids_indivbtn.retrieve(gnv_session.is_sys_id, lnv_userrole.is_userrole[], is_menu_id, string(gnv_session.idtm_login, 'YYYYMMDD'))
end if

end subroutine

on pf_n_buttonrole.create
call super::create
end on

on pf_n_buttonrole.destroy
call super::destroy
end on

event constructor;call super::constructor;// 공통버튼 권한 조회용
ids_commbtn = create datastore
ids_commbtn.dataobject = 'pf_d_commbtnauth'
ids_commbtn.settransobject(sqlca)

// 개별버튼 권한 조회용
ids_indivbtn = create datastore
ids_indivbtn.dataobject = 'pf_d_indivbtnauth'
ids_indivbtn.settransobject(sqlca)

end event

event destructor;call super::destructor;destroy ids_commbtn
destroy ids_indivbtn

end event

