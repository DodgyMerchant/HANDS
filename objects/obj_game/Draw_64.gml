/// @desc 



#region debug
if global.Debug 
{
draw_set_font(fn_debug);
draw_set_color(c_red);

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
"RULES",
"Wins against?: "+string(global.Game_Wins_against),
"Score type: "+(global.Rule_Score_type == SCORE_TYPE.st_points ? "Points" : "Health"),
"Timer enabled: "+string(global.Rule_Timer),
"Hand self type: "+_hsstr,
"global.Rule_Hand_self: "+string(global.Rule_Hand_self),
"Timer T",
"T: "+string(global.Timer_t),
"index +t:"+string(global.Timer_index)+"/"+string(global.Timer_index_t),
"last_t: "+string(global.Timer_last_t),
"return_t: "+string(global.Timer_return_t),
"timer_disp_player: "+string(timer_disp_player),
"test: "+string(-13 div 4),




);








}
#endregion