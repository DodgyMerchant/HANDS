/// @desc 

if !end_self
	{
	//active = global.Game_Score == number;
	active = abs(global.Game_Score) >= abs(number) and sign(global.Game_Score) == sign(number);
	
	if active
		{
		y += (active_pos - y) / 5;
		}
	else
		{
		y += (inactive_pos - y) / 20;
		}
	}
else
	{
	y += (room_height+50 - y) / 20;
	
	if y == y_origin
		{
		instance_destroy();
		}
	}