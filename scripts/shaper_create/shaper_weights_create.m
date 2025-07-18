% GENERATES IIR FILTER WEIGTHS FOR THE SHAPER (FENICS)

%%%%%%%%%%%%%%%%%% INSTRUCTIONS%%%%%%%%%%%%%%%%%%%%%
% - Change the delay to onde desired
% - Run the script
% - Check of the plots are ok to you
% - If IIR quantized response is not good, you can try to change the gain Gx and Gy
% - The "Hz_quant" variable are storing the quantized weights for the IIR filter
% shaper
% - Copy the values to the "a1", "a2", "b0", "b1" of "shaper_fenics.v" IIR
% instatiations in simulator project.
% - Remember:
%      -a1 and a2 are weights of the "Denominator". The first value of
%      "Denominator" is always 1024 and it not enters in the filter
%      weights. "a1" is the second value e "a2" is the third (if it exist)
%      -b0 and b1 are weigths of the "Numerator". First value of
%      "Numerator" is the b0 and the second is the b1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all

% Frequency of th ADC
freq = 40e6;
T  = 1/freq;

% Set the Delay (ns) that you want
% Example -> 1ns: delay = 1
% It can be positive or negative
delay = 0;

% Original Transfer Function
load digitalizeTF.mat

n1o = Ha{1,1}.Numerator{1,1};
d1o = Ha{1,1}.Denominator{1,1};

n2o = Ha{1,2}.Numerator{1,1};
d2o = Ha{1,2}.Denominator{1,1};

n3o = Ha{1,3}.Numerator{1,1};
d3o = Ha{1,3}.Denominator{1,1};

n4o = Ha{1,4}.Numerator{1,1};
d4o = Ha{1,4}.Denominator{1,1};

n5o = Ha{1,5}.Numerator{1,1};
d5o = Ha{1,5}.Denominator{1,1};


H1_o = tf(n1o, d1o);
H2_o = tf(n2o, d2o);
H3_o = tf(n3o, d3o);
H4_o = tf(n4o, d4o);
H5_o = tf(n5o, d5o);

H_total_o = H1_o + H2_o + H3_o + H4_o + H5_o;

% Continuos Impuls response
[y_cont_o, t_cont_o] = impulse(H_total_o, [0:1e-12:1.3e-6]);  


% Find the peak of the shaper and where it occurs
[max_val, max_idx] = max(y_cont_o);

% Time where it occurs
t_max = t_cont_o(max_idx);

%%%%%%%%%%%%%%%%

% Applyng the delay to the continous TF
s = tf('s');

T_d = 50e-9 - t_max - delay*1e-9;
atraso_exp = exp(- T_d *s);

% Pade aproximation
atraso = pade(atraso_exp,4);

%Applying the pade delay
H_total_taylor = H_total_o * atraso;

% Putting in vector format
[num_taylor, den_taylor] = tfdata(H_total_taylor, 'v');


freqi = freq;

% Applying the impinvar to digitalize
[Znt_taylor, Zdt_taylor] = impinvar(num_taylor, den_taylor, freqi);

% Normalizing
Znt_taylor = Znt_taylor * (freqi/max_val);

% Impulse response of Z TF
N = 50000;
[Xt_taylor, B] = impz(Znt_taylor, Zdt_taylor, N);



%% Sampling the point at 25ns

% Finding the continuos impulse response
[y_cont, t_cont] = impulse(H_total_o, [0:1e-12:1.3e-6]);
y_cont = y_cont/max(y_cont);

% Find the peak of the shaper and where it occurs
[max_val, max_idx] = max(y_cont);

% Time where it occurs
t_max = t_cont(max_idx);

% Sampling interval(25e-9 s)
delta_t = 25e-9;

% Creating deslocated points
n_points_e = 2; % Number of points at left
n_points_d = 500; % % Number of points at right
t_amostrado = t_max + (-n_points_e:n_points_d) * delta_t;

% Interpolating values 
y_amostrado = interp1(t_cont, y_cont, t_amostrado, 'linear', 'extrap');

t_cont = t_cont + (50e-9 - t_max);
t_amostrado = t_amostrado + (50e-9 - t_max);
t_amostrado2 = t_amostrado + delay*1e-9;

t_cont = t_cont * 1e9;
t_amostrado = t_amostrado * 1e9;
t_amostrado2 = t_amostrado2 * 1e9;

disp('Difference between sampled and approximated digital TF:');
disp(max(y_amostrado(1:50)-Xt_taylor(1:50)'./y_amostrado(1:50)))

% Ploting to see the difference
figure('DefaultAxesFontSize',24)
plot(t_cont, y_cont, 'k', 'DisplayName', 'FENICS Circuit Shaper');
hold on;
stem(t_amostrado, y_amostrado, 'r', 'LineWidth', 1.5, 'DisplayName', 'Sampled Points');
legend;
xlabel('Time (ns)');
xlim([0,350]);
ylim([-0.1,1.05]);
ylabel('Normalized Amplitude [ADC Count]');
title('Transfer Function');
grid on;

figure('DefaultAxesFontSize',24)
plot(t_cont, y_cont, 'k', 'DisplayName', 'FENICS Circuit Shaper');
hold on;
stem(t_amostrado, y_amostrado, 'r', 'LineWidth', 1.5, 'DisplayName', 'Sampled Points');
stem(t_amostrado2(1:50), Xt_taylor(1:50), 'b', 'filled', 'DisplayName', 'Digitalized Transfer Function');  % Resposta discreta
legend;
xlabel('Time (ns)');
ylabel('Normalized Amplitude [ADC Count]');
xlim([0,350]);
ylim([-0.1,1.05]);
title('Transfer Function');
grid on;

%% Finding the digitalized transfer function in partial components

% Decomposition using residue function
[r, p, k] = residuez(Znt_taylor, Zdt_taylor);

%Variable to store the fractional expression 
expressao = "";

% Auxiliary variable
processado = [];


X_f = zeros(length(p),N);
num_proc = 1;

% Joining the complex conjugated poles and mantaing the order 1 fractions
for i = 1:length(p)
    % If the pole has imaginary part different than zero
    if imag(p(i)) ~= 0
        %Finding the index of conjugated pole
        [~, idx_conjugate] = min(abs(p - conj(p(i))));
        
        % Varifying if the poles wasn't joined
        if ~ismember(p(i), processado)
            
            processado = [processado, conj(p(i))];
            % Sum of residues of conugated poles
            r_combined = real(conv(r(i),[1 -conj(p(i))]) + conv(r(idx_conjugate),[1 -p(i)]));
            p_combined = conv([1 -p(i)],[1 -conj(p(i))]);
            
            %Storing in variables the weights
            Hz{1,num_proc}.Numerator = r_combined;
            Hz{1,num_proc}.Denominator = p_combined;
            
            %Constructing the expression
            expressao_num = strcat(" H", num2str(num_proc), "(z) = ( ", num2str(r_combined(1))," + ", num2str(r_combined(2)),"z^-1 )");
            expressao_den = strcat(" / ( ", num2str(p_combined(1))," + ", num2str(p_combined(2)),"z^-1 + ", num2str(p_combined(3)),"z^-2 )");
            
            expressao(num_proc) = strcat(expressao_num,expressao_den);
            
            % Tracking the process poles
            num_proc = num_proc + 1;
            
            % Impulse reponse
            [X_f(i,:), B]  = impz (r_combined, p_combined, N);

        end
    else
        % If pole is simple (real), add directly
        r_sozinho = r(i);
        p_sozinho = [ 1 -p(i)];
        
        %Storing in variables the weights
        Hz{1,num_proc}.Numerator = r_sozinho;
        Hz{1,num_proc}.Denominator = p_sozinho;
        
        % Impulse reponse
        [X_f(i,:), B]  = impz (r_sozinho, p_sozinho, N);
        
        %Constructing the expression
        expressao_num = strcat(" H", num2str(num_proc), "(z) = ( ", num2str(r_sozinho(1))," )");
        expressao_den = strcat(" / ( ", num2str(p_sozinho(1))," + ", num2str(p_sozinho(2)),"z^-1 )");
            
        expressao(num_proc) = strcat(expressao_num,expressao_den);
        
        % Tracking the process poles
        num_proc = num_proc + 1;
        
        
    end
end

% Impulse response final
h_f = sum(X_f,1);

%Plotting the comparision
plotar_comparacao = 0; %Put 1, if you want to see
if plotar_comparacao
    figure;
    stem(t_amostrado2(1:50), h_f(1:50), 'r', 'filled');  % Resposta discreta
    hold on;
    stem(t_amostrado2(1:50), Xt_taylor(1:50), 'b', 'filled');  % Resposta discreta
    grid on;
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    %xlim([0,1.5e-6])
    %ylim([-0.2,1.1])
    title('Comparision: Fractional part and Original');
    legend('Patial Fraction','Original');
end


%% Calorimeter test

% Number of points of impulse response
N = 50000;

% Entry Gain
Gx = 2^32;

%Gain of IIR weights
Gy  = 2^10;

%Passing the signal to a IIR filter with quantized weights
X_f = zeros(N,length(Hz));
X = zeros(N,length(Hz));

for i=1:length(Hz)
    Zn = Hz{1,i}.Numerator;
    Zd = Hz{1,i}.Denominator;
    [X_f(:,i), Zn_q, Zd_q] = iir_generico(Zn, Zd, N, Gx, Gy);
    [X_temp, B] = impz (Zn, Zd, N); 
    
    X(:,i) = X_temp;
    
    Hz_quant{1,i}.Numerator = Zn_q;
    Hz_quant{1,i}.Denominator = Zd_q;
end

%Finding the final IIR output
h = sum(X,2);
h_f = sum(X_f,2);


% Ploting the difference between quantized and original IIR
figure
stem(h_f/(Gy*Gx));
hold on;
stem(h);
title('Impulse Response');
legend("Quantized signal","Original signal");
xlabel('Samples');
ylabel('Amplitude');
grid on;


figure('DefaultAxesFontSize',24)
stem((h_f)/(Gy*Gx));
%legend("Sinal Quantizado","Sinal Original");
xlim([0,1200]);
ylim([-0.015,0.01]);
xlabel('Samples');
ylabel('Normalized Amplitude [ADC Count]');
grid on;
