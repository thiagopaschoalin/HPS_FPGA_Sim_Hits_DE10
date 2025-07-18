function [weights] = LS_filter(snl,ener,num_weights,ls_bias)

    matrix_obs = [];
    matrix_ene = [];
    
    half_window = floor(num_weights/2);

    for i = 1:length(snl)-num_weights-1
        if ls_bias  %Com bias
            matrix_obs = [matrix_obs;snl(i:i+num_weights-1),1];
            matrix_ene = [matrix_ene;ener(i+half_window)];
       
        else  %Sem bias
            matrix_obs = [matrix_obs;snl(i:i+num_weights-1)];
            matrix_ene = [matrix_ene;ener(i+half_window)];
        end
    end
    
    weights = (inv(matrix_obs' * matrix_obs) * matrix_obs') * matrix_ene;
    
    

end