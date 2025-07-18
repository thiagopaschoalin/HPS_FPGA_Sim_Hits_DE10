function [y,x,eng_truth] = cdf_generate(arquivo);

% Criar histograma
load(arquivo);

eng_truth = eng_truth(find(eng_truth > 0));
%[num, edges] = histcounts(eng_truth, 'Normalization','probability', 'BinMethod', 'auto'); 
[num, edges] = histcounts(eng_truth, 100*round(max(eng_truth)) , 'Normalization','probability'); 

% Ajustar os valores do eixo X (centro das bins)
x_vals = (edges(1:end-1) + edges(2:end)) / 2;
x_vals_n = x_vals;
y_vals_n = num;

diff_x = (edges(2:end) - edges(1:end-1));

y_vals(1) = num(1) * diff_x(1);

for i = 2: length(num)
    y_vals(i) = num(i)*diff_x(i) + y_vals(i-1);
end


y_vals = y_vals/max(y_vals);

y = y_vals;
x = x_vals;


% % Exibir histograma
figure
bar(x_vals_n, y_vals_n);
xlabel('Valores do eixo X');
ylabel('Frequência');
title('Histograma dos Dados');

samples = length(eng_truth);


% Exibir histograma]
figure
bar(x_vals, y_vals);
xlabel('Energy');
ylabel('Probability');
title('CDF Plot');

