/// @desc 
player = -1;
player_score = 1;
xend = 0;
xend_disp = 0;
type = 0;
shiver_limit = 0.5; //when the shivering begins | used with _t  so should be val 0 - 1
shiver_val = 2;
shiver = 0;
end_self = false;

func_score_health_update_player_score = function()
	{
	player_score = global.Game_Score[player];
	}

func_game_end = function()
	{
	end_self = true;
	
	}
//shiver = (val / global.Rule_Health_max );

