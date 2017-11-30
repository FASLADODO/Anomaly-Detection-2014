function [result] = numconvert(data)
result = zeros(size(data));
data = double(categorical(data));
sorted = flip(sortrows(tabulate(data),2));
[x,~] = size(data);

for i = 1:x
    value = find(sorted == (data(i,1)));
    result(i,1) = value(1,1);
end