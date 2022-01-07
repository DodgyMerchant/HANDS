
function Func_poly_draw(_array) {
	
	var sz = array_length(_array);

	for (var i=0; i<sz; i+=2)
	{
	    var x1 = _array[i];
	    var y1 = _array[i+1];
	    if i < sz - 2
	    {
	        var x2 = _array[i+2];
	        var y2 = _array[i+3];
	    }
	    else
	    {
	        var x2 = _array[0];
	        var y2 = _array[1];
	    }
    
	    draw_line(x1, y1, x2, y2);
	}
}

function Func_poly_point_in_poly(point_x, point_y, poly_array) {
	
	// function returns: boolean
	
	var dots = array_length(poly_array);

	var result = 1;

	for (var i=0; i<dots; i+=2)
	{
	    var x1 = poly_array[i];
	    var y1 = poly_array[i+1];
	    if i < dots - 2
	    {
	        var x2 = poly_array[i+2];
	        var y2 = poly_array[i+3];
	    }
	    else
	    {
	        var x2 = poly_array[0];
	        var y2 = poly_array[1];
	    }
	    result *= Func_poly_point_on_line(x1, y1, x2, y2, point_x, point_y);
	};

	if result < 0 return true;

	return false;

}

function Func_poly_point_on_line(s_ax, s_ay, s_bx, s_by, s_mx, s_my) {
	
	// function returns: "0" - point on the line, "1" - no collision, "-1" - collision
	
	var ax = s_ax - s_mx;
	var ay = s_ay - s_my;
	var bx = s_bx - s_mx;
	var by = s_by - s_my;

	var s = sign(ax * by - ay * bx);    
	if (s == 0 && (ay == 0 || by == 0) && ax * bx <= 0)
	    return 0;  
	if ((ay < 0) ^ (by < 0))
	{
	    if (by < 0)
	        return s;
	    return -s;
	}      

	return 1;

}

function Func_poly_array_create_ext(val1,val2,infvaluesletsgooooo) {
	
	
	var sz = argument_count;

	var data = array_create(sz);

	for (var i=0; i<sz; i++)
	{
	    data[i] = argument[i];
	}

	return data;



}

function Func_poly_shift(poly_array, move_x, move_y) {
	
	var sz = array_length(poly_array);
	
	for (var i=0; i<sz; i+=2)
	{
	    poly_array[@ i]	+= move_x;
	    poly_array[@ i+1]+= move_y;
	}
	
	// print new values to the debug console
	// delete this line if you do not need it
	//show_debug_message(poly_array);

}


//self made version for UI stuff

function Func_polyUI_point_in_poly(point_x, point_y, _list)
	{
	// function returns: boolean
	
	var _coords = ds_list_size(_list);
	
	var result = 1;
	
	var _x1,_y1,_x2,_y2;
	for (var i= 0; i<_coords; i+=2)
		{
		_x1 = _list[| i];
		_y1 = _list[| i+1];
		if i < _coords - 2
			{
		    _x2 = _list[| i+2];
		    _y2 = _list[| i+3];
			}
		else
			{
		    _x2 = _list[| 0];
		    _y2 = _list[| 1];
			}
		result *= Func_poly_point_on_line(_x1,_y1,_x2,_y2, point_x, point_y);
		}
	
	if result < 0
		return true;
	
	return false;
	}


