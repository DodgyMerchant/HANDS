


#region init
enum UI_ELEMENT_INDEX
	{
	group,
	x1,
	y1,
	x2,
	y2,
	text,
	draw_func,
	step_func,
	enum_height
	}
UI_element_grid = ds_grid_create(UI_ELEMENT_INDEX.enum_height, 1);

enum UI_GROUP_INDEX
	{
	enabled,
	progress,
	time,
	trans,
	dis_step,
	dis_draw,
	enum_height
	}
UI_group_grid = ds_grid_create(UI_GROUP_INDEX.enum_height, 1);

//set empty
Func_DHP_grid_set_empty(UI_element_grid);
Func_DHP_grid_set_empty(UI_group_grid);

#endregion

/////////usables///////////////
//elements
function Func_UI_add_element(_group,_x1,_y1,_x2,_y2,_text,_step_func,_draw_func)
	{
	/*
	_group		| index		| the group the element belongs too
	_x1			| val		| the top left position of the button
	_y1			| val		| the top left position of the button
	_x2			| val		| the bottom right position of the button
	_y2			| val		| the bottom right position of the button
	_text		| string	| the text to display
	_draw_func	| function	| the function to call in the draw event	or -1 for no function
	_step_func	| function	| the function to call in the step event	or -1 for no function
	
	///////////////////////////////////////////////////////////////////
	
	concerning _draw_func _step_func:
	each function will be called in its respective event and will be handed variables that can be used.
	these variables are:
	
	_x1 _y1 _x2 _y2		: val	| the 4 posititions set on creation of the element + the master position given to the Func_UI_step or Func_UI_draw
	_index				: val	| the index if the element in the UI_Grid
	_str				: string| the string set on creation of the element
	_g_enabled			: bool	| in group is enabled
	_gt					: val	| transition of the group bwtween enabled and disabled
	
	returns index in UI_element_grid
	///////////////////////////////////////////////////////////////////
	
	*/
	var _index = Func_DHP_grid_expand_one(UI_element_grid,false);
	
	UI_element_grid[# UI_ELEMENT_INDEX.group			, _index] = _group;
	UI_element_grid[# UI_ELEMENT_INDEX.x1				, _index] = _x1;
	UI_element_grid[# UI_ELEMENT_INDEX.y1				, _index] = _y1;
	UI_element_grid[# UI_ELEMENT_INDEX.x2				, _index] = _x2;
	UI_element_grid[# UI_ELEMENT_INDEX.y2				, _index] = _y2;
	UI_element_grid[# UI_ELEMENT_INDEX.text				, _index] = _text;
	UI_element_grid[# UI_ELEMENT_INDEX.step_func		, _index] = _step_func;
	UI_element_grid[# UI_ELEMENT_INDEX.draw_func		, _index] = _draw_func;
	
	return _index;
	}

function Func_UI_callfunc(_index,_func_index,_master_x,_master_y)
	{
	var _func = UI_element_grid[# _func_index, _index];
	
	if _func != -1
		{
		var _x1 =	UI_element_grid[# UI_ELEMENT_INDEX.x1,		_index] + _master_x;
		var _y1 =	UI_element_grid[# UI_ELEMENT_INDEX.y1,		_index] + _master_y;
		var _x2 =	UI_element_grid[# UI_ELEMENT_INDEX.x2,		_index] + _master_x;
		var _y2 =	UI_element_grid[# UI_ELEMENT_INDEX.y2,		_index] + _master_y;
		var _str =	UI_element_grid[# UI_ELEMENT_INDEX.text,	_index];
		
		var _group = UI_element_grid[# UI_ELEMENT_INDEX.group,		_index];
		var _g_enabled =	UI_group_grid[# UI_GROUP_INDEX.enabled,	_group];
		var _gt =			UI_group_grid[# UI_GROUP_INDEX.trans,	_group];
		
		_func(_x1,_y1,_x2,_y2,_index,_str,_g_enabled,_gt);
		}
	}

//groups
function Func_UI_create_group(_enabled,_progress,_time,_dis_step,_dis_draw)
	{
	/*
	_enabled		| bool		| if the group is visible and active
	_time			| val		| the time it takes to deactivate the group
	_dis_draw		| bool		| if the group will still run its draw event when:	disabled but time not 0
	_dis_step		| bool		| if the group will still run its x event when:		disabled but time not 0
	
	///////////////////////////////////////////////////////////////////
	
	RETURN
	returns index in UI_element_grid
	///////////////////////////////////////////////////////////////////
	
	*/
	var _index = Func_DHP_grid_expand_one(UI_group_grid,false);
	
	UI_group_grid[# UI_GROUP_INDEX.enabled	,_index] = _enabled;
	UI_group_grid[# UI_GROUP_INDEX.progress	,_index] = _progress;
	UI_group_grid[# UI_GROUP_INDEX.time		,_index] = _time;
	UI_group_grid[# UI_GROUP_INDEX.trans	,_index] = _progress / _time;
	UI_group_grid[# UI_GROUP_INDEX.dis_step	,_index] = _dis_step;
	UI_group_grid[# UI_GROUP_INDEX.dis_draw	,_index] = _dis_draw;
	
	return _index;
	}
function Func_UI_group_enable(_index,_bool)
	{
	/*
	_index	index of the group to be changed
	_bool	to be enabled (true) or disabled (false)
	*/
	UI_group_grid[# UI_GROUP_INDEX.enabled	,_index] = _bool;
	}

//needs to be done every step event
function Func_UI_step(_master_x,_master_y)
	{
	Func_UI_group_calc();
	
	var _height = ds_grid_height(UI_element_grid);
	for(var i=0;i<_height;i++)
		{
		var _group = UI_element_grid[# UI_ELEMENT_INDEX.group, i];
		if (UI_group_grid[# UI_GROUP_INDEX.progress, _group] > 0) and (UI_group_grid[# UI_GROUP_INDEX.enabled, _group] or UI_group_grid[# UI_GROUP_INDEX.dis_step, _group])
			Func_UI_callfunc(i,UI_ELEMENT_INDEX.step_func,_master_x,_master_y);
		
		#region info
		/*
		| enabled| display	| p > 0	 | wanted |
		|--------|----------|--------|--------|
		|	0    |	0		|	0	 |	0	  |
		|--------|----------|--------|--------|
		|	0    |	0		|	1	 |	0	  |
		|--------|----------|--------|--------|
		|	0    |	1		|	0	 |	0	  |
		|--------|----------|--------|--------|
		|	0    |	1		|	1	 |	1	  |
		|--------|----------|--------|--------|
		|	1    |	0		|	0	 |	1	  |
		|--------|----------|--------|--------|
		|	1    |	0		|	1	 |	1	  |
		|--------|----------|--------|--------|
		|	1    |	1		|	0	 |	1	  |
		|--------|----------|--------|--------|
		|	1    |	1		|	1	 |	1	  |
		|--------|----------|--------|--------|
		*/
		#endregion
		}
	}

//needs to be done every draw event
function Func_UI_draw(_master_x,_master_y)
	{
	var _height = ds_grid_height(UI_element_grid);
	for(var i=0;i<_height;i++)
		{
		var _group = UI_element_grid[# UI_ELEMENT_INDEX.group, i];
		if UI_group_grid[# UI_GROUP_INDEX.enabled, _group] or (UI_group_grid[# UI_GROUP_INDEX.dis_draw, _group] and (UI_group_grid[# UI_GROUP_INDEX.progress, _group] > 0))
			Func_UI_callfunc(i,UI_ELEMENT_INDEX.draw_func,_master_x,_master_y);
		}
	}

//put into cleanup event
function Func_UI_cleanup()
	{
	ds_grid_destroy(UI_element_grid);
	ds_grid_destroy(UI_group_grid);
	}

///////////////NOT usables////////////////
function Func_UI_group_calc()
	{
	var _height = ds_grid_height(UI_group_grid)
	for (var i=0;i<_height;i++)
		{
		var _enable = UI_group_grid[# UI_GROUP_INDEX.enabled	,i];
		var _time = UI_group_grid[# UI_GROUP_INDEX.time		,i];
		var _val = UI_group_grid[# UI_GROUP_INDEX.progress		,i];
		
		_val = clamp(_val + Func_t_span(_enable),0,_time);
		
		UI_group_grid[# UI_GROUP_INDEX.progress	,i] = _val;
		UI_group_grid[# UI_GROUP_INDEX.trans	,i] = _val / _time;
		}
	}