/// @desc My personal evolution of my ui system. CHanges are projekt specific and wont be applied to general system.


// Inherit the parent event
event_inherited();


#region variables


//general menu stuff
group_speed = global.Game_speed * 0.3;


//display variation
menu_vari_dist_min = 0.5;
menu_vari_dist_max = 3;
menu_vari_dist = 0;
menu_vari_precision_dist = 40;
menu_shudder_max = 0.7; //shudder displayed if mouse hovers over menu ellement


#endregion
#region customize UI contructor


function Constructor_UIP_element(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) : Constructor_UI_element(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) constructor
	{
	#region all vars
	
	draw_set_font(fn_menu);
	text_leng = string_width(text);
	static hand_w = sprite_get_width(spr_hand);
	static hand_h = sprite_get_width(spr_hand);
	
	#region position help
	#region info
	/*
	x1 = point_list[| 0];//left top
	y1 = point_list[| 1];
	x2 = point_list[| 2];//right top
	y2 = point_list[| 3];
	x3 = point_list[| 4];//right bottom
	y3 = point_list[| 5];
	x4 = point_list[| 6];//left bottom
	y4 = point_list[| 7];
	
	midbegin_x = 0;		//x position of the vertical middle of the begin side (w.o. rottation left side) of the menu element
	midbegin_y = 0;		//y position of the vertical middle of the begin side (w.o. rottation left side) of the menu element
	midend_x = 0;		//x position of the vertical middle of the end side (w.o. rottation right side) of the menu element
	midend_y = 0;		//y position of the vertical middle of the end side (w.o. rottation right side) of the menu element
	mid_x = 0;			//x position of the vertical and horizontal middle of the menu element
	mid_y = 0;			//y position of the vertical and horizontal middle of the menu element
	offscreen_x = 0;	//x position of the vertical and horizontal middle of the menu element
	offscreen_y = 0;	//y position of the vertical and horizontal middle of the menu element
	
	rot = 0;
	*/#endregion
	//setting them through functions
	//base
	static func_UIESP_pos_change_all = function(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4)//changes and updates all position and helper variables
		{
		//update all points
		func_UIESP_set_coorddata(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4);
		//updates all base coords and helpers
		func_UIESP_pos_update_all()
		}
	static func_UIESP_pos_update_all = function()
		{
		//update all
		func_UIESP_pos_varset_basecoords();
			
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
	
	
	//calculating helpers
	static func_UIESP_pos_varset_basecoords = function()
		{
		x1 = point_list[| 0];//left top
		y1 = point_list[| 1];
		x2 = point_list[| 2];//right top
		y2 = point_list[| 3];
		x3 = point_list[| 4];//right bottom
		y3 = point_list[| 5];
		x4 = point_list[| 6];//left bottom
		y4 = point_list[| 7];
		}
	static func_UIESP_pos_varset_midbegin = function()//calculates and sets the midbegin variable
		{
		midbegin_x = min(x4,x1) + abs(x4 - x1)/2;
		midbegin_y = min(y4,y1) + abs(y4 - y1)/2;
		}
	static func_UIESP_pos_varset_midend = function()//calculates and sets the midend variable
		{
		midend_x = min(x3,x2) + abs(x3 - x2)/2;
		midend_y = min(y3,y2) + abs(y3 - y2)/2;
		}
	static func_UIESP_pos_varset_mid = function()//calculates and sets the mid variable
		{
		mid_x = min(midbegin_x,midend_x) + abs(midbegin_x - midend_x)/2;
		mid_y = min(midbegin_y,midend_y) + abs(midbegin_y - midend_y)/2;
		}
	static func_UIESP_pos_varset_rot = function()//calculates and sets the rot variable
		{
		rot = point_direction(midbegin_x, midbegin_y, midend_x, midend_y);
		
		}
	static func_UIESP_pos_varset_off = function()//calculates and sets the offscreen_x/y variable
		{
		/*
		distance should be enought so that the hand draw doesnt mess up when going offscreen
		
		
		STATE:
		ATM this just uses an arbitrary distance assuming that the beginning of the menu element is at the edge of the screen
		
		FUTURE:
		it should detect the screen edge in the reverse direction its facing and from that point apply a safe distance
		*/
		static _dist = hand_h+5;
		
		offscreen_x = midbegin_x + lengthdir_x(_dist, rot+180);
		offscreen_y = midbegin_y + lengthdir_y(_dist, rot+180);
		
		}
	
	//manipulating
	static func_UIESP_set_coorddata = function(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4)//only sets the coords in the data list
		{
		point_list[| 0] = _x1;
		point_list[| 1] = _y1;
		point_list[| 2] = _x2;
		point_list[| 3] = _y2;
		point_list[| 4] = _x3;
		point_list[| 5] = _y3;
		point_list[| 6] = _x4;
		point_list[| 7] = _y4;
		}
	static func_UIESP_shift_coorddata = function(_shiftx,_shifty,_update)//shifts the coorddata
		{
		/*
		_update = if all helper vars should be updated
		
		/////
		
		*/
		func_UIESP_pos_set_coordinates(
		x1 + _shiftx,
		y1 + _shifty,
		x2 + _shiftx,
		y2 + _shifty,
		x3 + _shiftx,
		y3 + _shifty,
		x4 + _shiftx,
		y4 + _shifty
		)
		
		/*
		func_UIESP_pos_varset_basecoords();
		if _update
			{
			func_UIESP_pos_varset_midbegin();
			func_UIESP_pos_varset_midend();
			func_UIESP_pos_varset_mid();
			func_UIESP_pos_varset_off();
			}
		//*/
		}
	static func_UIESP_rotate_coorddata = function(_rot,_pivot_x,_pivot_y)//rotates the element around a pivot point, changes coorddata
		{
		/*
		_rad = rotation in degrees
		_pivot_x = the x coordinate the element will be rotated around
		_pivot_y = the y coordinate the element will be rotated around
		*/
		
		x1 = point_list[| 0];//left top
		y1 = point_list[| 1];
		x2 = point_list[| 2];//right top
		y2 = point_list[| 3];
		x3 = point_list[| 4];//right bottom
		y3 = point_list[| 5];
		x4 = point_list[| 6];//left bottom
		y4 = point_list[| 7];
		
		var _x,_y,_dist,_dir;
		var _size = ds_list_size(point_list);
		for(var i=0;i<_size;i+=2)
			{
			_x = point_list[| i];
			_y = point_list[| i+1];
			_dist = point_distance(_pivot_x,_pivot_y,_x,_y);
			_dir = point_direction(_pivot_x,_pivot_y,_x,_y) + _rot;
			
			point_list[| i]		= lengthdir_x(_dist,_dir);
			point_list[| i+1]	= lengthdir_y(_dist,_dir);
			}
		}
	
	//special
	static func_UIESP_pos_set_enddistance = function(_dist)//recalculates and sets the end points given _distance away from the begin points
		{
		func_UIESP_pos_varset_rot();
		//calc new end position
		x2 = x1 + lengthdir_x(_dist, rot);//top
		y2 = y1 + lengthdir_y(_dist, rot);
		x3 = x4 + lengthdir_x(_dist, rot);//bottom
		y3 = y4 + lengthdir_y(_dist, rot);
		
		func_UIESP_pos_change_all(x1,y1,x2,y2,x3,y3,x4,y4);
		}
	
	//using
	func_UIESP_pos_update_all();
	#endregion
	
	#endregion
	
	func_UIESP_pos_set_enddistance(text_leng);
	}



#endregion