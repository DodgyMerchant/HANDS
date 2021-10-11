/// @desc 


var _t;
if !end_self
	{
	_t = player_score / global.Rule_Health_max;
	x = lerp(xend_disp,xstart,_t);
	}
else
	{
	_t = 1;
	var _dist = x - xend;
	x -= min(abs(_dist),5) * sign(_dist);
	
	if x == xend
		instance_destroy();
	}

//disp
if player_score == global.Rule_Health_max
	type = HAND_TYPE.fist;
else
	type = HAND_TYPE.open;


#region shiver
/*
global.Game_Score_t
shiver_limit
shiver_val
shiver
*/
//	if	other player == winning		| if my player is loosing
 //if my player is loosing

shiver = lerp(0,shiver_val,Func_t_invert(_t));







#endregion