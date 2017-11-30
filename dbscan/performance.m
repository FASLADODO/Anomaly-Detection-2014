%Function to evaluate the performance metrics
function [FPR ,TPR,accuracy,TNR,precision,fmeasure] = performance(label, type)
[x,~] = size(label);

truepositive = 0;
falsepositive = 0;
truenegative = 0;
falsenegative = 0;

for i = 1:x
   if (label(i,1) == 1)
        if (type(i,1) ~= 1)
           truepositive = truepositive + 1;
       else
           falsenegative = falsenegative + 1;
        end
   else
      if (type(i,1) == 1)
           truenegative = truenegative + 1;
           
       else
           falsepositive = falsepositive + 1;
       end
   end
end

FPR = (falsepositive/(falsepositive + truenegative));
TPR = truepositive/(truepositive + falsenegative);
accuracy = (truepositive + truenegative)/((truepositive + falsenegative)+(falsepositive+truenegative));
TNR = truenegative/(falsepositive+truenegative);
precision = truepositive/(truepositive + falsepositive) ;
fmeasure = (2*truepositive)/(2*truepositive + falsepositive + falsenegative);
