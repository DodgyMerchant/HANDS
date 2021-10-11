/// @desc 

if global.Debug 
{
draw_set_font(fn_debug);
draw_set_color(c_orange);

var _y = 20;

var _hsstr;
switch(global.Rule_Hand_self)
	{
	case RULE_HAND_SELF.anarchy:	_hsstr = "Anarchy";	break;
	case RULE_HAND_SELF.soft:		_hsstr = "Soft";		break;
	case RULE_HAND_SELF.spikey:	_hsstr = "Spikey";	break;
	}

_y = func_debug_txt(0,_y,
"RULES",
"Wins against?: "+string(global.Game_Wins_against),
"Score type: "+(global.Rule_Score_type == SCORE_TYPE.st_points ? "Points" : "Health"),
"Timer enabled: "+string(global.Rule_Timer),
"Hand self type: "+_hsstr,
"T",
"score t/s: "+string(global.Game_Score_t)+"/"+string(global.Game_Score_t_sign),
"win t/s: "+string(global.Game_Wins_t)+"/"+string(global.Game_Wins_t_sign),
"other",
"Time t: "+string(global.Timer_t),


);









}