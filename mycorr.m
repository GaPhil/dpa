function C = mycorr(x, y)
% faster corrcoef for two matrices (octave style)
% only real numbers(?)
% rows ... observations
% columns ... variables

[xr, xc] = size(x);
[yr, yc] = size(y);
assert((xr == yr), 'Matrix row count mismatch');

x = x - repmat(mean(x, 1), xr, 1);              % remove means
y = y - repmat(mean(y, 1), yr, 1);
C = x' * y;                                     % (n - 1)cov(x, y)
C = C ./ repmat((sqrt(sum(x.^2, 1)))', 1, yc);  % divide by sqrt((n - 1)var(x))
C = C ./ repmat(sqrt(sum(y.^2, 1)), xc, 1);     % divide by sqrt((n - 1)var(y))
% resulting C ... correlation coefficient

%  C = C . / (repmat((sqrt(sum(x.^2, 1)))', 1, yc) . * repmat(sqrt(sum(y.^2, 1)), xc, 1));
end
