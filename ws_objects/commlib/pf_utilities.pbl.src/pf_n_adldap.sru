$PBExportHeader$pf_n_adldap.sru
$PBExportComments$LDAP 연동용 NVO
forward
global type pf_n_adldap from nonvisualobject
end type
end forward

global type pf_n_adldap from nonvisualobject
end type
global pf_n_adldap pf_n_adldap

type variables
string is_domain = ""
string is_basedn = "";
//string is_domain = "{ldap_ip}"
//string is_basedn = "OU=Users,DC=ad"

end variables

forward prototypes
public function string of_getfield (string as_userid, string as_fieldname)
public function string of_getbasedomain ()
public subroutine of_setdomain (string as_domain)
public subroutine of_setbasedn (string as_basedn)
public function boolean of_connecterror (integer ai_rc, string as_conn)
public function string of_getldaperrormesg (integer al_errornumber)
public function integer of_checklogin (string as_userid, string as_password)
end prototypes

public function string of_getfield (string as_userid, string as_fieldname);// createtimestamp, useraccountcontrol, badpwdcount, samaccountname, cn, mail, pwdLastSet

OLEObject adoCommand
OLEObject adoConnection
OLEObject adoRecordset
String ls_Query, ls_Name, ls_Type, ls_Value, ls_retval
Long ll_nextrow, ll_Value
Integer li_rc, li_col, li_max

adoCommand = create OLEObject
adoConnection = create OLEObject

// Setup ADO objects
li_rc = adoCommand.ConnectToNewObject("ADODB.Command")
//If of_ConnectError(li_rc, "ADODB.Command") Then Return ''

li_rc = adoConnection.ConnectToNewObject("ADODB.Connection")
//If of_ConnectError(li_rc, "ADODB.Connection") Then Return ''

adoConnection.Provider = "ADsDSOObject"
adoConnection.Open("Active Directory Provider")
adoCommand.ActiveConnection = adoConnection

// Construct the SQL syntax query
ls_Query = "SELECT " + as_fieldname + " "
ls_Query +=  "FROM 'LDAP://" + is_domain + "/" + is_basedn + "' "
ls_Query +=  "WHERE objectClass='user' and objectCategory='person' and cn='" + as_userid + "'"

try 
           // Run the query
           adoCommand.CommandText = ls_Query
           adoRecordset = adoCommand.Execute
           // Enumerate the resulting recordset
           If Not adoRecordset.EOF Then
                     ls_retval = String(adoRecordset.Fields(as_fieldname).Value)
           End If
           // Close the connection
           adoRecordset.Close
catch ( oleruntimeerror orte )
           MessageBox("OLERuntimeError", orte.Text)
end try

// Close the connection
adoConnection.Close

if isvalid(adoRecordset) then adoRecordset.disconnectobject()
if isvalid(adoConnection) then adoConnection.disconnectobject()
if isvalid(adoCommand) then adoCommand.disconnectobject()

Return ls_retval

end function

public function string of_getbasedomain ();// LDAP Base Domain 을 가져옵니다.

OLEObject adoRootDSE
String ls_DNSDomain
Integer li_rc

adoRootDSE = create OLEObject

// Determine the domain
li_rc = adoRootDSE.ConnectToObject("LDAP://RootDSE")
//If of_ConnectError(li_rc, "ADODB.Connection") Then Return ''

ls_DNSDomain = adoRootDSE.Get("defaultNamingContext")

// Close the connection
adoRootDSE.disconnectobject()

return ls_DNSDomain

end function

public subroutine of_setdomain (string as_domain);this.is_domain = as_domain

end subroutine

public subroutine of_setbasedn (string as_basedn);this.is_basedn = as_basedn

end subroutine

public function boolean of_connecterror (integer ai_rc, string as_conn);String ls_errmsg

choose case ai_rc
           case 0
                     // no error
                     Return False
           case -1
                     ls_errmsg = "Invalid Call: the argument is the Object property of a control"
           case -2
                     ls_errmsg = "Class name not found"
           case -3
                     ls_errmsg = "Object could not be created"
           case -4
                     ls_errmsg = "Could not connect to object"
           case -9
                     ls_errmsg = "Other error"
           case -15
                     ls_errmsg = "COM+ is not loaded on this computer"
           case -16
                     ls_errmsg = "Invalid Call: this function not applicable"
           case else
                     ls_errmsg = "Undefined error: " + String(ai_rc)
end choose

MessageBox("Error connecting to " + as_conn, ls_errmsg, StopSign!)

Return True

end function

public function string of_getldaperrormesg (integer al_errornumber);// LDAP 에러 메시지를 가져옵니다(OpenDSObject 수행 후)
// https://msdn.microsoft.com/en-us/library/aa746530(v=vs.85).aspx

//         1317(0x525)       사용자를 찾을 수 없음
//         1326(0x52e)       잘못된 자격 증명
//         1328(0x530)       현재 로그온 할 수 없습니다.
//         1329(0x531)       이 워크 스테이션에서 로그온 할 수 없습니다.
//         1330(0x532)       암호가 만료되었습니다.
//         1331(0x533)      계정 사용 안 함 
//         1332(0x534)       이 시스템에서 요청한 로그온 유형이 사용자에게 부여되지 않았습니다.
//         1793(0x701)       계정 만료
//         1907(0x773)       사용자는 암호를 재설정해야합니다.
//         1909(0x775)       사용자 계정 잠김                     

string ls_errorMSG

choose case al_errorNumber
           //Success
           Case 0
                     ls_errorMSG = ""
           Case 1317         
                     ls_errorMSG = "사용자를 찾을 수 없음"
           Case 1326         
                     ls_errorMSG = "잘못된 자격 증명"
           Case 1328         
                     ls_errorMSG = "현재 로그온 할 수 없습니다."
           Case 1329         
                     ls_errorMSG = "이 워크 스테이션에서 로그온 할 수 없습니다."
           Case 1330         
                     ls_errorMSG = "암호가 만료되었습니다."
           Case 1331         
                     ls_errorMSG = "계정 사용 안 함 "
           Case 1332         
                     ls_errorMSG = "이 시스템에서 요청한 로그온 유형이 사용자에게 부여되지 않았습니다."
           Case 1793         
                     ls_errorMSG = "계정 만료"
           Case 1907         
                     ls_errorMSG = "사용자는 암호를 재설정해야합니다."
           Case 1909         
                     ls_errorMSG = "사용자 계정 잠김"
           Case Else
                     ls_errorMSG = "Unknown error"
End Choose

return ls_errorMSG

end function

public function integer of_checklogin (string as_userid, string as_password);// LDAP 로그인 확인

// 리턴코드
//         0(0x000)                     인증성공
//         1317(0x525)       사용자를 찾을 수 없음
//         1326(0x52e)       잘못된 자격 증명
//         1328(0x530)       현재 로그온 할 수 없습니다.
//         1329(0x531)       이 워크 스테이션에서 로그온 할 수 없습니다.
//         1330(0x532)       암호가 만료되었습니다.
//         1331(0x533)      계정 사용 안 함 
//         1332(0x534)       이 시스템에서 요청한 로그온 유형이 사용자에게 부여되지 않았습니다.
//         1793(0x701)       계정 만료
//         1907(0x773)       사용자는 암호를 재설정해야합니다.
//         1909(0x775)       사용자 계정 잠김                     

OLEObject ole_wsh
Boolean lb_Result
String ls_code
Integer li_rc

// define VBScript
//ls_code  = 'Function fnCheckAccess()~r~n' &
//                        + 'const ADS_SECURE_AUTHENTICATION = &h0001~r~n' &
//                        + 'const ADS_CHASE_REFERRALS_ALWAYS = &H60~r~n' &
//                        + 'strDomain = "' + is_Domain + '"~r~n' &
//                        + 'strUserID = "' + as_Userid + '"~r~n' &
//                        + 'strUserPWD = "' + as_Password + '"~r~n' &
//                        + 'strBaseDN = "' + is_BaseDn + '"~r~n' &
//                        + 'strPath = "LDAP://" & strDomain & "/" & strBaseDN~r~n' &
//                        + 'On Error Resume Next~r~n' &
//                        + 'set objDSO = GetObject("LDAP:")~r~n' &
//                        + 'set objUser = objDSO.OpenDSObject(strPath, strUserID, strUserPWD, ADS_SECURE_AUTHENTICATION OR ADS_CHASE_REFERRALS_ALWAYS)~r~n' &
//                        + 'if Err.Number <> 0 then~r~n' &
//                        + '   fnCheckAccess = False~r~n' &
//                        + 'else~r~n' &
//                        + '   fnCheckAccess = True~r~n' &
//                        + 'end if~r~n' &
//                        + 'Err.Clear~r~n' &
//                        + 'On Error Goto 0~r~n' &
//                        + 'set objDSO = Nothing~r~n' &
//                        + 'set objUser = Nothing~r~n' &
//                        + 'end function'

ls_code  = 'Function fnCheckAccess()~r~n' &
                        + 'const ADS_SECURE_AUTHENTICATION = &h0001~r~n' &
                        + 'const ADS_CHASE_REFERRALS_ALWAYS = &H60~r~n' &
                        + 'strDomain = "' + is_Domain + '"~r~n' &
                        + 'strUserID = "' + as_Userid + '"~r~n' &
                        + 'strUserPWD = "' + as_Password + '"~r~n' &
                        + 'strBaseDN = "' + is_BaseDn + '"~r~n' &
                        + 'strPath = "LDAP://" & strDomain & "/" & strBaseDN~r~n' &
                        + 'On Error Resume Next~r~n' &
                        + 'set objDSO = GetObject("LDAP:")~r~n' &
                        + 'set objUser = objDSO.OpenDSObject(strPath, strUserID, strUserPWD, ADS_SECURE_AUTHENTICATION OR ADS_CHASE_REFERRALS_ALWAYS)~r~n' &
                        + 'fnCheckAccess = Err.Number~r~n' &
                        + 'Err.Clear~r~n' &
                        + 'On Error Goto 0~r~n' &
                        + 'set objDSO = Nothing~r~n' &
                        + 'set objUser = Nothing~r~n' &
                        + 'end function'

ole_wsh = CREATE OLEObject
ole_wsh.ConnectToNewObject("MSScriptControl.ScriptControl")

// set the VBScript
ole_wsh.Language = "vbscript"
ole_wsh.AddCode(ls_code)

// run the function
li_rc = integer(ole_wsh.Eval("fnCheckAccess"))

ole_wsh.DisconnectObject()
DESTROY ole_wsh

Return li_rc

end function

on pf_n_adldap.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_adldap.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

