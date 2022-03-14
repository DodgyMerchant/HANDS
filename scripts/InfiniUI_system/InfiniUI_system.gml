

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




////////////////////////// NAMING CONVENTION //////////////////////////
Function name convention:

UI		= User Interface							| global UI function, mostly to setup a UI system and supply it with elements
UIE		= User Interface Element					| global function for a UI Element specifiacally		| atm all functions of this type are only usable by system
UIES	= User Interface Element Struct				| local function to UIE Structs

*P		= Personal									| any function that isnt part of the base UI system | My personal addition for specific usecases

////////////////////////// UI ELEMENT COMPOSITION //////////////////////////

known variables:
	index		= my id		| id
	menu		= instance id	| menu "parent" | object the menu is reated from
	group		= group_id		| the group the UI element is part of
	text		= string		| text given to the element. Can be displayed.
	step_func	= function		| event funtion used in respective event call
	draw_func	= function		| event funtion used in respective event call
	create_func	= function		| event funtion used in respective event call
	point_list	= ds_list		| list containing all points. set up in pairs. [| 0]=x1 [| 2]=y1
	selectable	= bool			| if element is selectaable
	
known functions:
	static func_UIES_doEvent			//executes event script					| arg: enum UI_ELEMENT_EVENT_TYPE	| return none
	static func_UIES_check_point		//checks if point is in element Polygon	| arg: 2 floar coords				| return bool
	static func_UIES_get_group_t		//returns the groups transition value										| return float, multiplier 0-1 | 0=fully deactivated | 1=fully active, extended
	static func_UIES_get_selectable		//returns if the element is selectable										| return bool
	static func_UIES_check_selected		//checks for menu player mouse or other position on element					| return bool
	static func_UIES_check_action		//checks for menu player interaction everywhere								| return bool
	static func_UIES_check_selaction	//checks for menu player position and interaction							| return bool

	
//other
toString()	//look into structs if this meeans nothing to you / change if needed


////////////////////////// UI GROUP COMPOSITION //////////////////////////

known variables:
	index			= my id			| id
	menu			= instance id	| menu "parent" | object the menu is reated from
	enabled			= bool			| if the group is visible and active
	progress		= val			| starting progress
	time			= val			| the time it takes to deactivate the group
	trans			= mult			| 0-1 of transition / startup time
	dis_step		= bool			| if the group will still run its x event when:		disabled but time not 0
	dis_draw		= bool			| if the group will still run its draw event when:	disabled but time not 0
	element_list	= ds_list		| ds_list of all elements in the group

///////////////////////////////////////////////////////////////////




--------------CUSTOMIZABILITY-----------------

Element and Group constructor can be inherited
I insist on not using any of the constructors, base or inherited, on their own. Use them throug the Func_UIE_create_struct_default & Func_UIG_create_struct_default functions
or make you custom Func_UI(E/G)P_create_struct_[...] function.

The provided group_create or element_add provide multiple basic wasys to create elements and groups but are NOT nesessary.

I recommend that you write your own create/add function for your Inherited constructor version of one of the base constructors.

If you want to add additional agruments to the constructors you need to make your own versions of the Func_UI(E/G)_create_struct_default functions.
for this:
	-use the custom inherited constructor
	-after you MUST use the Func_UIE_post_constructor function.	!!!This step is nessesary.!!!
	
	-Additionally expand the UI_ELEMENT_INDEX enum by one index/identifier you want to identify the new type of element by
	 whithout this the element wont be identifiable as of any type of element
	 can be found in InfiniUI_custom script




*/
#endregion
#region Init

InfiniUI_custom();

enum UI_ELEMENT_EVENT_TYPE
	{
	create,
	step,
	draw
	}

UI_group_list = ds_list_create();

#region Element Constructor
function Constructor_UI_element(_menu,_group,_text,_selectable,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list) constructor
	{
	/*
	NOT FOR USE IN CODE DIRECTLY
	Functios referencing this constructor performs necessary setup that this constructor cant provide
	
	Arguments:
		_menu				=	id of creating object, used to reference as a "motheer" object
		_group			=	description provided in create function
		_text			=	description provided in create function
		_selectable		=	description provided in create function
		_create_func	=	description provided in create function
		_step_func		=	description provided in create function
		_draw_func		=	description provided in create function
		_point_list		=	ds_list | a list containing all given points in pairs.
	
	--------------CUSTOMIZABILITY-----------------
	read manual on CUSTOMIZABILITY
	
	*/
	index = undefined; //my index | id
	element_index = undefined;
	menu = _menu;	//menu "parent" | object the menu is reated from
	group = _group;	//the group the UI element is part of
	text = _text;	//text the element displayes
	step_func =		(_step_func==-1 ?	-1 : method(undefined, _step_func));
	draw_func =		(_draw_func==-1 ?	-1 : method(undefined, _draw_func));
	create_func =	(_create_func==-1 ?	-1 : method(undefined, _create_func));
	point_list = _point_list;
	selectable = _selectable;//if element is selectaable
	
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
		return group.trans;
		}
	static func_UIES_get_selectable = function()//TEMP//returns if the element is selectable										| return bool
		{
		return selectable;
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
	
	static func_UIES_get_index = function()		//checks for menu player position and interaction							| return bool
		{
		return element_index;
		}
	
	//other
	static toString = function()
		{
		return "UIE: group: "+string(group)+"| text: "+string(text);
		}
	
	//end
	func_UIES_doEvent(UI_ELEMENT_EVENT_TYPE.create);
	}
function Func_UIE_create_struct_default(_constructor=Constructor_UI_element, _group, _text,_selectable, _create_func=-1, _step_func=-1, _draw_func=-1, _points_or_list, _num_or_index, _x1, _y1)
	{//											0						1		2		3				4				5				6				7				8		9	10
	#region INFO
	/*
	
	_points_or_list		| bool	| true -> list of points in following arguments / false -> list index in next argument
	_num_or_index		| val	| Number of points means: Number of point Pairs f.e. x1 & y1 -> 1 Point | x1,y1,x2,y2,x3,y3 -> 3 Points
	
	
	--------------CUSTOMIZABILITY-----------------
	read manual on CUSTOMIZABILITY
	
	*/
	#endregion
	#region convert points to point list
	var _point_list;
	switch(_points_or_list)
		{
		case true:
			//make point list
			_point_list = ds_list_create();
			var ii;
			for (var i=0;i<_num_or_index;i++)
				{
				ii = 9 + i * 2;
				ds_list_add(_point_list,argument[ii		]);
				ds_list_add(_point_list,argument[ii + 1	]);
				}
		break;
		case false:
			//is aalready a list
			_point_list = _num_or_index;
		break;
		}
	#endregion
	
	var _inst = new _constructor(id,_group,_text,_selectable,_create_func,_step_func,_draw_func,_point_list);
	
	//necessary post constructor work
	Func_UIE_post_constructor(_inst,UI_ELEMENT_INDEX.standart,_group);
	
	//return
	return _inst;
	}

function Func_UIE_post_constructor(_inst,_myindex,_group) //necessary post constructor work
	{
	
	//add to group list
	Func_UI_group_manual_addElement(_group,_inst);
	
	//set stuff only here can be done
	with(_inst)
		{
		index = _inst;
		element_index = _myindex;
		/* for some reason the struct has no ID or if an insatnce acts through the strucs the "id", if not set, will be the id of the operating object
		// this causes a bunch of identification problems
		// this is the only way to supply the instance with its own id
		*/
		}
	
	
	}

#endregion
#region Group Constructor
function Constructor_UI_group(_menu,_enabled,_progress,_time,_dis_step,_dis_draw) constructor
	{
	/*
	NOT FOR USE IN CODE DIRECTLY
	Function referencing this constructor performs necessary setup that this constructor cant provide
	
	Arguments:
		_menu		=	id of creating object, used to reference as a "mother" object
		_enabled	=	description provided in create function
		_progress	=	description provided in create function
		_time		=	description provided in create function
		_dis_step	=	description provided in create function
		_dis_draw	=	description provided in create function
	
	--------------CUSTOMIZABILITY-----------------
	read manual on CUSTOMIZABILITY
	
	*/
	
	index = undefined; //my index | id
	group_index = undefined;
	menu = _menu;
	
	enabled =	_enabled;			// bool		| if the group is visible and active
	progress =	_progress;			// val		| starting progress
	time =		_time;				// val		| the time it takes to deactivate the group
	trans =		_progress / _time;	// mult		| 0-1 of transition / startup time
	dis_step =	_dis_step;			// bool		| if the group will still run its x event when:		disabled but time not 0
	dis_draw =	_dis_draw;			// bool		| if the group will still run its draw event when:	disabled but time not 0
	element_list = ds_list_create();// ds_list	| ds_list of all elements in the group
	
	//functions
	static func_UIGS_get_index = function()		//checks for menu player position and interaction							| return bool
		{
		return group_index;
		}
	
	}
function Func_UIG_create_struct_default(_constructor=Constructor_UI_group,_enabled,_progress,_time,_dis_step,_dis_draw)
	{
	#region INFO
	
	/*
	
	--------------CUSTOMIZABILITY-----------------
	read manual on CUSTOMIZABILITY
	
	*/
	#endregion
	
	var _inst = new _constructor(id,_enabled,_progress,_time,_dis_step,_dis_draw);
	
	//necessary post constructor work
	Func_UIG_post_constructor(_inst,UI_GROUP_INDEX.standart);
	
	return _inst;
	}

function Func_UIG_post_constructor(_inst,_myindex) //necessary post constructor work
	{
	
	//non constructor setup
	with(_inst)
		{
		index = _inst;
		group_index = _myindex;
		/* for some reason the struct has no ID or if an insatnce acts through the strucs the "id", if not set, will be the id of the operating object
		// this causes a bunch of identification problems
		// this is the only way to supply the instance with its own id
		*/
		}
	
	ds_list_add(UI_group_list,_inst);
	}



#endregion
#endregion


#region functions
/////////usables///////////////
#region elements
//easy create
function Func_UI_add_element(_constructor=Constructor_UI_element,_group,_x1,_y1,_x2,_y2,_text,_selectable,_create_func=-1,_step_func=-1,_draw_func=-1)			//create element from rectanlge x,y coords
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
	return Func_UIE_create_struct_default(_constructor,_group,_text,_selectable,_create_func,_step_func,_draw_func,true,4,
	_x1,_y1,   //top	left
	_x2,_y1,   //top	right
	_x2,_y2,   //bottom	right
	_x1,_y2);  //bottom	left
	}
function Func_UI_add_element_ext(_constructor=Constructor_UI_element,_group,_x,_y,_w,_h,_r,_text,_selectable,_create_func=-1,_step_func=-1,_draw_func=-1)		//create element from extended position arguments
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
	
	return Func_UIE_create_struct_default(_constructor,_group,_text,_selectable,_create_func,_step_func,_draw_func,true,4,
	_x1,_y1,
	_x2,_y2,
	_x3,_y3,
	_x4,_y4);
	}
function Func_UI_add_element_poly(_constructor=Constructor_UI_element,_group,_text,_selectable,_create_func=-1,_step_func=-1,_draw_func=-1,coords)				//create element from supplied coordinate pairs
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
	for (var i=7;i<argument_count;i++)
		{
		ds_list_add(_list,argument[i]);
		}
	
	return Func_UIE_create_struct_default(_constructor,_group,_text,_selectable,_create_func,_step_func,_draw_func,false,_list);
	}
function Func_UI_add_element_polylist(_constructor=Constructor_UI_element,_group,_text,_selectable,_create_func=-1,_step_func=-1,_draw_func=-1,_point_list)	//create element from a ds_list of points | copies list
	{
	/*
	_constructor| constructor	| index of the custom contructor ro leave empty
	_group		| index			| the group the element belongs too
	_text		| string		| the text to display
	_create_func| function		| function that acts like an additional create event for the element	or -1 for no function
	_step_func	| function		| the function to call in the step event	or -1 for no function
	_draw_func	| function		| the function to call in the draw event	or -1 for no function
	
	_point_list | ds_list		| a list of points used for the element positions. Points must be in x & y pairs. F.e. [|0]=x1, [|2]=y1, [|3]=x2, [|4]=y2
								| creates an independant copy of the given point list. So delete the given point list afterward if there is no need ffor it anymore.
	*/
	
	//create list and copy
	var _list = ds_list_create();
	ds_list_copy(_list,_point_list);
	
	return Func_UIE_create_struct_default(_constructor,_group,_text,_selectable,_create_func,_step_func,_draw_func,false,_list);
	}
//delete
function Func_UI_delete_element(_element_id)
	{
	with(_element_id)
		{
		ds_list_destroy(point_list);
		}
	
	delete _element_id;
	}

//calling events
function Func_UI_callevent(_element_id,_event_index)
	{
	with(_element_id) func_UIES_doEvent(_event_index);
	}

function Func_UI_get_element_index(_element)
	{
	return _element.func_UIES_get_index();
	}
#endregion
#region groups

//easy create
function Func_UI_create_group(_constructor=Constructor_UI_group,_enabled,_progress,_time,_dis_step,_dis_draw)
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
	var _index = Func_UIG_create_struct_default(_constructor,_enabled,_progress,_time,_dis_step,_dis_draw);
	
	return _index;
	}

//delete
function Func_UI_delete_group(_struct_id, _clean_elements)//deletes and cleans the group struct
	{
	with(_struct_id)
		{
		
		//clean elements?
		if _clean_elements
			{
			var _size = ds_list_size(element_list)
			for(var i=0; i<_size;i++)
				{
				//delete element
				Func_UI_delete_element( element_list[| i]);
				}
			}
		
		ds_list_destroy(element_list);
		}
	
	delete _struct_id;
	}

//enabling/disabling
function Func_UI_group_enable(_id,_bool)
	{
	/*
	_id		id of the group to be changed
	_bool	to be enabled (true) or disabled (false)
	*/
	_id.enabled = _bool;
	}
function Func_UI_group_is_anabled(_id)
	{
	/*
	_id	id of the group to be looked at
	*/
	return _id.enabled;
	}
function Func_UI_group_switch(_id)
	{
	/*
	_id	id of the group to be looked at
	*/
	Func_UI_group_enable(_id, !Func_UI_group_is_anabled(_id));
	}

//calling events
function Func_UI_groupcallevent(_group_id,_event_index)
	{
	//go through all elements in one group and call event given
	var _list = _group_id.element_list;
	var _size = ds_list_size(_list);
	for(var i=0; i<_size;i++)
		{
		Func_UI_callevent(_list[| i],_event_index);
		}
	}

function Func_UI_get_group_index(_group)
	{
	return _group.func_UIGS_get_index();
	}
function Func_UI_group_get_Elist(_id)
	{
	/*
	_id	id of the group to be looked at
	*/
	return _id.element_list;
	}
function Func_UI_group_manual_addElement(_group_id,_element) //adds list to group manuall | creating an element should add element automatically to given group
	{
	/*
	_group_id	id of the group to be looked at
	*/
	with(_group_id) ds_list_add(element_list, _element);
	}
#endregion



/////needs to be done every step event
function Func_UI_step(_master_x,_master_y)
	{
	Func_UI_group_calc();
	
	var _group;
	var _size = ds_list_size(UI_group_list)
	for(var i=0; i<_size;i++)
		{
		_group = UI_group_list[| i];
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
		if _group.enabled or (_group.dis_step and (_group.progress > 0))
			{
			Func_UI_groupcallevent(_group,UI_ELEMENT_EVENT_TYPE.step);
			}
		}
	}

//////needs to be done every draw event
function Func_UI_draw(_master_x,_master_y)
	{
	var _group;
	var _size = ds_list_size(UI_group_list)
	for(var i=0; i<_size;i++)
		{
		_group = UI_group_list[| i];
		//if group should be active
		if _group.enabled or (_group.dis_draw and (_group.progress > 0))
			{
			Func_UI_groupcallevent(_group,UI_ELEMENT_EVENT_TYPE.draw);
			}
		}
	}

/////clean up///////

//put into cleanup event
function Func_UI_deinitialize() //destroys all vcreated data structures but not the base systems / resets to default
	{
	Func_UI_cleanup();
	Func_UI_cleanbase();
	}

function Func_UI_cleanup() //destroys all vcreated data structures but not the base systems / resets to default
	{
	var _size = ds_list_size(UI_group_list)
	for(var i=0; i<_size;i++)
		{
		Func_UI_delete_group(UI_group_list[| i], true);//cleans group and all elements
		}
	
	//clean list
	ds_list_clear(UI_group_list);
	}
function Func_UI_cleanbase() //destroys all vcreated data structures but not the base systems / resets to default
	{
	ds_list_destroy(UI_group_list);
	}

#endregion
#region ///////////////NOT usables////////////////

function Func_UI_group_calc()
	{
	var _size = ds_list_size(UI_group_list)
	for (var i=0;i<_size;i++)
	with(UI_group_list[| i])
		{
		progress = clamp(progress + Func_t_span(enabled),0,time);
		trans		= progress / time;
		}
	}


#endregion