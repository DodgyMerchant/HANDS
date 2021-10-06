/// @desc 

image_speed = 0;


player = -1;
spd = 0;
dir = point_direction(x,y,global.Game_point_x, global.Game_point_y);
dest_x = global.Game_point_x - lengthdir_x(global.Circle_hand_offset,dir);
dest_y = global.Game_point_y - lengthdir_y(global.Circle_hand_offset,dir);
tics = -1;
tics_count = 0;
eval = false;
dim = false;
end_self = false;
start_x = xstart;
start_y = ystart;


func_hand_dim = function()
	{
	dim = true;
	}

func_end = function()
	{
	spd = 20;
	dest_x = xstart;
	dest_y = ystart;
	tics = -1;
	end_self = true;
	start_x = x;
	start_y = y;
	}