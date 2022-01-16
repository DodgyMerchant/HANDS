/// @desc 


//open = false;
//time = global.Game_speed * 1;


time_count = open * time;
pre_time_count = pre_time;
post_time_count = post_time;
time_t = 0;
time_tcheck = 0;

//display
speed_channel = animcurve_get_channel(ac_transition,"speed_close");
var _curve_channel = animcurve_get_channel(ac_transition,"eye_curve");

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();
gui_h2 = display_get_gui_height()/2;

hand_num = 5;//20;//number of hands

x_start = 0;
y_start = gui_h2;

#region path


hand_path1 = path_add();
#region path setup
path_set_kind(hand_path1, 1);
path_set_precision(hand_path1, 1); 
path_set_closed(hand_path1, false);

var _x,_y,_t;

var _num = 20 -1;//-1 to make it end on 100% completion
for(var i=0;i<=_num;i++)
	{
	_t = i/_num;
	_x = x_start + gui_w * _t;
	_y = y_start + -gui_h2 * animcurve_channel_evaluate(_curve_channel,_t);
	
	path_add_point(hand_path1,_x,_y,1);
	}
#endregion
hand_path2 = path_duplicate(hand_path1);
path_flip(hand_path2);
path_shift(hand_path2,0,gui_h2);


#endregion


func_end = function()
	{
	instance_destroy();
	}