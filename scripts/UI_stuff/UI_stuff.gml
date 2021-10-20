

//ONLY USED WITH UI SYSTEM
function Func_button_draw_main(_x1,_y1,_x2,_y2,i,_str,_g_enabled,_gt)
	{
	var _w = sprite_get_width(HAND_TYPE.open);
	_x2 = max(_x1 + string_width(_str),_x2 - _w); //end position = self or fit to string length
	
	UI_element_grid[# UI_ELEMENT_INDEX.x2, i] = _x2;//update for better click
	
	var _text_x = _x2 - _x1;//update text position
	
	_x2 = lerp(0 - _w,_x2,_gt);//scale end position wht active
	
	var _ymid = _y1 + (_y2 - _y1) *.5;
	Func_draw_hand_stretch(HAND_TYPE.open,min(0, _x2 - 1),_ymid,_x2,_ymid,1,false);
	
	draw_set_color(c_black);
	draw_text(_x2 - _text_x, _ymid,_str);
	}

function Func_menu_group_switch(_g1,_g2)
	{
	Func_UI_group_enable(_g1, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g1]);
	Func_UI_group_enable(_g2, !UI_group_grid[# UI_GROUP_INDEX.enabled, _g2]);
	}