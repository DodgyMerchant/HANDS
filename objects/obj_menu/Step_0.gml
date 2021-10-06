/// @desc 


if keyboard_check_pressed(vk_space)
	obj_game.func_game_setup();

if keyboard_check_pressed(vk_escape)
	{
	if game_on
		func_game_end();
	else
		game_end();
	}


//func_input_check