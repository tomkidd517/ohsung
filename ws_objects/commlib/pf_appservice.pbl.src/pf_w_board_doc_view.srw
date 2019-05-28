$PBExportHeader$pf_w_board_doc_view.srw
$PBExportComments$게시물 조회 화면 (WebEditor) 입니다.
forward
global type pf_w_board_doc_view from pf_w_response
end type
type uo_viewer from pf_u_webeditor within pf_w_board_doc_view
end type
type p_close from pf_u_imagebutton within pf_w_board_doc_view
end type
type dw_mast from pf_u_datawindow within pf_w_board_doc_view
end type
type dw_attach from pf_u_datawindow within pf_w_board_doc_view
end type
end forward

global type pf_w_board_doc_view from pf_w_response
integer width = 3918
integer height = 3032
string title = "문서보기"
uo_viewer uo_viewer
p_close p_close
dw_mast dw_mast
dw_attach dw_attach
end type
global pf_w_board_doc_view pf_w_board_doc_view

type variables
constant string UPLOADING_SUBDIR = '/attached'

string is_board_no
long il_docu_no
string is_log_yn

end variables

forward prototypes
public function long of_attachedfileopen (long al_row)
public function integer of_attachedfilesave (long al_row)
public function integer of_inithtml (string as_id)
end prototypes

public function long of_attachedfileopen (long al_row);// 첨부파일 열기
choose case dw_attach.getitemstatus(al_row, 0, primary!)
	case newmodified!, new!
		messagebox('알림', '첨부파일이 아직 업로드 되지 않았습니다')
		return 0
end choose

string ls_org_filename, ls_mod_filename
string ls_filepath
string ls_board_no
long ll_docu_no
long ll_attach_seq

ls_org_filename = dw_attach.getitemstring(al_row, 'org_file_name')
ls_mod_filename = dw_attach.getitemstring(al_row, 'mod_file_name')
ls_board_no = dw_attach.getitemstring(al_row, 'board_no')
ll_docu_no = dw_attach.getitemnumber(al_row, 'docu_no')
ll_attach_seq = dw_attach.getitemnumber(al_row, 'attach_seq')
ls_filepath = gnv_extfunc.of_getsystemtemppath() + ls_org_filename

pf_n_httptransfer lnv_http
lnv_http = create pf_n_httptransfer
if lnv_http.of_filedownload(ls_org_filename, UPLOADING_SUBDIR, ls_filepath) < 0 then
	return -1
end if

destroy lnv_http

return gnv_extfunc.of_shellexecute(ls_filepath)

end function

public function integer of_attachedfilesave (long al_row);// 첨부파일 저장
choose case dw_attach.getitemstatus(al_row, 0, primary!)
	case newmodified!, new!
		messagebox('알림', '첨부파일이 아직 업로드 되지 않았습니다')
		return 0
end choose

string ls_org_filename, ls_mod_filename
string ls_filepath, ls_filename
string ls_board_no
long ll_docu_no
long ll_attach_seq

ls_org_filename = dw_attach.getitemstring(al_row, 'org_file_name')
ls_mod_filename = dw_attach.getitemstring(al_row, 'mod_file_name')
ls_board_no = dw_attach.getitemstring(al_row, 'board_no')
ll_docu_no = dw_attach.getitemnumber(al_row, 'docu_no')
ll_attach_seq = dw_attach.getitemnumber(al_row, 'attach_seq')

ls_filepath = ls_org_filename
if getfilesavename("첨부파일을 저장할 위치를 설정하세요", ls_filepath, ls_filename) <= 0 then return 0

pf_n_httptransfer lnv_http
lnv_http = create pf_n_httptransfer
if lnv_http.of_filedownload(ls_mod_filename, UPLOADING_SUBDIR, ls_filepath) < 0 then
	return -1
end if

destroy lnv_http

messagebox('알림', '파일 다운로드 완료')
return 1

end function

public function integer of_inithtml (string as_id);//ole_ie.object.navigate2("http://eas.penta.co.kr/SmartEditor2/ContentsViewer.jsp?id=" + as_id + "&type=webeditor&title=WebEditor")

return 0

end function

on pf_w_board_doc_view.create
int iCurrent
call super::create
this.uo_viewer=create uo_viewer
this.p_close=create p_close
this.dw_mast=create dw_mast
this.dw_attach=create dw_attach
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_viewer
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.dw_mast
this.Control[iCurrent+4]=this.dw_attach
end on

on pf_w_board_doc_view.destroy
call super::destroy
destroy(this.uo_viewer)
destroy(this.p_close)
destroy(this.dw_mast)
destroy(this.dw_attach)
end on

event open;call super::open;string ls_mesg, ls_parm[]

ls_mesg = message.stringparm
if pf_f_parsetoarray(ls_mesg, '~t', ls_parm) <> 3 then
	messagebox('알림', '잘못된 윈도우 호출입니다')
	post close(this)
	return
end if

is_board_no = ls_parm[1]
il_docu_no = long(ls_parm[2])
is_log_yn = ls_parm[3]

end event

event pfe_postopen;call super::pfe_postopen;dw_mast.settransobject(sqlca)
dw_attach.settransobject(sqlca)

blob lb_content
long ll_read_seq
string ls_errtext
datetime ldtm_now

if dw_mast.retrieve(gnv_session.is_sys_id, is_board_no, il_docu_no) > 0 then
		
	this.of_inithtml(is_board_no + string(il_docu_no))
	
	selectblob	docu_content
	into		:lb_content
	from		pf_docu_mst
	where	sys_id = :gnv_session.is_sys_id
	and		board_no = :is_board_no
	and		docu_no = :il_docu_no
	using		sqlca;
	
	if sqlca.sqlcode = 0 then
		
		uo_viewer.of_navigate(uo_viewer.viewer_url)
		uo_viewer.of_viewcontents(string(lb_content))
		
		if is_log_yn = 'Y' then
			select		max(read_seq)
			into		:ll_read_seq
			from		pf_docu_log
			where	sys_id = :gnv_session.is_sys_id
			and		board_no = :is_board_no
			and		docu_no = :il_docu_no
			using		sqlca;
			
			if isnull(ll_read_seq) then ll_read_seq = 0
			ll_read_seq += 1
			
			ldtm_now = pf_f_getdbmsdatetime()
			
			insert into pf_docu_log  ( sys_id, board_no, docu_no, read_seq, read_user, read_dtm )
			values ( :gnv_session.is_sys_id, :is_board_no, :il_docu_no, :ll_read_seq, :gnv_session.is_user_id, :ldtm_now )
			using sqlca;
			
			if sqlca.sqlcode = 0 then
				commit using sqlca;
			else
				ls_errtext = sqlca.sqlerrtext
				rollback using sqlca;
				messagebox('알림', '게시글 로그 생성 오류~r~n' + ls_errtext)
				return
			end if
		end if
	else
		messagebox('알림', '게시글 읽기 실패!')
		return
	end if
end if

dw_attach.retrieve(gnv_session.is_sys_id, is_board_no, il_docu_no)

end event

type ln_templeft from pf_w_response`ln_templeft within pf_w_board_doc_view
end type

type ln_tempright from pf_w_response`ln_tempright within pf_w_board_doc_view
end type

type ln_temptop from pf_w_response`ln_temptop within pf_w_board_doc_view
end type

type ln_tempbuttom from pf_w_response`ln_tempbuttom within pf_w_board_doc_view
end type

type ln_tempbutton from pf_w_response`ln_tempbutton within pf_w_board_doc_view
end type

type ln_tempstart from pf_w_response`ln_tempstart within pf_w_board_doc_view
end type

type uo_viewer from pf_u_webeditor within pf_w_board_doc_view
event destroy ( )
integer x = 50
integer y = 376
integer width = 3826
integer height = 2268
integer taborder = 20
string binarykey = "pf_w_board_doc_view.win"
boolean scaletoright = true
boolean scaletobottom = true
end type

on uo_viewer.destroy
call pf_u_webeditor::destroy
end on

type p_close from pf_u_imagebutton within pf_w_board_doc_view
integer x = 3643
integer y = 24
integer width = 233
integer height = 88
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\topBtn_close.gif"
end type

event clicked;call super::clicked;close(parent)

end event

type dw_mast from pf_u_datawindow within pf_w_board_doc_view
integer x = 50
integer y = 120
integer width = 3826
integer height = 244
integer taborder = 10
boolean bringtotop = true
string dataobject = "pf_d_board_doc_view_01"
boolean issearchcondition = true
boolean scaletoright = true
end type

type dw_attach from pf_u_datawindow within pf_w_board_doc_view
integer x = 50
integer y = 2652
integer width = 3826
integer height = 288
integer taborder = 30
boolean bringtotop = true
string dataobject = "pf_d_board_doc_view_02"
boolean vscrollbar = true
boolean livescroll = false
boolean fixedtobottom = true
boolean scaletoright = true
end type

event buttonclicked;call super::buttonclicked;choose case string(dwo.name)
	case 'b_open'
		of_attachedfileopen(row)
	case 'b_save'
		of_attachedfilesave(row)
	case 'b_delete'
		if messagebox('알림', '선택한 첨부파일을 삭제하시겠습니까?', Question!, YesNo!, 2) = 1 then
			dw_attach.deleterow(row)
			dw_attach.update()
		end if
end choose

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
09pf_w_board_doc_view.bin 
2400000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000823cbf8001d352d400000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f00000000823cbf8001d352d4823cbf8001d352d4000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c0000568200003a9a0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c0000568200003a9a0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19pf_w_board_doc_view.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
