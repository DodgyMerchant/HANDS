/// @desc 


draw_set_alpha(1);

#region Background








#endregion

if game_on_t > 0
{
#region dim surface

//draw dim surface
func_handsurf_draw();

#endregion
#region timer back hand

if global.Rule_Timer
	{
	//non moving
	Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,global.Game_point_x,global.Game_point_y - timer_disp_length * game_on_t,0.5,false);
	
	
	
	//action_player
	var _return = global.Timer_return_t<1;
	
	var _x,_y,_ang,_leng;
	var ;
	for (var i = 1;i<timer_tick_num;i++)
		{
		/*
		//var _t = (i == global.Timer_index) * Func_t_invert(global.Timer_index_t);	//pure 1-0 with val progress over my index position
		//var _t = clamp((timer_count - (i * timer_tick_val)) / timer_tick_val,0,1);//constantly 0 transitions to 1 with progress in val over my index position
		
		var _count = (_return ? timer_hand_return_hold : timer_count);
		
		var _t_inactive = Func_t_invert(Func_t_get_span_clamp((_count - (i * timer_tick_val)) / timer_tick_val,0,.5));
		var _t_last = Func_t_get_span_clamp(global.Timer_last_t,0.5,1);
		
		var _t = max(_t_inactive + _t_last, _return * global.Timer_return_t);
		//*/
		
		var _t = max(Func_t_invert(Func_t_get_span_clamp(((_return ? timer_hand_return_hold : timer_count) - (i * timer_tick_val)) / timer_tick_val,0,.5)) + Func_t_get_span_clamp(global.Timer_last_t,0.5,1), _return * global.Timer_return_t);
		
		_ang = (timer_tick_ang * timer_disp_player) * i + 90 + (timer_hand_sway * func_timer_arm_close_precision(i));
		//_ang = timer_tick_ang * i + 90; // no flavour
		
		
		_leng = (lerp(timer_disp_length_inactive,timer_disp_length,_t) + timer_hand_tide) * game_on_t;
		//_leng = lerp(timer_disp_length_inactive,timer_disp_length,_t); // no flavour
		
		
		_x = global.Game_point_x + lengthdir_x(_leng,_ang);
		_y = global.Game_point_y + lengthdir_y(_leng,_ang);
		
		Func_draw_hand_stretch((global.Timer_index >= i ? HAND_TYPE.fist : HAND_TYPE.point),global.Game_point_x,global.Game_point_y,_x,_y,0.2,false);
		}
	
	
	}

#endregion
#region draw hand cascade
/*
hand_casc_count1
hand_casc_count2
hand_casc_channel1
hand_casc_channel2
*/

//if action_type != -1
	{
	//var _strenght = abs(global.Game_Score) +1;	old
	var _strenght = lerp(1,3,global.Game_Score_t);
	var _ang = 360/ 10;
	var _tcol = hand_casc_tcol * game_on_t;
	var _type = (action_type==-1 ? HAND_TYPE.open : action_type);
	var _x,_y,_dist,_ang_move;
	
	for (var i=0;i<360;i+=_ang)
		{
		_dist = (hand_casc_dist_min + hand_casc_dist * _strenght *													//
		((animcurve_channel_evaluate(hand_casc_channel1,(hand_casc_count1/global.Game_speed + i/360) mod 1) +		//some of this can be calced outside the loop
		animcurve_channel_evaluate(hand_casc_channel2,hand_casc_count2/global.Game_speed)) / 2)) + game_on_t;		//
		
		
		_ang_move = (i + hand_casc_count3 / global.Game_speed * 360) mod 360;
		_x = global.Game_point_x + lengthdir_x(_dist,_ang_move);
		_y = global.Game_point_y + lengthdir_y(_dist,_ang_move);
		
		Func_draw_hand_stretch(_type,global.Game_point_x,global.Game_point_y,_x,_y,_tcol,false);
		}
	}

#endregion
#region timer moving hand

if global.Rule_Timer
	{
	//moving
	
	//return time hand
	if global.Timer_return_t<1
		Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,global.Game_point_x,global.Game_point_y - timer_disp_length * game_on_t * global.Timer_return_t,1,false);
	
	//normal time hand
	Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,timer_disp_x,timer_disp_y,1 * game_on_t,false);
	}

#endregion
#region base circle
var _r = (20 + 2 * cos(current_time/200)) * clamp(game_on_t/0.2,0,1);
//var _r = (20 + 2 * cos(current_time/200));
draw_set_color(c_black);
draw_circle(global.Game_point_x,global.Game_point_y, _r + 1,false);
draw_set_color(c_white);
draw_circle(global.Game_point_x,global.Game_point_y, _r,false);
#endregion

}






