

//ONLY USED WITH UI SYSTEM

function Func_button_create_func()
	{
	//create points
	
	
	
	
	
	}

function Func_button_draw_main()
	{
	//set
	var _selected = func_UIES_check_selected();
	var _tension = 1+global.Game_Score_t;
	var _trans = func_UIES_get_group_t();
	
	#region hand type
	var _type;
	if step_func == -1
		_type = HAND_TYPE.point;
	else
		_type = (_selected ? HAND_TYPE.open : HAND_TYPE.fist);
	#endregion
	
	//xy
	var _x = lerp(offscreen_x,	midend_x, _trans);
	var _y = lerp(offscreen_y,	midend_y, _trans);
	
	//draw
	Func_draw_hand_stretch(_type, offscreen_x, offscreen_y, _x, _y, 1, true);
	draw_text_transformed(midbegin_x, midbegin_y , text, 1, 1, rot);
	}
function Func_button_draw_mainOLD()
	{
	
	x2 = max(x1 + string_width(_str),x2 - hand_w); //end position = self or fit to string length
	
	var _selected = func_UIES_check_selected();
	
	#region type
	var _type;
	if step_func == -1
		_type = HAND_TYPE.point;
	else
		_type = (_selected ? HAND_TYPE.open : HAND_TYPE.fist);
	#endregion
	#region display vari
	
	//*
	//precision anti wiggle
	//base calc on menu control type
	var _precision; //from 1==no precision to 0==full precision
	if _selected//if im selected
		_precision = 0;//no wiggle
	else if global.Menu_control_type == MENU_CONTROL_TYPE.mouse //if mouse used -> calc wiggle on distance
		_precision = clamp(point_distance(_x1+(_x2-_x1)/2,_y1+(_y2-_y1)/2,mouse_x,mouse_y) / menu_vari_precision_dist, 0, 1);
	else//keyboard used -> full wiggle
		_precision = 1;//full wiggle
	
	//own y position _t
	var _yt = _y1/global.Height;
	//score multiplier
	var _tension = 1+global.Game_Score_t;
	
	//wiggle
	var _vari_x = menu_vari_dist * Func_t_span(animcurve_channel_evaluate(global.gendisp_vari_channel1, (global.gendisp_vari_t1 * _tension + _yt) mod 1)) * _precision;
	var _vari_y = menu_vari_dist * Func_t_span(animcurve_channel_evaluate(global.gendisp_vari_channel2, (global.gendisp_vari_t2 * _tension + _yt) mod 1)) * _precision;
	
	_x1+=_vari_x;
	_y1+=_vari_y;
	_x2+=_vari_x;
	_y2+=_vari_y;
	//*/
	#endregion
	
	UI_element_grid[# UI_ELEMENT_INDEX.x2, i] = _x2;//update for better click
	
	var _text_x = _x2 - _x1;//update text position
	var _ymid = _y1 + (_y2 - _y1) *.5;//calc h mid
	var moving_x2 = lerp(-hand_w,_x2,_gt);//scale end position wht active
	
	#region display hand
	/*
	if _precision == 1
		Func_draw_hand_stretch(_type,-hand_w-10,_ymid,moving_x2,_ymid,1,false);
	else
		{//same display only shudder is calced and applied
		var _shudder = menu_shudder_max * Func_t_invert(_precision);
		var _shdrx = random_range(-_shudder,_shudder);
		var _shdry = random_range(-_shudder,_shudder);
		Func_draw_hand_stretch(_type,
		-hand_w-10	+ _shdrx,
		_ymid		+ _shdry,
		moving_x2	+ _shdrx,
		_ymid		+ _shdry,
		1,false);
		}
	//*/
	#endregion
	
	//display text
	//draw_set_color(c_black);
	//draw_text(moving_x2 - _text_x, _ymid,_str);
	
	draw_set_color(c_white);
	draw_text_transformed(mid_x, mid_y ,text, 1, 1, rot);
	
	draw_line(x1,y1,x2,y2);
	draw_line(x2,y2,x3,y3);
	draw_line(x3,y3,x4,y4);
	draw_line(x4,y4,x1,y1);
	draw_circle(x1, y1, 5,true);
	draw_circle(x2, y2, 5,true);
	draw_circle(x3, y3, 5,true);
	draw_circle(x4, y4, 5,true);
	draw_line(mid_x, mid_y, offscreen_x, offscreen_y);
	}

function Func_menu_group_switch(_g1,_g2)
	{
	Func_UI_group_enable(_g1, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g1]);
	Func_UI_group_enable(_g2, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g2]);
	}

function Func_menu_create_button_halo(_constructor,_group,_r,_w,_h,_distance,_text,_create_func,_step_func,_draw_func)//cerates button in a halo manner
	{
	/*
	_r = degree relative zur mitte. 0=rechts.
	
	*/
	
	var _r2 = _r;
	_r = _r + 180;//reverse | 0
	
	var _x = lengthdir_x((_w*.5) + _distance,_r2) + global.Game_point_x;
	var _y = lengthdir_y((_w*.5) + _distance,_r2) + global.Game_point_y;
	
	return Func_UI_add_element_ext(_constructor,_group,_x,_y,_w,_h,_r,_text,_create_func,_step_func,_draw_func)
	}