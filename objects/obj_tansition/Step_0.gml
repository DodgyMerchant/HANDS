/// @desc 


#region counting

pre_time_count -= 1;

if pre_time_count<=0
	{
	time_count += Func_t_span(!open) * 1;
	
	if (open and time_count<=0) or (!open and time_count>=time)//if at its end
		{
		/*//reset
		open = !open;
		time_count = open * time;
		//*/
		
		post_time_count -= 1;
		
		if post_time_count<=0
			{
			func_end();
			}
		}
	}

#endregion
#region _t
time_t = animcurve_channel_evaluate(speed_channel,time_count/time);

#endregion

