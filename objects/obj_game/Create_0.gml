/// @desc 

/*


new rule: timer against //timer diesnt get reset but reversed, and if it runs out on your side you get -score






global.Game_Wins_needed		// val
global.Game_Wins_against	// bool
global.Rule_Score_type		// SCORE_TYPE
global.Game_Score_needed	// val
global.Rule_Health_max		// val
global.Rule_Timer			// bool
global.Rule_Timer_Time		// time
global.Rule_Hand_self		// RULE_HAND_SELF
*/

randomize();

#region General
global.Width = 300;
global.Height = 200;
room_width = global.Width;
room_height = global.Height;
display_set_gui_size(global.Width,global.Height);

global.Player_num = 2;

enum HAND_TYPE
	{
	open = 0,
	point= 1,
	fist = 2
	}

global.Game_speed = game_get_speed(gamespeed_fps);
global.Cam = view_camera[0];
global.Layer_hand = layer_get_id("Hands");
global.Layer_score = layer_get_id("Score");
global.Layer_menus = layer_get_id("Menus");
//global.Layer_back = layer_get_id("Back_hands");

global.Game_point_x = global.Width/2;
global.Game_point_y = global.Height/2;

func_game_point_update = function(_xoff,_yoff)
	{
	global.Game_point_x = global.Width/2	+ _xoff;
	global.Game_point_y = global.Height/2	+ _yoff;
	}

func_window_name = function()
	{
	var _str = choose(
	//"Dont look turn around, there a hand!",
	"Hands are all around you.",
	"Your life is nothing but hands",
	"All you can think about are hands.",
	"The hands of fate guide you.",
	"You are nothing without the hands.",
	"You crave the touch of the hand.",
	"The will of the hands is your will.",
	"The hands only want the best for you.",
	"Disobeying the hands would be a grave mistake.",
	"All you do is for the hands."
	);
	window_set_caption(_str);
	}

#endregion
#region menu

#region control type
enum MENU_CONTROL_TYPE
	{
	mouse,
	buttons
	}
global.Menu_control_type = MENU_CONTROL_TYPE.buttons;

func_menu_check_inputtype = function()
	{
	if mouse_check_button(mb_any) or mouse_moved
		global.Menu_control_type = MENU_CONTROL_TYPE.mouse;
	else if keyboard_check(vk_anykey) or Func_input_all_gp_any()!=-1
		global.Menu_control_type = MENU_CONTROL_TYPE.buttons;
	}

#endregion

func_menu_create = function()
	{
	instance_create_layer(0,0,global.Layer_menus,obj_menu);
	
	
	}
func_menu_pause_create = function()
	{
	if !instance_exists(obj_menu_pause)
		instance_create_layer(0,0,global.Layer_menus,obj_menu_pause);
	else
		with(obj_menu_pause)
			{
			active = true;
			}
	}

#endregion
#region general display


#region general display variation



gendisp_vari_count1 = 0; //counts from 0 - gamespeed
gendisp_vari_count2 = 0; //
global.gendisp_vari_t1 = 0; // t of count  for display needs
global.gendisp_vari_t2 = 0; //


//angle
gendisp_vari_angle1 = 0; //a progress counter for an angle from 0 to 360 | speed depending on score_t | without score_t_sign
gendisp_vari_angle2 = 0; //a progress counter for an angle from 0 to 360 | speed depending on score_t | with score_t_sign+
gendisp_vari_angle1_max = global.Game_speed; //a progress counter for an angle from 0 to 360 | speed depending on score_t | without score_t_sign
gendisp_vari_angle2_max = global.Game_speed*2.73; //a progress counter for an angle from 0 to 360 | speed depending on score_t | with score_t_sign+
global.gendisp_vari_ang_t = 0;//angle multiplier without sign
global.gendisp_vari_ang_ts = 0;//angle multiplier with sign including 0
gendisp_vari_angle_min = 0.1; //max speed
gendisp_vari_angle_max = 6; //min speed
//channels
global.gendisp_vari_channel1 = animcurve_get_channel(ac_gendisp_vari, 0); 
global.gendisp_vari_channel2 = animcurve_get_channel(ac_gendisp_vari, 1);

func_gendisp_calc = function()
	{
	gendisp_vari_count1 = (gendisp_vari_count1 + 1) mod gendisp_vari_angle1_max;//counts up by val(1) mods to gamespeed(1 second)
	gendisp_vari_count2 = (gendisp_vari_count2 + 1) mod gendisp_vari_angle2_max;//
	global.gendisp_vari_t1 = gendisp_vari_count1 / gendisp_vari_angle1_max;
	global.gendisp_vari_t2 = gendisp_vari_count2 / gendisp_vari_angle2_max;
	//angle
	var _spd = lerp(gendisp_vari_angle_min,gendisp_vari_angle_max,global.Game_Score_t);
	gendisp_vari_angle1 = (gendisp_vari_angle1 + _spd) mod 360;//
	_spd = lerp(gendisp_vari_angle_min,gendisp_vari_angle_max,global.Game_Score_t) * global.Game_Score_t_sign;
	gendisp_vari_angle2 = (gendisp_vari_angle2 + _spd) mod 360;//
	global.gendisp_vari_ang_t = gendisp_vari_angle1 / 360;//
	global.gendisp_vari_ang_ts = gendisp_vari_angle2 / 360;//
	}


#endregion



#endregion
#region game rules

//wins
global.Game_Wins_needed = 2;
global.Game_Wins_against = true; //if a win counts agains your oppnents win | one player need 2 wins and the player 0 to win

//score
enum SCORE_TYPE
	{
	st_points,
	st_health
	}
//global.Rule_Score_type = SCORE_TYPE.st_points;
global.Rule_Score_type = SCORE_TYPE.st_health;
global.Game_Score_needed = 2;
global.Rule_Health_max = 10;

//timer
global.Rule_Timer = true;
global.Rule_Timer_Time = global.Game_speed * 5;

enum RULE_HAND_SELF
	{
	anarchy,	//can beat your own hand for points
	soft,		//can play onto your own hand
	spikey		//if oyu play onto your own hand you loos points
	}
global.Rule_Hand_self = RULE_HAND_SELF.spikey; //how hands react to self plays

function Func_game_rule_reset()
	{
	//wins
	global.Game_Wins_needed = 2;
	global.Game_Wins_against = true; //if a win counts agains your oppnents win | one player need 2 wins and the player 0 to win
	
	//score
	global.Rule_Score_type = SCORE_TYPE.st_health;
	global.Game_Score_needed = 2;
	global.Rule_Health_max = 10;
	
	//timer
	global.Rule_Timer = true;
	global.Rule_Timer_Time = global.Game_speed * 5;
	
	global.Rule_Hand_self = RULE_HAND_SELF.spikey; //how hands react to self plays
	}

#endregion
#region score and win

global.Game_Score = 0;//counts the players scores | if type points is a value	if type health is an array that hold the health
global.Game_Wins = 0; //counts the players wins | if rule win gainst is true then is a var   if rule agains is false   is a array

//disp
/*
all _t here is seen in a way that it describes the player who is winning
f.e.  player 1 has low health ==  high Score_t and Score_t_sign == 0

*/
//the vars
global.Game_Score_t	= 0;		//percentual value of score	/display helper
global.Game_Wins_t	= 0;		//percentual value of win		/display helper
global.Game_Score_t_sign = 0;	//value multiplier for who is winning | 1==player 1 | 0==noone | -1==player 2
global.Game_Score_t_signN0 = 0;	//no 0
global.Game_Wins_t_sign	= 0;	//
//_t
func_score_t_sign_update = function(_sign) //checks if the Game_Score_t_sign is allowed to be 0 and handles accordingly
	{
	global.Game_Score_t_sign = _sign;	//value multiplier for who is winning
	if _sign != 0
	global.Game_Score_t_signN0 = _sign;	//no 0
	}

//score display
//points
score_points_sep = 35;
score_points_inactive_y = room_height - 20;
score_points_active_y = room_height - 35;

func_score_setup = function()
	{
	switch(global.Rule_Score_type)
		{
		#region health
		case SCORE_TYPE.st_health:
			
			global.Game_Score = array_create(global.Player_num,global.Rule_Health_max);
			
			#region create score hands
			/*
			FOR 2 PLAYERS ONLY
			change for more players
			
			*/
			#region // horizontal bars	NOT ACTIVE
			/* 
			var _offset = 20;
			var _disp_offset = 50;
			var _y = room_height - _offset;
			with(instance_create_layer(-_disp_offset, _y, global.Layer_score, obj_score_health))
				{
				player = 0;
				
				x2 = global.Game_point_x - _offset;
				y2 = y;
				x1 = _offset;
				y1 = y;
				xdisp = x;
				ydisp = y;
				}
			with(instance_create_layer(room_width + _disp_offset, _y, global.Layer_score, obj_score_health))
				{
				player = 1;
				
				x2 = global.Game_point_x + _offset;
				y2 = y;
				x1 = room_width - _offset;
				y1 = y;
				xdisp = x;
				ydisp = y;
				}
			#endregion
			//*/
			#endregion
			#region // vertical bars	ACTIVE
			//* 
			var _y_end =		50;
			var _y_start =		room_height - 20;
			var _y_offscreen =	room_height + 50;
			var _x = 25;
			with(instance_create_layer(_x, _y_offscreen, global.Layer_score, obj_score_health))
				{
				player = 0;
				turn = false;
				
				x2 = x;
				y2 = _y_end;
				x1 = x;
				y1 = _y_start;
				xdisp = x;
				ydisp = _y_offscreen;
				}
			with(instance_create_layer(room_width - _x, _y_offscreen, global.Layer_score, obj_score_health))
				{
				player = 1;
				turn = false;
				
				x2 = x;
				y2 = _y_end;
				x1 = x;
				y1 = _y_start;
				xdisp = x;
				ydisp = _y_offscreen;
				}
			#endregion
			//*/
			#endregion
			//update score in score health object
			with(obj_score_health) func_score_health_update_player_score();
			
		break;
		#endregion
		#region points
		case SCORE_TYPE.st_points:
			
			global.Game_Score = 0;
			
			#region create score hands
			
			var _x;
			for (var i=-global.Game_Score_needed;i<=global.Game_Score_needed;i++)
				{
				_x = global.Game_point_x + i * score_points_sep;
				
				with(instance_create_layer(_x,score_points_inactive_y,global.Layer_score,obj_score_points))
					{
					number = i;
					active_pos = other.score_points_active_y;
					inactive_pos = other.score_points_inactive_y;
					}
				}
			
			#endregion
		break;
		#endregion
		}
	}
func_score_reset = function()
	{
	switch(global.Rule_Score_type)
		{
		case SCORE_TYPE.st_health:
			for(var i=0;i<global.Player_num;i++)
				global.Game_Score[i] = global.Rule_Health_max;
			
			//update score in score health object
			with(obj_score_health) func_score_health_update_player_score();
		break;
		case SCORE_TYPE.st_points:
			global.Game_Score = 0;
		break;
		}
	//reset display vals
	global.Game_Score_t	= 0;		//percentual value of score	/display helper
	global.Game_Score_t_sign = 0;	//value multiplier for who is winning
	}
func_score_cleanup = function()
	{
	global.Game_Score = 0;
	
	if global.Rule_Score_type == SCORE_TYPE.st_points
		with(obj_score_points) func_game_end(); 
	else
		with(obj_score_health) func_game_end(); 
	}
func_win_setup = function()
	{
	if global.Game_Wins_against //
		{//normal against calc  -2 - 2
		global.Game_Wins = 0;
		}
	else
		{
		global.Game_Wins = array_create(global.Player_num,0);
		}
	}
func_win_reset = function()
	{
	if global.Game_Wins_against //
		{//normal against calc  -2 - 2
		global.Game_Wins = 0;
		}
	else//individual point count
		{
		for(var i=0;i<global.Player_num;i++)
			global.Game_Wins[i] = 0;
		}
	
	//reset display vals
	global.Game_Wins_t	= 0;		//percentual value of win		/display helper
	global.Game_Wins_t_sign	= 0;	//
	}
func_win_cleanup = function()
	{
	global.Game_Wins = 0;
	}

//game
func_game_score = function(_player,_outcome)
	{
	/*
	outcome is confirmed to be != -1
	*/
	switch(global.Rule_Score_type)
		{
		case SCORE_TYPE.st_points:
			//2 player specific
			#region info
			// p | o | result | expected
			//---|---|--------|----------
			// 0 | 1 |	0	  | -1
			//---|---|--------|----------
			// 1 | 1 |	1	  | +1
			//---|---|--------|----------
			// 0 | 0 |	1	  | +1
			//---|---|--------|----------
			// 1 | 0 |	0	  | -1
			//---|---|--------|----------
			#endregion
			global.Game_Score += Func_t_span( _player == _outcome );
			
			////////////maybe make something like this for  points
			//update health score hand val
			//with(obj_score_health) func_score_health_update_player_score();
		break;
		case SCORE_TYPE.st_health:
			//2 player specific
			#region info
			// p | o | result | expected
			//---|---|--------|----------
			// 0 | 1 |	1	  | 1
			//---|---|--------|----------
			// 1 | 1 |	0	  | 0
			//---|---|--------|----------
			// 0 | 0 |	0	  | 0
			//---|---|--------|----------
			// 1 | 0 |	1	  | 1
			//---|---|--------|----------
			#endregion
			global.Game_Score[_player != _outcome] -= 1;
			
			//update health score hand val
			with(obj_score_health) func_score_health_update_player_score();
		break;
		}
	
	func_cam_shock_active();
	
	}
func_game_win = function(_player)
	{
	show_debug_message("Win! player: "+string(_player));
	/*
	_player = player to win | player1 -> p==0 | player2 -> p==1
	
	*/
	var _check;
	switch( global.Game_Wins_against)
		{
		#region against
		case true:
			//wins are calculated against | standart values applied: -2 - 0 - 2
			// p == 0 ==> -1	|  p == 1 ==> +1
			global.Game_Wins += Func_t_span(_player);
			_check = abs(global.Game_Wins);
		break;
		#endregion
		#region seperate
		case false:
			
			global.Game_Wins[_player]++;
			_check = global.Game_Wins[_player];
		break;
		#endregion
		}
	
	show_debug_message("Player "+string(_player)+" has "+string(_check)+" points!");
	
	//check for win win
	if _check >= global.Game_Wins_needed
		{
		return func_game_win_win(_player);
		}
	
	//reset stuff
	func_game_round_reset();
	}
func_game_win_win = function(_player)
	{
	show_debug_message("Win Win!!! player: "+string(_player));
	/*
	global.Game_Wins_against
	*/
	
	func_game_end();
	}

#endregion
#region game

game_on = false;	//
game_active = false; //if player can create hands

func_game_setup = function()//sets up the game
	{
	game_on = true;
	
	func_score_setup();
	func_win_setup();//sets up win variable
	func_timer_setup();
	
	//start game timer to start game
	func_countdown_start();//activate countdown
	}
func_game_start = function()//start the game play mode
	{
	game_active = true;
	//timer
	if global.Rule_Timer
		{
		timer_start = true;
		
		}
	
	//destroy pause menu
	if instance_exists(obj_menu_pause)
		with(obj_menu_pause) {instance_destroy();}
	}
func_game_stop = function()//stops the game play mode
	{
	game_active = false;
	//timer
	if global.Rule_Timer
		timer_start = false;
	
	//cam
	//kick return
	func_cam_kick_return();
	
	//pause menu
	func_menu_pause_create();
	}
func_game_round_reset = function() //resets the vars to    //MUST BE PLAYABLE STATE
	{
	with(obj_hand) func_end();
	
	action_type = -1;
	action_inst = -1;
	//score and win
	func_win_reset();
	func_score_reset();
	
	//timer
	//func_timer_reset(); // no reset more setup
	//hand surface
	func_handsurf_erase_begin();
	
	//for fun
	func_window_name();
	
	//cam
	//kick
	func_cam_kick_return();
	}
func_game_end = function() //end the game play mode return to menu
	{
	//reset vars
	func_game_round_reset();
	
	//other
	game_on = false;
	
	//score and win cleanup
	func_score_cleanup();
	func_win_cleanup();
	
	//menu create
	func_menu_create();
	}

game_on_t = 0;
game_on_time = global.Game_speed * 1;
game_on_count = 0;

//hand
global.Circle_hand_offset = 20; //offset for game hands
global.LongestDistance = point_distance(0,0,global.Game_point_x,global.Game_point_y); //longest distance between game point and screen edge

func_hand_create = function(_type,_x,_y)
	{
	/*
	//old hand destroy of traveled
	if instance_exists(obj_hand)
		with(obj_hand)
			if tics_count == tics
				func_hand_dim();
	//*/
	var _inst = instance_create_layer(_x,_y,global.Layer_hand,obj_hand);
	with(_inst)
		{
		image_index = _type;
		spd = 5;
		tics = 5;
		}
	
	return _inst;
	}

func_type_logic = function(_attacker,_target)	//returns true if attacker wins and false if not /-1 for nothing
	{
	switch(_attacker)
		{
		case HAND_TYPE.open:
			switch(_target)
				{
				case HAND_TYPE.point:
					return false;//open looses to poin
				break;
				case HAND_TYPE.fist:
					return true;//open wins over fist
				break;
				}
		break;
		case HAND_TYPE.point:
			switch(_target)
				{
				case HAND_TYPE.fist:
					return false;//point looses fist 
				break;
				case HAND_TYPE.open:
					return true;//point wins over open
				break;
				}
		break;
		case HAND_TYPE.fist:
			switch(_target)
				{
				case HAND_TYPE.open:
					return false;//fist looses to open
				break;
				case HAND_TYPE.point:
					return true;//fist wins over point
				break;
				}
		break;
		}
	
	return -1;
	}

#region player action

action_type = -1; //the last type of action taken
action_inst = -1; //the associated hand inst
action_player = -1;//the player that played last action

func_game_player_action = function(_type,_player)
	{
	switch(_type)
		{
		#region hand action
		case INPUT_TYPE.open: // == HAND_TYPE.open
		case INPUT_TYPE.point: // == HAND_TYPE.point
		case INPUT_TYPE.fist: // == HAND_TYPE.fist
		var _type_angle = 30;
		var _type_region = 20 / 2;
		var _dist = global.LongestDistance + 10;
		
		
		var _dir;
		#region get point creation
		
		if _player == 0//if player one
			{
			_dir = (180 - _type_angle) + (_type * _type_angle)	+ random_range(-_type_region,_type_region);
			}
		else
			{
			_dir = (0 + _type_angle) - (_type * _type_angle)	- random_range(-_type_region,_type_region);
			}
		#endregion
		
		var _x = global.Game_point_x + lengthdir_x(_dist,_dir);
		var _y = global.Game_point_y + lengthdir_y(_dist,_dir);
		
		with(func_hand_create(_type,_x,_y))
			{
			player = _player;
			}
		
		#region camera kick
		
		func_cam_kick(_dir + 180);
		
		#endregion
		break;
		#endregion
		#region space action
		case INPUT_TYPE.special:
		
		if global.Rule_Score_type =  SCORE_TYPE.st_points
			{
			//if the right player presses it
			//if (_player == 0 and global.Game_Score<0) or (_player == 1 and global.Game_Score>0) //space hat no player accociated atm :/
				//if the score is high enough
				if abs(global.Game_Score) >= global.Game_Score_needed
					{
					//winning player will have over 0 points
					// 
					func_game_win( global.Game_Score > 0 );
					}
			}
		else// SCORE_TYPE.st_health
			{
			var _size = array_length(global.Game_Score)
			for (var i=0;i<_size;i++)
				{
				if global.Game_Score[i] <= 0
				//if i != _player //laywe cant win with his own defeat	//space hat no player accociated atm :/
					{
					func_game_win((i+1) mod (global.Player_num-1));
					}
				}
			}
		
		show_debug_message("game player action space");
		
		
		break;
		#endregion
		}
	}

func_game_player_action_hand_eval = function(_id,_type,_player)
	{
	/*
	global.Rule_Hand_self
	RULE_HAND_SELF.anarchy
	RULE_HAND_SELF.soft
	RULE_HAND_SELF.spikey
	*/
	if action_type != -1//if there is a previous action
		{
		var _outcome;
		//action_player
		
		#region self play
		if (_player == action_player) //selfplay happens
			switch(global.Rule_Hand_self)//check rules
				{
				case RULE_HAND_SELF.anarchy:
					_outcome = func_type_logic(_type,action_type);
				break;
				case RULE_HAND_SELF.soft:
					//nothing happens
					_outcome = -1;
				break;
				case RULE_HAND_SELF.spikey:
					//loose the outcome
					_outcome = false;
				break;
				}
		#endregion
		#region get outcome
		else //get normal outcome
			_outcome = func_type_logic(_type,action_type);
		#endregion
		
		if _outcome != -1
			{
			func_game_score(_player,_outcome);
			}
		
		//dim old hand
		action_inst.func_hand_dim();
		}
	
	//set self to last hand played
	action_type = _type;
	action_inst = _id;
	action_player = _id.player;
	
	#region time
	//reset time
	
	func_game_rule_timer_reset(false);
	
	#endregion
	}

#endregion
#endregion
#region countdown

//countdown_time = global.Game_speed * 3;
countdown_time = 30;	//count town time untol game starts
countdown_time_count = countdown_time;
countdown_active = false;
countdown_done = false;
pause_dim_a_max = 0.9;
pause_dim_a = 0;

func_countdown_start = function()
	{
	countdown_active = true;
	countdown_time_count = countdown_time;
	}

func_countdown_stop = function()
	{
	func_countdown_reset();
	}

func_countdown_reset = function()
	{
	countdown_done = false;
	countdown_active = false;
	countdown_time_count = countdown_time;
	}

#endregion
#region rule timer

timer_start = false;
timer_count = 0;
timer_disp_x = 0;
timer_disp_y = 0;

timer_angle_tick_channel = animcurve_get_channel(ac_game_rule_timer, "Tick");

//timer_tick_num = global.Rule_Timer_Time / global.Game_speed;
timer_tick_num = 11;//11
timer_tick_val = global.Rule_Timer_Time / timer_tick_num;	//timespan in frames between two arms
timer_tick_val_smooth = round(timer_tick_val);				//timer_tick_val rounded to remove fractions for better displaying,  might be better to do at runtime for benefit of bankers rounding
//global.Rule_Timer_Time = timer_tick_num * timer_tick_val;
timer_tick_tval = 1 / timer_tick_num;
timer_tick_ang = 360 / timer_tick_num;

//disp vals
timer_disp_length = 50;
timer_disp_length_inactive = 30;
timer_hand_sway_val = 10;
timer_hand_sway = 0;
timer_hand_tide_val = 5;
timer_hand_tide = 0;
timer_hand_return_val = 1;//holds the time that is added to the count to smooth out the hand reset
timer_hand_return_hold = 0;//holds the time that is added to the count to smooth out the hand reset
timer_disp_player = 0;


//display helpers
global.Timer_t = 0;			// t for the whole time
global.Timer_index = 0;		//number that represents which last full tick has been passed  f.e. tick_num = 4; _t = 0.3; _index == 1;
global.Timer_index_t = 0;	// t in the current tick space
global.Timer_last_t = 0;	// t in the last tick space
global.Timer_return_t = 0;

//in round use
func_game_rule_timer_up = function()//when timer runs out
	{
	show_debug_message("Times Up");
	/*
	what happens when the timer runs out
	
	*/
	//sound
	func_audio_play(-1,sfx_time_time_over,true,false);
	
	//-score to other player
	func_game_score(!action_player,0);
	
	
	func_game_rule_timer_reset(true);
	}
func_game_rule_timer_reset = function(_time_up)//var reset
	{
	if global.Rule_Timer
		{
		if _time_up//time up reset
			timer_count = 0;
		else
			{
			if timer_count >= 0
				{
				timer_hand_return_hold = max(0,timer_count);
				timer_hand_return_val = (timer_tick_val - (timer_count - (timer_count div timer_tick_val) * timer_tick_val));
			
				timer_count = 0 - timer_hand_return_val;
			
				show_debug_message("time reset: at= "+string(timer_hand_return_hold)+"| to= "+string(timer_count));
				}
			
			func_timer_player_set();
			}
		}
	}

func_timer_setup = function()
	{
	if global.Rule_Timer
		{
		
		
		timer_count = 0;
		global.Timer_t = 0;
		
		
		}
	}
func_timer_reset = function()//complete var reset 
	{
	timer_count = 0;
	global.Timer_t = 0;
	timer_hand_return_val = 1;
	timer_hand_return_hold = 0;
	timer_disp_player = 0;
	
	//func_timer_angle_calc(0);
	}

func_timer_player_set = function() //sets timer_disp_player to either -1 or 1
	{
	timer_disp_player = (action_player==-1 ? choose(-1,1) : Func_t_span(action_player));
	}

func_timer_angle_calc = function(_count)
	{
	var _shiver = global.Timer_t * 1;
	
	var _time_t = ((_count div timer_tick_val) * timer_tick_val) / global.Rule_Timer_Time;
	//var _time_t = 0;
	var _tick_t = timer_tick_tval * animcurve_channel_evaluate(timer_angle_tick_channel, (_count mod timer_tick_val_smooth) / timer_tick_val_smooth);
	//var _tick_t = 0;
	
	var _ang =  (360 * timer_disp_player) * (_time_t + _tick_t) + 90;// + (timer_hand_sway * func_timer_arm_close_precision(round(global.Timer_t / timer_tick_tval)));
	
	var _leng = timer_disp_length * game_on_t * (global.Timer_return_t<1 ? Func_t_invert(global.Timer_return_t) : 1);
	
	
	
	
	
	timer_disp_x = global.Game_point_x + lengthdir_x(_leng,_ang) + random_range(-_shiver,_shiver);
	timer_disp_y = global.Game_point_y + lengthdir_y(_leng,_ang) + random_range(-_shiver,_shiver);
	}

func_timer_arm_close_precision = function(i) //0 - 1	//0 when arm is on the given i index  1 when arm is one tick space or more away
	{
	return (min(abs((i / timer_tick_num ) - global.Timer_t), timer_tick_tval) / timer_tick_tval);
	}


func_timer_player_set();
func_timer_angle_calc(0);

#endregion
#region hand surface

global.Hand_surface = surface_create(300,200);
hand_surf_a = 0.1;
hand_surf_erase_a = 1;
hand_surf_erase = false;
var _speed = 30;
hand_surf_erase_a_decay = hand_surf_erase_a/_speed;

func_handsurf_erase_begin = function()
	{
	hand_surf_erase = true;
	}
func_handsurf_draw = function()
	{
	if hand_surf_erase
		hand_surf_erase_a = max(hand_surf_erase_a - hand_surf_erase_a_decay, 0);
	
	//reset if a is 0
	if hand_surf_erase_a == 0
		{
		surface_set_target(global.Hand_surface);
		draw_clear_alpha(c_white,0);
		surface_reset_target();
		
		//reset var
		hand_surf_erase = false;
		hand_surf_erase_a = 1;
		}
	
	draw_surface_ext(global.Hand_surface,0,0,1,1,0,-1,hand_surf_a * hand_surf_erase_a);
	}


#endregion
#region input

/*
rumble!!

gamepad_set_vibration(device, left_motor, right_motor);
*/
#region mouse input

mouse_xlast = mouse_x;
mouse_ylast = mouse_y;
mouse_moved = false;

func_mouse_check_moved = function()
	{
	mouse_moved = mouse_xlast != mouse_x or mouse_ylast != mouse_y;
	
	mouse_xlast = mouse_x;
	mouse_ylast = mouse_y;
	}

#endregion
#region gamepad

global.Input_gp_list = ds_list_create();
global.Input_gp_active_list = ds_list_create();

func_gamepad_connected_update = function()
	{
	//clear active list
	ds_list_clear(global.Input_gp_active_list);
	
	var gp_num = gamepad_get_device_count();
	var _size = ds_list_size(global.Input_gp_list);
	for (var i = 0; i < gp_num; i++;)
	    {
		if i > _size //resize of too small
			ds_list_add(global.Input_gp_list,false);
		
	    if gamepad_is_connected(i)
	        {
	        global.Input_gp_list[| i] = true;
			ds_list_add(global.Input_gp_active_list,i);
	        }
	    else
	        {
	        global.Input_gp_list[| i] = false;
	        }
	    }
	}

func_gamepad_connected_update();
#endregion

player_input_list = ds_list_create(); //lists that holds all inputs that are done this frame
repeat (global.Player_num) ds_list_add(player_input_list,false);

enum INPUT_TYPE
	{
	special = -1,
	open = HAND_TYPE.open,
	point = HAND_TYPE.point,
	fist = HAND_TYPE.fist
	}
enum PLAYER_INPUT_GRID_INDEX
	{
	input,
	type,
	player
	}

#region fill grid
player_input_grid = Func_DH_createfill_grid(true,3,
//| input | type of input | player |
//////p1
//123
ord("1"),	INPUT_TYPE.open,	0,
ord("2"),	INPUT_TYPE.point,	0,
ord("3"),	INPUT_TYPE.fist,	0,
///qay/z
ord("Q"),	INPUT_TYPE.open,	0,
ord("A"),	INPUT_TYPE.point,	0,
ord("Y"),	INPUT_TYPE.fist,	0,
ord("Z"),	INPUT_TYPE.fist,	0,
///contrller
gp_padu,	INPUT_TYPE.open,	0,
gp_padr,	INPUT_TYPE.point,	0,
gp_padd,	INPUT_TYPE.fist,	0,
//////p2

//890
ord("8"),	INPUT_TYPE.open,	1,
ord("9"),	INPUT_TYPE.point,	1,
ord("0"),	INPUT_TYPE.fist,	1,
///ujm
ord("U"),	INPUT_TYPE.open,	1,
ord("J"),	INPUT_TYPE.point,	1,
ord("M"),	INPUT_TYPE.fist,	1,
///numpad 936
vk_numpad3,	INPUT_TYPE.open,	2,
vk_numpad6,	INPUT_TYPE.point,	2,
vk_numpad9,	INPUT_TYPE.fist,	2,
///controller
gp_face4,	INPUT_TYPE.open,	2,
gp_face3,	INPUT_TYPE.point,	2,
gp_face1,	INPUT_TYPE.fist,	2,


///////space
vk_space,	INPUT_TYPE.special,	-1,
//controller
gp_shoulderlb,	INPUT_TYPE.special,	-1,
gp_shoulderrb,	INPUT_TYPE.special,	-1
)
#endregion

func_input_check = function()
	{
	//clear list
	ds_list_clear(player_input_list);
	
	//go through all game inputs
	//var _p;
	var _h = ds_grid_height(player_input_grid)
	for (var i=0;i<_h;i++)//goes through all inputs and checks them
		{
		if keyboard_check_pressed(player_input_grid[# PLAYER_INPUT_GRID_INDEX.input, i])
			{
			//add input to list
			ds_list_add(player_input_list,i);
			
			/*
			_p = player_input_grid[# PLAYER_INPUT_GRID_INDEX.player,i];
			//check if input already done
			if player_input_list[| _p] == false
				{
				func_game_player_action(player_input_grid[# PLAYER_INPUT_GRID_INDEX.type,i],_p);
				//set action taken
				player_input_list[| _p] = true;
				}
			//*/
			}
		}
	}
func_input_react_func = function(_func) //go through all done inputs and execute given function(input_type,input_player)
	{
	//go through aall done inputs
	var _type,_player;
	var _size = ds_list_size(player_input_list);
	for (var i=0;i<_size;i++)
		{
		_type = player_input_grid[# PLAYER_INPUT_GRID_INDEX.type, player_input_list[| i]];
		_player = player_input_grid[# PLAYER_INPUT_GRID_INDEX.player, player_input_list[| i]];
		
		_func(_type,_player);
		}
	}

#endregion
#region window frame create

enum WINDOWFRAME_TYPE
	{
	sprite,
	live
	}
//frame_type = WINDOWFRAME_TYPE.sprite;
frame_type = WINDOWFRAME_TYPE.live;
frame_x = 0;
frame_y = 0;
frame_border = 20;

#region live version vars
//spaz / chanze t spaz out randomly, increases with score_t
frame_hand_spazchance_min = 0.001;
frame_hand_spazchance_max = 0.2;
frame_hand_spazchance = 0;
frame_hand_spaztime_min = 3;
frame_hand_spaztime_max = 5;
frame_hand_spaztime = 0;
frame_hand_spazrange_min = 7;
frame_hand_spazrange_max = 15;
frame_hand_spazrange = 0;
//reach /reacing out of the mouse
frame_hand_reach_rfar = 70;
frame_hand_reach_rclose = 20;//rage at wich the effect is maxxed
frame_hand_reach_dist = 20;

#endregion

var _num = 90;
var _num_w = (global.Width / (global.Width+global.Height)) * _num/2;
var _num_h = (global.Height / (global.Width+global.Height)) * _num/2;
var _border = 0;//distance to room edge
var _type = 0;
var _x1 = -_border;
var _y1 = -_border;
var _x2 = global.Width + _border;
var _y2 = global.Height + _border;

#region specific stuff
switch(frame_type)
	{
	#region sprite specific
	case WINDOWFRAME_TYPE.sprite:
		var _surf = surface_create(global.Width + frame_border*2,global.Height + frame_border*2);
		
		surface_set_target(_surf);
	break;
	#endregion
	#region live specific
	case WINDOWFRAME_TYPE.live:
		
		frame_list = ds_list_create();
		
		con_frame_hand = function(_type, _x, _y, _rot) constructor
			{
			
			o_type = _type;	// original type
			type = _type;	// type
			o_x = _x;		// original x
			x = _x;			// x
			o_y = _y;		// original y
			y = _y;			// y
			o_rot = _rot;	// original rotation
			rot = _rot;		// rotation
			var _dist = sprite_get_width(spr_hand) + 5;
			x2 = x + lengthdir_x(_dist,o_rot+180);	// get end arm position
			y2 = y + lengthdir_y(_dist,o_rot+180);	// get end arm position
			spaz_time = 0;	// time left to spaz
			static mouse_dist = sprite_get_width(spr_hand)+5;
			static safe_dist = sprite_get_height(spr_hand)/2;
			
			static func_step = function()
				{
				#region mouse interaction
				
				var _dist = point_distance(o_x,o_y,mouse_x,mouse_y);
				var _rfar =	obj_game.frame_hand_reach_rfar;
				
				if _dist <= _rfar
					{
					//set type
					//type = HAND_TYPE.open;
					
					var _dir = point_direction(o_x,o_y,mouse_x,mouse_y);
				
					var _rclose =	obj_game.frame_hand_reach_rclose;//rage at wich the effect is maxxed
					var _rdist =	obj_game.frame_hand_reach_dist;
				
					var _t = clamp(Func_t_invert((_dist-_rclose) / (_rfar-_rclose)),0,1);
					var _movedist = min(_rdist*_t,_dist-mouse_dist);
					
					x = o_x + lengthdir_x(_movedist,_dir);// x
					y = o_y + lengthdir_y(_movedist,_dir);// y
					
					//rot = o_rot - angle_difference(o_rot,_dir) * max(clamp(_movedist/nearest,0,1), _t);//angle difference * distance moved towards screen
					rot = o_rot - angle_difference(o_rot,_dir) * _t;//angle difference * distance moved towards screen
					}
				else
					{
					type = o_type;
					x = o_x;// x
					y = o_y;// y
					rot = o_rot;
					}
				
				#endregion
				#region spaz
				if spaz_time<=0
					{
					if Func_chance1(obj_game.frame_hand_spazchance)
						{
						spaz_time = obj_game.frame_hand_spaztime;
						func_spaz();
						}
					}
				else
					func_spaz();
				#endregion
				}
			static func_draw = function()
				{
				if !point_in_rectangle(x,y,-safe_dist,-safe_dist,global.Width+safe_dist,global.Height+safe_dist) //end of sprite shouldnt be on screen
					Func_draw_hand(type, x, y, rot, 1, false);
				else
					//Func_draw_hand(type, x, y, rot, 0.5, false);
					//Func_draw_hand_stretch(type, x2, y2, x, y, .5, false);
					Func_draw_hand_arm(type, x2, y2, x, y, rot, 1, false);
				}
			
			static func_spaz = function()//calcs spazim range
				{
				spaz_time--;
				func_spaz_move(obj_game.frame_hand_spazrange);
				}
			static func_spaz_move = function(_range)//calcs spazim range
				{
				rot += random_range(-_range,_range);
				}
			}
		
	break;
	#endregion
	}
#endregion

var _func_frame_hand_place = function(_type,_t,_x,_y,_irot)
	{
	var _irot_even = _irot==0 or _irot==2;
	var _angle_random = 7;
	var _angle_max = 45;
	var _curve_size_max = 17;//
	var _axis_primeary_rand = 2;	//primary axis random offset
	var _axis_secondary_rand = 3;	//secondary axis random offset
			
	var _p1x = global.Game_point_x;
	var _p1y = global.Game_point_y;
	var _rot;
	#region add random
			
	if _irot_even
		{//prime y
		_x += random_range(-_axis_secondary_rand,_axis_secondary_rand);
		_y += random_range(-_axis_primeary_rand,_axis_primeary_rand);
		}
	else
		{//prime x
		_x += random_range(-_axis_primeary_rand,_axis_primeary_rand);
		_y += random_range(-_axis_secondary_rand,_axis_secondary_rand);
		}
	#endregion
	#region curve
	//*
	//add curve
	if _irot_even
		_x += animcurve_channel_evaluate(animcurve_get_channel(ac_frame_hands, "position_arc"),_t) * _curve_size_max * (_irot==0 ? -1 : 1);
	else
		_y += animcurve_channel_evaluate(animcurve_get_channel(ac_frame_hands, "position_arc"),_t) * _curve_size_max * (_irot==3 ? -1 : 1);
	//*/
	#endregion
	#region rotation
	_rot = _irot * 90;
			
	_rot += Func_angle_approach(_rot,point_direction(_x,_y,_p1x,_p1y),_angle_max) + random_range(-_angle_random,_angle_random);
			
	#endregion
	
	switch(frame_type)
		{
		case WINDOWFRAME_TYPE.sprite:
			draw_sprite_ext(spr_hand,_type,_x + frame_border,_y + frame_border,1,1,_rot,-1,1);
		break;
		case WINDOWFRAME_TYPE.live:
			ds_list_add(frame_list, new con_frame_hand(_type, _x, _y, _rot));
		break;
		}
	
	return _type + 1;
	}

//doing
#region place loops
var _xl,_yl,_t;

//skip 0 for no duplicate hand drawing
//top left to right
for (var i=1;i<_num_w;i++)
	{
	_t = i/(_num_w-1);
	_xl = lerp(_x1,_x2,_t);
	
	_type = _func_frame_hand_place(_type,_t,_xl,_y1,3);
	}

//right up to down
for (var i=1;i<_num_h;i++)
	{
	_t = i/(_num_h-1);
	_yl = lerp(_y1,_y2,_t);
	
	_type = _func_frame_hand_place(_type,_t,_x2,_yl,2);
	}

//bottom right to left
for (var i=1;i<_num_w;i++)
	{
	_t = i/(_num_w-1);
	_xl = lerp(_x2,_x1,_t);
	
	_type = _func_frame_hand_place(_type,_t,_xl,_y2,1);
	}

//right up to down
for (var i=1;i<_num_h;i++)
	{
	_t = i/(_num_h-1);
	_yl = lerp(_y2,_y1,_t);
	
	_type = _func_frame_hand_place(_type,_t,_x1,_yl,0);
	}
#endregion

#region end
switch(frame_type)
	{
	case WINDOWFRAME_TYPE.sprite:
		surface_reset_target();
		frame_sprite = sprite_create_from_surface(_surf,0,0,surface_get_width(_surf),surface_get_height(_surf),false,false,0,0);
		surface_free(_surf);
	break;
	case WINDOWFRAME_TYPE.live:
		delete con_frame_hand;
	break;
	}
#endregion

func_frame_move = function(_x,_y)
	{
	switch(frame_type)
		{
		case WINDOWFRAME_TYPE.sprite:
			frame_x = _x;
			frame_y = _y;
		break;
		case WINDOWFRAME_TYPE.live:
			
			var _size = ds_list_size(frame_list);
			for(var i=0;i<_size;i++)
				{
				with(frame_list[| i])
					{
					x+=_x;
					x+=_x;
					}
				}
			
		break;
		}
	}

func_frame_step = function()
	{
	
	switch(frame_type)
		{
		case WINDOWFRAME_TYPE.sprite:
			
		break;
		case WINDOWFRAME_TYPE.live:
			
			var _size = ds_list_size(frame_list);
			for(var i=0;i<_size;i++)
				{
				frame_list[| i].func_step();
				}
		break;
		}
	}
func_frame_draw = function()
	{
	
	switch(frame_type)
		{
		case WINDOWFRAME_TYPE.sprite:
			if sprite_exists(frame_sprite)
				draw_sprite(frame_sprite,0,frame_x - frame_border,frame_y - frame_border);
		break;
		case WINDOWFRAME_TYPE.live:
			
			var _size = ds_list_size(frame_list);
			for(var i=0;i<_size;i++)
				{
				frame_list[| i].func_draw();
				}
		break;
		}
	}

#endregion
#region background create

/*
var _surf = surface_create(room_width,room_height);
surface_set_target(_surf);


//draw_sprite(spr_hand,0,global.Game_point_x - 50,global.Game_point_y);


///////end
surface_reset_target();//reset target
//create sprite
background_sprite = sprite_create_from_surface(_surf,0,0,surface_get_width(_surf),surface_get_height(_surf),false,false,0,0);
//free surface
surface_free(_surf);
//set sprite
var _back_id = layer_background_get_id(global.Layer_back);
layer_background_sprite(_back_id,background_sprite);
layer_background_visible(_back_id,true);
layer_background_blend(_back_id,c_white);
layer_x(global.Layer_back, 0);
layer_y(global.Layer_back, 0);
*/



#endregion
#region hand cascade


hand_casc_num =	10; //number of hands
hand_casc_dist =	10; //minimum distance from middle point
hand_casc_dist_vari_min =	5; //addative vrying distance from middle point
hand_casc_dist_vari_max =	15; //addative vrying distance from middle point
hand_casc_tcol =		.7;
hand_casc_battle_min = 0;
hand_casc_battle_max = 4;


#endregion
#region Background white

background_white = layer_get_id("Backgrounds_W");

//var _back = layer_background_get_id(background_white);
//layer_background_blend(_back,c_white);
//layer_background_sprite(_back, spr_pixel);
//layer_background_xscale(_back,room_width);
//layer_background_yscale(_back,room_height);

func_background_white_move = function(_x,_y)
	{
	layer_x(background_white,_x);
	layer_y(background_white,_y);
	}


#endregion
#region Background black

background_black = layer_get_id("Backgrounds_B");

func_background_black_move = function(_x,_y)
	{
	layer_x(background_black,_x);
	layer_y(background_black,_y);
	}


#endregion
#region camera

global.Cam_pos_x = 0;	//controlled camera position
global.Cam_pos_y = 0;
global.Cam_offx = 0;	//offset applied to camera | most screen effects
global.Cam_offy = 0;
global.Cam_disp_x = 0;	//displayed cam position | Cam_pos + Cam_offx
global.Cam_disp_y = 0;


#region shock // when score happens

cam_shock_active = false;

cam_shock_time = 3;
cam_shock_count = 0;
cam_shock_dist = 4;
cam_shock_ang = 0;
cam_shock_ang_rand = 45 / 2;

cam_shock_x = 0;
cam_shock_y = 0;

func_cam_shock_active = function()
	{
	cam_shock_active = true;
	
	cam_shock_ang = random(360);
	}
func_cam_shock_reset = function()
	{
	cam_shock_count = 0;
	cam_shock_active = false;
	
	cam_shock_x = 0;
	cam_shock_y = 0;
	}

#endregion
#region kick
cam_ckick_spd = 0;
cam_ckick_dir = 0;
cam_ckick_x = 0;
cam_ckick_y = 0;
cam_ckick_strg = 0.7;
//cam_ckick_dir_range = 20; //used: random_range(-cam_ckick_dir_range.cam_ckick_dir_range)
cam_ckick_fric = 0.9;
cam_ckick_rubber_dec = 0.99;
cam_ckick_limit_rubber = 3;
cam_ckick_limit_hard = 7;

//return
cam_ckick_return = false;
cam_ckick_return_time = 5;
cam_ckick_return_count = cam_ckick_return_time;
cam_ckick_return_dist = cam_ckick_return_time;


func_cam_kick = function(_ang)
	{
	cam_ckick_spd = cam_ckick_strg;
	cam_ckick_dir = _ang;// + random_range(-cam_ckick_dir_range,cam_ckick_dir_range);
	}

func_cam_kick_return = function()
	{
	cam_ckick_return = true;
	cam_ckick_return_dist = point_distance(0,0,cam_ckick_x,cam_ckick_y);
	}


#endregion
#region score win reaction

cam_score_rumble_val = .4;
cam_score_rumble_t = 0.4;

//cam_win_rumble_val = 2;
//cam_win_rumble_t = 1;

cam_rumble_x = 0;
cam_rumble_y = 0;

#endregion

func_cam_calc = function()
	{
	global.Cam_offx = cam_ckick_x + cam_rumble_x + cam_shock_x;
	global.Cam_offy = cam_ckick_y + cam_rumble_y + cam_shock_y;
	
	global.Cam_disp_x = global.Cam_pos_x + global.Cam_offx;
	global.Cam_disp_y = global.Cam_pos_y + global.Cam_offy;
	
	camera_set_view_pos(global.Cam,global.Cam_disp_x,global.Cam_disp_y);
	}

#endregion
#region sound

/*
sounds needed

menu:
select
back
exit
play

Music:
background ambiance

battle music
angle music
menu music
win chime
become god chime
*/

enum AUDIO_PRIO
	{
	music = 100,
	sfx_essential = 90,
	sfx_other = 0
	}


//////music
music_bga = 0;			// background ambiance


////////////sfx
/////menu


////game
//time
sfx_time_tick = snd_sfx_timer_tick;
sfx_time_time_over = snd_sfx_timer_over;
//hand logic
sfx_hand_extend = snd_sfx_placeholder;
sfx_hand_win = snd_sfx_placeholder;
sfx_hand_loose = snd_sfx_placeholder;
//score
sfx_score_positive = snd_sfx_placeholder;
sfx_score_negative = snd_sfx_placeholder;
sfx_score_rumble = snd_sfx_placeholder;
//health
sfx_health_hurt = snd_sfx_hurt1;
//win
sfx_win_positive = snd_sfx_placeholder;
sfx_win_negative = snd_sfx_placeholder;
sfx_win_hand_extend = snd_sfx_win_extend;



//emitter
sound_emit = audio_emitter_create();
audio_emitter_position(sound_emit, room_width, global.Game_point_y, 0);
sound_emit = audio_emitter_create();
audio_emitter_position(sound_emit, room_width, global.Game_point_y, 0);
sound_emit = audio_emitter_create();
audio_emitter_position(sound_emit, room_width, global.Game_point_y, 0);

//listener
var _list = 100;
audio_listener_position(global.Game_point_x, global.Game_point_y, -_list);


func_audio_play = function(_emit,_snd,_stop,_loop,_manprio)
	{
	//plays a sound, automatically sets priority
	/*
	_emit		= | id		| emitter id
	_snd		= | id		| sound id
	_stop		= | bool	| if there is a sound with same id playing, stop it to play the new one
	_loop		= | bool	| if the sound should loop
	_manprio	= | val		| manual priority set
	*/
	
	#region sound priority
	var _prio;
	
	if is_undefined(_manprio)
		_manprio = func_audio_get_prio(_snd);
	else
		_prio = _manprio;
	#endregion
	
	if _stop
	if audio_is_playing(_snd)
		audio_stop_sound(_snd);
	
	/*
	if _emit == -1
		audio_play_sound(_snd,_prio,_loop);
	else//use emitter
		{
		audio_play_sound_on(_emit,_snd,_loop,_prio);
		}
	*/
	show_debug_message("!!! Audio DISABLED !!! sound played: "+string(audio_get_name(_snd)));
	
	
	}

func_audio_get_prio = function(_snd)
	{
	var _val;
	switch(_snd)
		{
		case music_bga:
			_val = AUDIO_PRIO.music;
		break;
		//time
		case sfx_time_tick:
		case sfx_time_time_over:
		//hand
		case sfx_hand_win:
		case sfx_hand_loose:
		//score
		case sfx_score_positive:
		case sfx_score_negative:
		//health
		case sfx_health_hurt:
		//win
		case sfx_win_positive:
		case sfx_win_negative:
			_val = AUDIO_PRIO.sfx_essential;
		break;
		//hand
		case sfx_hand_extend:
		//score
		case sfx_score_rumble:
		//win
		case sfx_win_hand_extend:
			_val = AUDIO_PRIO.sfx_other;
		break;
		}
	return _val;
	}

func_sound_cleanup = function()
	{
	//audio_emitter_free(emitter);
	
	
	
	
	}

#endregion
#region debug

global.Debug = false;

function Func_Debug_Enable(_bool)
	{
	global.Debug = _bool;
	
	if _bool
		{
		
		
		}
	else
		{
		
		
		}
		
	//show_debug_overlay(_bool);
	show_debug_overlay(true);
	var _times = _bool ? 2 : 1;
	display_set_gui_size(global.Width * _times ,global.Height * _times);
	}

//Func_Debug_Enable(global.Debug);


#endregion




//do
func_menu_create();
func_window_name();


//instance_create_layer(0,0,"Menus",obj_tansition);