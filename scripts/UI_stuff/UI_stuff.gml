

//ONLY USED WITH UI SYSTEM

function Func_button_create_func()
	{
	
	}

function Func_button_draw_main()
	{
	//set
	var _selected = func_UIES_check_selected();
	var _tension = 1+global.Game_Score_t;
	var _trans = func_UIES_get_group_t();
	
	#region hand type
	var _type;
	if !func_UIES_get_selectable()
		_type = HAND_TYPE.point;
	else
		_type = (_selected ? HAND_TYPE.open : HAND_TYPE.fist);
	#endregion
	
	#region variation
	//*/
	
	//variation = wiggle/sway
	var _vari_mult; //from 1==full variation to 0==no variation
	if _selected//if im selected
		_vari_mult = 0;//no wiggle
	else if global.Menu_control_type == MENU_CONTROL_TYPE.mouse //if mouse used -> calc wiggle on distance
		_vari_mult = clamp(point_distance(mid_x, mid_y, mouse_x,mouse_y) / menu.menu_vari_precision_dist, 0, 1);
	else//keyboard used -> full wiggle
		_vari_mult = 1;//full wiggle
	
	//individual variation offset
	var _ind_x = midend_x/global.Height;
	var _ind_y = midend_y/global.Height;
	
	//wiggle
	var _vari_x = menu.menu_vari_dist * Func_t_span(animcurve_channel_evaluate(global.gendisp_vari_channel1, (global.gendisp_vari_t1 * _tension + _ind_x) mod 1)) * _vari_mult;
	var _vari_y = menu.menu_vari_dist * Func_t_span(animcurve_channel_evaluate(global.gendisp_vari_channel2, (global.gendisp_vari_t2 * _tension + _ind_y) mod 1)) * _vari_mult;
	
	#region //shudder | element shivers when mouse near or selected
	var _shudder_x,_shudder_y;
	if func_UIES_get_selectable()//if element is selectable
		{
		var _shudder = menu.menu_shudder_max * Func_t_invert(_vari_mult);
		_shudder_x = random_range(-_shudder,_shudder);
		_shudder_y = random_range(-_shudder,_shudder);
		}
	else
		{
		_shudder_x = 0;
		_shudder_y = 0;
		}
	#endregion
	//*/
	#endregion
	
	//xy
	var _x = lerp(offscreen_x,	midend_x, _trans) + _vari_x;
	var _y = lerp(offscreen_y,	midend_y, _trans) + _vari_y;
	
	//draw
	Func_draw_hand_stretch(_type, offscreen_x, offscreen_y, _x + _shudder_x, _y + _shudder_y, 1, true);
	#region text
	//!!!!!!!!!!YES the text is off 1 pixel if rotated !!!!!!!!!!!!!!  I hope they fix it
	//rotates and formats text
	var _r = (rot + 90) mod 360;
	if _r div 180 == 0 //not flipped
		draw_set_halign(fa_right);
	else
		draw_set_halign(fa_left);
	
	draw_text_transformed(_x, _y, text, 1, 1, _r mod 180 - 90);
	#endregion
	}

function Func_menu_group_switch(_g1,_g2)
	{
	Func_UI_group_switch(_g1);
	Func_UI_group_switch(_g2);
	}

function Func_menu_create_button_halo(_constructor,_group,_r,_w,_h,_distance,_text,_create_func=-1,_step_func=-1,_draw_func=-1)//cerates button in a halo manner
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