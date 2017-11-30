function [ROCtable] = dbscanROC(data, label, revolutions, metric)
minpts = 10;
maxeps = 1.5;
interval = (maxeps/revolutions);
%interval = 0.01;
ROCtable = zeros(revolutions,6);

for i = 1:revolutions
    eps = i * interval;
    [~,type] = dbscan(data,minpts,eps,metric);
    type = type';
    [FPR ,TPR,accuracy,TNR,precision,fmeasure] = performance(label, type);
    ROCtable(i,1) = FPR;
    ROCtable(i,2) = TPR;
    ROCtable(i,3) = accuracy;
    ROCtable(i,4) = TNR;
    ROCtable(i,5) = precision;
    ROCtable(i,6) = fmeasure;

end