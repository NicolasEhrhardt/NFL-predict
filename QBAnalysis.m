file = 'QBData.csv';
input = importdata(file);

display(['Data imported' file]);

X = input.data(1: end-1, 4: end);
y = input.data(2: end, 3);

display('Inputs formatted')

b = regress(y,X);

yhat = X * b;

error = sqrt(sum((yhat - y).^2) / length(y));

display(['Error:' num2str(error)])
