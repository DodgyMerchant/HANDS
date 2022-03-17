

//menu input

func_mouse_check_moved();
func_menu_check_inputtype(); //global.Menu_control_type



#region menu mouse interaction help
menu_selected = Func_menu_update_select();

if func_menu_hasselected()
	{
	menu_action = Func_menu_update_action();
	}
else
	{
	//menu_action = false; //if clicked/interacted
	}

#endregion