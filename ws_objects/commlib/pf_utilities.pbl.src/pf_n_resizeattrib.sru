﻿$PBExportHeader$pf_n_resizeattrib.sru
$PBExportComments$리사이즈 서비스 Attribute 용 오브젝트 입니다.
forward
global type pf_n_resizeattrib from nonvisualobject
end type
end forward

global type pf_n_resizeattrib from nonvisualobject autoinstantiate
end type

type variables
Public:
graphicobject		wo_control
string		s_classname
string		s_typeof
boolean		b_scale
boolean		b_movex
boolean		b_movey
boolean		b_scalewidth
boolean		b_scaleheight
real		r_x
real		r_y
real		r_width
real		r_height
integer		i_widthmin
integer		i_heightmin
integer		i_movex
integer		i_movey
integer		i_scalewidth
integer		i_scaleheight

integer	i_originalWidth
integer	i_originalHeight
integer	i_originalTextSize

end variables

on pf_n_resizeattrib.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_resizeattrib.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

