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
manu_group_optGame = 0;
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

func_button_int_switch_group = function()
	{
	var _back = keyboard_check_pressed(vk_escape);
	var _index = index;
	
	if func_UIES_check_selaction() or _back
	with(menu)
		{
		//dont know how to do it better am :(
		if _back
			switch(_index)
				{
				case menu_element_opt_swMain:
					Func_menu_group_switch(manu_group_main,manu_group_options);
				break;
				case menu_element_optWin_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optWin);
				break;
				case menu_element_optScoHe_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optScoHeal);
				break;
				case menu_element_optGame_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optGame);
				break;
				}
		else
			switch(_index)
				{
				case menu_element_opt_swMain:
				case menu_element_main_swOpt:
					Func_menu_group_switch(manu_group_main,manu_group_options);
				break;
				case menu_element_opt_swWin:
				case menu_element_optWin_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optWin);
				break;
				case menu_element_opt_swScoHeal:
				case menu_element_optScoHe_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optScoHeal);
				break;
				case menu_element_opt_swGame:
				case menu_element_optGame_swOpt:
					Func_menu_group_switch(manu_group_options,manu_group_optGame);
				break;
				}
		}
	}

func_button_int_options = function()
	{
	var _id = index;
	var _str = text;
	with(menu)
		{
		var _click = _id==menu_selected and menu_action;
		
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
			_str = "Wins needed: "+ string(global.Game_Wins_needed);
		
			break;
			#endregion
			#region optWin_against
			case menu_element_optWin_against:
		
			if _click
				global.Game_Wins_against = !global.Game_Wins_against;
		
			_str = "Wins counted against: "+(global.Game_Wins_against ? "Enabled" : "Disabled");
		
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
			_str = "Scoring system: "+ _str;
		
			break;
			#endregion
			#region optScoHe_scoNeed
			case menu_element_optScoHe_scoNeed:
		
			if _click
				global.Game_Score_needed = (global.Game_Score_needed + 1) mod 10;
		
			_str = "Score needed: "+string(global.Game_Score_needed);
		
			break;
			#endregion
			#region optScoHe_helMax
			case menu_element_optScoHe_helMax:
		
			if _click
				{
				var _step = 5;
				global.Rule_Health_max = clamp((global.Rule_Health_max + _step) mod 50,_step,50);
				}
		
			_str = "Health Maximum: "+string(global.Rule_Health_max);
		
			break;
			#endregion
			#endregion
			#region optGame
			#region optGame_timer
			case menu_element_optGame_timer:
		
			if _click
				global.Rule_Timer = !global.Rule_Timer;
		
			_str = "Use Timer: "+(global.Rule_Timer ? "Enabled" : "Disabled");
		
			break;
			#endregion
			#region optGame_timTime
			case menu_element_optGame_timTime:
		
			if _click
				{
				var _step = global.Game_speed * 0.5;
				var _max = global.Game_speed * 10.5;
			
				global.Rule_Timer_Time = clamp((global.Rule_Timer_Time + _step) mod _max,_step,_max);
				}
		
			_str = "Time for each action: "+string_format(global.Rule_Timer_Time/global.Game_speed,2,2)+" seconds";
		
			break;
			#endregion
			#region optGame_Hand
			case menu_element_optGame_Hand:
		
			if _click
				global.Rule_Hand_self = (global.Rule_Hand_self+1) mod 3;
		
			switch(global.Rule_Hand_self)
				{
				case RULE_HAND_SELF.anarchy:
					_str = "Anarchy";
				break;
				case RULE_HAND_SELF.soft:
					_str = "Soft";
				break;
				case RULE_HAND_SELF.spikey:
					_str = "Spikey";
				break;
				default:
					_str = "?????";
				}
			_str = "Hand Play Rule: "+ _str;
			break;
			#endregion
			#endregion
			}
		}
	//save test
	text = _str;
	}

#endregion
#region creating element and groups


var _element_x = 20;
var _element_y = 20;
var _element_w = 50;
var _element_h = sprite_get_height(spr_hand_stretch);
var _element_sep = 10;




#region main

manu_group_main = Func_UI_create_group(true,0,group_speed,false,true);

var _x = _element_x;
var _y = _element_y;
var _x2 = _x + _element_w;
var _y2 = _y + _element_h;
Func_UI_add_element(Constructor_UIP_element,manu_group_main,_x,_y,_x2,_y2,"Start",Func_button_create_func,func_button_int_start,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_main_swOpt = Func_UI_add_element(Constructor_UIP_element,manu_group_main,_x,_y,_x2,_y2,"Options",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

Func_UI_add_element(Constructor_UIP_element,manu_group_main,_x,_y,_x2,_y2,"Exit",Func_button_create_func,func_button_int_end,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
#endregion
#region options

#region general

var _x = _element_x;
var _y = _element_y;
var _x2 = _x + _element_w;
var _y2 = _y + _element_h;

manu_group_options = Func_UI_create_group(false,0,group_speed,false,true);



Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Game Rules",Func_button_create_func,-1,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_opt_swMain = Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Back",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_opt_swWin = Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Winning",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_opt_swScoHeal = Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Score and Health",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_opt_swGame = Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Gameplay",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_opt_reset = Func_UI_add_element(Constructor_UIP_element,manu_group_options,_x,_y,_x2,_y2,"Reset",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;



#endregion
#region wins
//*

var _x = _element_x;
var _y = _element_y;
var _x2 = _x + _element_w;
var _y2 = _y + _element_h;
manu_group_optWin = Func_UI_create_group(false,0,group_speed,false,true);

Func_UI_add_element(Constructor_UIP_element,manu_group_optWin,_x,_y,_x2,_y2,"Options: Winning",Func_button_create_func,-1,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_optWin_swOpt = Func_UI_add_element(Constructor_UIP_element,manu_group_optWin,_x,_y,_x2,_y2,"Back",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
//global.Game_Wins_needed	// 
menu_element_optWin_needed = Func_UI_add_element(Constructor_UIP_element,manu_group_optWin,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
//global.Game_Wins_against	// bool
menu_element_optWin_against = Func_UI_add_element(Constructor_UIP_element,manu_group_optWin,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
//*/

#endregion
#region score / health
//*

var _x = _element_x;
var _y = _element_y;
var _x2 = _x + _element_w;
var _y2 = _y + _element_h;
manu_group_optScoHeal = Func_UI_create_group(false,0,group_speed,false,true);

Func_UI_add_element(Constructor_UIP_element,manu_group_optScoHeal,_x,_y,_x2,_y2,"Options: Score and Health",Func_button_create_func,-1,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_optScoHe_swOpt = Func_UI_add_element(Constructor_UIP_element,manu_group_optScoHeal,_x,_y,_x2,_y2,"Back",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optScoHe_scoType = Func_UI_add_element(Constructor_UIP_element,manu_group_optScoHeal,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optScoHe_scoNeed = Func_UI_add_element(Constructor_UIP_element,manu_group_optScoHeal,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optScoHe_helMax = Func_UI_add_element(Constructor_UIP_element,manu_group_optScoHeal,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
//*/
#endregion
#region gameplay rules
//*


var _x = _element_x;
var _y = _element_y;
var _x2 = _x + _element_w;
var _y2 = _y + _element_h;
manu_group_optGame = Func_UI_create_group(false,0,group_speed,false,true);

Func_UI_add_element(Constructor_UIP_element,manu_group_optGame,_x,_y,_x2,_y2,"Options: Gameplay",Func_button_create_func,-1,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
menu_element_optGame_swOpt = Func_UI_add_element(Constructor_UIP_element,manu_group_optGame,_x,_y,_x2,_y2,"Back",Func_button_create_func,func_button_int_switch_group,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optGame_timer = Func_UI_add_element(Constructor_UIP_element,manu_group_optGame,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optGame_timTime = Func_UI_add_element(Constructor_UIP_element,manu_group_optGame,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;

menu_element_optGame_Hand = Func_UI_add_element(Constructor_UIP_element,manu_group_optGame,_x,_y,_x2,_y2,"",Func_button_create_func,func_button_int_options,Func_button_draw_main);
_y	= _y2 + _element_sep;
_y2 = _y + _element_h;
//*/
#endregion


#endregion
#region other

manu_group_other = Func_UI_create_group(true,0,group_speed,false,true);
var _y = room_height - 20;
Func_UI_add_element(Constructor_UIP_element,manu_group_other,_element_x,_y,_element_x + _element_w,_y,"Feedback Would be appreciated.",Func_button_create_func,-1,Func_button_draw_main);

#endregion
#endregion
#endregion
