function regAnalysis(file)
  input = importdata(file);

  display(['Data imported' file]);

  X = input.data(1: end-1, 4: end);
  y = input.data(2: end, 3);


  X( :, all(~X,1) ) = [];

  X([17:17:size(X, 1)], :) = [];
  y([17:17:size(y, 1)]) = [];

  display('Inputs formatted')

  X = unique(X', 'rows')';

  X = [X ones(size(X, 1), 1)];
  b = regress(y,X);

  yhat = X * b;

  error = sqrt(sum((yhat - y).^2) / length(y));

  display(['Error:' num2str(error)])

  figure()
  plot([1:16], y([1:16]), 'r')
  hold on
  plot([1:16], X([1:16], :) * b, 'b')
  title('Number of plays of a random player compared to prediction')
  ylabel('Number of downs played')
  xlabel('Week of season')
  legend('Random player', 'Prediction')

  figure()
  plot([1:16], sum(reshape(y, length(y) / 16, 16), 1), 'r')
  hold on
  plot([1:16], sum(reshape(X * b, length(y) / 16, 16), 1), 'b')
  title('Average number of plays per player compared to average of prediction')
  ylabel('Number of downs played')
  xlabel('Week of season')
  legend('Average player', 'Average prediction')
end
