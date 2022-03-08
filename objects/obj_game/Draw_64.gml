/// @desc 



#region debug
if global.Debug 
{
draw_set_font(fn_debug);
draw_set_color(c_red);
draw_set_alpha(1);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

var _y = 20;

var _hsstr;
switch(global.Rule_Hand_self)
	{
	case RULE_HAND_SELF.anarchy:	_hsstr = "Anarchy";	break;
	case RULE_HAND_SELF.soft:		_hsstr = "Soft";		break;
	case RULE_HAND_SELF.spikey:	_hsstr = "Spikey";	break;
	default : _hsstr = "??????";
	}

_y = func_debug_txt(0,_y,
"DEBUG:",
/*
"RULES",
"Wins against?: "+string(global.Game_Wins_against),
"Score type: "+(global.Rule_Score_type == SCORE_TYPE.st_points ? "Points" : "Health"),
"Timer enabled: "+string(global.Rule_Timer),
"Hand self type: "+_hsstr,
"global.Rule_Hand_self: "+string(global.Rule_Hand_self),
//*/
/*
"TIMER",
"Timer T",
"T: "+string(global.Timer_t),
"index +t:"+string(global.Timer_index)+"/"+string(global.Timer_index_t),
"last_t: "+string(global.Timer_last_t),
"return_t: "+string(global.Timer_return_t),
"timer_disp_player: "+string(timer_disp_player),
//*/
/*
"Display t",
"Game_Score_t/sign:"+string(global.Game_Score_t)+"/"+string(global.Game_Score_t_sign),
"Game_Wins_t/sign:"+string(global.Game_Wins_t)+"/"+string(global.Game_Wins_t_sign),
"Vari",
"vari t1|2: "+string(global.gendisp_vari_t1)+"|"+string(global.gendisp_vari_t2),
"vari ang t|ts: "+string(global.gendisp_vari_ang_t)+"|"+string(global.gendisp_vari_ang_ts),
"Frame Hands",
"spaz chance : "+string(frame_hand_spazchance),
"spaz time : "+string(frame_hand_spaztime),
"spaz range : "+string(frame_hand_spazrange),


//*/
);
#region InfiniUI_parent
if instance_exists(InfiniUI_parent){
_y = func_debug_txt(0,_y,
"///////MENU///////",
"menu_selected: "+string(InfiniUI_parent.menu_selected),
"global.Menu_control_type: "+string(global.Menu_control_type),


);


//go through all UI parents and display all their group data

var _str;
var _inst_num = instance_number(InfiniUI_parent);
for(var _in=0; _in<_inst_num; _in++)
	{
	with( instance_find(InfiniUI_parent,_in) )
		{
		var _size = ds_list_size(UI_group_list);
		for(var _g=0; _g<_size; _g++)
			{
			with(UI_group_list[| _g])
				{
				_str = "Enab.: " + string(enabled) + " |t: " + string(trans) + " |dis/s: " + string(dis_step) + " |d: " + string(dis_draw);
				draw_text(0,_y,_str);
				_y += string_height(_str);
				}
			}
		}
	}
}
#endregion
}
#endregion




