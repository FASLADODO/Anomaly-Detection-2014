%Importing
importTest();

%Converting to numeric
label = numconvert(label);
flags = numconvert(flags);
services = numconvert(services);
protocol_types = numconvert(protocol_types);

%Creating data matrix
rawdata = horzcat(count, diff_srv_rate, dst_bytes, dst_host_count, dst_host_diff_srv_rate, dst_host_rerror_rate, dst_host_same_src_port_rate, dst_host_same_srv_rate, dst_host_serror_rate, dst_host_srv_count, dst_host_srv_diff_host_rate, dst_host_srv_rerror_rate, dst_host_srv_serror_rate, duration, flags, hot1, is_guest_logins, is_host_logins, lands, logged_ins, num_access_files, num_compromised, num_failed_logins, num_file_creations, num_outbound_cmds, num_root, num_shells, protocol_types, rerror_rate, root_shell, same_srv_rate, serror_rate, services, src_bytes, srv_count, srv_diff_host_rate, srv_rerror_rate, srv_serror_rate, su_attempted, urgent, wrong_fragment);

newdata = preprocessing(rawdata, 25); % How many dimensions do we want after preprocessing?

%Because dbscan is so heavy and slow and you have to run it a million
%times, it would take ages so I have to cheat here and only use 1000 rows of the
%data.


newdata = newdata(1:1000,:);
label = label(1:1000,:);


%10-fold split
folds = 10;
revolutions = 200;
[x,~] = size(newdata);
c = cvpartition(x, 'KFold',folds);
averageROCtable = zeros(revolutions,6);
averageROCtable2 = zeros(revolutions,6);
averageROCtable3 = zeros(revolutions,6);
for i = 1:folds
    testindices = find(c.test(i));
    trainindices = find(c.training(i));
    
    trainlabel = label(trainindices);
    testlabel = label(testindices);
    traindata = newdata(trainindices);
    testdata = newdata(testindices);
    
    
    [tempROC] = dbscanROC(testdata, testlabel, revolutions, 'euclidean');
    [tempROC2] = dbscanROC(testdata, testlabel, revolutions, 'minkowski');
    [tempROC3] = dbscanROC(testdata, testlabel, revolutions, 'cityblock');
    
    averageROCtable = averageROCtable + tempROC;
    averageROCtable2 = averageROCtable2 + tempROC2;
    averageROCtable3 = averageROCtable3 + tempROC3;
end

averageROCtable = averageROCtable/folds;
averageROCtable2 = averageROCtable2/folds;
averageROCtable3 = averageROCtable3/folds;

AUC = abs(trapz(averageROCtable(:,1),averageROCtable(:,2)));
AUC2 = abs(trapz(averageROCtable2(:,1),averageROCtable2(:,2)));
AUC3 = abs(trapz(averageROCtable3(:,1),averageROCtable3(:,2)));



 h = figure();
 %plot(averageROCtable(:,1),averageROCtable(:,2),'-x');
 plot(averageROCtable(:,1),averageROCtable(:,2),averageROCtable2(:,1),averageROCtable2(:,2),averageROCtable3(:,1),averageROCtable3(:,2));
 axis([0,1,0,1]);
 xlabel('False positive rate');
 ylabel('True positive rate');

%Cleanup
clearvars trainlabel newdata revolutions tempROC tempROC2 tempROC3 testdata testindices testlabel traindata trainindices i folds centroids2 centroids c pcadata h rawdata zdata x count diff_srv_rate dst_bytes dst_host_count dst_host_diff_srv_rate dst_host_rerror_rate dst_host_same_src_port_rate dst_host_same_srv_rate dst_host_serror_rate dst_host_srv_count dst_host_srv_diff_host_rate dst_host_srv_rerror_rate dst_host_srv_serror_rate duration flags hot1 is_guest_logins is_host_logins label lands logged_ins num_access_files num_compromised num_failed_logins num_file_creations num_outbound_cmds num_root num_shells protocol_types rerror_rate root_shell same_srv_rate serror_rate services src_bytes srv_count srv_diff_host_rate srv_rerror_rate srv_serror_rate su_attempted type1 urgent wrong_fragment;
