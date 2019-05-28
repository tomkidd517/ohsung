﻿$PBExportHeader$pf_n_appsession.sru
$PBExportComments$어플리케이션 실행시 참고할 각종 변수 및 오브젝트들을 보관 또는 불러오는 기능을 수행합니다.
forward
global type pf_n_appsession from pf_n_hashtable
end type
end forward

global type pf_n_appsession from pf_n_hashtable
end type
global pf_n_appsession pf_n_appsession

type variables
public:
	// CommandButton Image 캐시용
	datastore ids_btnrepo
	string is_btnfile
	
	// 로그인 정보
	string is_sys_id			// System_id
	string is_login_yn		// Login 여부
	datetime idtm_login	// Login 일시
	string is_user_id		// 사용자 ID
	string is_user_name	// 사용자 명
	string is_admin_yn		// Administrator 여부
	string is_emp_no		// 사번
	string is_emp_name	// 사원명

end variables

forward prototypes
public function string of_getclassname ()
end prototypes

public function string of_getclassname ();return "pf_n_appsession"

end function

on pf_n_appsession.create
call super::create
end on

on pf_n_appsession.destroy
call super::destroy
end on

event constructor;call super::constructor;//inv_userauth = create pf_n_userauthority

// CommandButton Image 캐시용 Datastore
ids_btnrepo = create datastore
ids_btnrepo.dataobject = 'pf_d_commandbutton_repo'

is_btnfile = gnv_extfunc.of_getpowerframetemppath() + 'pfbtnrepo.his'
if fileexists(is_btnfile) then
	ids_btnrepo.importfile(text!, is_btnfile)
	ids_btnrepo.resetupdate()
end if

end event

event destructor;call super::destructor;//destroy inv_userauth

// 버튼 생성 정보 저장
if ids_btnrepo.modifiedcount() > 0 then
	ids_btnrepo.saveas(is_btnfile, text!, false)
end if

if isvalid(ids_btnrepo) then
	destroy ids_btnrepo
end if

end event

