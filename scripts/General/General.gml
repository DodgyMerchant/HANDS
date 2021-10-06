


function Func_angle_approach(_source,_dest,_amount) //aproaches an angle by the amount or smaller
	{
	/*
	add to variable
	
	*/
	var _diff = angle_difference(_source, _dest );
	return -(min(abs(_diff),_amount) * sign(_diff));
	}