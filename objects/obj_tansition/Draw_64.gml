/// @desc 

//debugggggggggggggggggggg
draw_set_color(c_orange);

var _num = hand_num -1;
var _path,_x,_y,_x2,_y2,_t,_dist,_dir;
for(var i=0;i<=_num;i++)
	{
	_t = i/_num;
	_x2 = gui_w * _t;
	
	_x = path_get_x(hand_path1,_t);
	_y = path_get_y(hand_path1,_t);
	
	_dist = point_distance(_x2,gui_h2,_x,_y) * time_t;
	_dir = point_direction(_x2,gui_h2,_x,_y);
	
	draw_circle(_x2+lengthdir_x(_dist,_dir),gui_h2+lengthdir_y(_dist,_dir),9,true);
	_dir += 180;
	draw_circle(_x2+lengthdir_x(_dist,_dir),gui_h2+lengthdir_y(_dist,_dir),9,true);
	}


draw_path(hand_path1,0,0,true);
draw_path(hand_path2,0,0,true);
draw_text(mouse_x,mouse_y,string(time_count)+"/"+string(time))


//Func_draw_hand_stretch(HAND_TYPE.open);