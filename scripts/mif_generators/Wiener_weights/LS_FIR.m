function [estimated] = LS_FIR(weigths_t, signal, ls_bias)
    
    estimated = [];
    
    if ls_bias
        weigths = weigths_t(1:end-1);
        bias = weigths_t(end);
    else
        weigths = weigths_t(1:end)
        bias = 0;
    end    
    
    
    half_window = floor(length(weigths)/2);
    
    
    signal_zero = [zeros(1,half_window),signal,zeros(1,half_window+1)];
    
    length(signal_zero);
    for i = 1:length(signal_zero)-length(weigths)
        estimated = [estimated; (dot(signal_zero(i:i+length(weigths)-1),weigths))+ bias];
    end
    

end