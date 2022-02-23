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
#region customize UI contructors

function Constructor_UIP_element				(_menu,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list) : Constructor_UI_element	(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) constructor
	{
	#region all vars
	
	draw_set_font(fn_menu);
	text_leng = string_width(text);
	static hand_w = sprite_get_width(spr_hand);
	static hand_h = sprite_get_width(spr_hand);
	static hand_longest = point_distance(0,0,hand_w,hand_h);
	
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
		
		
		
		*/
		
		var _r = rot+180;
		
		#region //good idea dont know how to do it
		/* 
		var _rrad = degtorad(_r);
		
		if _r mod 90 == 0 //rad is either hor or vertical | only one side can be possible
			{
			offscreen_x = midbegin_x;
			offscreen_y = midbegin_y;
			
			switch(_r)
				{
				case 0:
					offscreen_x = global.Width;
				break;
				case 90:
					offscreen_y = 0;
				break;
				case 180:
					offscreen_x = 0;
				break;
				case 270:
					offscreen_y = global.Height;
				break;
				}
			}
		else
			{
			offscreen_x = midbegin_x;
			offscreen_y = midbegin_y;
			
			//get rotational non relative nearest corner
			var _rcorner_x = round(Func_t_reverse_span(cos(_rrad))) * global.Width;
			var _rcorner_y = round(Func_t_reverse_span(-sin(_rrad))) * global.Height;
			
			if point_direction(midbegin_x,midbegin_y,_rcorner_x,_rcorner_y) > _r //angle to corner is higher than _r | _r lower
				{
				
				}
			else
				{
				
				}
			
			
			switch(corner)
				{
				case 0:
					offscreen_x = global.Width;
					offscreen_y = 0;
				break;
				case 1:
					offscreen_x = 0;
					offscreen_y = 0;
				break;
				case 2:
					offscreen_x = 0;
					offscreen_y = global.Height;
				break;
				case 3:
					offscreen_x = global.Width;
					offscreen_y = global.Height;
				break;
				}
			}
		//*/
		#endregion
		
		#region placeholder omega bad shit
		
		var _step = 10;
		var _x = midend_x;
		var _y = midend_y;
		
		do{
			_x += lengthdir_x(_step,_r);
			_y += lengthdir_y(_step,_r);
			}
		until(!point_in_rectangle(_x,_y,0,0,global.Width,global.Height))
		
		//set and add distance
		offscreen_x = _x + lengthdir_x(hand_longest, _r);
		offscreen_y = _y + lengthdir_y(hand_longest, _r);
		
		#endregion
		
		/* //old stuff
		offscreen_x = midbegin_x + lengthdir_x(hand_longest, _r);
		offscreen_y = midbegin_y + lengthdir_y(hand_longest, _r);
		//*/
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
		
		var _x,_y,_dist,_dir;
		var _size = ds_list_size(point_list);
		for(var i=0;i<_size;i+=2)
			{
			_x = point_list[| i];
			_y = point_list[| i+1];
			_dist = point_distance(_pivot_x,_pivot_y,_x,_y);
			_dir = point_direction(_pivot_x,_pivot_y,_x,_y) + _rot;
			
			point_list[| i]		= _pivot_x + lengthdir_x(_dist,_dir);
			point_list[| i+1]	= _pivot_y + lengthdir_y(_dist,_dir);
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
	static func_UIESP_pos_set_begindistance = function(_dist)//recalculates and sets the begin points given _distance away from the end points
		{
		func_UIESP_pos_varset_rot();
		//calc new end position
		x1 = x2 - lengthdir_x(_dist, rot);//top
		y1 = y2 - lengthdir_y(_dist, rot);
		x4 = x3 - lengthdir_x(_dist, rot);//bottom
		y4 = y3 - lengthdir_y(_dist, rot);
		
		func_UIESP_pos_change_all(x1,y1,x2,y2,x3,y3,x4,y4);
		}
	static func_UIESP_set_text = function(_str, calc_dist)//recalculates and sets the begin points given _distance away from the end points
		{
		/*
		calc_dist = 0,1,2 | 0=false no calc | 1 = set end points | 2 = set begin points
		
		*/
		text = _str;
		text_leng = string_width(text);
		
		//sets no, end or begin points
		switch(calc_dist)
			{
			case 1: func_UIESP_pos_set_enddistance(text_leng); break;
			case 2:func_UIESP_pos_set_begindistance(text_leng); break;
			}
		}
	
	
	//using
	func_UIESP_pos_update_all();
	
	
	#endregion
	#endregion
	}
function Constructor_UIP_element_orient_end	(_menu,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list) : Constructor_UIP_element	(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) constructor
	{
	func_UIESP_pos_set_begindistance(max(text_leng,3));//if text is "" setting the width to 0 effectivly deletes the rotation of the element as the begin, end and mid will be ontop of each other.
	//func_UIESP_pos_set_begindistance(text_leng);
	}
function Constructor_UIP_element_orient_begin	(_menu,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list) : Constructor_UIP_element	(_menu,_group,_text,_create_func,_step_func,_draw_func,_point_list) constructor
	{
	func_UIESP_pos_set_enddistance(max(text_leng,3));//if text is "" setting the width to 0 effectivly deletes the rotation of the element as the begin, end and mid will be ontop of each other.
	//func_UIESP_pos_set_enddistance(text_leng);
	}

#endregion