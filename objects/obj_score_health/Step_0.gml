/// @desc 
val = global.Game_Score[player];
x = lerp(xend,xstart,val / global.Rule_Health_max);

//disp
if val == global.Rule_Health_max
	type = HAND_TYPE.fist;
else
	type = HAND_TYPE.open;