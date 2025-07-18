function [hits_bunch_train, bt_mask_out] = hits_positions(archive_name, N);
% Function to define positions where occur collisions
% archive_name: name of archive containing the truth energy of a cell
% N: Number of samples
% hits_bunch_train: Vector that informs where collisions occur
% bt_mask_out: Vector with the bunch train pattern extended for all samples

% loadings datas
load(archive_name);
load("bunch_pat.mat"); % Bunch Train Pattern


% Finding the original occupation
position_zeros = find(eng_truth == 0);
occ = (length(eng_truth) - length(position_zeros))/length(eng_truth);

disp(strcat("Original Occupation: ",num2str(occ*100),"%"));


% Extending the buch train pattern to all samples
tam_bunch_pat = length(bunch_pat);

cont_bp = 0;
bunch_pat_extended = zeros(1,N);
for i = 1:N;
    cont_bp = cont_bp + 1;
    if cont_bp > tam_bunch_pat;
        cont_bp = 1;
    end
    bunch_pat_extended(i) = bunch_pat(cont_bp);
end

% Exporting the Bunch Train Pattern of all samples
bt_mask_out = bunch_pat_extended;

% Finding the positions where has collisions
rand_num = rand([1,N]);
posicao_occ = find(rand_num <= occ);

hits = zeros(1,N);
hits_bunch_train = hits;


% Applying the Bunch Train Pattern to all samples
for i = 1:length(posicao_occ)
    hits(posicao_occ(i)) = 1;
    hits_bunch_train(posicao_occ(i)) = hits(posicao_occ(i));
    
    if bunch_pat_extended(posicao_occ(i)) == 0
        hits_bunch_train(posicao_occ(i)) = 0;
    end
end

% Checking if the occupany simulated is correct
pos_bunch_Train_ones = find(bunch_pat_extended == 1);

hits_analise = hits(pos_bunch_Train_ones);
occ_ger = sum(hits_analise)/length(hits_analise);

disp(strcat("Generated Occupation: ",num2str(occ_ger*100),"%"));