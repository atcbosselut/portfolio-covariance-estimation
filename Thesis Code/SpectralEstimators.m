function [ new_covariance ] = SpectralEstimators( covariance, numStocks, timeRange )
%This function returns the spectral estimators of the covariance matrix
%defined as RMT-M and RMT-0 in "9 Estimators" paper

w_covariance = covariance(2:end, 2:end);

%Calculate variances for each stock based on covariance matrix
variances = diag(w_covariance);

%Calculate the correlation matrix
correlations = w_covariance./sqrt(variances*variances');

%Calculate the eigenvectors and eigenvalues of the correlation matrix
[eigenvecs,eigenvals] = eig(correlations);
eigenvals_only = eig(correlations);

%Find the maximum eigenvalue of the correlation matrix
max(eigenvals_only);

%Find the max eigenvalue threshold according to the "9 Estimators" paper
max_eig = (1-(max(eigenvals_only))/numStocks)*(1+numStocks/timeRange+2*sqrt(numStocks/timeRange));

eigenvals_o = eigenvals;
eigenvals_m = eigenvals;
sum_m = 0;
count = 0;

%Calculate the average size of the eigenvalues smaller than the max
%eigenvalue threshold
for b = 1:numStocks
    if eigenvals_only(b) < max_eig
        sum_m = sum_m + eigenvals_only(b);
        count = count + 1;
    end
end

avg_m = sum_m/count;

%For the RMT-0 estimator, if an eigenvalue of the correlation matrix is
%less than the threshold, set it to 0
%For the RMT-M estimator, if an eigenvalue of the correlation matrix is
%less than the threshold, set it to the average of eigenvalues less than
%the threshold
for a = 1:numStocks
    if (eigenvals_o(a,a) < max_eig)
        eigenvals_o(a,a) = 0;
    end
    if (eigenvals_m(a,a) < max_eig)
        eigenvals_m(a,a) = avg_m;
    end
end

%Convert the diagonalized matrices back to the standard basis
h_rmt_o = eigenvecs*eigenvals_o*inv(eigenvecs);
h_rmt_m = eigenvecs*eigenvals_m*inv(eigenvecs);

%Force all the diagonal elements of the RMT-0 matrix to 1.
for c = 1:numStocks
    h_rmt_o(c,c) = 1;   
end

%Compute the filtered correlation matrix for the RMT-M method
h_rmt_m = h_rmt_m./(sqrt(diag(h_rmt_m)*diag(h_rmt_m)'));

%Convert the filtered correlation matrices back to covariance matrices
s_rmt_o = h_rmt_o.*sqrt(variances*variances');
s_rmt_m = h_rmt_m.*sqrt(variances*variances');

%Return the covariance matrices in the same format as they were received
new_covariance = zeros(numStocks+1,numStocks+1,2);
new_covariance(1,2:end,1) = covariance(1,2:end);
new_covariance(2:end,1,1) = covariance(2:end,1);
new_covariance(1,2:end,2) = covariance(1,2:end);
new_covariance(2:end,1,2) = covariance(2:end,1);
new_covariance(2:end,2:end,1) = s_rmt_o;
new_covariance(2:end,2:end,2) = s_rmt_m;
end

