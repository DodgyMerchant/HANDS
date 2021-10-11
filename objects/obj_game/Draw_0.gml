/// @desc 




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
	
	
	
	
	var _x,_y,_ang,_leng;
	for (var i = 1;i<timer_tick_num;i++)
		{
		var _t = clamp(timer_count / timer_tick_val - i,0,1) + clamp(Func_t_invert(timer_count / timer_tick_val),0,1);
		
		
		_ang = timer_tick_ang * i + 90 + (timer_hand_sway * func_timer_arm_close_precision(i));
		
		
		_leng = (lerp(timer_disp_length,timer_disp_length_inactive,_t) + timer_hand_tide) * game_on_t;
		
		
		_x = global.Game_point_x + lengthdir_x(_leng,_ang);
		_y = global.Game_point_y + lengthdir_y(_leng,_ang);
		
		Func_draw_hand_stretch((global.Timer_index >= i ? HAND_TYPE.fist : HAND_TYPE.point),global.Game_point_x,global.Game_point_y,_x,_y,0.2,false);
		}
	
	
	}

#endregion
}

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
	var _x,_y,_dist,_ang_move;
	for (var i=0;i<360;i+=_ang)
		{
		_dist = hand_casc_dist_min + hand_casc_dist * _strenght *
		((animcurve_channel_evaluate(hand_casc_channel1,(hand_casc_count1/global.Game_speed + i/360) mod 1) +
		animcurve_channel_evaluate(hand_casc_channel2,hand_casc_count2/global.Game_speed)) / 2);
		
		
		_ang_move = (i + hand_casc_count3/global.Game_speed * 360) mod 360;
		_x = global.Game_point_x + lengthdir_x(_dist,_ang_move);
		_y = global.Game_point_y + lengthdir_y(_dist,_ang_move);
		
		Func_draw_hand_stretch((action_type==-1 ? HAND_TYPE.open : action_type),global.Game_point_x,global.Game_point_y,_x,_y,0.7,false);
		}
	}

#endregion

if game_on_t > 0
{
#region timer moving hand

if global.Rule_Timer
	{
	//moving
	Func_draw_hand_stretch(HAND_TYPE.point,global.Game_point_x,global.Game_point_y,timer_disp_x,timer_disp_y,1,false);
	}

#endregion

}

#region base circle
//var _r = (20 + 2 * cos(current_time/200)) * clamp(game_on_t/0.2,0,1);
var _r = (20 + 2 * cos(current_time/200));
draw_set_color(c_black);
draw_circle(global.Game_point_x,global.Game_point_y, _r + 1,false);
draw_set_color(c_white);
draw_circle(global.Game_point_x,global.Game_point_y, _r,false);
#endregion








