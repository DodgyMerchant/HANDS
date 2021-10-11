// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information



function func_debug_grid(_x, _y, _grid, _woh, _txt, _sep)
	{
	/// displays ds_grids. returns the y of the last line.
	/// x		the x coord to display at.
	/// y		start height of the list. is added upon and returnd so it can be used in other debug scripts.
	/// grid	the index of the grid
	/// woh		width or height | horizontal axis of the the displayed grid	width == true
	/// txt		the name of the list to identify it
	

	var _str,i,ii,ii1;
	//var _sep_w=string_length(" ");
	var _width = ds_grid_width(_grid);
	var _height= ds_grid_height(_grid)
	var _space = string_width(" ");
	var _halighn = draw_get_halign() == fa_right;
	
	if _woh
	for (i=0;i<_height;i++)//width horizontal
	    {
		_str="";
		
	    for (ii=0; ii<_width; ii++)
	        {
	        _str+=" "+string(_grid[# ii,i]);//add text to this row
			
			#region space
	        if _halighn or ii!=_height-1 //if alighned right OR not at the end of the row
				{
				ii1=ii+1;//so +1 doesnt need to be done multiple times
		        repeat(max(0,ii1*_sep - string_width(_str)) div _space)    //min distance to next entry
		            {
		            _str+=" ";
		            }
				}
			#endregion
	        }
	    _str=string_insert(_txt+" - "+string(i)+" - ",_str,0);  //adding the grid name in front
	    draw_text(_x,_y+i*string_height(_str),_str);
	    }
	else
	for (i=0;i<_width;i++)//height horizontal
	    {
		_str="";
		
	    for (ii=0; ii<_height; ii++)
	        {
	        _str+=" "+string(_grid[# i,ii]);//add text to this row
			
			#region space
	        if _halighn or ii!=_height-1 //if alighned right OR not at the end of the row
				{
				ii1=ii+1;//so +1 doesnt need to be done multiple times
		        repeat(max(0,ii1*_sep - string_width(_str)) div _space)    //min distance to next entry
		            {
		            _str+=" ";
		            }
				}
			#endregion
	        }
	    _str=string_insert(_txt+" - "+string(i)+" - ",_str,0);  //adding the grid name in front
	    draw_text(_x,_y+i*string_height(_str),_str);
	    }
	
	
	return _y+(i+1)*string_height(_str)
	}

function func_debug_txt(_x,_y,_txt)
	{
	/// displays lines of debug code. returns the y of the last line. 
	/// xx height of text
	/// yy height of text
	/// txt1 line of debug code.
	/// txt2... line of debug code.
	/*
	argument[0]	=	xx
	argument[1]	=	yy

	*/

	var _skip_to= 2;//number of arguments to skip // skips the xx,yy as displayable text

	for(var i=_skip_to;i<argument_count;i++)
	    {
	    var str=argument[i];
		draw_text(_x,_y,str);
		_y+=string_height(str);
	    }

	return _y


}

function func_debug_list(_x, _y, _list, _txt)
	{
	/// displays ds_lists. returns the y of the last line.
	/// x
	/// y start height of the list. is added upon and returnd so it can be used in other debug scripts.
	/// list the index of the list
	/// txt the name of the list to identify it
	
	

	var _str=_txt+" - "+string(_list);
	var _size = ds_list_size(_list);
	for (var i=0;i<_size;i++)
	    {
	    _str+="|"+string(_list[| i]);
	    }
	draw_text(_x,_y,_str);
	return _y + string_height(_str)




}