/// @desc 


draw_set_alpha(1);

#region Background








#endregion

if game_on_t > 0 //game is active not playing
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


//if action_type != -1 //dont display when nothing was played
	{
	
	var _vari_dist = lerp(hand_casc_dist_vari_min, hand_casc_dist_vari_max, global.Game_Score_t);
	var _ang = 360/ hand_casc_num;
	var _tcol = hand_casc_tcol * game_on_t;
	var _type = (action_type==-1 ? HAND_TYPE.open : action_type);
	
	var _varicurve = animcurve_channel_evaluate(global.gendisp_vari_channel2,global.gendisp_vari_t2);
	
	#region battle
	var _battle;
	if global.Game_Score_t_sign==0
		{
		var _battle_range = lerp(hand_casc_battle_min, hand_casc_battle_max, global.Game_Score_t);
		_battle = random_range(-_battle_range,_battle_range);
		}
	else
		_battle = 0;
	#endregion
	
	var _vari_ang = global.gendisp_vari_ang_ts * 360 + _battle;
	var _x,_y,_dist,_ang_move;
	for (var i=0;i<360;i+=_ang)
		{
		_dist = 
			(
			hand_casc_dist + _vari_dist *													//
				(
				animcurve_channel_evaluate(global.gendisp_vari_channel1,(global.gendisp_vari_t1 + i/360) mod 1)//curve 1 applied over each hand position individually
				* _varicurve //curve 2 applied to all hands equaly
				)
			/// 2 //divide by number of curves | so 2 curves at max == max deviation distance allowed | dont need to if I multiplay
			)
		* game_on_t; //apply fade in
		
		
		_ang_move = (i + _vari_ang) mod 360;
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
#region base circle INACTIVE
/*
var _size_scale_offset = 0.2;
var _r = (20 + 2 * cos(current_time/200)) * clamp(game_on_t/_size_scale_offset,0,1);
draw_set_color(c_black);
draw_circle(global.Game_point_x,global.Game_point_y, _r + 1,false);
draw_set_color(c_white);
draw_circle(global.Game_point_x,global.Game_point_y, _r,false);
//*/
#endregion

}

#region base circle INACTIVE
//*
//var _size_scale_offset = 0.2;
//* clamp(game_on_t/_size_scale_offset,0,1);
draw_set_color(c_black);
draw_circle(global.Game_point_x,global.Game_point_y, basecircle_rad + 1,false);
draw_set_color(c_white);
draw_circle(global.Game_point_x,global.Game_point_y, basecircle_rad,false);
//*/
#endregion

//Func_draw_hand_arm(HAND_TYPE.open,global.Game_point_x,global.Game_point_y,mouse_x,mouse_y,90,1,false);