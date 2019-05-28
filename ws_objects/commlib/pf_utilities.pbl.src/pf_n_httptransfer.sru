﻿$PBExportHeader$pf_n_httptransfer.sru
$PBExportComments$HTTP 형태로 파일을 송,수신하는 오브젝트입니다.
forward
global type pf_n_httptransfer from nonvisualobject
end type
end forward

global type pf_n_httptransfer from nonvisualobject
end type
global pf_n_httptransfer pf_n_httptransfer

type prototypes

end prototypes

type variables
constant integer TYPE_PARAM = 0
constant integer TYPE_FILE = 1

constant integer SIZE_UPLOAD = 0
constant integer SIZE_DOWNLOAD = 1

constant integer HTTP_OK = 0

// HTTP_GETINFO 참조 가능한 항목
constant int HTTPINFO_RESPONSE_CODE = 100
constant int HTTPINFO_HTTP_CONNECTCODE = 101
constant int HTTPINFO_FILETIME = 102
constant int HTTPINFO_REDIRECT_COUNT = 103
constant int HTTPINFO_HEADER_SIZE = 104
constant int HTTPINFO_REQUEST_SIZE = 105
constant int HTTPINFO_SSL_VERIFYRESULT = 106
constant int HTTPINFO_HTTPAUTH_AVAIL = 107
constant int HTTPINFO_PROXYAUTH_AVAIL = 108
constant int HTTPINFO_OS_ERRNO = 109
constant int HTTPINFO_NUM_CONNECTS = 110
constant int HTTPINFO_PRIMARY_PORT = 111
constant int HTTPINFO_LOCAL_PORT = 112
constant int HTTPINFO_LASTSOCKET = 113
constant int HTTPINFO_CONDITION_UNMET = 114
constant int HTTPINFO_RTSP_CLIENT_CSEQ = 115
constant int HTTPINFO_RTSP_SERVER_CSEQ = 116
constant int HTTPINFO_RTSP_CSEQ_RECV = 117

constant int HTTPINFO_TOTAL_TIME = 200
constant int HTTPINFO_NAMELOOKUP_TIME = 201
constant int HTTPINFO_CONNECT_TIME = 202
constant int HTTPINFO_APPCONNECT_TIME = 203
constant int HTTPINFO_PRETRANSFER_TIME = 204
constant int HTTPINFO_STARTTRANSFER_TIME = 205
constant int HTTPINFO_REDIRECT_TIME = 206
constant int HTTPINFO_SIZE_UPLOAD = 207
constant int HTTPINFO_SIZE_DOWNLOAD = 208
constant int HTTPINFO_SPEED_DOWNLOAD = 209
constant int HTTPINFO_SPEED_UPLOAD = 210
constant int HTTPINFO_CONTENT_LENGTH_DOWNLOAD = 211
constant int HTTPINFO_CONTENT_LENGTH_UPLOAD = 212

constant int HTTPINFO_EFFECTIVE_URL = 300
constant int HTTPINFO_REDIRECT_URL = 301
constant int HTTPINFO_CONTENT_TYPE = 302
constant int HTTPINFO_PRIVATE = 303
constant int HTTPINFO_PRIMARY_IP = 304
constant int HTTPINFO_LOCAL_IP = 305
constant int HTTPINFO_FTP_ENTRY_PATH = 306
constant int HTTPINFO_RTSP_SESSION_ID = 307

pf_w_httpupload iw_upload
pf_w_httpdownload iw_download

datastore ids_httpcode

public:
	string UPLOAD_URL = '' //as-is "http://localhost:9090/pfservices/FileUpload"
	string DOWNLOAD_URL= '' //as-is "http://localhost:9090/pfservices/FileDownload"
	boolean OVERWRITE_UPLOADEDFILE = true
	uint DEFAULT_TIMEOUT = 5

end variables

forward prototypes
public subroutine of_setuploadurl (string as_uploadurl)
public subroutine of_setdownloadurl (string as_downloadurl)
public subroutine of_setoverwriteuploadedfile (boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir)
public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir)
public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfile, string as_subdir)
public function integer of_fileupload (ref string as_uploadfile, string as_subdir, boolean ab_overwrite)
public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir)
public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir, boolean ab_overwrite)
public function integer of_filedownload (string as_downloadfile, string as_subdir, ref string as_downloadpath)
public function boolean of_ping (string as_url, unsignedinteger aui_timeout)
public function boolean of_ping (string as_url)
public subroutine of_settimeout (unsignedinteger aui_timeout)
public function string of_getdescriptionofhttpcode (integer ai_httpcode)
public function string of_getmessageofhttpcode (integer ai_httpcode)
public function integer of_filedownload (string as_downloadfile, string as_subdir)
public function integer of_filedownload (string as_downloadfiles[], string as_subdir)
public function integer of_filedownload (string as_downloadfiles[], string as_subdir, string as_downloadpath)
public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content)
public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content, ref string as_uploadfiles[])
public function string of_urlencode (string as_text)
public function string of_urldecode (string as_text)
public function integer of_postrequest (string as_serverurl, string as_postfields, ref string as_respdata)
public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath, boolean ab_overwrite)
public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath)
public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath, boolean ab_overwrite)
public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath)
end prototypes

public subroutine of_setuploadurl (string as_uploadurl);UPLOAD_URL = as_uploadurl

end subroutine

public subroutine of_setdownloadurl (string as_downloadurl);DOWNLOAD_URL = as_downloadurl

end subroutine

public subroutine of_setoverwriteuploadedfile (boolean ab_overwrite);OVERWRITE_UPLOADEDFILE = ab_overwrite

end subroutine

public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir, boolean ab_overwrite);string ls_filepath, ls_filename
string ls_error
integer li_rc, li_running

if isnull(as_uploadfiles) then return -1
if upperbound(as_uploadfiles) = 0 then
	messagebox('알림(pf_n_httptransfer)', '업로드할 파일이 지정되지 않았습니다.')
	return - 1
end if

// 업로드 상태창 오픈
open(iw_upload)
iw_upload.cb_close.text = 'Cancel'
iw_upload.st_msg.text = '업로드 초기화 중...'

// 업로드할 파일 설정
long ll_new, i
long ll_filesize
long ll_total_sum, ll_sent_sum

iw_upload.dw_filelist.reset()

for i = 1 to upperbound(as_uploadfiles)
	ll_filesize = gnv_extfunc.pf_getfilesize(as_uploadfiles[i])
	if ll_filesize = -1 then
		messagebox('알림', '[' + as_uploadfiles[i] + '] 파일 정보를 읽을 수 없습니다')
		close(iw_upload)
		return -1
	end if

	ll_new = iw_upload.dw_filelist.insertrow(0)
	iw_upload.dw_filelist.setitem(ll_new, 'filepath', as_uploadfiles[i])
	iw_upload.dw_filelist.setitem(ll_new, 'filename', gnv_extfunc.of_pathstrippath(as_uploadfiles[i]))
	iw_upload.dw_filelist.setitem(ll_new, 'filesize', ll_filesize)
next

ll_total_sum = iw_upload.dw_filelist.getitemnumber(1, 'compute_1')

// 업로드 초기화
double ld_ultotal, ld_ulnow
double ld_ultotal_bef, ld_ulnow_bef
integer li_percent, li_percent_bef
string ls_resptext, ls_uploadedfile
string ls_httpmesg
long ll_httpcode

// HTTP 모듈 초기화
gnv_extfunc.pf_http_globalinit()
iw_upload.st_msg.text = '파일 업로드 중...'

// HTTP header 설정
//gnv_extfunc.pf_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
//gnv_extfunc.pf_http_addhttpheader("Content-Type: multipart/form-data; charset=euc-kr")
//gnv_extfunc.pf_http_addhttpheader("Content-Type: application/x-www-form-urlencoded")

// HTTP 헤더 설정
gnv_extfunc.pf_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
gnv_extfunc.pf_http_addhttpheader("Content-Type: multipart/form-data; charset=euc-kr")

for i = 1 to upperbound(as_uploadfiles)
	iw_upload.dw_filelist.scrolltorow(i)
	iw_upload.dw_filelist.setrow(i)
	
	yield()
	
	ls_filepath = iw_upload.dw_filelist.getitemstring(i, 'filepath')
	ls_filename = iw_upload.dw_filelist.getitemstring(i, 'filename')
	ll_filesize = iw_upload.dw_filelist.getitemnumber(i, 'filesize')
	
	gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "filename", this.of_urlencode(ls_filename))
	gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "subdir", this.of_urlencode(as_subdir))
	if ab_overwrite = true then
		gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "overwrite", "true")
	else
		gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "overwrite", "false")
	end if
	gnv_extfunc.pf_http_addformfield(TYPE_FILE, "file1", ls_filepath)
	
	// initialize http
	li_rc = gnv_extfunc.pf_http_openupload(as_uploadurl, ls_filepath)
	if li_rc = -1 then
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('알림(' + string(li_rc) + ')', '업로드 초기화 오류입니다.~r~n' + string(ls_filepath) + ' 파일을 오픈할 수 없습니다.')
		close(iw_upload)
		return -1
	end if
	
	li_running = gnv_extfunc.pf_http_send()
	do while li_running = 1
		ld_ultotal = gnv_extfunc.pf_http_uploadprogress_total()
		ld_ulnow = gnv_extfunc.pf_http_uploadprogress_now()
		
		if ld_ultotal <> ld_ultotal_bef then
			iw_upload.st_bytestotal.text = string(ld_ultotal, '#,##0')
			ld_ultotal_bef = ld_ultotal
		end if
		
		if ld_ulnow <> ld_ulnow_bef then
			iw_upload.st_bytessent.text = string(ld_ulnow, '#,##0')
			ld_ulnow_bef = ld_ulnow
		end if
		
		if ld_ulnow > 0 then
			li_percent = int((ld_ulnow / ld_ultotal) * 100)
			if li_percent <> li_percent_bef then
				iw_upload.hpb_file.position = li_percent
				li_percent_bef = li_percent
			end if
		end if
		
		// Cancelling...
		if iw_upload.ib_cancel = true then
			gnv_extfunc.pf_http_abort()
			exit
		end if

		yield()
		li_running = gnv_extfunc.pf_http_checkrunningstatus()
	loop
	
	// check result code
	li_rc = gnv_extfunc.pf_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.pf_http_geterrormessage(li_rc)
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_upload)
		return -1
	end if
	
	// check http code
	ll_httpcode = gnv_extfunc.pf_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 업로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('파일 업로드 오류', ls_httpmesg)
		close(iw_upload)
		return -1
	end if
	
	// get response
	ls_resptext = gnv_extfunc.pf_http_getresponsefromupload()
	if left(ls_resptext, 9) = 'uploaded:' then
		ls_uploadedfile = mid(ls_resptext, 10)
		ls_uploadedfile = pf_f_replaceall(ls_uploadedfile, '~r', '')
		ls_uploadedfile = pf_f_replaceall(ls_uploadedfile, '~n', '')
		
		if ls_uploadedfile <> as_uploadfiles[i] then
			as_uploadfiles[i] = ls_uploadedfile
		end if
	end if
	
	gnv_extfunc.pf_http_close()
	
	// Check if cancel button was clicked
	if iw_upload.ib_cancel = true then
		exit
	end if
	
	ll_sent_sum += ll_filesize
	gnv_extfunc.sleep(10)
next

// HTTP 모듈 클린업
gnv_extfunc.pf_http_globalcleanup()
iw_upload.cb_close.text = 'Close'

if iw_upload.ib_cancel = true then
	iw_upload.st_msg.text = '파일 전송 취소!!'
	messagebox('알림', '파일 전송이 취소되었습니다.')
else
	iw_upload.st_msg.text = '파일 업로드 완료!!'
	//messagebox('알림', '파일 전송이 완료되었습니다.')
end if

close(iw_upload)
return li_rc

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_uploadurl, string as_subdir);return this.of_fileupload(as_uploadfiles[], as_uploadurl, as_subdir, OVERWRITE_UPLOADEDFILE)

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir);if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('알림', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

return this.of_fileupload(as_uploadfiles[], UPLOAD_URL, as_subdir, OVERWRITE_UPLOADEDFILE)

end function

public function integer of_fileupload (ref string as_uploadfiles[], string as_subdir, boolean ab_overwrite);if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('알림', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

return this.of_fileupload(as_uploadfiles[], UPLOAD_URL, as_subdir, ab_overwrite)

end function

public function integer of_fileupload (ref string as_uploadfile, string as_subdir);string ls_uploadfiles[]
integer li_rc

if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('알림', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

ls_uploadfiles[1] = as_uploadfile
li_rc = this.of_fileupload(ls_uploadfiles[], UPLOAD_URL, as_subdir, OVERWRITE_UPLOADEDFILE)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_subdir, boolean ab_overwrite);string ls_uploadfiles[]
integer li_rc

if isnull(UPLOAD_URL) then return -1
if len(trim(UPLOAD_URL)) = 0 then
	messagebox('알림', 'FILE UPLOAD용 서블릿URL 이 설정되지 않았습니다')
	return -1
end if

ls_uploadfiles[1] = as_uploadfile
li_rc =  this.of_fileupload(ls_uploadfiles[], UPLOAD_URL, as_subdir, ab_overwrite)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir);string ls_uploadfiles[]
integer li_rc

ls_uploadfiles[1] = as_uploadfile
li_rc =  this.of_fileupload(ls_uploadfiles[], as_uploadurl, as_subdir, OVERWRITE_UPLOADEDFILE)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_fileupload (ref string as_uploadfile, string as_uploadurl, string as_subdir, boolean ab_overwrite);string ls_uploadfiles[]
integer li_rc

ls_uploadfiles[1] = as_uploadfile
li_rc = this.of_fileupload(ls_uploadfiles[], as_uploadurl, as_subdir, ab_overwrite)
as_uploadfile = ls_uploadfiles[1]

return li_rc

end function

public function integer of_filedownload (string as_downloadfile, string as_subdir, ref string as_downloadpath);string ls_downloadfiles[]
integer li_rc

ls_downloadfiles[1] = as_downloadfile
li_rc =  this.of_filedownload(ls_downloadfiles[], DOWNLOAD_URL, as_subdir, as_downloadpath, false)
return li_rc

end function

public function boolean of_ping (string as_url, unsignedinteger aui_timeout);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소
// aui_timeout : 테스트 타임아웃(초)

boolean lb_rv

if isnull(as_url) or len(trim(as_url)) = 0 then
	messagebox('of_ping 알림', 'URL 정보가 없습니다')
	return false
end if

// Time Out 초가 설정되지 않은 경우 기본 5초 설정
if aui_timeout <= 0  then
	aui_timeout = DEFAULT_TIMEOUT
end if

lb_rv = gnv_extfunc.pf_http_ping(as_url, aui_timeout)
return lb_rv

end function

public function boolean of_ping (string as_url);// as_url 이 유효한지 검사합니다
// as_url : 테스트할 URL 주소

uint lui_timeout

lui_timeout = DEFAULT_TIMEOUT
return this.of_ping(as_url, lui_timeout)

end function

public subroutine of_settimeout (unsignedinteger aui_timeout);DEFAULT_TIMEOUT = aui_timeout

end subroutine

public function string of_getdescriptionofhttpcode (integer ai_httpcode);// HTTPCODE에 해당하는 상세 에러 메시지를 리턴합니다.

long ll_find
string ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_desc')
end if

return ls_errmsg

end function

public function string of_getmessageofhttpcode (integer ai_httpcode);// HTTPCODE에 해당하는 에러 메시지를 리턴합니다.

long ll_find
string ls_errmsg

ll_find = ids_httpcode.find("httpcode='" + string(ai_httpcode) + "'", 1, ids_httpcode.rowcount())
if ll_find > 0 then
	ls_errmsg = ids_httpcode.getitemstring(ll_find, 'httpcode_mesg')
end if

return ls_errmsg

end function

public function integer of_filedownload (string as_downloadfile, string as_subdir);string ls_downloadfiles[]
string ls_downloadpath
integer li_rc

ls_downloadfiles[1] = as_downloadfile
li_rc =  this.of_filedownload(ls_downloadfiles[], DOWNLOAD_URL, as_subdir, ls_downloadpath, false)
return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_subdir);integer li_rc
string ls_downloadpath

li_rc =  this.of_filedownload(as_downloadfiles[], DOWNLOAD_URL, as_subdir, ls_downloadpath, false)
return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_subdir, string as_downloadpath);integer li_rc

li_rc =  this.of_filedownload(as_downloadfiles[], DOWNLOAD_URL, as_subdir, as_downloadpath, false)
return li_rc

end function

public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content);String		ls_DummyFiles[]

return This.of_sendmail( as_server_url, as_from_user_name, as_from_addr, as_to_addr, as_subject, as_content, ls_DummyFiles )
end function

public function integer of_sendmail (string as_server_url, string as_from_user_name, string as_from_addr, string as_to_addr, string as_subject, ref string as_content, ref string as_uploadfiles[]);
//string ls_filepath, ls_filename
string ls_error
integer li_rc, li_running

// 업로드 초기화
double ld_ultotal, ld_ulnow
double ld_ultotal_bef, ld_ulnow_bef
integer li_percent, li_percent_bef
string ls_resptext, ls_uploadedfile
string ls_httpmesg
long ll_httpcode

// HTTP 모듈 초기화
gnv_extfunc.pf_http_globalinit()

string ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr
string ls_subject, ls_content

gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "from_user_name", of_urlencode(as_from_user_name))
gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "from_addr", of_urlencode(as_from_addr))
gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "to_addr", of_urlencode(as_to_addr))
gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "subject", of_urlencode(as_subject))
gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "content", as_content)

long	i, li_cnt
string	ls_filename
string	ls_add_files[10]	// 첨부파일 최대 10개로 지정.(추가시 dll 수정 필요.)

li_cnt = UpperBound(as_uploadfiles)
if li_cnt > 0 then
	for i=1 to li_cnt
		ls_add_files[i] = as_uploadfiles[i]
		if pf_f_isemptystring(ls_add_files[i]) then
			messagebox('알림', '첨부 파일이 빠져 있습니다!')
			return -1
		end if
	//  dll에서 수행.	
	//	ls_filename =  gnv_extfunc.of_pathstrippath(ls_add_files[i])
	//	gnv_extfunc.pf_http_addformfield(TYPE_PARAM, "filename", ls_filename)	
	//	gnv_extfunc.pf_http_addformfield(TYPE_FILE, "file1", as_uploadfiles[i])
	next
end if

// initialize http
if gnv_extfunc.pf_http_sendmail(as_server_url, ls_add_files, li_cnt ) = -1 then
	return -1
end if

li_running = gnv_extfunc.pf_http_send()
do while li_running = 1
//		ld_ultotal = gnv_extfunc.pf_http_uploadprogress_total()
//		ld_ulnow = gnv_extfunc.pf_http_uploadprogress_now()
//		

	yield();yield();yield();yield();
	li_running = gnv_extfunc.pf_http_checkrunningstatus()
loop

// check result code
li_rc = gnv_extfunc.pf_http_getresultcode()
if li_rc <> HTTP_OK then
	ls_error = gnv_extfunc.pf_http_geterrormessage(li_rc)
	gnv_extfunc.pf_http_close()
	gnv_extfunc.pf_http_globalcleanup()
	messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
	return -1
end if

// check http code
ll_httpcode = gnv_extfunc.pf_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
if ll_httpcode >= 300 then
	ls_httpmesg = '메일 전송 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
	this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
	gnv_extfunc.pf_http_close()
	gnv_extfunc.pf_http_globalcleanup()
	messagebox('메일 전송 오류', ls_httpmesg)
	return -1
end if


gnv_extfunc.pf_http_close()


// HTTP 모듈 클린업
gnv_extfunc.pf_http_globalcleanup()

//messagebox('알림', '메일 전송이 완료되었습니다.')

return li_rc

end function

public function string of_urlencode (string as_text);string ls_escaped

ls_escaped = space(5120)
gnv_extfunc.pf_http_escape(as_text, ls_escaped)

return ls_escaped

end function

public function string of_urldecode (string as_text);string ls_unescaped

ls_unescaped = space(5120)
gnv_extfunc.pf_http_unescape(as_text, ls_unescaped)

return ls_unescaped

end function

public function integer of_postrequest (string as_serverurl, string as_postfields, ref string as_respdata);// 서버 URL POST 방식 호출
// PostRequest 호출 예제
//ls_postfields = 'filename=' + lnv_http.of_urlencode(ls_serverfiles[i]) + "&subdir=" + lnv_http.of_urlencode(ls_subdir)
//li_rc = lnv_http.of_postrequest(FILELENGTH_URL, ls_postfields, ls_respdata)
//if li_rc < 0 then
//		messagebox('알림(of_postrequest)', '파일검증 실패~r~n시스템 관리자에게 문의하세요~r~nRetCode=' + string(li_rc))
//		return -1
//end if

integer li_rc, li_filenum
string ls_respfile

//ls_postfields = "filename=" + as_file_nm + "&subdir=" + as_sub_dir
ls_respfile = gnv_extfunc.of_getsystemtemppath() + "pf_http_resp.txt"

li_rc = gnv_extfunc.pf_http_post_request(as_serverurl, as_postfields, ls_respfile)
if li_rc = -1 then return -1

li_filenum = fileopen(ls_respfile, textmode!, read!)
if li_filenum = -1 then return -1

filereadex(li_filenum, as_respdata)
fileclose(li_filenum)

return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath, boolean ab_overwrite);string ls_filepath
string ls_error
integer li_rc, li_running
integer i, li_filecnt

// 다운로드할 (서버)파일명 확인
if isnull(as_downloadfiles) then return -1

li_filecnt = upperbound(as_downloadfiles)
if li_filecnt = 0 then
	messagebox('알림', '다운로드할 파일이 지정되지 않았습니다.')
	return - 1
end if

for i = 1 to li_filecnt
	if isnull(as_downloadfiles[i]) or len(trim(as_downloadfiles[i])) = 0 then
		messagebox('알림', '다운로드할 파일이 지정되지 않았습니다.')
		return - 1
	end if
next

// 다운로드 URL 확인
if isnull(as_downloadurl) then return -1
if len(trim(as_downloadurl)) = 0 then
	messagebox('알림', '다운로드 URL이 설정되지 않았습니다.')
	return - 1
end if

// 다운로드 SUBDIR 확인
if isnull(as_subdir) then return -1
if len(trim(as_subdir)) = 0 then
	messagebox('알림', '다운로드 SUBDIR(서버_하위경로)이 설정되지 않았습니다.')
	return - 1
end if

// DownloadPath 가 미설정된 경우 사용자 설정 처리
if isnull(as_downloadpath) or len(trim(as_downloadpath)) = 0 then
	if getfolder("첨부파일을 저장할 폴더를 선택하세요", as_downloadpath) < 1 then return 0
end if

// 다운로드 상태창 오픈
open(iw_download)
iw_download.cb_close.text = 'Cancel'
iw_download.st_msg.text = '다운로드 초기화 중...'

// 다운로드 초기화
double ld_dltotal, ld_dlnow
double ld_dltotal_bef, ld_dlnow_bef
double ld_bytespersec
long ll_total_sum, ll_recv_sum
integer li_percent, li_percent_bef

iw_download.st_msg.text = '파일 다운로드 중...'

long ll_new, ll_lastpos
long ll_filesize
string ls_extension
string ls_fileext

// 다운로드할 파일 DW 표시
iw_download.dw_filelist.reset()
for i = 1 to li_filecnt
	
	// 파일명 일련번호 제거
	ls_filepath = as_downloadfiles[i]
	ll_lastpos = lastpos(ls_filepath, '.')
	if ll_lastpos > 0 then
		ls_fileext = mid(ls_filepath, ll_lastpos + 1)
		if isnumber(ls_fileext) then
			ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
		end if
	end if
	
	// 기 존재하는 파일 확인
	if ab_overwrite = false then
		if fileexists(as_downloadpath + '\' + ls_filepath) then
			li_rc = messagebox('알림', '[' + as_downloadpath + '\' + ls_filepath + ']~r~n다운로드 받을 파일이 이미 존재합니다.~r~n해당 파일을 덮어쓰기 하시겠습니까?', Question!, YesNoCancel!, 2)
			choose case li_rc
				case 2
					continue
				case 3
					close(iw_download)
					return 0
			end choose
		end if
	end if
	
	ll_new = iw_download.dw_filelist.insertrow(0)
	iw_download.dw_filelist.setitem(ll_new, 'filepath', as_downloadpath + '\' + ls_filepath)
	iw_download.dw_filelist.setitem(ll_new, 'filename', ls_filepath)
	iw_download.dw_filelist.setitem(ll_new, 'filesize', 0)
next

// 작업 대상이 없으면 리턴
if iw_download.dw_filelist.rowcount() = 0 then 
	close(iw_download)
	return 0
end if

// HTTP 모듈 초기화
gnv_extfunc.pf_http_globalinit()

// HTTP 헤더 설정
gnv_extfunc.pf_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
gnv_extfunc.pf_http_addhttpheader("Content-Type: application/x-www-form-urlencoded; charset=euc-kr")

// 파일 다운로드
for i = 1 to li_filecnt
	iw_download.dw_filelist.scrolltorow(i)
	iw_download.dw_filelist.setrow(i)
	
	ls_filepath = iw_download.dw_filelist.getitemstring(i, 'filepath')
	
	// 다운로드 URL 및 로컬 파일경로 설정
	li_rc = gnv_extfunc.pf_http_opendownload(as_downloadurl, ls_filepath)
	if li_rc < 0 then
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('알림(' + string(li_rc) + ')', '다운로드 초기화 오류입니다.~r~n' + string(ls_filepath) + ' 파일이 사용중이거나 해당 경로에 쓰기 권한이 없습니다.')
		close(iw_download)
		return -1
	end if
	
	// 수신 파일명 및 서브 경로 설정
	//gnv_extfunc.pf_http_setpostfields("filename=" + as_downloadfiles[i] + "&subdir=" + as_subdir)
	gnv_extfunc.pf_http_setpostfields("filename=" + this.of_urlencode(as_downloadfiles[i]) + "&subdir=" + this.of_urlencode(as_subdir))
	if gnv_extfunc.pf_http_send() <> 1 then
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('알림', 'pf_http_send() 호출 오류 입니다')
		close(iw_download)
		return -1
	end if
	
	// 진행상태 점검
	li_running = gnv_extfunc.pf_http_checkrunningstatus()
	do while li_running = 1
		yield()
		
		ld_dlnow = gnv_extfunc.pf_http_downloadprogress_now()
		ld_dltotal = gnv_extfunc.pf_http_downloadprogress_total()
		
		if ld_dltotal <> ld_dltotal_bef then
			iw_download.st_bytestotal.text = string(ld_dltotal, '#,##0')
			ld_dltotal_bef = ld_dltotal
		end if	
		
		if ld_dlnow <> ld_dlnow_bef then
			iw_download.st_bytesrecv.text = string(ld_dlnow, '#,##0')
			ld_dlnow_bef = ld_dlnow
		end if
		
		if ld_dlnow > 0 then
			li_percent = int((ld_dlnow / ld_dltotal) * 100)
			if li_percent <> li_percent_bef then
				iw_download.hpb_file.position = li_percent
				li_percent_bef = li_percent
			end if
		end if
		
		// 다운로드 취소 확인
		if iw_download.ib_cancel = true then
			gnv_extfunc.pf_http_abort()
			exit
		end if
		
		li_running = gnv_extfunc.pf_http_checkrunningstatus()
	loop
	
	// 결과코드 처리
	li_rc = gnv_extfunc.pf_http_getresultcode()
	if li_rc <> HTTP_OK then
		ls_error = gnv_extfunc.pf_http_geterrormessage(li_rc)
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
		close(iw_download)
		return -1
	end if
	
	// 마지막 진행상황 처리
	ld_dlnow = gnv_extfunc.pf_http_downloadprogress_now()
	if ld_dltotal > 0 then li_percent = int((ld_dlnow / ld_dltotal) * 100)
	iw_download.st_bytesrecv.text = string(ld_dlnow, '#,##0')
	iw_download.hpb_file.position = li_percent
	ll_recv_sum += ld_dltotal
	
	// 다운로드 전송 속도
	//ld_bytespersec = gnv_extfunc.pf_http_getinfo_double(HTTPINFO_SPEED_DOWNLOAD)
	//iw_download.st_msg.text = string(ld_bytespersec / 1000, '#,##0') + ' Kbytes/sec'
	
	// HTTP Code 확인
	long ll_httpcode
	string ls_httpmesg
	ll_httpcode = gnv_extfunc.pf_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
	if ll_httpcode >= 300 then
		ls_httpmesg = '파일 다운로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
		this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
		gnv_extfunc.pf_http_close()
		gnv_extfunc.pf_http_globalcleanup()
		messagebox('파일 다운로드 오류', ls_httpmesg)
		close(iw_download)
		return -1
	end if

	// HTTP 전송 종료
	gnv_extfunc.pf_http_close()
	
	// 오픈전 대기
	gnv_extfunc.sleep(10)
next

gnv_extfunc.pf_http_globalcleanup()
iw_download.cb_close.text = 'Close'

// 결과 메시지 표시
if len(ls_httpmesg) > 0 then
	li_rc = -1
	iw_download.st_msg.text = '파일 전송 오류!'
elseif iw_download.ib_cancel = true then
	li_rc = -1
	iw_download.st_msg.text = '전송이 취소되었습니다!'
else
	iw_download.st_msg.text = '파일 다운로드 완료!'
end if

close(iw_download)
return li_rc

end function

public function integer of_filedownload (string as_downloadfiles[], string as_downloadurl, string as_subdir, string as_downloadpath);integer li_rc

li_rc =  this.of_filedownload(as_downloadfiles[], DOWNLOAD_URL, as_subdir, as_downloadpath, false)
return li_rc

end function

public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath, boolean ab_overwrite);string ls_downloadfiles[]
integer li_rc

ls_downloadfiles[1] = as_downloadfile
li_rc = this.of_filedownload(ls_downloadfiles[], as_downloadurl, as_subdir, as_downloadpath, ab_overwrite)
return li_rc

//string ls_filepath, ls_filename
//string ls_error
//integer li_rc, li_running
//
//// 다운로드할 (서버)파일명 확인
//if isnull(as_downloadfile) then return -1
//if len(trim(as_downloadfile)) = 0 then
//	messagebox('알림', '다운로드할 파일이 지정되지 않았습니다.')
//	return - 1
//end if
//
//// 다운로드 URL 확인
//if isnull(as_downloadurl) then return -1
//if len(trim(as_downloadurl)) = 0 then
//	messagebox('알림', '다운로드 URL이 설정되지 않았습니다.')
//	return - 1
//end if
//
//// 다운로드 SUBDIR 확인
//if isnull(as_subdir) then return -1
//if len(trim(as_subdir)) = 0 then
//	messagebox('알림', '다운로드 SUBDIR(서버_하위경로)이 설정되지 않았습니다.')
//	return - 1
//end if
//
//// DownloadPath 가 미설정된 경우 사용자 설정 처리
//long ll_lastpos
//string ls_fileext
//
//ls_filepath = as_downloadfile
//ll_lastpos = lastpos(ls_filepath, '.')
//if ll_lastpos > 0 then
//	ls_fileext = mid(ls_filepath, ll_lastpos + 1)
//	if isnumber(ls_fileext) then
//		ls_filepath = mid(ls_filepath, 1, ll_lastpos - 1)
//	end if
//end if
//
//if isnull(as_downloadpath) or len(trim(as_downloadpath)) = 0 then
//	ls_filename = ls_filepath
//	if getfilesavename("첨부파일을 저장할 위치를 설정하세요", ls_filepath, ls_filename) <= 0 then return 0
//	as_downloadpath = ls_filepath
//end if
//
//// 다운로드 상태창 오픈
//open(iw_download)
//iw_download.cb_close.text = 'Cancel'
//iw_download.st_msg.text = '다운로드 초기화 중...'
//
//// 다운로드 초기화
//double ld_dltotal, ld_dlnow
//double ld_dltotal_bef, ld_dlnow_bef
//double ld_bytespersec
//long ll_total_sum, ll_recv_sum
//integer li_percent, li_percent_bef
//long ll_filecnt, i
//
//iw_download.st_msg.text = '파일 다운로드 중...'
//
//long ll_new
//long ll_filesize
//string ls_extension
//
//// 기 존재하는 파일 확인
//if fileexists(as_downloadpath) then
//	if messagebox('알림', '[' + as_downloadpath + ']~r~n다운로드 받을 파일이 이미 존재합니다.~r~n해당 파일을 덮어쓰기 하시겠습니까?', Question!, YesNo!, 2) = 2 then
//		close(iw_download)
//		return -1
//	end if
//end if
//
//// 다운로드할 파일 DW 표시
//iw_download.dw_filelist.reset()
//ll_new = iw_download.dw_filelist.insertrow(0)
//iw_download.dw_filelist.setitem(ll_new, 'filepath', as_downloadpath)
//iw_download.dw_filelist.setitem(ll_new, 'filename', gnv_extfunc.of_pathstrippath(as_downloadpath))
//iw_download.dw_filelist.setitem(ll_new, 'filesize', 0)
//iw_download.dw_filelist.scrolltorow(ll_new)
//iw_download.dw_filelist.setrow(ll_new)
//
//// HTTP 모듈 초기화
//gnv_extfunc.pf_http_globalinit()
//
//// HTTP header 설정
//gnv_extfunc.pf_http_addhttpheader("User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705) ")
//gnv_extfunc.pf_http_addhttpheader("Content-Type: application/x-www-form-urlencoded; charset=euc-kr")
////gnv_extfunc.pf_http_addhttpheader("Content-Type: multipart/form-data; charset=euc-kr")
//
//// 다운로드 URL 및 로컬 파일경로 설정
//if gnv_extfunc.pf_http_opendownload(as_downloadurl, as_downloadpath) = -1 then
//	gnv_extfunc.pf_http_globalcleanup()
//	messagebox('알림', 'pf_http_opendownload() 호출 오류 입니다~r~nas_downloadurl=' + string(as_downloadurl) + ', as_downloadpath=' + string(as_downloadpath))
//	return -1
//end if
//
//// 수신 파일명 및 서브 경로 설정
////as_downloadfile = this.of_urlencode(as_downloadfile)
////gnv_extfunc.pf_http_setpostfields("filename=" + as_downloadfile + "&subdir=" + as_subdir)
//gnv_extfunc.pf_http_setpostfields("filename=" + as_downloadfile + "&subdir=" + as_subdir)
//
//if gnv_extfunc.pf_http_send() <> 1 then
//	gnv_extfunc.pf_http_globalcleanup()
//	messagebox('알림', 'pf_http_send() 호출 오류 입니다')
//	return -1
//end if
//
//// 진행상태 점검
//li_running = gnv_extfunc.pf_http_checkrunningstatus()
//do while li_running = 1
//	yield()
//	
//	ld_dlnow = gnv_extfunc.pf_http_downloadprogress_now()
//	ld_dltotal = gnv_extfunc.pf_http_downloadprogress_total()
//	
//	if ld_dltotal <> ld_dltotal_bef then
//		iw_download.st_bytestotal.text = string(ld_dltotal, '#,##0')
//		iw_download.st_bytestotal_sum.text = string(ll_recv_sum + ld_dltotal, '#,##0')
//		ld_dltotal_bef = ld_dltotal
//	end if	
//	
//	if ld_dlnow <> ld_dlnow_bef then
//		iw_download.st_bytesrecv.text = string(ld_dlnow, '#,##0')
//		iw_download.st_bytesrecv_sum.text = string(ll_recv_sum + ld_dlnow, '#,##0')
//		ld_dlnow_bef = ld_dlnow
//	end if
//	
//	if ld_dlnow > 0 then
//		li_percent = int((ld_dlnow / ld_dltotal) * 100)
//		if li_percent <> li_percent_bef then
//			iw_download.hpb_file.position = li_percent
//			li_percent_bef = li_percent
//		end if
//	end if
//	
//	// 다운로드 취소 확인
//	if iw_download.ib_cancel = true then
//		gnv_extfunc.pf_http_abort()
//		exit
//	end if
//	
//	li_running = gnv_extfunc.pf_http_checkrunningstatus()
//loop
//
//// 결과코드 처리
//li_rc = gnv_extfunc.pf_http_getresultcode()
//if li_rc <> HTTP_OK then
//	ls_error = gnv_extfunc.pf_http_geterrormessage(li_rc)
//	gnv_extfunc.pf_http_close()
//	gnv_extfunc.pf_http_globalcleanup()
//	messagebox('HTTP 알림(' + string(li_rc) + ')', ls_error)
//	close(iw_download)
//	return -1
//end if
//
//// 마지막 진행상황 처리
//ld_dlnow = gnv_extfunc.pf_http_downloadprogress_now()
//if ld_dltotal > 0 then li_percent = int((ld_dlnow / ld_dltotal) * 100)
//iw_download.st_bytesrecv.text = string(ld_dlnow, '#,##0')
//iw_download.st_bytesrecv_sum.text = string(ll_recv_sum + ld_dlnow, '#,##0')
//iw_download.hpb_file.position = li_percent
//iw_download.hpb_total.position = li_percent
//ll_recv_sum += ld_dltotal
//
//// 다운로드 전송 속도
////ld_bytespersec = gnv_extfunc.pf_http_getinfo_double(HTTPINFO_SPEED_DOWNLOAD)
////iw_download.st_msg.text = string(ld_bytespersec / 1000, '#,##0') + ' Kbytes/sec'
//
//// HTTP Code 확인
//long ll_httpcode
//string ls_httpmesg
//ll_httpcode = gnv_extfunc.pf_http_getinfo_long(HTTPINFO_RESPONSE_CODE)
//if ll_httpcode >= 300 then
//	ls_httpmesg = '파일 다운로드 중 아래와 같은 오류가 발생했습니다~r~n~r~nHttp Code: ' + string(ll_httpcode) + '~r~nHttp Message: ' + &
//	this.of_getmessageofhttpcode(ll_httpcode) + '~r~nHttp Description: ' + this.of_getdescriptionofhttpcode(ll_httpcode)
//	gnv_extfunc.pf_http_close()	
//	gnv_extfunc.pf_http_globalcleanup()
//	messagebox('파일 다운로드 오류', ls_httpmesg)
//	close(iw_download)
//	return -1
//end if
//
//// HTTP 전송 종료
//gnv_extfunc.pf_http_close()
//gnv_extfunc.pf_http_globalcleanup()
//iw_download.cb_close.text = 'Close'
//
//// 결과 메시지 표시
//if len(ls_httpmesg) > 0 then
//	li_rc = -1
//	iw_download.st_msg.text = '파일 전송 오류!'
//elseif iw_download.ib_cancel = true then
//	li_rc = -1
//	iw_download.st_msg.text = '전송이 취소되었습니다!'
//else
//	iw_download.st_msg.text = '파일 다운로드 완료!'
//end if
//
//close(iw_download)
//return li_rc
//
end function

public function integer of_filedownload (string as_downloadfile, string as_downloadurl, string as_subdir, string as_downloadpath);string ls_downloadfiles[]
integer li_rc

ls_downloadfiles[1] = as_downloadfile
li_rc = this.of_filedownload(ls_downloadfiles[], as_downloadurl, as_subdir, as_downloadpath, false)
return li_rc

end function

on pf_n_httptransfer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_httptransfer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// 업, 다운로드 서블릿 URL 설정
//if isvalid(gnv_appconf) then
//	UPLOAD_URL = gnv_appconf.of_getproperty("httptransfer.upload_url")
//	DOWNLOAD_URL = gnv_appconf.of_getproperty("httptransfer.download_url")
//end if

// HTTPCODE 메시지용 데이터윈도우
ids_httpcode = create datastore
ids_httpcode.dataobject = 'pf_d_httpcode'

end event

event destructor;if isvalid(ids_httpcode) then
	destroy ids_httpcode
end if

end event

