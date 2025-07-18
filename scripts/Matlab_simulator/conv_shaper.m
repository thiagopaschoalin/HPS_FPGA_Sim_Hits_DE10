function [sinal1,S_truth] = conv_shaper(S_truth,yn)
%% sinal da distribuição "CONVOLUÇÃO"
N_A = length(yn);
                                                            % No novo pulso o máximo ocorre na posição 50.
a = find(yn == max(yn));
sinal1 = zeros(1,length(S_truth) + N_A - 1);                         %criando o sinal1 com o comprimento de termos da convolução
S_truth1 = [(zeros(1,a)) S_truth (zeros(1,N_A - a))];                      % colocando zeros nas bordas do sinal truth para entrar na "convolução" 
jj = 1;
for i = 1+a : length(S_truth1) - N_A + a

    aux = zeros(1,N_A);

    if S_truth1(i)~=0

         for j = 1:N_A

                aux(j) = S_truth1(i)*yn(j);                       %caso o desvio de fase nao seja simulado basta escolher aqui a coluna da matriz sorteio central para convolução neste caso 6 
         end

        jj=jj+1;  
    end

    sinal1(i-a:i+N_A-a-1) = aux + sinal1(i-a:i+N_A-a-1);                        %caso queira convoluir com apenas uma fase da matrix substituir fase posição pelo numero da coluna da fase
%     sinal1          = sinal1(a:end-a);
end
sinal1 = sinal1(a:end - N_A + a);
end
