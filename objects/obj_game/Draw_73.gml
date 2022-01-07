/// @desc 


#region pause dim

draw_sprite_ext(spr_pixel,0,0,0,room_width,room_height,0,c_black,pause_dim_a);


#endregion
#region countdown


if countdown_active
{
draw_set_font(fn_countdown1);
draw_set_color(c_fuchsia);
draw_set_valign(1);
draw_set_halign(0);
//var _str = string(countdown_time_count div global.Game_speed) +"."+ string_format(countdown_time_count mod global.Game_speed,,);
var _str = string_format(countdown_time_count / global.Game_speed, 1,2);
draw_text(global.Game_point_x-10,global.Game_point_y, _str);
}




#endregion


#region draw frame


func_frame_draw();
	

#endregion