/// @desc 

#region Background


if backgound_update
	{
	var _move_distance = 0;
	var _move_speed = 500;
	var _hand_rot_speed = 500;
	
	var _target_surf,_source_surf;
	#region choose surface
	switch(background_swing)
		{
		case true:
			_target_surf = background_surface1;
			_source_surf = background_surface2;
		break;
		case false:
			_target_surf = background_surface2;
			_source_surf = background_surface1;
		break;
		default: show_debug_message("WTF?");
		}
	background_swing = !background_swing;
	#endregion
	//begin
	surface_set_target(_target_surf);
	//clear
	draw_clear(c_black);
	
	//draw old
	var _radians = current_time/_move_speed mod 100;
	var _x = (background_surf_w - background_surf_w * background_scale) / 2 + (_move_distance * sin(_radians));
	var _y = (background_surf_h - background_surf_h * background_scale) / 2 + (_move_distance * cos(_radians));
	//draw_surface_stretched(_source_surf,_x,_y,background_surf_w * background_scale,background_surf_h * background_scale);
	draw_surface_ext(_source_surf,_x,_y,background_scale,background_scale,0,-1,background_alpha);
	
	//draw detail
	
	var _rot_add = current_time/_hand_rot_speed mod 360;
	var _times = 85;
	var _raad_part = 360 / _times;
	var _x,_y,_rot;
	for (var i=0;i<_times;i++)
		{
		_rot = i * _raad_part + _rot_add;
		_x = background_surf_w*.5 + lengthdir_x(background_circle_dist,_rot);
		_y = background_surf_h*.5 + lengthdir_y(background_circle_dist,_rot);
		draw_sprite_ext(spr_hand,0,_x,_y,1,1,_rot + 180,-1,1);
		}
	
	surface_reset_target();
	background_surface_display = _target_surf;
	backgound_update = false;
	}

var _zoom	= 1 - (1 - background_scale) * backgound_time_t;
var _a		= 1 - (1 - background_alpha) * backgound_time_t;
var _x = global.Game_point_x - (background_surf_w/2 * _zoom);
var _y = global.Game_point_y - (background_surf_h/2 * _zoom);
draw_surface_ext(background_surface_display, _x, _y,_zoom,_zoom,0,-1,_a);





#endregion
#region timer
if global.Rule_Timer
	{
	var _ang = 90 + timer_ang_disp;
	var _x = global.Game_point_x + lengthdir_x(timer_disp_length,_ang);
	var _y = global.Game_point_y + lengthdir_y(timer_disp_length,_ang);
	
	//non moving
	Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,global.Game_point_x,global.Game_point_y - timer_disp_length,0.5,false);
	
	//moving
	Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,_x,_y,1,false);
	
	
	
	
	
	}
#endregion
#region draw hand cascade
/*
hand_casc_count1
hand_casc_count2
hand_casc_channel1
hand_casc_channel2
*/

if action_type != -1
	{
	var _strenght = abs(global.Game_Score) +1;
	var _ang = 360/ 10;
	var _x,_y,_dist,_ang_move;
	for (var i=0;i<360;i+=_ang)
		{
		_dist = hand_casc_dist_min + hand_casc_dist * _strenght *
		((animcurve_channel_evaluate(hand_casc_channel1,(hand_casc_count1/global.Game_speed + i/360) mod 1) +
		animcurve_channel_evaluate(hand_casc_channel2,hand_casc_count2/global.Game_speed)) / 2);
		
		//_dist = hand_casc_dist_min + hand_casc_dist * animcurve_channel_evaluate(hand_casc_channel1,hand_casc_count1/global.Game_speed);
		
		_ang_move = (i + hand_casc_count3/global.Game_speed * 360) mod 360;
		_x = global.Game_point_x + lengthdir_x(_dist,_ang_move);
		_y = global.Game_point_y + lengthdir_y(_dist,_ang_move);
		//Func_draw_hand(action_type,_x,_y,_ang_move,1,true);
		Func_draw_hand_stretch(action_type,global.Game_point_x,global.Game_point_y,_x,_y,1,false);
		}
	}

#endregion

//base circle
var _r = 20 + 2 * cos(current_time/200);
draw_set_color(c_black);
draw_circle(global.Game_point_x,global.Game_point_y, _r + 1,false);
draw_set_color(c_white);
draw_circle(global.Game_point_x,global.Game_point_y, _r,false);

//draw dim surface
func_handsurf_draw();


