function [snl_out, mean] = pzc(snl,M_factor,bt_mask)
% Function to apply the PZC
% snl: signal from ADC
% M_factor: paramater that depends on the exp decay time
% bt_mas: vector with the bunch train pattern
% snl_out: pzc output
% mean: mean to correct the accumulator


% pzc output
snl_out = zeros(1,length(snl));

% previous value of PZC accumulator
previous_entry = 0;

% Acumulator for correction
acc = 0;

% Counter for correction
counter = 0;

% Counter to identify the gap
gap_counter = 0;

% parameter to check if the negative values reach the determined
num_corr = 2^4;

% parameter to check if it is in the gap to correct
len_gap = 2^5;

% mean to correct the pzc accumulator
mean = 0;

% limit to check the pzc accumulator
limit = 0;


for i = 1:length(snl)
    
    % PZC accumulator
    p = snl(i) + previous_entry;
    previous_entry = p;
    
    % PZC Operation
    snl_out(i) = p + snl(i)*M_factor;
   
    % Check if it is 0 mask of bunch train
    if bt_mask(i) == 0
        % Increment the gap counter
        gap_counter = gap_counter + 1;
    else
        % Reset the gap counter
        gap_counter = 0;
    end
    
    % Check if it is in a gap region
    if gap_counter >= len_gap
        % Check if the PZC is diverging from the negative value
        if snl_out(i) <  limit
            % This is only to treat the first sample of vector
            if i > 1
                % Increment the counter to correct pzc accumulator
                counter(i) = counter(i-1) + 1;
                % Store the sum of negative values
                acc(i) = acc(i-1) + snl_out(i)-limit;
            else
                % Same as before, but for the first sample
                counter(i) = 1;
                acc(i) = snl_out(i)-limit;
            end
        else
            % This is only to treat the first sample of vector
            if i > 1
                % Mantain the previous value of counter and acc
                counter(i) = counter(i-1);
                acc(i) = acc(i-1);
            end
        end
        
        % To check if there is any value in counter and avoid code error
        if counter(i) > 0
            % Mean of negative values
            mean(i) = acc(i)/counter(i);
        else
            mean(i) = 0;
        end
        
        % Check if the counter reaches the predetermined samples of
        % negative values
        if counter(i) >= num_corr
            % Correcting the output value
            snl_out(i) = snl_out(i) - acc(i)/counter(i);
            % Zeroing the mean
            mean(i) = 0;
            % Correcting the pzc accumulator
            p = p - acc(i)/counter(i);
            % Updating the previous value of pzc accumulator
            previous_entry = p;
            % Zeroing the auxiliary variables
            acc(i) = 0;
            counter(i) = 0;
        end
       
    else
        % Zeroing the auxiliary variables if it is not in gap region
        acc(i) = 0;
        mean(i) = 0;
        counter(i) = 0;
    end
    
    
    
   
end

% Extracting the gain given by pzc operation
snl_out = snl_out/(M_factor+1);
mean = mean/(M_factor+1);


end
