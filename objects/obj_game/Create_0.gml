/// @desc 

/*
to do:
convert frame to working hands
make transition from it
background see of hands

create wins visual
create win win

Rules:
all self plays -points

*/


randomize();
show_debug_overlay(true);

global.Width = 300;
global.Height = 200;
room_width = global.Width;
room_height = global.Height;

display_set_gui_size(global.Width,global.Height);

enum HAND_TYPE
	{
	open = 0,
	point= 1,
	fist = 2
	}

global.Game_speed = game_get_speed(gamespeed_fps);
global.Cam = view_camera[0];
global.Layer_hand = layer_get_id("Hands");
global.Layer_back = layer_get_id("Back_hands");

global.Game_point_x = global.Width/2;
global.Game_point_y = global.Height/2;
global.LongestDistance = point_distance(0,0,global.Game_point_x,global.Game_point_y);
global.Circle_hand_offset = 20;

global.Player_num = 2;

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

func_menu_create = function()
	{
	instance_create_layer(0,0,layer,obj_menu);
	
	
	
	
	}

#region game rules

global.Game_Score_needed = 2;
global.Game_Wins_needed = 2;
global.Game_Wins_against = true; //if a win counts agains your oppnents win | one player need 2 wins and the player 0 to win

global.Rule_Timer = false;
global.Rule_Timer_Time = global.Game_speed * 5;

enum RULE_HAND_SELF
	{
	anarchy,	//can beat your own hand for points
	soft,		//can play onto your own hand
	spikey		//if oyu play onto your own hand you loos points
	}
global.Rule_Hand_self = RULE_HAND_SELF.spikey; //how hands react to self plays

enum SCORE_TYPE
	{
	st_points,
	st_health
	}
global.Rule_Score_type = SCORE_TYPE.st_points;
global.Rule_Health_max = 10;


#endregion
#region score and win

global.Game_Score = 0;//counts the players scores | if type points is a value	if type health is an array that hold the health
global.Game_Wins = 0; //counts the players wins | if rule win gainst is true then is a var   if rule agains is false   is a array

//disp
global.Game_Score_t	= 0;		//percentual value of score	/display helper
global.Game_Wins_t	= 0;		//percentual value of win		/display helper
global.Game_Score_t_sign = 0;	//value multiplier for who is winning
global.Game_Wins_t_sign	= 0;	//


//score display
//points
score_points_sep = 35;
score_points_inactive_y = room_height - 2;
score_points_active_y = room_height - 35;




func_score_setup = function()
	{
	switch(global.Rule_Score_type)
		{
		case SCORE_TYPE.st_health:
			
			global.Game_Score = array_create(global.Player_num,global.Rule_Health_max);
			
			#region create score hands
			for (var i=0;i<global.Player_num;i++)
				with(instance_create_layer(_x,score_points_inactive_y,layer,obj_score_health))
					{
					player = i;
					xend = i * room_width;
					}
			#endregion
			
		break;
		case SCORE_TYPE.st_points:
			
			global.Game_Score = 0;
			
			#region create score hands
			
			var _x;
			for (var i=-global.Game_Score_needed;i<=global.Game_Score_needed;i++)
				{
				_x = global.Game_point_x + i * score_points_sep;
				
				with(instance_create_layer(_x,score_points_inactive_y,layer,obj_score_points))
					{
					number = i;
					active_pos = other.score_points_active_y;
					inactive_pos = other.score_points_inactive_y;
					}
				}
			
			func_game_start();
			
			#endregion
		break;
		}
	}
func_score_reset = function()
	{
	switch(global.Rule_Score_type)
		{
		case SCORE_TYPE.st_health:
			for(var i=0;i<global.Player_num;i++)
				global.Game_Score[i] = global.Rule_Health_max;
		break;
		case SCORE_TYPE.st_points:
			global.Game_Score = 0;
		break;
		}
	}
func_score_cleanup = function()
	{
	global.Game_Score = 0;
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
	}
func_win_cleanup = function()
	{
	global.Game_Wins = 0;
	}
func_game_win = function(_player)
	{
	show_debug_message("Win! player: "+string(_player));
	var _check;
	if global.Game_Wins_against
		{
		if _player == 0
			global.Game_Wins--;
		else
			global.Game_Wins++;
		
		_check = abs(global.Game_Wins);
		}
	else
		{
		global.Game_Wins[_player]++;
		
		_check = global.Game_Wins[_player];
		}
	
	//check for win win
	if _check >= global.Game_Wins_needed
		{
		func_game_win_win(_player);
		}
	
	func_game_reset();
	}
func_game_win_win = function(_player)
	{
	show_debug_message("Win WIn!!! player: "+string(_player));
	/*
	
	global.Game_Wins_against
	
	*/
	
	
	func_game_end();
	}

#endregion
#region rule timer

timer_start = false;
timer_count = 0;
timer_ang_disp = 0;
//timer_ang_speed = max(360 / global.Rule_Timer_Time, 360/20);
timer_ang_speed = 5; // distance / x
timer_disp_length = 50;

global.Timer_t = 0; // a variable to react to

func_game_rule_timer_up = function()//when timer runs out
	{
	show_debug_message("Times Up");
	/*
	what happens when the timer runs out
	
	*/
	
	
	func_game_rule_timer_reset();
	}
func_game_rule_timer_reset = function()//var reset
	{
	timer_count = 0;
	
	
	}



func_timer_reset = function()//var reset
	{
	timer_count = 0;
	timer_ang_disp = 0;
	global.Timer_t = 0;
	}


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

#region game

game_on = false;
game_active = false; //if player can create hands

func_game_setup = function()//sets up the game
	{
	game_on = true;
	#region close menu
	//destroy menu
	with(obj_menu){instance_destroy();}
	#endregion
	
	func_score_setup();
	func_win_setup();//sets up win variable
	}
func_game_start = function()//start the game play mode
	{
	game_active = true;
	//timer
	if global.Rule_Timer
		{
		timer_start = true;
		
		}
	}
func_game_stop = function()//stops the game play mode
	{
	game_active = false;
	//timer
	if global.Rule_Timer
		timer_start = false;
	}
func_game_reset = function() //resets the vars to    //MUST BE PLAYABLE STATE
	{
	with(obj_hand) func_end();
	
	action_type = -1;
	action_inst = -1;
	//score and win
	func_win_reset();
	func_score_reset();
	
	//timer
	func_timer_reset();
	//hand surface
	func_handsurf_erase_begin();
	
	//for fun
	func_window_name();
	}
func_game_end = function() //end the game play mode return to menu
	{
	//reset vars
	func_game_reset();
	
	//other
	game_on = false;
	
	//with(obj_hand) func_game_end(); done in reset
	with(obj_score_points) func_game_end(); 
	
	//score and win cleanup
	func_score_cleanup();
	func_win_cleanup();
	
	
	func_menu_create();
	}

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

#region player action

action_type = -1; //the last type of action taken
action_inst = -1;

func_game_player_action = function(_type,_player)
	{
	switch(_type)
		{
		#region hand action
		case HAND_TYPE.open:
		case HAND_TYPE.point:
		case HAND_TYPE.fist:
		var _type_angle = 30;
		var _type_region = 20 / 2;
		var _dist = global.LongestDistance + 10;
		
		var _dir;
		if _player == 0//if player one
			{
			_dir = (180 - _type_angle) + (_type * _type_angle)	+ random_range(-_type_region,_type_region);
			}
		else
			{
			_dir = (0 + _type_angle) - (_type * _type_angle)	- random_range(-_type_region,_type_region);
			}
		
		var _x = global.Game_point_x + lengthdir_x(_dist,_dir);
		var _y = global.Game_point_y + lengthdir_y(_dist,_dir);
		
		with(func_hand_create(_type,_x,_y))
			{
			player = _player;
			}
		break;
		#endregion
		#region space action
		case -1:
		
		if global.Rule_Score_type =  SCORE_TYPE.st_points
			{
			//if the right player presses it
			//if (_player == 0 and global.Game_Score<0) or (_player == 1 and global.Game_Score>0) //space hat no player accociated atm :/
				//if the score is high enough
				if abs(global.Game_Score) >= global.Game_Score_needed
					{
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
	#region time
	//reset time
	if global.Rule_Timer
		func_game_rule_timer_reset();
	
	#endregion
	
	/*
	global.Rule_Hand_self
	RULE_HAND_SELF.anarchy
	RULE_HAND_SELF.soft
	RULE_HAND_SELF.spikey
	*/
	if action_type != -1//if there is a previous action
		{
		var _outcome;
		var _attacked_player = action_inst.player;
		
		#region self play
		if (_player == _attacked_player) //selfplay happens
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
			if (_player==0 and _outcome) or (_player==1 and !_outcome)
				global.Game_Score--;
			else if (_player==0 and !_outcome) or (_player==1 and _outcome)
				global.Game_Score++;
			}
		
		//dim old hand
		action_inst.func_hand_dim();
		}
	
	//set self to last hand played
	action_type = _type;
	action_inst = _id;
	}

func_type_logic = function(_attacker,_target)	//retuirns true if attacker wins /-1 for nothing
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

#endregion
#endregion
#region player input

player_input_list = ds_list_create(); //lists that holds all inputs that are done this frame
repeat (global.Player_num) ds_list_add(player_input_list,false);

enum INPUT_TYPE
	{
	space = -1,
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
//space
vk_space,	INPUT_TYPE.space,	-1
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
	var _type,_player
	var _size = ds_list_size(player_input_list);
	for (var i=0;i<_size;i++)
		{
		_type = player_input_grid[# PLAYER_INPUT_GRID_INDEX.type, player_input_list[| i]];
		_player = player_input_grid[# PLAYER_INPUT_GRID_INDEX.player, player_input_list[| i]];
		
		_func(_type,_player);
		}
	}

#endregion
#region frame create

frame_border = 20;
var _surf = surface_create(global.Width + frame_border*2,global.Height + frame_border*2);
var _num = 90;
var _num_w = (global.Width / (global.Width+global.Height)) * _num/2;
var _num_h = (global.Height / (global.Width+global.Height)) * _num/2;
var _border = 2;	//distance to room edge
var _type = 0;
var _x1 = -_border;
var _y1 = -_border;
var _x2 = global.Width + _border;
var _y2 = global.Height + _border;

var _func_draw_hand = function(_type,_t,_x,_y,_irot)
	{
	var _irot_even = _irot==0 or _irot==2;
	var _angle_random = 7;
	var _angle_max = 45;
	var _curve_size_max = 17;
	var _axis_primeary_rand = 2;	//primary axis random offset
	var _axis_secondary_rand = 5;	//secondary axis random offset
	
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
		_x += animcurve_channel_evaluate(animcurve_get_channel(ac_border, "Hand_arc"),_t) * _curve_size_max * (_irot==0 ? -1 : 1);
	else
		_y += animcurve_channel_evaluate(animcurve_get_channel(ac_border, "Hand_arc"),_t) * _curve_size_max * (_irot==3 ? -1 : 1);
	//*/
	#endregion
	#region rotation
	_rot = _irot * 90;
	
	_rot += Func_angle_approach(_rot,point_direction(_x,_y,_p1x,_p1y),_angle_max) + random_range(-_angle_random,_angle_random);
	
	#endregion
	draw_sprite_ext(spr_hand,_type,_x + frame_border,_y + frame_border,1,1,_rot,-1,1);
	return _type + 1;
	}

surface_set_target(_surf);
var _xl,_yl,_t;

#region draw loops
//skip 0 for no duplicate hand drawing
//top left to right
for (var i=1;i<_num_w;i++)
	{
	_t = i/(_num_w-1);
	_xl = lerp(_x1,_x2,_t);
	
	_type = _func_draw_hand(_type,_t,_xl,_y1,3);
	}

//right up to down
for (var i=1;i<_num_h;i++)
	{
	_t = i/(_num_h-1);
	_yl = lerp(_y1,_y2,_t);
	
	_type = _func_draw_hand(_type,_t,_x2,_yl,2);
	}

//bottom right to left
for (var i=1;i<_num_w;i++)
	{
	_t = i/(_num_w-1);
	_xl = lerp(_x2,_x1,_t);
	
	_type = _func_draw_hand(_type,_t,_xl,_y2,1);
	}

//right up to down
for (var i=1;i<_num_h;i++)
	{
	_t = i/(_num_h-1);
	_yl = lerp(_y2,_y1,_t);
	
	_type = _func_draw_hand(_type,_t,_x1,_yl,0);
	}
#endregion

//end
surface_reset_target();
frame_sprite = sprite_create_from_surface(_surf,0,0,surface_get_width(_surf),surface_get_height(_surf),false,false,0,0);
surface_free(_surf);

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
background_swing = false;

background_surf_w = global.Width*2;
background_surf_h = global.Height*2;
background_surface1 = surface_create(background_surf_w,background_surf_h);
background_surface2 = surface_create(background_surf_w,background_surf_h);
background_surface_display = 0;

backgound_time = global.Game_speed * 0.1;
backgound_time_count = 0;
backgound_update = true;
backgound_time_t = 0;

background_scale = .9;
background_alpha = .8;


background_circle_dist = 200;



#endregion
#region hand cascade

hand_casc_dist_min =	10;
hand_casc_dist =		5;

hand_casc_count1 = 0; //max game_speed
hand_casc_count2 = 0; //max game_speed
hand_casc_count3 = 0; //max game_speed
hand_casc_channel1 = animcurve_get_channel(ac_hand_cascade, 0); 
hand_casc_channel2 = animcurve_get_channel(ac_hand_cascade, 1);


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





//do
func_menu_create();
func_window_name();