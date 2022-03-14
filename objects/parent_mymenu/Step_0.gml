/// @desc 

// Inherit the parent event
event_inherited();



#region UI group orient


if func_menu_hasselected()
	{
	var _group = menu_selected.group;
	
	if Func_UI_group_is_anabled(_group)
		{
		if Func_UI_get_group_index(_group) == UI_GROUP_INDEX.orientate
			{
			
			var _val = _group.func_UIGSPO_orientate(menu_selected,ori_speed);
			
			if _val != 0
				{
				Func_set_mouse(menu_selected.mid_x,menu_selected.mid_y);
				
				}				
			}
		}
	}



#endregion