


function Func_angle_approach(_source,_dest,_amount) //aproaches an angle by the amount or smaller
	{
	/*
	add to variable
	
	*/
	var _diff = angle_difference(_source, _dest );
	return -(min(abs(_diff),_amount) * sign(_diff));
	}

function Func_value_approach(_source,_dest,_amount)
	{
	var _diff = _dest - _source;
	return _source + (min(abs(_diff), _amount) * sign(_diff));
	}

function Func_t_invert(_t)	//from 0-1 to 1-0
	{
	//return _t * -1 + 1; am I fucking stupid???
	return 1 - _t;
	}

function Func_t_span(_t)	//from 0-1 to -1 - 1
	{
	return _t * 2 - 1;
	}

function Func_t_reverse_span(_t)	//from -1 - 1  to  0-1
	{
	return (_t + 1) * .5;
	}

function Func_t_get_span(_t,_tbegin,_tend) //changes the progression of the t  not the output values  NO CLAMP
	{
	/*
	changes the progression
	f.e. 
	_tbegin	= 0.3;
	_tend	= 0.5;
	
	the whole progression of 0-1 would be happening in between the values 0.3 to 0.5
	
	_t = 0.2 => -0.5
	_t = 0.4 => 0.5
	_t = 0.5 => 1
	_t = 0.6 => 1.5
	
	NOT CLAMPED
	*/
	
	return (_t - _tbegin) / (_tend - _tbegin);
	}
function Func_t_get_span_clamp(_t,_tbegin,_tend) //same but clamped to 0,1
	{
	return clamp(Func_t_get_span(_t,_tbegin,_tend),0,1);
	}

//controller
function Func_input_gp_any(_controller) //returns number of nay controller input or -1
	{
	for (var i=gp_face1;i<gp_axisrv;i++)
		{
	    if gamepad_button_check(_controller, i)
			return i;
		}
	return -1;
	}
function Func_input_all_gp_any() //checks all gamepads eturns input or -1
	{
	var _val;
	var _size = ds_list_size(global.Input_gp_active_list);
	if _size > 0
		{
		for (var i=0;i<_size;i++)
			_val = Func_input_gp_any(global.Input_gp_active_list[| i]);
			if _val != -1
				return _val;
		}
	else
		return -1;
	}

//chance
function Func_chance1(_chance)
	{
	return random(1) < _chance;
	}

function Func_chance100(_chance)
	{
	return random(100) < _chance;
	}