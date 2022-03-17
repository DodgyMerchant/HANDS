/// @desc 


#region find target

if tics == -1
	{
	//calc tics
	tics = point_distance(x,y,dest_x,dest_y) / spd;
	tics_count = 0;
	}

#endregion
#region moving

if tics_count < tics
	{
	tics_count++;
	}

if tics_count >= tics
	{
	if !eval //if not evaluated
		{
		obj_game.func_game_player_action_hand_eval(id,image_index,player);
		eval = true;
		}
	
	if end_self
		instance_destroy();
	}

var _t = min(tics_count/tics);
x = lerp(start_x,dest_x,_t);
y = lerp(start_y,dest_y,_t);

#endregion