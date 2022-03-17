/// @desc 
player = -1;
turn = true;
player_score = 1;
type = 0;
//shiver_limit = 0.5; //when the shivering begins | used with _t  so should be val 0 - 1
shiver_val = 2;
shiver = 0;
end_self = false;


x1 = 0;
y1 = 0;
x2 = 0;
y2 = 0;
xdisp = 0;
ydisp = 0;

func_score_health_update_player_score = function()
	{
	player_score = global.Game_Score[player];
	}

func_game_end = function()
	{
	end_self = true;
	
	}


