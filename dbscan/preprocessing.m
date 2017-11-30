function [procdata] = preprocessing(rawdata, dim)


%Normalization
% procdata = mat2gray(rawdata);
% norm_data = zeros(size(rawdata));
% [~,col] = size(norm_data);
% for i = 1:col
%     norm_data(:,i) = (rawdata(:,i) - min(rawdata(:,i))) / (max(rawdata(:,i)) - min(rawdata(:,i)));
% end
%  procdata = norm_data;
norm_data = zscore(rawdata);

% PCA
pcadata = pca(norm_data);
pcadata = pcadata(:, 1:dim);
newdata = pcadata' * norm_data';

procdata = newdata';



