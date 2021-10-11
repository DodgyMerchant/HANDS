


function Func_angle_approach(_source,_dest,_amount) //aproaches an angle by the amount or smaller
	{
	/*
	add to variable
	
	*/
	var _diff = angle_difference(_source, _dest );
	return -(min(abs(_diff),_amount) * sign(_diff));
	}

function Func_t_invert(_t)	//from 0-1 to 1-0
	{
	return _t * -1 + 1;
	}

function Func_t_span(_t)	//from 0-1 to -1 - 1
	{
	return _t * 2 - 1;
	}
function Func_t_reverse_span(_t)	//from -1 - 1  to  0-1
	{
	return (_t + 1) * .5;
	}