

function Func_draw_hand(_type,_x,_y,_rot,_tcol,_turn)
	{
	_rot = _rot mod 360;
	var _yscale = 1;
	if _turn
		_yscale = ((_rot < 90 or _rot > 270) ? 1 : -1 );
	
	//col
	var _col;
	switch(_tcol)
		{
		case 1: _col = -1; break;
		case 0: _col = 0; break;
		default: _col = make_colour_hsv(0,0,255*_tcol);
		}
	
	//draw
	draw_sprite_ext(spr_hand,_type,_x,_y,1,_yscale,_rot,_col,1);
	}

function Func_draw_hand_stretch(_type,_x1,_y1,_x2,_y2,_tcol,_turn)
	{
	var _rot = point_direction(_x1,_y1,_x2,_y2);
	var _dis = point_distance(_x1,_y1,_x2,_y2);
	
	//stretch
	var _yscale = 1;
	if _turn
		_yscale = ((_rot < 90 or _rot > 270) ? 1 : -1 );
	
	//col
	var _col;
	switch(_tcol)
		{
		case 1: _col = -1; break;
		case 0: _col = 0; break;
		default: _col = make_colour_hsv(0,0,255*_tcol);
		}
	
	//draw
	draw_sprite_ext(spr_hand_stretch,0,_x1,_y1,_dis,_yscale,_rot,_col,1);
	
	//hand
	Func_draw_hand(_type,_x2,_y2,_rot,_tcol,_turn);
	}