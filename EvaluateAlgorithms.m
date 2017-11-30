%Importing
importTest();

%Converting to numeric
label = numconvert(label);
flags = numconvert(flags);
services = numconvert(services);
protocol_types = numconvert(protocol_types);

%Creating data matrix
rawdata = horzcat(count, diff_srv_rate, dst_bytes, dst_host_count, dst_host_diff_srv_rate, dst_host_rerror_rate, dst_host_same_src_port_rate, dst_host_same_srv_rate, dst_host_serror_rate, dst_host_srv_count, dst_host_srv_diff_host_rate, dst_host_srv_rerror_rate, dst_host_srv_serror_rate, duration, flags, hot1, is_guest_logins, is_host_logins, lands, logged_ins, num_access_files, num_compromised, num_failed_logins, num_file_creations, num_outbound_cmds, num_root, num_shells, protocol_types, rerror_rate, root_shell, same_srv_rate, serror_rate, services, src_bytes, srv_count, srv_diff_host_rate, srv_rerror_rate, srv_serror_rate, su_attempted, urgent, wrong_fragment);

newdata = preprocessing(rawdata, 2); % How many dimensions do we want after preprocessing?

smalldata = newdata(1:1000,:); % for dbscan
smalllabel = label(1:1000,:);

%DBSCAN
%10-fold split
folds = 10;
revolutions = 200;
[x,~] = size(smalldata);
c = cvpartition(x, 'KFold',folds);
averageROCtableDBSCAN = zeros(revolutions,6);
for i = 1:folds
    testindices = find(c.test(i));    
    testlabel = smalllabel(testindices);
    testdata = smalldata(testindices);
    
    [tempROC] = dbscanROC(testdata, testlabel, revolutions, 'euclidean');
    averageROCtableDBSCAN = averageROCtableDBSCAN + tempROC;
end
averageROCtableDBSCAN = averageROCtableDBSCAN/folds;
AUCDBSCAN = abs(trapz(averageROCtableDBSCAN(:,1),averageROCtableDBSCAN(:,2)));

%Simple split
revolutions = 200;
[x,~] = size(smalldata);
c = cvpartition(x, 'HoldOut');
averageROCtableDBSCAN2 = zeros(revolutions,6);
testindices = find(c.test(1));
testlabel = smalllabel(testindices);
testdata = smalldata(testindices);

[tempROC] = dbscanROC(testdata, testlabel, revolutions, 'euclidean');
averageROCtableDBSCAN2 = averageROCtableDBSCAN2 + tempROC;
AUCDBSCAN2 = abs(trapz(averageROCtableDBSCAN2(:,1),averageROCtableDBSCAN2(:,2)));

%K-means
%10-fold split
revolutions = 200;
[x,~] = size(data);
c = cvpartition(x, 'KFold',folds);
averageROCtablekmeans = zeros(revolutions,6);
for i = 1:folds
    testindices = find(c.test(i));
    trainindices = find(c.training(i));
    
    trainlabel = label(trainindices);
    testlabel = label(testindices);
    traindata = newdata(trainindices);
    testdata = newdata(testindices);
    
    centroids = train(traindata, trainlabel, 5, 'sqEuclidean');
    [tempROC] = kmeansROC(testdata, testlabel, centroids, revolutions, 'euclidean');
    
    averageROCtablekmeans = averageROCtablekmeans + tempROC;
end
averageROCtablekmeans = averageROCtablekmeans/folds;
AUCkmeans = abs(trapz(averageROCtablekmeans(:,1),averageROCtablekmeans(:,2)));

%Simple-split
revolutions = 200;
[x,~] = size(newdata);
c = cvpartition(x, 'HoldOut');
averageROCtablekmeans2 = zeros(revolutions,6);

testindices = find(c.test(1));
trainindices = find(c.training(1));

trainlabel = label(trainindices);
testlabel = label(testindices);
traindata = newdata(trainindices);
testdata = newdata(testindices);

centroids = train(traindata, trainlabel, 5, 'sqEuclidean');
[tempROC] = kmeansROC(testdata, testlabel, centroids, revolutions, 'euclidean');

averageROCtablekmeans2 = averageROCtablekmeans2 + tempROC;
AUCkmeans2 = abs(trapz(averageROCtablekmeans2(:,1),averageROCtablekmeans2(:,2)));

%Visualisation
h = figure();
plot(averageROCtablekmeans(:,1),averageROCtablekmeans(:,2),averageROCtableDBSCAN(:,1),averageROCtableDBSCAN(:,2));
legend('K-means','DBSCAN','Location','southeast');
axis([0,1,0,1]);
xlabel('False positive rate');
ylabel('True positive rate');
%Cleanup
clearvars trainlabel smalldata smalllabel newdata revolutions tempROC tempROC2 tempROC3 testdata testindices testlabel traindata trainindices i folds centroids2 centroids c pcadata h rawdata zdata x count diff_srv_rate dst_bytes dst_host_count dst_host_diff_srv_rate dst_host_rerror_rate dst_host_same_src_port_rate dst_host_same_srv_rate dst_host_serror_rate dst_host_srv_count dst_host_srv_diff_host_rate dst_host_srv_rerror_rate dst_host_srv_serror_rate duration flags hot1 is_guest_logins is_host_logins label lands logged_ins num_access_files num_compromised num_failed_logins num_file_creations num_outbound_cmds num_root num_shells protocol_types rerror_rate root_shell same_srv_rate serror_rate services src_bytes srv_count srv_diff_host_rate srv_rerror_rate srv_serror_rate su_attempted type1 urgent wrong_fragment;
