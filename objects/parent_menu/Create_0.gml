


#region UI system init

UI_system();


#endregion




//mouse menu system
menu_selected = -1;
menu_action = false; //if clicked/interacted


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
	if menu_selected != -1
		//check if enabled
		if UI_group_grid[# UI_GROUP_INDEX.enabled, menu_selected.group ] == true
		if func_menu_check_element_mouse_select(menu_selected)
			return menu_selected;
	
	//if not selected or selection isnt accrate anymore
	return func_menu_find_mouse_select();
	}
func_menu_find_mouse_select = function()
	{
	var i,ii,_list,_size,_struct_index;
	
	var _ag_height = ds_grid_height(UI_group_grid);
	for(i=0;i<_ag_height;i++)//go through all groups
		{
		//check if active
		if UI_group_grid[# UI_GROUP_INDEX.enabled, i]
			{
			//go through all elements
			_list = UI_group_grid[# UI_GROUP_INDEX.element_list, i];
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
		if step_func!=-1
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