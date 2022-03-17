


#region UI system init

InfiniUI_system();


#endregion

#region input
enum MENU_CONTROL_TYPE
	{
	mouse,
	buttons
	}
global.Menu_control_type = MENU_CONTROL_TYPE.buttons;

func_menu_check_inputtype = function()
	{
	if mouse_check_button(mb_any) or mouse_moved
		global.Menu_control_type = MENU_CONTROL_TYPE.mouse;
	else if keyboard_check(vk_anykey) or Func_input_all_gp_any()!=-1
		global.Menu_control_type = MENU_CONTROL_TYPE.buttons;
	}

#region mouse input

mouse_xlast = mouse_x;
mouse_ylast = mouse_y;
mouse_moved = false;

func_mouse_check_moved = function()
	{
	mouse_moved = mouse_xlast != mouse_x or mouse_ylast != mouse_y;
	
	mouse_xlast = mouse_x;
	mouse_ylast = mouse_y;
	}

#endregion


#endregion



//mouse menu system
menu_selected = -1;
menu_action = false; //if clicked/interacted

func_menu_hasselected = function()
	{
	return menu_selected != -1;
	}

#region general selection and action

function Func_menu_update_select()
	{
	switch(global.Menu_control_type)
		{
		case MENU_CONTROL_TYPE.buttons:
			return Func_menu_update_button_select();
		case MENU_CONTROL_TYPE.mouse:
			return Func_menu_update_mouse_select();
		}
	}
function Func_menu_update_action()
	{
	switch(global.Menu_control_type)
		{
		case MENU_CONTROL_TYPE.buttons:
			return -1;
		case MENU_CONTROL_TYPE.mouse:
			return Func_menu_update_mouse_action();
		}
	}

#endregion
#region mouse selection and action

//selection
function Func_menu_update_mouse_select()
	{
	if func_menu_hasselected()//if something selected
		if menu_selected.group.enabled == true	//check if enabled
			if func_menu_check_element_mouse_select(menu_selected)
				return menu_selected;
	
	//if not selected or selection isnt accrate anymore
	return func_menu_find_mouse_select();
	}
func_menu_find_mouse_select = function()
	{
	var _group,i,ii,_list,_size,_struct_index;
	
	var _ag_size = ds_list_size(UI_group_list);
	for(i=0;i<_ag_size;i++)//go through all groups
		{
		_group = UI_group_list[| i];
		//check if active
		if _group.enabled
			{
			//go through all elements
			_list = _group.element_list;
			_size = ds_list_size(_list);
			for(ii=0;ii<_size;ii++)//go through all elements in group
				{
				_struct_index = _list[| ii];
				
				if func_menu_check_element_mouse_select(_struct_index)
					return _struct_index;
				}
			}
		}
	return -1;
	}
func_menu_check_element_mouse_select = function(_struct_index)
	{
	with(_struct_index)
		{
		if func_UIES_get_selectable()
			{
			return func_UIES_check_point(mouse_x,mouse_y);
			}
		else
			return false;
		}
	}

//action
function Func_menu_update_mouse_action()
	{
	//placeholder
	return mouse_check_button_pressed(mb_left)
	}

#endregion
#region button selection and action

//selection
function Func_menu_update_button_select()
	{
	//placeholder
	return -1;
	}

//action


#endregion