/// @desc 

// Inherit the parent event
event_inherited();

#region customize UI contructor


function Constructor_UIP_element(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) : Constructor_UI_element(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) constructor
	{
	
	text_leng = string_width(text);
	
	#region position help
	
	static hand_w = sprite_get_width(spr_hand);
	static hand_h = sprite_get_width(spr_hand);
	
	//base
	static func_UIESP_pos_change_all = function(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4)
		{
		//update all
		point_list[| 0] = _x1;
		point_list[| 1] = _y1;
		point_list[| 2] = _x2;
		point_list[| 3] = _y2;
		point_list[| 4] = _x3;
		point_list[| 5] = _y3;
		point_list[| 6] = _x4;
		point_list[| 7] = _y4;
		x1 = _x1;//left top
		y1 = _y1;
		x2 = _x2;//right top
		y2 = _y2;
		x3 = _x3;//right bottom
		y3 = _y3;
		x4 = _x4;//left bottom
		y4 = _y4;
			
		func_UIESP_pos_update_all_helpers();
		}
	static func_UIESP_pos_update_all = function()
		{
		//update all
		x1 = point_list[| 0];//left top
		y1 = point_list[| 1];
		x2 = point_list[| 2];//right top
		y2 = point_list[| 3];
		x3 = point_list[| 4];//right bottom
		y3 = point_list[| 5];
		x4 = point_list[| 6];//left bottom
		y4 = point_list[| 7];
			
		func_UIESP_pos_update_all_helpers();
		}
	static func_UIESP_pos_update_all_helpers = function()
		{
			
		func_UIESP_pos_varset_midbegin();
		func_UIESP_pos_varset_midend();
		func_UIESP_pos_varset_mid();
		func_UIESP_pos_varset_rot();
		func_UIESP_pos_varset_off();
		}
		
	//helpers
	static func_UIESP_pos_varset_midbegin = function()
		{
		midbegin_x = min(x4,x1) + abs(x4 - x1)/2;
		midbegin_y = min(y4,y1) + abs(y4 - y1)/2;
		}
	static func_UIESP_pos_varset_midend = function()
		{
		midend_x = min(x3,x2) + abs(x3 - x2)/2;
		midend_y = min(y3,y2) + abs(y3 - y2)/2;
		}
	static func_UIESP_pos_varset_mid = function()
		{
		mid_x = min(midbegin_x,midend_x) + abs(midbegin_x - midend_x)/2;
		mid_y = min(midbegin_y,midend_y) + abs(midbegin_y - midend_y)/2;
		}
	static func_UIESP_pos_varset_rot = function()
		{
		rot = point_direction(midbegin_x, midbegin_y, midend_x, midend_y);
		}
	static func_UIESP_pos_varset_off = function()
		{
		static _dist = 20;
		offscreen_x = midbegin_x + lengthdir_x(_dist, rot+180);
		offscreen_y = midbegin_y + lengthdir_y(_dist, rot+180);
		}
		
	//special
	
	
	
	//useing
	func_UIESP_pos_update_all();
	#endregion
	
	
	}



#endregion
