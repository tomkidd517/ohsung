$PBExportHeader$pf_n_winrescale.sru
forward
global type pf_n_winrescale from nonvisualobject
end type
end forward

global type pf_n_winrescale from nonvisualobject
end type
global pf_n_winrescale pf_n_winrescale

type variables
protected:
	window iw_parent
	datawindow idw_target
	integer ii_width
	integer ii_height
	boolean ib_smaller

public:
	integer ii_colcnt
	string is_colname[]
	string is_coltype[]
	integer ii_colx[]
	//integer ii_coly[]
	integer ii_colwidth[]
	//integer ii_colheight[]

end variables

forward prototypes
public function integer of_register (datawindow adw_target)
public function integer of_resize (integer ai_width, integer ai_height)
public function long of_parsetoarray (string as_sourcestring, string as_delimiter, ref string as_outputarray[])
end prototypes

public function integer of_register (datawindow adw_target);// 컬럼 및 데이터윈도우 상태값 저장

if not isvalid(adw_target) then return -1

// 데이터 윈도우 속성 저장
idw_target = adw_target
ii_width = adw_target.width
ii_height = adw_target.height

// 컬럼 속성 저장
long ll_objcnt, i
string ls_objects[]
string ls_visible, ls_xpos

ii_colcnt = 0
ll_objcnt = this.of_parsetoarray(adw_target.describe("Datawindow.Objects"), "~t", ls_objects[])
for i = 1 to ll_objcnt
	ls_visible = adw_target.describe(ls_objects[i] + ".visible")
	ls_xpos = adw_target.describe(ls_objects[i] + ".x")
	
	if ls_visible = '1' or isnumber(ls_xpos) then
		ii_colcnt ++
		is_colname[ii_colcnt] = ls_objects[i]
		is_coltype[ii_colcnt] = adw_target.describe(ls_objects[i] + ".type")
		
		if is_coltype[ii_colcnt] = 'line' then
			ii_colx[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".x1"))
			//ii_coly[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".y1"))
			ii_colwidth[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".x2"))
			//ii_colheight[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".y2"))
		else
			ii_colx[ii_colcnt] = integer(ls_xpos)
			//ii_coly[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".y"))
			ii_colwidth[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".width"))
			//ii_colheight[ii_colcnt] = integer(adw_target.describe(ls_objects[i] + ".height"))
		end if
	end if
next

return 1

end function

public function integer of_resize (integer ai_width, integer ai_height);// resize

if not isvalid(idw_target) then return -1

double ld_xratio, ld_yratio
integer i, li_xpos, li_width
string ls_syntax, ls_error

if ai_width > ii_width then
	ib_smaller = false
	ld_xratio = 1 + (ai_width - ii_width) / ii_width
	
	for i = 1 to ii_colcnt
		li_xpos = ii_colx[i] * ld_xratio
		li_width = ii_colwidth[i] * ld_xratio
		
		if is_coltype[i] = 'line' then
			ls_syntax += is_colname[i] + ".x1=" + string(li_xpos) + " " + is_colname[i] + ".x2=" + string(li_width) + " "
		else
			ls_syntax += is_colname[i] + ".x=" + string(li_xpos) + " " + is_colname[i] + ".width=" + string(li_width) + " "
		end if
	next
else
	if ib_smaller = false then
		for i = 1 to ii_colcnt
			if is_coltype[i] = 'line' then
				ls_syntax += is_colname[i] + ".x1=" + string(ii_colx[i]) + " " + is_colname[i] + ".x2=" + string(ii_colwidth[i]) + " "
			else
				ls_syntax += is_colname[i] + ".x=" + string(ii_colx[i]) + " " + is_colname[i] + ".width=" + string(ii_colwidth[i]) + " "
			end if
		next
		
		ib_smaller = true
	end if
end if

ls_error = idw_target.modify(ls_syntax)
if len(ls_error) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_resize() failure!!', ls_error)
	return -1
end if

return 1

end function

public function long of_parsetoarray (string as_sourcestring, string as_delimiter, ref string as_outputarray[]);LONG lPosEnd, lPosStart = 1, ll_delimiterLen, lCounter = 1

IF UpperBound(as_outputarray) > 0 THEN as_outputarray = {""}
ll_delimiterLen = len(as_delimiter)

lPosEnd = Pos (as_sourcestring, as_delimiter, 1)

DO WHILE lPosEnd > 0
     as_outputarray[lCounter] = Mid (as_sourcestring, lPosStart, lPosEnd - lPosStart)
     lPosStart = lPosEnd + ll_delimiterLen
     lPosEnd = Pos (as_sourcestring, as_delimiter, lPosStart)
     lCounter++
LOOP

as_outputarray[lCounter] = Right (as_sourcestring, Len(as_sourcestring) - lPosStart + 1)
RETURN lCounter

end function

on pf_n_winrescale.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_winrescale.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

