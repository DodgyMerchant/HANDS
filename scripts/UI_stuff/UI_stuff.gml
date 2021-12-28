

//ONLY USED WITH UI SYSTEM
function Func_button_draw_main(_x1,_y1,_x2,_y2,i,_str,_g_enabled,_gt)
	{
	
	var _hand_w = sprite_get_width(spr_hand);
	_x2 = max(_x1 + string_width(_str),_x2 - _hand_w); //end position = self or fit to string length
	
	#region display vari
	
	var _yt = y/global.Height;
	var _vari_dist = menu_vari_dist *
	//animcurve_channel_evaluate(global.gendisp_vari_channel1, (global.gendisp_vari_t1 + _yt) mod 1) *
	animcurve_channel_evaluate(global.gendisp_vari_channel2, global.gendisp_vari_t2);
	var _vari_ang = ((global.gendisp_vari_ang_t + _yt) * 360) mod 360;
	var _vari_x = lengthdir_x(_vari_dist,_vari_ang);
	var _vari_y = lengthdir_y(_vari_dist,_vari_ang);
	_x1+=_vari_x;
	_y1+=_vari_y;
	_x2+=_vari_x;
	_y2+=_vari_y;
	
	#endregion
	
	UI_element_grid[# UI_ELEMENT_INDEX.x2, i] = _x2;//update for better click
	
	var _text_x = _x2 - _x1;//update text position
	
	var _ymid = _y1 + (_y2 - _y1) *.5;//calc h mid
	
	var moving_x2 = lerp(-_hand_w,_x2,_gt);//scale end position wht active
	
	Func_draw_hand_stretch(HAND_TYPE.open,-_hand_w-1,_ymid,moving_x2,_ymid,1,false);
	
	draw_set_color(c_black);
	draw_text(moving_x2 - _text_x, _ymid,_str);
	}

function Func_menu_group_switch(_g1,_g2)
	{
	Func_UI_group_enable(_g1, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g1]);
	Func_UI_group_enable(_g2, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g2]);
	}