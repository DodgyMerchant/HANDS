/// @desc 


if game_on
	{
	if game_active
		{
		//player input
		func_input_react_func(func_game_player_action);
		
		}
	
	#region timer
	
	if global.Rule_Timer
		{
		if timer_start
			timer_count++;
		
		if timer_count >= global.Rule_Timer_Time
			{
			func_game_rule_timer_up();
			}
		
		global.Timer_t = timer_count / global.Rule_Timer_Time; // a variable to react to
		//display
		
		timer_ang_disp -= angle_difference(timer_ang_disp, lerp(0,360,global.Timer_t)) / timer_ang_speed;
		//timer_ang_disp += Func_angle_approach(timer_ang_disp,lerp(0,360,global.Timer_t),timer_ang_speed);
		}
	
	#endregion
	
	#region exit game
	if keyboard_check_pressed(vk_escape)
		{
		func_game_end();
		}
	#endregion
	}
else
	{
	
	}


#region visual display _t and sign

#region score
switch(global.Rule_Score_type)
	{
	case SCORE_TYPE.st_health: 
		//gest smallest val
		var _small_val = global.Rule_Health_max;
		var _small_i = 0;
		var _val;
		var _arrh = array_length(global.Game_Score);
		for (var i=0;i>_arrh;i++)
			{
			_val = global.Game_Score[i];
			if _val<_small_val
				{
				//save smallest
				_small_val = _val;
				_small_i = i;
				}
			}
		
		global.Game_Score_t = (global.Rule_Health_max - _small_val)/global.Rule_Health_max;//inverts _t   1(high) == full effect
		global.Game_Score_t_sign = (_small_i == 0 ? 1 : -1);
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
	var _big_i = 0;
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
	global.Game_Wins_t_sign = ( _big_i==0 ? -1 : 1 );
	}



#endregion

#endregion
#region surface handling


//surface exists
if !surface_exists(global.Hand_surface)//surf got destroyed
	{
	global.Hand_surface = surface_create(300,200);
	}
if !surface_exists(background_surface1)//surf got destroyed
	{
	background_surface1 = surface_create(background_surf_w,background_surf_h);
	}
if !surface_exists(background_surface2)//surf got destroyed
	{
	background_surface2 = surface_create(background_surf_w,background_surf_h);
	}


#endregion
#region hand cascade count

hand_casc_count1 = (hand_casc_count1 + 1) mod global.Game_speed;//
hand_casc_count2 = (hand_casc_count2 + 1) mod global.Game_speed;//
hand_casc_count3 = (hand_casc_count3 + 0.10 * (global.Game_Score_needed * global.Game_Score_t * global.Game_Score_t_sign)) mod global.Game_speed;//


#endregion
#region debug

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
		
		if keyboard_check_pressed(vk_left)
			global.Game_Score[0] += _inp;
		if keyboard_check_pressed(vk_right)
			global.Game_Score[1] += _inp;
		}
	#endregion
	
	
	
	}
else
	{
	
	}

if keyboard_check_pressed(ord("R"))
	{
	game_restart();
	}

#endregion
#region Background


backgound_time_count++;

if backgound_time_count == backgound_time
	{
	backgound_update = true;
	backgound_time_count = 0;
	background_zoom = 0;
	}

backgound_time_t = backgound_time_count / backgound_time;
//backgound_time_t = Func_t_inverse(backgound_time_count / backgound_time);

#endregion





var _input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
var _input_y = keyboard_check(vk_down) - keyboard_check(vk_up);

camera_set_view_pos(global.Cam,camera_get_view_x(global.Cam)+ _input_x,camera_get_view_y(global.Cam) + _input_y);


//move background with cam
func_background_white_move(camera_get_view_x(global.Cam),camera_get_view_y(global.Cam));