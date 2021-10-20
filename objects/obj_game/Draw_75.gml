/// @desc 


draw_set_valign(0);
draw_set_halign(0);
draw_set_font(fn_menu);
draw_set_alpha(0.7);

#region Alpha notice

var _str = "Alpha version, Game in unfinished state.";
var _x = 1;
var _y = 1;
var _w = string_width(_str);
var _h = string_height(_str);

draw_set_color(c_black);
draw_rectangle(_x -2,_y - 2,_x+_w +2,_y+_h +2,false);

draw_set_color(c_lime);
draw_text(_x,_y,_str);

#endregion