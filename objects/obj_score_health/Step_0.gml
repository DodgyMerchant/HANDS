/// @desc 


var _t;
if !end_self
	{
	_t = player_score / global.Rule_Health_max;
	
	var _xpos = lerp(x1,x2,_t);
	var _ypos = lerp(y1,y2,_t);
	
	var _dist = Func_value_approach(0,point_distance(x,y,_xpos,_ypos),5);
	var _dir = point_direction(x,y,_xpos,_ypos);
	
	x += lengthdir_x(_dist,_dir);
	y += lengthdir_y(_dist,_dir);
	}
else
	{
	_t = 1;
	var _dist = Func_value_approach(point_distance(x,y,xdisp,ydisp) ,0,5);
	var _dir = point_direction(xdisp,ydisp,x,y);
	
	x = xdisp + lengthdir_x(_dist,_dir);
	y = ydisp + lengthdir_y(_dist,_dir);
	
	if x == xdisp and y == ydisp 
		instance_destroy();
	}

//disp
#region set hand type depending on score
/* DOESNT  WORK WITH <=0 FOR POINT
switch(player_score)
	{
	case global.Rule_Health_max:
		type = HAND_TYPE.fist;
	break;
	case 0:
		type = HAND_TYPE.point;
	break;
	default:
		type = HAND_TYPE.fist;
	}
//*/
//*
if player_score == global.Rule_Health_max
	type = HAND_TYPE.fist;
else if player_score <= 0
	type = HAND_TYPE.point;
else
	type = HAND_TYPE.open;
//*/
#endregion
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