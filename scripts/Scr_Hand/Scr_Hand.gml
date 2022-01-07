
function Func_draw_hand_calcturn(_turn,_rot)
	{
	if _turn
		return ((_rot < 90 or _rot > 270) ? 1 : -1 );
	else
		return 1;
	}

function Func_draw_hand_calctcol(_tcol)
	{
	//col
	switch(_tcol)
		{
		case 1:		return -1;		break;
		case 0:		return 0;		break;
		default:	return make_colour_hsv(0,0,255*_tcol);
		}
	}

//basics
function Func_draw_hand(_type,_x,_y,_rot,_tcol=-1,_turn=-1,_col=-1,_yscale=1)
	{
	/*
	_tcol can be set to -1 to forgo the calculation and use the optional argument _col directly
	_turn can be set to -1 to forgo the calculation and use the optional argument _yscale directly
	*/
	
	_rot = _rot mod 360;
	
	//turn
	if _turn != -1
		_yscale = Func_draw_hand_calcturn(_turn,_rot);
	//col
	if _tcol != -1
		_col = Func_draw_hand_calctcol(_tcol);
	
	//draw
	draw_sprite_ext(spr_hand,_type,_x,_y,1,_yscale,_rot,_col,1);
	}
function Func_draw_arm(_arm_x,_arm_y,_hand_x,_hand_y,_armrot,_handrot)
	{
	//var _rot = point_direction(_arm_x,_arm_y,_hand_x,_hand_y);
	
	//draw hand
	//static drhnd_Hspryoff = sprite_get_yoffset(spr_hand);			//HAND sprite offset
	//static drhnd_Hdiff = sprite_get_height(spr_hand)-drhnd_Hspryoff;//HAND sprite difference
	static drhnd_HSspryoff = sprite_get_yoffset(spr_hand_stretch);	//HAND STREATCH sprite offset
	static drhnd_HSdiff = sprite_get_height(spr_hand_stretch)-drhnd_HSspryoff;//HAND STREATCH sprite difference
	
	//arm end
	var _x1 = _arm_x + lengthdir_x(drhnd_HSspryoff,	_armrot + 90);
	var _y1 = _arm_y + lengthdir_y(drhnd_HSspryoff,	_armrot + 90);
	var _x4 = _arm_x + lengthdir_x(drhnd_HSdiff,	_armrot - 90);
	var _y4 = _arm_y + lengthdir_y(drhnd_HSdiff,	_armrot - 90);
	//hand end
	var _x2 = _hand_x + lengthdir_x(drhnd_HSspryoff,_handrot + 90);
	var _y2 = _hand_y + lengthdir_y(drhnd_HSspryoff,_handrot + 90);
	var _x3 = _hand_x + lengthdir_x(drhnd_HSdiff,	_handrot - 90);
	var _y3 = _hand_y + lengthdir_y(drhnd_HSdiff,	_handrot - 90);
	
	if (_handrot<=_armrot-90) or (_handrot>=_armrot+90)//if lines will cross
		draw_sprite_pos(spr_hand_stretch,0,_x1,_y1, _x3,_y3, _x2,_y2, _x4,_y4,1);//switch hand points
	else
		draw_sprite_pos(spr_hand_stretch,0,_x1,_y1, _x2,_y2, _x3,_y3, _x4,_y4,1);
	}

//combinations
function Func_draw_hand_stretch(_type,_x1,_y1,_x2,_y2,_tcol,_turn)
	{
	var _rot = point_direction(_x1,_y1,_x2,_y2);
	var _dis = point_distance(_x1,_y1,_x2,_y2);
	
	//turn
	var _yscale = Func_draw_hand_calcturn(_turn,_rot);
	//col
	var _col = Func_draw_hand_calctcol(_tcol);
	
	//draw
	draw_sprite_ext(spr_hand_stretch,0,_x1,_y1,_dis,_yscale,_rot,_col,1);
	
	//hand
	Func_draw_hand(_type,_x2,_y2,_rot,,,_col,_yscale);
	}
function Func_draw_hand_arm(_type,_arm_x,_arm_y,_hand_x,_hand_y,_handrot,_tcol,_turn)
	{
	
	//col
	var _col = Func_draw_hand_calctcol(_tcol);
	
	Func_draw_arm(_arm_x,_arm_y,_hand_x,_hand_y,point_direction(_arm_x,_arm_y,_hand_x,_hand_y),_handrot);
	
	//hand
	Func_draw_hand(_type,_hand_x,_hand_y,_handrot,,_turn,_col);
	}

