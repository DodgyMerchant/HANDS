

#region info
/*
//////////////////////////////MANUAL / EXPLAINATION //////////////////////////////

This UI system uses what it calls "Elements" for everything that is in someway UI, f.e. Button, Text Boxes, Boxes, Menus.
Elements can have a step and draw function they are executed in the respective functions.
Elements are grouped into Groups, which can be activated/deactivated.
Elements CANNOT exist outside a group, they will practically not exist.


The InfiniUI_parent has a UI system setup in its create event + some setup for a system that helps tracking mouse interaction with the system.

The Element create functions are run at the end of the default UI Element constructor.



///////////////// Lerning The Setup: ///////////////////////

In this basic learning experience we will:
	- Initialize the UI System inside your Menu obj.
	- Create a group.
	- Create a Element inside the group and give it a step and draw function.
	
1.	Initializing UI system:
	-	Have your UI Object inherit/set as a child as InfiniUI_parent.
		This parent object has all the setup done in its create event.
		
2.	Creating content fo the UI element:
	-	Create 2 functions. One fo the UI Elements Step event and one for the Draw event.
		They can be empty at the moment.

3.	Creating a Group:
	-	Create a groups with the Func_UI_create_group function and store returned value.
		The returned value is the Group ID used to identify that group.

4.	Createing the Element
	-	Create a Element with the Func_UI_add_element function or any other *add_element* function.
		Use the previously created Groups Group ID in the function.
		Supply the previously created step and draw functions as arguments.



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Technical: Elements-
	Elements are structs that are created via a constructor that can be modefied/replaced/inherited.
	Elements position is handled via a point list that can be any number of points.
	The func_UIES_check_point function integrated in the base Element constructor checks if a point falls into the UI Element polygon.
	
	There are a number of default functions given to the Default UI Element Constructor (Constructor_UI_element):
		func_UIES_doEvent			//executes event script					| arg: enum UI_ELEMENT_EVENT_TYPE	| return none
		func_UIES_check_point		//checks if point is in element Polygon	| arg: 2 floar coords				| return bool
		func_UIES_get_group_t		//returns the groups transition value										| return float, multiplier 0-1 | 0=fully deactivated | 1=fully active, extended
		func_UIES_check_selected	//checks for menu player mouse or other position on element					| return bool
		func_UIES_check_action		//checks for menu player interaction everywhere								| return bool
		func_UIES_check_selaction	//checks for menu player position and interaction							| return bool
	
	
Technical: Groups-
	Groups are entries in the UI_group_grid.
	Groups contain a list that contains the struct IDs of every Element given to that Group.
	All to be executed Groups step or draw Element functions executed via the Func_UI_step and Func_UI_draw functions.
	A group can be in active but still execute their functions.
	This happens if the groups attribute to run the function  if inactive but the transition time is not 0  is true.
		UI_group_grid[# UI_GROUP_INDEX.dis_step	,_index]		//consult the create Group function for more information
		UI_group_grid[# UI_GROUP_INDEX.dis_draw	,_index]
	This is so that f.e. menu elements that can be extended or opened dont just dissaapear instantly if deactivated.
	
	Look into the Func_UI_create_group function and the UI_GROUP_INDEX enum for insights into the grid.


Technical: Event Functions-
	Event Functions have no arguments passed into them.
	But as they are run in a struct they can access all variables and functions inside the Element/Struct.









Variables that exist in initialized UI systems:

UI_group_grid		= Grid that contains every UI Group



Function name convention:

UI		= User Interface							| global UI function, mostly to setup a UI system and supply it with elements
UIE		= User Interface Element					| global function for a UI Element specifiacally		| atm all functions of this type are only usable by system
UIES	= User Interface Element Struct				| local function to UIE Structs

*P		= Personal									| any function that isnt part of the base UI system | My personal addition for specific usecases

///////////////////////////////////////////////////////////////////

concerning _create_func _draw_func _step_func:
each function will be called in its respective event and known variables can be used.
these variables are:
	
point_list			: ds_list, index	| list of points given/calculated
text				: string			| the string set on creation of the element
step_func			: function			| function given
draw_func			: function			| function given

group				: val, index		| the index of the group in the UI_Grid the element is part of
group_enabled		: bool				| in group is enabled
group_t				: val, multiplier	| transition of the group bwtween enabled and disabled

returns index of the UI element struct
///////////////////////////////////////////////////////////////////

*/
#endregion
#region init

enum UI_ELEMENT_EVENT_TYPE
	{
	create,
	step,
	draw
	}

enum UI_GROUP_INDEX
	{
	enabled,
	progress,
	time,
	trans,
	dis_step,		//if the group will still run its step event when disabled but transitiontime not 0		//f.e. display while UI dropdown menu is closing
	dis_draw,		//if the group will still run its draw event when disabled but transitiontime not 0
	element_list,	//list of all elements contained in the group
	enum_height//this enums height
	}
UI_group_grid = ds_grid_create(UI_GROUP_INDEX.enum_height, 1);

//set empty
Func_DHP_grid_set_empty(UI_group_grid);

//constructor

function Constructor_UI_element(_menu,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list) constructor
	{
	menu = _menu;	//menu "parent" | object the menu is reated from
	group = _group;	//the group the UI element is part of
	text = _text;	//text the element displayes
	step_func =		(_step_func==-1 ?	-1 : method(undefined, _step_func));
	draw_func =		(_draw_func==-1 ?	-1 : method(undefined, _draw_func));
	create_func =	(_create_func==-1 ?	-1 : method(undefined, _create_func));
	//creates and fills list 
	point_list = _point_list;
	index = 0; //my index
	
	//functions
	static func_UIES_doEvent = function(_event_type)	//executes event script					| arg: enum UI_ELEMENT_EVENT_TYPE	| return none
		{
		func_UIES_get_group_t();
		
		switch(_event_type)
			{
			case UI_ELEMENT_EVENT_TYPE.create:	if create_func != -1	create_func();	break;
			case UI_ELEMENT_EVENT_TYPE.step:	if step_func != -1		step_func();	break;
			case UI_ELEMENT_EVENT_TYPE.draw:	if draw_func != -1		draw_func();	break;
			}
		}
	static func_UIES_check_point = function(_x,_y)	//checks if point is in element Polygon	| arg: 2 floar coords				| return bool
		{
		return Func_polyUI_point_in_poly(_x,_y,point_list);
		}
	static func_UIES_get_group_t = function()			//returns the groups transition value										| return float, multiplier 0-1 | 0=fully deactivated | 1=fully active, extended
		{
		return menu.UI_group_grid[# UI_GROUP_INDEX.trans, group];
		}
	static func_UIES_get_selectable = function()//TEMP//returns if the element is selectable										| return bool
		{
		return step_func != -1;
		}
	static func_UIES_check_selected = function()		//checks for menu player mouse or other position on element					| return bool
		{
		return menu.menu_selected==index;
		}
	static func_UIES_check_action = function()		//checks for menu player interaction everywhere								| return bool
		{
		return menu.menu_action;//==true
		}
	static func_UIES_check_selaction = function()		//checks for menu player position and interaction							| return bool
		{
		return func_UIES_check_action() and func_UIES_check_selected();
		}
	
	//end
	func_UIES_doEvent(UI_ELEMENT_EVENT_TYPE.create);
	}
function Func_UIE_create_struct(_constructor=-1,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,_points_or_List,_list_o_x1,_y1,_pointsInf)
	{
	/*
	NOT FOR USE IN CODE ONLY IN RESPECTIVE FUNTIONS
	
	
	_points_or_List		| bool	| true -> list of points in folliwing arguments / false -> list index in next argument
	
	*/
	
	#region convert points to point list
	var _point_list;
	switch(_points_or_List)
		{
		case true:
			//make point list
			_point_list = ds_list_create();
			var _num = argument_count;
			for (var i=7;i<_num;i++)
				{
				ds_list_add(_point_list,argument[i]);
				}
		break;
		case false:
			//is aalready a list
			_point_list = _list_o_x1;
		break;
		}
	#endregion
	
	//give base constructor
	if _constructor==-1
		_constructor = Constructor_UI_element;
	
	
	var _inst = new _constructor(id,_group,_text,_create_func,_step_func,_draw_func,_point_list);
	
	//add to group list
	ds_list_add(UI_group_grid[# UI_GROUP_INDEX.element_list, _group], _inst);
	
	//set stuff only here can be done
	with(_inst)
		{
		index = _inst;
		/* for some reason the struct has no ID or if an insatnce actrs through the strucs the "id", if not set, will be the id of the operating object
		// this causes a bunch of identification problems
		*/
		}
	
	//return
	return _inst;
	}

#endregion

/////////usables///////////////
//elements
function Func_UI_add_element(_constructor=-1,_group,_x1,_y1,_x2,_y2,_text,_create_func=-1,_step_func=-1,_draw_func=-1)
	{
	/*
	_constructor| constructor	| index of the custom contructor ro leave empty
	_group		| index			| the group the element belongs too
	_x1			| val			| the top left position of the button
	_y1			| val			| the top left position of the button
	_x2			| val			| the bottom right position of the button
	_y2			| val			| the bottom right position of the button
	_text		| string		| the text to display
	_draw_func	| function		| the function to call in the draw event	or -1 for no function
	_step_func	| function		| the function to call in the step event	or -1 for no function
	
	*/
	return Func_UIE_create_struct(_constructor,_group,_text,_create_func,_step_func,_draw_func,true,_x1,_y1,_x2,_y1, _x2,_y2,_x1,_y2);
	}
function Func_UI_add_element_ext(_constructor=-1,_group,_x,_y,_w,_h,_r,_text,_create_func=-1,_step_func=-1,_draw_func=-1)
	{
	/*
	_constructor| constructor	| index of the custom contructor ro leave empty
	_group		| index			| the group the element belongs too
	_x			| val			| center x coordiante
	_y			| val			| center y coordiante
	_w			| val			| width of the element
	_h			| val			| height of the element
	_r			| val			| rotation of the element
	_text		| string		| the text to display
	_draw_func	| function		| the function to call in the draw event	or -1 for no function
	_step_func	| function		| the function to call in the step event	or -1 for no function
	
	*/
	
	//calc some stuff
	
	var _dist = point_distance(_x,_y,_x+_w/2,_y+_h/2)
	var _dir;
	//top left
	_dir = point_direction(_x,_y,_x-_w/2,_y-_h/2) + _r;
	var _x1 = _x + lengthdir_x(_dist,_dir);
	var _y1 = _y + lengthdir_y(_dist,_dir);
	//top right
	_dir = point_direction(_x,_y,_x+_w/2,_y-_h/2) + _r;
	var _x2 = _x + lengthdir_x(_dist,_dir);
	var _y2 = _y + lengthdir_y(_dist,_dir);
	//bottom right
	_dir = point_direction(_x,_y,_x+_w/2,_y+_h/2) + _r;
	var _x3 = _x + lengthdir_x(_dist,_dir);
	var _y3 = _y + lengthdir_y(_dist,_dir);
	//bottom left
	_dir = point_direction(_x,_y,_x-_w/2,_y+_h/2) + _r;
	var _x4 = _x + lengthdir_x(_dist,_dir);
	var _y4 = _y + lengthdir_y(_dist,_dir);
	
	return Func_UIE_create_struct(_constructor,_group,_text,_create_func,_step_func,_draw_func,true,_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4);
	}
function Func_UI_add_element_poly(_constructor=-1,_group,_text,_create_func=-1,_step_func=-1,_draw_func=-1,coords)
	{
	/*
	_constructor| constructor	| index of the custom contructor ro leave empty
	_group		| index			| the group the element belongs too
	_text		| string		| the text to display
	_create_func| function		| function that acts like an additional create event for the element	or -1 for no function
	_step_func	| function		| the function to call in the step event	or -1 for no function
	_draw_func	| function		| the function to call in the draw event	or -1 for no function
	
	_x1			| val			| x coord of a point
	_y1			| val			| y coord of a point
	...
	infinite amount of points can be allocated, as long as they come in x&y pairs
	*/
	
	//convert points to list
	var _list = ds_list_create();
	for (var i=6;i<argument_count;i++)
		{
		ds_list_add(_list,argument[i]);
		}
	
	return Func_UIE_create_struct(_constructor,_group,_text,_create_func,_step_func,_draw_func,false,_list);
	}

function Func_UI_delete_element(_struct_index)
	{
	delete _struct_index;
	}

function Func_UI_callevent(_struct_index,_event_index)
	{
	_struct_index.func_UIES_doEvent(_event_index)
	}
function Func_UI_groupcallevent(_group_index,_event_index)
	{
	//go through all elements in one group and call event given
	var _list = UI_group_grid[# UI_GROUP_INDEX.element_list, _group_index];
	var _size = ds_list_size(_list)
	for(var i=0; i<_size;i++)
		{
		Func_UI_callevent(_list[| i],_event_index);
		}
	}

//groups
function Func_UI_create_group(_enabled,_progress,_time,_dis_step,_dis_draw)
	{
	/*
	_enabled		| bool		| if the group is visible and active
	_progress		| val		| starting progress
	_time			| val		| the time it takes to deactivate the group
	_dis_step		| bool		| if the group will still run its x event when:		disabled but time not 0
	_dis_draw		| bool		| if the group will still run its draw event when:	disabled but time not 0
	
	///////////////////////////////////////////////////////////////////
	
	RETURN
	returns index in UI_group_grid
	///////////////////////////////////////////////////////////////////
	
	*/
	var _index = Func_DHP_grid_expand_one(UI_group_grid,false);
	
	UI_group_grid[# UI_GROUP_INDEX.enabled	,_index] = _enabled;
	UI_group_grid[# UI_GROUP_INDEX.progress	,_index] = _progress;
	UI_group_grid[# UI_GROUP_INDEX.time		,_index] = _time;
	UI_group_grid[# UI_GROUP_INDEX.trans	,_index] = _progress / _time;
	UI_group_grid[# UI_GROUP_INDEX.dis_step	,_index] = _dis_step;
	UI_group_grid[# UI_GROUP_INDEX.dis_draw	,_index] = _dis_draw;
	UI_group_grid[# UI_GROUP_INDEX.element_list	,_index] = ds_list_create();
	
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
function Func_UI_group_is_anabled(_index)
	{
	/*
	_index	index of the group to be looked at
	*/
	return UI_group_grid[# UI_GROUP_INDEX.enabled	,_index];
	}
function Func_UI_group_switch(_index)
	{
	/*
	_index	index of the group to be looked at
	*/
	Func_UI_group_enable(_index, !Func_UI_group_is_anabled(_index));
	}

//needs to be done every step event
function Func_UI_step(_master_x,_master_y)
	{
	Func_UI_group_calc();
	
	var _height = ds_grid_height(UI_group_grid)
	for(var i=0; i<_height;i++)
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
		//if group should be active
		if UI_group_grid[# UI_GROUP_INDEX.enabled, i] or (UI_group_grid[# UI_GROUP_INDEX.dis_step, i] and (UI_group_grid[# UI_GROUP_INDEX.progress, i] > 0))
			{
			Func_UI_groupcallevent(i,UI_ELEMENT_EVENT_TYPE.step);
			}
	}

//needs to be done every draw event
function Func_UI_draw(_master_x,_master_y)
	{
	var _height = ds_grid_height(UI_group_grid)
	for(var i=0; i<_height;i++)
		//if group should be active
		if UI_group_grid[# UI_GROUP_INDEX.enabled, i] or (UI_group_grid[# UI_GROUP_INDEX.dis_draw, i] and (UI_group_grid[# UI_GROUP_INDEX.progress, i] > 0))
			{
			Func_UI_groupcallevent(i,UI_ELEMENT_EVENT_TYPE.draw);
			}
	}

//put into cleanup event
function Func_UI_cleanup()
	{
	var _height = ds_grid_height(UI_group_grid)
	for(var i=0; i<_height;i++)
		{
		var _list = UI_group_grid[# UI_GROUP_INDEX.element_list, i]
		var _size = ds_list_size(_list)
		for(var ii=0; ii<_size;ii++)
			{
			Func_UI_delete_element( _list[| ii]);
			}
		
		ds_list_destroy(_list);
		}
	
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


