/// @desc 

#region game loop
if game_on
	{
	if game_active
		{
		
		//player input
		func_input_react_func(func_game_player_action);
		
		//exit game
		if keyboard_check_pressed(vk_escape)
			func_game_stop();
		
		}
	else//game is stopped
		{
		//start game
		if keyboard_check_pressed(vk_space)//space runs through from menu to game setup :(
			func_game_start();
		
		//exit ga,e
		if keyboard_check_pressed(vk_escape)
			func_game_end();
		
		
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
	
	
	global.Timer_t =		timer_count / global.Rule_Timer_Time;
	global.Timer_index =	timer_count div timer_tick_val;
	global.Timer_index_t =	(timer_count mod timer_tick_val) / timer_tick_val;
	global.Timer_last_t =	max(0,(timer_count - ((timer_tick_num-1) * timer_tick_val)) / timer_tick_val);
	
	//display
	timer_hand_sway = sin(current_time / 2000) * timer_hand_sway_val;
	timer_hand_tide = sin(current_time / 1500) * timer_hand_tide_val;
	
	func_timer_angle_calc(timer_count);
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
#region debug

if keyboard_check_pressed(ord("P"))
	{
	global.Debug = !global.Debug;
	show_debug_overlay(global.Debug);
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
		
		
		
		}
	else
		{
		
		var _input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
		var _input_y = keyboard_check(vk_down) - keyboard_check(vk_up);
		
		camera_set_view_pos(global.Cam,camera_get_view_x(global.Cam)+ _input_x,camera_get_view_y(global.Cam) + _input_y);
		}
	
	if keyboard_check_pressed(ord("R"))
		{
		game_restart();
		}
	}

#endregion
#region Background






#endregion







//move background with cam
func_background_white_move(camera_get_view_x(global.Cam),camera_get_view_y(global.Cam));