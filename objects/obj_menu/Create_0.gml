/// @desc 

event_inherited();

func_menu_game_start = function()
	{
	obj_game.func_game_setup();
	
	}
func_menu_game_end = function()
	{
	game_end();
	}

#region UI


manu_group_main = 0;
manu_group_options = 0;
manu_group_optWin = 0;
manu_group_optScoHeal = 0;
manu_group_optTime = 0;
manu_group_optRules = 0;

manu_group_other = 0;

/*
updated UI system!!

menu_selected == index of the hovered over menu element
menu_action == true if action taken ()atm only mb_left


if func_UIES_check_selaction()

_x1,_y1,_x2,_y2,_index,_str,_g_enabled,_gt
*/


#region func step

func_button_int_start = function()
	{
	if func_UIES_check_selaction()
	with(menu)
		{
		func_menu_game_start();
		Func_UI_group_enable(manu_group_main,false);
		Func_UI_group_enable(manu_group_other,false);
			
		alarm[0] = UI_group_grid[# UI_GROUP_INDEX.time,manu_group_main];
		}
	}
func_button_int_end = function()
	{
	if func_UIES_check_selaction() or keyboard_check_pressed(vk_escape)
		with(menu) func_menu_game_end();
	}

func_button_int_switch_options = function()
	{
	/*
	manu_group_main
	
	manu_group_options
	
	manu_group_optWin
	manu_group_optScoHeal
	manu_group_optGame
	
	manu_group_options
	
	menu_element_main_swOpt
	menu_element_opt_swMain
	*/
	var _back = keyboard_check_pressed(vk_escape);
	var _index = index;
	
	if func_UIES_check_selaction() or _back
	with(menu)
		{
		/*
		switch(_index)
			{
			case menu_element_opt_swMain:
			case menu_element_main_swOpt:
				Func_menu_group_switch(manu_group_main,manu_group_options);
			}
		//*/
		func_button_subopt_closeall();
		Func_menu_group_switch(manu_group_main,manu_group_options);
		}
	}
func_button_int_optionsub_group_sw = function()//switch option sub groups on and off
	{
	/*
	manu_group_main
	
	manu_group_options
	
	manu_group_optWin
	manu_group_optScoHeal
	manu_group_optTime
	manu_group_optRules
	
	manu_group_other
	*/
	var _index = index;
	
	if func_UIES_check_selaction()
	with(menu)
		{
		func_button_subopt_closeall();
		
		//activate only one I want
		switch(_index)
			{
			case menu_element_opt_swWin:
				Func_UI_group_enable(manu_group_optWin,true);
			break;
			case menu_element_opt_swScoHeal:
				Func_UI_group_enable(manu_group_optScoHeal,true);
			break;
			case menu_element_opt_swTime:
				Func_UI_group_enable(manu_group_optTime,true);
			break;
			case menu_element_opt_swRules:
				Func_UI_group_enable(manu_group_optRules,true);
			break;
			}
		}
	}

func_button_subopt_closeall = function()
	{
	//deactivate all
	Func_UI_group_enable(manu_group_optWin,false);
	Func_UI_group_enable(manu_group_optScoHeal,false);
	Func_UI_group_enable(manu_group_optTime,false);
	Func_UI_group_enable(manu_group_optRules,false);
	}
func_button_handinfo_closeall = function()
	{
	//deactivate all
	Func_UI_group_enable(manu_group_optRulesAnarchy,false);
	Func_UI_group_enable(manu_group_optRulesSoft,false);
	Func_UI_group_enable(manu_group_optRulesSpikey,false);
	}


func_button_int_options = function()
	{
	var _id = index;
	var _str = text;
	var _click = func_UIES_check_selaction();
	var _group = group;
	with(menu)
		{
		switch(_id)
			{
			#region general
			#region reset
			case menu_element_opt_reset:
		
			if _click
				obj_game.Func_game_rule_reset();
		
			break;	
			#endregion
			#endregion
			#region optWin
			#region optWin_needed
			case menu_element_optWin_needed:
			
			if _click
				global.Game_Wins_needed = max((global.Game_Wins_needed + 1) mod 11, 1);
			_str = string(global.Game_Wins_needed) + " :Wins needed";
			
			break;
			#endregion
			#region optWin_against
			case menu_element_optWin_against:
		
			if _click
				global.Game_Wins_against = !global.Game_Wins_against;
		
			_str = (global.Game_Wins_against ? "Yes" : "No")+" :Wins against";
		
			break;
			#endregion
			#endregion
			#region optScoHe
			#region optScoHe_scoType
			case menu_element_optScoHe_scoType:
		
			if _click
				{
				switch(global.Rule_Score_type)
					{
					case SCORE_TYPE.st_health:
						global.Rule_Score_type = SCORE_TYPE.st_points;
					break;
					case SCORE_TYPE.st_points:
						global.Rule_Score_type = SCORE_TYPE.st_health;
					break;
					}
				}
		
			switch(global.Rule_Score_type)
				{
				case SCORE_TYPE.st_health:
					_str = "Health";
				break;
				case SCORE_TYPE.st_points:
					_str = "Points";
				break;
				}
			_str = _str + " :Scoring system";
		
			break;
			#endregion
			#region optScoHe_scoNeed
			case menu_element_optScoHe_scoNeed:
		
			if _click
				global.Game_Score_needed = (global.Game_Score_needed + 1) mod 10;
		
			_str = string(global.Game_Score_needed) + " :Score needed";
		
			break;
			#endregion
			#region optScoHe_helMax
			case menu_element_optScoHe_helMax:
			
			if _click
				{
				var _step = 5;
				global.Rule_Health_max = clamp((global.Rule_Health_max + _step) mod 50,_step,50);
				}
			
			_str = string(global.Rule_Health_max) + " :Health Maximum";
			
			break;
			#endregion
			#endregion
			#region optTime
			#region optGame_timer
			case menu_element_optTime_timer:
		
			if _click
				global.Rule_Timer = !global.Rule_Timer;
		
			_str = (global.Rule_Timer ? "Yes" : "No")+ ": Use Timer";
		
			break;
			#endregion
			#region optGame_timTime
			case menu_element_optTime_timTime:
		
			if _click
				{
				var _step = global.Game_speed * 0.5;
				var _max = global.Game_speed * 10.5;
			
				global.Rule_Timer_Time = clamp((global.Rule_Timer_Time + _step) mod _max,_step,_max);
				}
		
			_str = string_format(global.Rule_Timer_Time/global.Game_speed,2,2)+" seconds" + " Time for each action";
		
			break;
			#endregion
			#endregion
			#region optRules
			#region optRules_Hand
			case menu_element_optRules_Hand:
			
			/*
			manu_group_optRulesAnarchy							
			manu_group_optRulesSoft						
			manu_group_optRulesSpikey
			*/
			if _click
				{
				global.Rule_Hand_self = (global.Rule_Hand_self+1) mod 3;
				}
			
			
			
			if Func_UI_group_is_anabled(_group)
				{
				switch(global.Rule_Hand_self)
					{
					case RULE_HAND_SELF.anarchy:	_str = "Anarchy";	if !Func_UI_group_is_anabled(manu_group_optRulesAnarchy)	{func_button_handinfo_closeall(); Func_UI_group_enable(manu_group_optRulesAnarchy,true)}	break;
					case RULE_HAND_SELF.soft:		_str = "Soft";		if !Func_UI_group_is_anabled(manu_group_optRulesSoft)		{func_button_handinfo_closeall(); Func_UI_group_enable(manu_group_optRulesSoft,true)}		break;
					case RULE_HAND_SELF.spikey:	_str = "Spikey";	if !Func_UI_group_is_anabled(manu_group_optRulesSpikey)	{func_button_handinfo_closeall(); Func_UI_group_enable(manu_group_optRulesSpikey,true)}		break;
					default:						_str = "?????";
					}
				_str = _str + " :Hand Play Rule";
				}
			else
				func_button_handinfo_closeall();
			
			break;
			#endregion
			#endregion
			}
		}
	//save text
	if text != _str
		{
		func_UIESP_set_text(_str, 2);//sets begin points
		}
	}

#endregion
#region creating element and groups

var _func_create_menu_element = function(_reset=false, _rot_start = undefined, _sep = undefined, _dist = undefined, _constructor,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1)
	{
	static _element_rot = _rot_start;
	static _element_sep = _sep;
	static _element_dist = obj_game.basecircle_rad_base + sprite_get_width(spr_hand) + _dist;
	
	if _reset
		{
		if _rot_start	!= undefined	{_element_rot =		_rot_start;																				}
		if _sep		!= undefined	{_element_sep =		_sep;																					}
		if _dist		!= undefined	{_element_dist =	obj_game.basecircle_rad_base + sprite_get_width(spr_hand) + _dist;						}
		}
	
	static _element_w = 50;
	static _element_h = sprite_get_height(spr_hand_stretch);
	
	
	
	//create new element
	var _element = Func_menu_create_button_halo(_constructor,_group,_element_rot,_element_w,_element_h,_element_dist,_text,_create_func,_step_func,_draw_func);//
	
	//progress
	if _element_sep != 0		//measures direction to front bottom edge from game_point x2 as minimum element sep
		_element_rot += max(-angle_difference(_element_rot ,point_direction(global.Game_point_x,global.Game_point_y,_element.x3,_element.y3))*2, abs(_element_sep)) * sign(_element_sep);
	
	return _element;
	}


#region main

manu_group_main = Func_UI_create_group(true,0,group_speed,false,true);
							_func_create_menu_element(true,175,20,10,	Constructor_UIP_element_orient_end,manu_group_main,"Start"		,,func_button_int_start,			Func_button_draw_main);
							_func_create_menu_element(,,,,				Constructor_UIP_element_orient_end,manu_group_main,"Options"	,,func_button_int_switch_options,	Func_button_draw_main);
							_func_create_menu_element(,,,,				Constructor_UIP_element_orient_end,manu_group_main,"Exit"		,,func_button_int_end,				Func_button_draw_main);
#endregion
#region options

#region general

manu_group_options = Func_UI_create_group(false,0,group_speed,false,true);

							_func_create_menu_element(true,150,15,0,	Constructor_UIP_element_orient_end,manu_group_options,"-OPTIONS-"		,,-1,									Func_button_draw_main);
							_func_create_menu_element(,,,,				Constructor_UIP_element_orient_end,manu_group_options,"Back"			,,func_button_int_switch_options,		Func_button_draw_main);
menu_element_opt_swWin		= _func_create_menu_element(,,,,			Constructor_UIP_element_orient_end,manu_group_options,"Winning"			,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_opt_swScoHeal	= _func_create_menu_element(,,,,			Constructor_UIP_element_orient_end,manu_group_options,"Score and Health",,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_opt_swTime		= _func_create_menu_element(,,,,			Constructor_UIP_element_orient_end,manu_group_options,"Timer"			,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_opt_swRules	= _func_create_menu_element(,,,,			Constructor_UIP_element_orient_end,manu_group_options,"Hand Rules"		,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_opt_reset		= _func_create_menu_element(,,,,			Constructor_UIP_element_orient_end,manu_group_options,"Reset"			,,func_button_int_options,				Func_button_draw_main);


#endregion


var _subrot = 20;
var _subdist = -20;
#region wins
//*

manu_group_optWin = Func_UI_create_group(false,0,group_speed,false,true);
								_func_create_menu_element(true,20,-20,-10,				Constructor_UIP_element_orient_end,manu_group_optWin,"-Winning-"	,,,										Func_button_draw_main);
//menu_element_optWin_swOpt		= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optWin,"Back"				,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_optWin_needed		= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optWin,""					,,func_button_int_options,				Func_button_draw_main);
menu_element_optWin_against		= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optWin,""					,,func_button_int_options,				Func_button_draw_main);
//*/

#endregion
#region score / health
//*

manu_group_optScoHeal = Func_UI_create_group(false,0,group_speed,false,true);

								_func_create_menu_element(true,_subrot,-5,_subdist,		Constructor_UIP_element_orient_end,manu_group_optScoHeal,"-Score and Health-"		,,,										Func_button_draw_main);
//menu_element_optScoHe_swOpt	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optScoHeal,"Back"						,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_optScoHe_scoType	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optScoHeal,""							,,func_button_int_options,				Func_button_draw_main);
menu_element_optScoHe_scoNeed	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optScoHeal,""							,,func_button_int_options,				Func_button_draw_main);
menu_element_optScoHe_helMax	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optScoHeal,""							,,func_button_int_options,				Func_button_draw_main);

//*/
#endregion
#region timer
//*

manu_group_optTime = Func_UI_create_group(false,0,group_speed,false,true);
								_func_create_menu_element(true,_subrot,-20,_subdist,	Constructor_UIP_element_orient_end,manu_group_optTime,"-Timer-"			,,,										Func_button_draw_main);
//menu_element_optTime_swOpt	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optTime,"Back"				,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_optTime_timer		= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optTime,""					,,func_button_int_options,				Func_button_draw_main);
menu_element_optTime_timTime	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optTime,""					,,func_button_int_options,				Func_button_draw_main);

//*/
#endregion
#region rules
//*
var _handrot = 55;
manu_group_optRules = Func_UI_create_group(false,0,group_speed,true,true);

#region info text
var _inforot = _handrot - 45;
var _infodist = 0;
//can beat your own hand for points
//can play onto your own hand
//if oyu play onto your own hand you loos points
//global.Rule_Hand_self == RULE_HAND_SELF.anarchy
manu_group_optRulesAnarchy =	Func_UI_create_group(false,0,group_speed,false,true);
manu_group_optRulesSoft =		Func_UI_create_group(false,0,group_speed,false,true);
manu_group_optRulesSpikey =		Func_UI_create_group(false,0,group_speed,false,true);
_func_create_menu_element(true,_inforot,-20,_infodist,		Constructor_UIP_element_orient_end,	manu_group_optRulesAnarchy,	"can beat your own"							,,,Func_button_draw_main);
_func_create_menu_element(,,,,								Constructor_UIP_element_orient_end,	manu_group_optRulesAnarchy,	"hand for points"							,,,Func_button_draw_main);

_func_create_menu_element(true,_inforot,-20,_infodist,		Constructor_UIP_element_orient_end,	manu_group_optRulesSoft,	"can play onto"								,,,Func_button_draw_main);
_func_create_menu_element(,,,,								Constructor_UIP_element_orient_end,	manu_group_optRulesSoft,	"your own hand"								,,,Func_button_draw_main);

_func_create_menu_element(true,_inforot,-20,_infodist,		Constructor_UIP_element_orient_end,	manu_group_optRulesSpikey,	"play onto your own hand"					,,,Func_button_draw_main);
_func_create_menu_element(,,,,								Constructor_UIP_element_orient_end,	manu_group_optRulesSpikey,	"but lose points"							,,,Func_button_draw_main);

#endregion

								_func_create_menu_element(true,_handrot,-20,_subdist,	Constructor_UIP_element_orient_end,manu_group_optRules,"-Hand Rules-"			,,,										Func_button_draw_main);
//menu_element_optRules_swOpt	= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optRules,"Back"				,,func_button_int_optionsub_group_sw,	Func_button_draw_main);
menu_element_optRules_Hand		= _func_create_menu_element(,,,,						Constructor_UIP_element_orient_end,manu_group_optRules,""					,,func_button_int_options,				Func_button_draw_main);


//*/

#endregion


#endregion
#region other

//manu_group_other = Func_UI_create_group(true,0,group_speed,false,true);
//var _y = room_height - 20;
//var _x = 20;
//Func_UI_add_element(Constructor_UIP_element_orient_begin,manu_group_other,_x,_y,_x + 50,_y,"Feedback Would be appreciated.",,,Func_button_draw_main);

#endregion
#endregion
#endregion