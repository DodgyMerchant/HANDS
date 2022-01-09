


menu_vari_dist = lerp(menu_vari_dist_min, menu_vari_dist_max, global.Game_Score_t);



#region menu mouse interaction help
menu_selected = Func_menu_update_select();

if menu_selected != -1
	{
	menu_action = Func_menu_update_action();
	
	}
else
	{
	//menu_action = false; //if clicked/interacted
	}

#endregion