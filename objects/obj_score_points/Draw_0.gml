/// @desc 

var _spr,_a;
if active
	{
	_spr = HAND_TYPE.open;
	_a = 1;
	}
else
	{
	_spr = HAND_TYPE.fist;
	_a = 0.5;
	}

var _x = x + random(disp_tremble * global.Game_Score_t * global.Game_Score_t_sign);
var _y = y;
Func_draw_hand_stretch(_spr,x,y_origin,_x,_y,_a,false);