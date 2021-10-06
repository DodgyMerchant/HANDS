

function Func_draw_hand(_type,_x,_y,_rot,_a,_turn)
	{
	_rot = _rot mod 360;
	var _yscale = 1;
	if _turn
	_yscale = ((_rot < 90 or _rot > 270) ? 1 : -1 );
	draw_sprite_ext(spr_hand,_type,_x,_y,1,_yscale,_rot,-1,_a);
	
	}

function Func_draw_hand_stretch(_type,_x1,_y1,_x2,_y2,_a,_turn)
	{
	var _rot = point_direction(_x1,_y1,_x2,_y2);
	var _dis = point_distance(_x1,_y1,_x2,_y2);
	
	//stretch
	var _yscale = 1;
	if _turn
	_yscale = ((_rot < 90 or _rot > 270) ? 1 : -1 );
	draw_sprite_ext(spr_hand_stretch,0,_x1,_y1,_dis,_yscale,_rot,-1,_a);
	
	//hand
	Func_draw_hand(_type,_x2,_y2,_rot,_a,_turn);
	}