


#region UI system init

UI_system();


#endregion


//general menu stuff
group_speed = global.Game_speed * 0.3;

//display variation
menu_vari_dist_min = 0.5;
menu_vari_dist_max = 3;
menu_vari_dist = 0;
menu_vari_precision_dist = 20;
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
		if UI_group_grid[# UI_GROUP_INDEX.enabled, UI_element_grid[# UI_ELEMENT_INDEX.group, menu_selected] ] == true
		if func_menu_check_element_mouse_select(menu_selected)
			return menu_selected;
	
	//if not selected or selection isnt accrate anymore
	return func_menu_find_mouse_select();
	}
func_menu_find_mouse_select = function()
	{
	var _ag_height = ds_grid_height(UI_group_grid);
	for(var i=0;i<_ag_height;i++)//go through all groups
		{
		//check if active
		if UI_group_grid[# UI_GROUP_INDEX.enabled, i]
			{
			//go through all elements
			var _list = UI_group_grid[# UI_GROUP_INDEX.element_list, i];
			var _size = ds_list_size(_list);
			for(var ii=0;ii<_size;ii++)//go through all elements in group
				{
				var _index = _list[| ii];
			
				if func_menu_check_element_mouse_select(_index)
					return _index;
				}
			}
		}
	return -1;
	}
func_menu_check_element_mouse_select = function(_index)
	{
	return point_in_rectangle(mouse_x,mouse_y,
	UI_element_grid[# UI_ELEMENT_INDEX.x1, _index],
	UI_element_grid[# UI_ELEMENT_INDEX.y1, _index],
	UI_element_grid[# UI_ELEMENT_INDEX.x2, _index],
	UI_element_grid[# UI_ELEMENT_INDEX.y2, _index]);
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