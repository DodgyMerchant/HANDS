/// @desc 

// Inherit the parent event
event_inherited();



#region UI group orient

if func_menu_hasselected()
	{
	var _group = menu_selected.group;
	
	if Func_UI_group_is_anabled(_group)
		{
		
		//func_UIESP_
		//menu_selected.rot
		
		
		
		}
	}



#endregion
/*
if Func_UI_group_is_anabled(manu_group_main)
	{
	var _input = mouse_wheel_down() - mouse_wheel_up();
	if _input !=0
		{
		var _list = Func_UI_group_get_Elist(manu_group_main);
		
		var _size = ds_list_size(_list);
		for(var i=0;i<_size;i++)
			with (_list[| i])
				{
				
				func_UIESP_rotate_coorddata(_input,global.Game_point_x,global.Game_point_y);
				func_UIESP_pos_update_all();
				}
		
		
		}
	}
*/