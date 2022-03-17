/// @desc 



if dim
	{
	surface_set_target(global.Hand_surface);
	}

//Func_draw_hand(sprite_index, x, y, dir, image_alpha);
Func_draw_hand_stretch(image_index, xstart, ystart, x, y, image_alpha, true);

if dim
	{
	surface_reset_target();
	instance_destroy();
	}