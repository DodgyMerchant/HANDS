/// @desc 

event_inherited();

active = true;


#region UI system

//init
UI_system();


//set
var _disp_x = 20;
var _disp_y = 40;
var _disp_w = 80;
var _disp_h = sprite_get_height(spr_hand_stretch);
var _disp_y_sep = 15;

//pause menu group

pamen_group = Func_UI_create_group(true,0,group_speed,false,true);

/*
updated UI system!!

menu_selected == index of the hovered over menu element
menu_action == true if action taken ()atm only mb_left

if menu_action and menu_selected==_index

_x1,_y1,_x2,_y2,_index,_str,_g_enabled,_gt
*/

func_pausemenu_close = function()
	{
	alarm[0] = group_speed;
	Func_UI_group_enable(pamen_group,false);
	}
func_pausemenu_return = function()
	{
	with(obj_game)
		{
		if countdown_active
			{
			func_countdown_stop();
			alarm[0] = -1;//stop destroy alarm
			}
		else
			func_countdown_start();//activate countdown
		}
	}
func_pausemenu_int_return = function(_x1,_y1,_x2,_y2,_index)
	{
	if (menu_action and menu_selected==_index) or keyboard_check_pressed(vk_space)
		{
		func_pausemenu_return();
		func_pausemenu_close();
		}
	}
func_pausemenu_int_to_main = function(_x1,_y1,_x2,_y2,_index)
	{
	if (menu_action and menu_selected==_index) or keyboard_check_pressed(vk_escape)
		{
		with(obj_game)
			{
			func_game_end();
			}
		func_pausemenu_close();
		}
	}


var _x = _disp_x;
var _y = _disp_y;
Func_UI_add_element(pamen_group,_x,_y,_x+_disp_w,_y+_disp_h,"Game Paused",-1,Func_button_draw_main);
_y += _disp_h + _disp_y_sep;

Func_UI_add_element(pamen_group,_x,_y,_x+_disp_w,_y+_disp_h,"Return",func_pausemenu_int_return,Func_button_draw_main);
_y += _disp_h + _disp_y_sep;

Func_UI_add_element(pamen_group,_x,_y,_x+_disp_w,_y+_disp_h,"Exit to menu",func_pausemenu_int_to_main,Func_button_draw_main);
_y += _disp_h + _disp_y_sep;


#endregion
#region menu input


//input transition overflow prevention
//input_allow = false;



#endregion