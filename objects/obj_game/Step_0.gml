/// @desc 

#region countdown

if countdown_active
if countdown_time_count <= 0
	{
	countdown_active = false;
	countdown_time_count = countdown_time;
	countdown_done = true;
	}
else
	{
	countdown_time_count--;
	}

#endregion
#region game loop
if game_on
	{
	if game_active
		{
		//player input
		func_input_react_func(func_game_player_action);
		
		//pause game
		if keyboard_check_pressed(vk_escape)
			{
			func_game_stop();
			
			}
		
		}
	else//game is paused
		{
		#region unpause game
		
		
		//timer done unpauses game
		if countdown_done
			{
			func_game_start();
			func_countdown_reset();
			}
		#endregion
		
		
		
		
		}
	
	
	}
else
	{
	
	}

game_on_count = clamp(game_on_count +Func_t_span(game_on),0,game_on_time);
game_on_t = game_on_count / game_on_time;

#endregion
#region timer
	
if global.Rule_Timer
	{
	#region count
	if timer_start
		timer_count++;
	#endregion
	#region time up
	
	if timer_count >= global.Rule_Timer_Time
		{
		func_game_rule_timer_up();
		}
	
	#endregion
	#region retuirn time reset
	
	if timer_count == 0
		{
		timer_hand_return_val = 1;
		timer_hand_return_hold = 0;
		}
	
	#endregion
	#region _t
	var _count = max(timer_count,0);
	global.Timer_t =		_count / global.Rule_Timer_Time;
	global.Timer_index =	_count div timer_tick_val;
	global.Timer_index_t =	(_count mod timer_tick_val_smooth) / timer_tick_val_smooth;
	global.Timer_last_t =	max(0,(_count - ((timer_tick_num-1) * timer_tick_val_smooth)) / timer_tick_val_smooth);
	global.Timer_return_t = Func_t_invert(clamp(timer_count / (-timer_hand_return_val),0,1)); // value < 0 => 0 | value==0 => _t==1
	
	#endregion
	
	//display
	timer_hand_sway = sin(current_time / 2000) * timer_hand_sway_val;
	timer_hand_tide = sin(current_time / 1500) * timer_hand_tide_val;
	
	
	#region sound
	
	
	if timer_start  and  global.Timer_index != timer_tick_num  and  global.Timer_index_t==0
		func_audio_play(-1,sfx_time_tick,true,false);
	
	#endregion
	
	
	#region time hand
	if global.Timer_return_t < 1// if resetting
		func_timer_angle_calc(timer_hand_return_hold);//display old receding hand
	else
		func_timer_angle_calc(timer_count);
	#endregion
	}

#endregion
#region visual display _t and sign

#region score
switch(global.Rule_Score_type)
	{
	case SCORE_TYPE.st_health: 
		//gest smallest val
		var _small_val = global.Rule_Health_max;
		var _small_i = .5;//0.5 so after the _t_span it will be 0 if nothing overwrites it
		var _val;
		var _arrh = array_length(global.Game_Score);
		for (var i=0;i<_arrh;i++)
			{
			_val = global.Game_Score[i];
			if _val<_small_val
				{
				//save smallest
				_small_val = _val;
				_small_i = i;
				}
			else if _val == _small_val
				_small_i = .5;
			}
		
		global.Game_Score_t = Func_t_invert(_small_val/global.Rule_Health_max);//inverts _t   1(high) == full effect
		//global.Game_Score_t_sign = (_small_i == 0 ? 1 : -1);
		global.Game_Score_t_sign = Func_t_span( Func_t_invert(_small_i));
	break;
	case SCORE_TYPE.st_points:
		global.Game_Score_t = abs(global.Game_Score) / global.Game_Score_needed;
		global.Game_Score_t_sign = sign(global.Game_Score);
		
	break;
	}
#endregion
#region win
if global.Game_Wins_against
	{
	global.Game_Wins_t = abs(global.Game_Wins) / global.Game_Wins_needed;
	global.Game_Wins_t_sign = sign(global.Game_Wins);
	}
else
	{
	//gest biggest val
	var _big_val = 0;
	var _big_i = .5;//0.5 so after the _t_span it will be 0 if nothing overwrites it
	var _val;
	var _arrh = array_length(global.Game_Wins);
	for (var i=0;i>_arrh;i++)
		{
		_val = global.Game_Wins[i];
		if _val>_big_val
			{
			//save smallest
			_big_val = _val;
			_big_i = i;
			}
		}
	
	global.Game_Wins_t = _big_val / global.Game_Wins_needed;
	//global.Game_Wins_t_sign = ( _big_i==0 ? -1 : 1 );
	global.Game_Wins_t_sign = Func_t_span(_big_i);
	}



#endregion

#endregion
#region surface handling


//surface exists
if !surface_exists(global.Hand_surface)//surf got destroyed
	{
	global.Hand_surface = surface_create(300,200);
	}



#endregion
#region hand cascade count

hand_casc_count1 = (hand_casc_count1 + 1) mod global.Game_speed;//
hand_casc_count2 = (hand_casc_count2 + 1) mod global.Game_speed;//
hand_casc_count3 = (hand_casc_count3 + 0.10 * (global.Game_Score_needed * global.Game_Score_t * global.Game_Score_t_sign)) mod global.Game_speed;//


#endregion
#region Background






#endregion
#region cam position

if cam_shock_active
	{
	
	#region calc and apply
	var _ang = cam_shock_ang + random_range(-cam_shock_ang_rand,cam_shock_ang_rand);
	
	cam_shock_x = lengthdir_x(cam_shock_dist,_ang);
	cam_shock_y = lengthdir_x(cam_shock_dist,_ang);
	
	cam_shock_ang += 180;
	#endregion
	
	cam_shock_count++;
	if cam_shock_count > cam_shock_time // to be num of frames active must be >
		{
		func_cam_shock_reset();
		}
	}




#region kick

if !cam_ckick_return
	{
	cam_ckick_x += lengthdir_x(cam_ckick_spd,cam_ckick_dir);
	cam_ckick_y += lengthdir_y(cam_ckick_spd,cam_ckick_dir);
	
	#region cap to range
	var _dist = point_distance(0,0,cam_ckick_x,cam_ckick_y);
	if _dist > cam_ckick_limit_rubber
		{
		var _dir = point_direction(0,0,cam_ckick_x,cam_ckick_y);
		var _leng = min(cam_ckick_limit_hard,_dist * cam_ckick_rubber_dec);
		cam_ckick_x = lengthdir_x(_leng,_dir);
		cam_ckick_y = lengthdir_y(_leng,_dir);
		}
	#endregion
	}
else
	{
	var _dist = lerp(0,cam_ckick_return_dist,cam_ckick_return_count / cam_ckick_return_time);
	var _dir = point_direction(0,0,cam_ckick_x,cam_ckick_y);
	cam_ckick_x = lengthdir_x(_dist,_dir);
	cam_ckick_y = lengthdir_y(_dist,_dir);
	
	cam_ckick_return_count--;
	
	if cam_ckick_return_count==0
		{
		cam_ckick_return = false;
		cam_ckick_return_count = cam_ckick_return_time;
		}
	}

//friction
cam_ckick_spd *= cam_ckick_fric;

#endregion
#region rumble

var _rum_mult = max(0, (global.Game_Score_t - (1 - cam_score_rumble_t)) / cam_score_rumble_t);//cam rumble multiplier
cam_rumble_x = random_range(-cam_score_rumble_val,cam_score_rumble_val)*_rum_mult;
cam_rumble_y = random_range(-cam_score_rumble_val,cam_score_rumble_val)*_rum_mult;


//func_frame_move(cam_rumble_x,cam_rumble_y);
//func_background_black_move(cam_rumble_x,cam_rumble_y);
//func_game_point_update(cam_rumble_x,cam_rumble_y);

#endregion

func_cam_calc();


#endregion
#region pause game

pause_dim_a = lerp(0, pause_dim_a_max, (countdown_time_count / countdown_time) * instance_exists(obj_menu_pause));


#endregion


#region debug

if keyboard_check_pressed(ord("P"))
	{
	Func_Debug_Enable(!global.Debug);
	}

if global.Debug 
	{
	if game_on
		{
		#region score
		if global.Rule_Score_type==SCORE_TYPE.st_points
			{
			var _inp = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
			if _inp != 0
				global.Game_Score += _inp;
			}
		else if global.Rule_Score_type==SCORE_TYPE.st_health
			{
			var _inp = keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down);
			
			if keyboard_check(vk_left)
				{
				global.Game_Score[0] += _inp;
				with(obj_score_health) func_score_health_update_player_score();
				}
			if keyboard_check(vk_right)
				{
				global.Game_Score[1] += _inp;
				with(obj_score_health) func_score_health_update_player_score();
				}
			}
		#endregion
		
		
		if keyboard_check_pressed(ord("R"))
			{
			func_game_end();
			func_game_setup();
			countdown_time_count = 0;
			}
		}
	else
		{
		/*
		var _input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
		var _input_y = keyboard_check(vk_down) - keyboard_check(vk_up);
		
		camera_set_view_pos(global.Cam,camera_get_view_x(global.Cam)+ _input_x,camera_get_view_y(global.Cam) + _input_y);
		//*/
		
		}
	
	
	}

#endregion


//move background with cam
func_background_white_move(global.Cam_disp_x,global.Cam_disp_y);