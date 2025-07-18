function [eng_temp] = eng_gen_v2(x_cdf,y_cdf,total_eng);
% Funciton to generate the energy of collisions using the CDF information
% y_cdf and x_cdf: axes of the CDF plot
% total_eng: number of samples to generate
% eng_temp: simulated energy values

num_y = [1:length(y_cdf)];


div_y = 1/(length(y_cdf)-1);
y_ticks = [0:div_y:1];

rand_num = randi(length(y_ticks),1,total_eng);

pos_tick_greater = arrayfun(@(y) find(y_cdf > y, 1), y_ticks, 'UniformOutput', false);
pos_tick_equal   = arrayfun(@(y) find(y_cdf >= y, 1), y_ticks, 'UniformOutput', false);

empty_pos_tick_greater = cellfun(@isempty, pos_tick_greater);

x_ticks = zeros(size(y_ticks));

idx_empty = find(empty_pos_tick_greater);
idx_not_empty = find(~empty_pos_tick_greater);

% Para os casos em que pos_tick_greater está vazio
x_ticks(idx_empty) = cellfun(@(pos) x_cdf(pos(1)), pos_tick_equal(idx_empty));

% Para os casos em que pos_tick_greater não está vazio
greater_vals = cell2mat(pos_tick_greater(idx_not_empty));
equal_vals = cell2mat(pos_tick_equal(idx_not_empty));

condition = greater_vals == equal_vals;
x_ticks(idx_not_empty(condition)) = x_cdf(max(greater_vals(condition) - 1, 1));
x_ticks(idx_not_empty(~condition)) = x_cdf(equal_vals(~condition));



eng_temp = x_ticks(rand_num);