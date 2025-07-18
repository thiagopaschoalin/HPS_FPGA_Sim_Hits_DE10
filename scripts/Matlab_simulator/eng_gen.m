function [eng_temp] = eng_gen(x_cdf,y_cdf,total_eng);

num_y = [1:length(y_cdf)];


div_y = 1/(length(y_cdf)-1);
y_ticks = [0:div_y:1];

rand_num = randi(length(y_ticks),1,total_eng);

for i = 1:length(y_ticks)
    pos_tick_greater = find (y_cdf > y_ticks(i));
    pos_tick_equal =   find (y_cdf >= y_ticks(i));
    
    empty_pos_tick_greater = isempty(pos_tick_greater);
    
    if(empty_pos_tick_greater == 1)
        x_ticks(i) = x_cdf(pos_tick_equal(1));
        
    else
        if (pos_tick_greater(1) == pos_tick_equal(1))
            if(pos_tick_greater(1) == 1)
                x_ticks(i) = x_cdf(pos_tick_greater(1));
            else
                x_ticks(i) = x_cdf(pos_tick_greater(1)-1);
            end
        else
            x_ticks(i) = x_cdf(pos_tick_equal(1));
        end
    end
    
    
%     if (pos_tick(1) == 1)
%         x_ticks(i) = x_vals(1);
%     else
%         x_ticks(i) = x_vals(pos_tick(1)-1);
%     end
end




eng_temp = x_ticks(rand_num);