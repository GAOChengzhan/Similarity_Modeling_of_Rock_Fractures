function [x1,m,x2,s,n] = Stats(x,lbl)
% Stats
% returns and prints statistics for "x"
%
% Usage...:
% [x1,m,x2,s,n] = Stats(x,lbl);
%
% Input...: x         any
%           lbl       labels
% Output..: x1        minimum
%           m         mean
%           x2        maximum
%           s         standard deviation
%           n         number of data
%
% Examples:
%{
Stats(rand(10,11),'U');
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE1.5_License.txt and at http://alghalandis.net/products/adfne/adfne15
%
% Citations:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% Fadakar-A Y, 2018, "DFNE Practices with ADFNE", Alghalandis Computing, Toronto, 
% Ontario, Canada, http://alghalandis.net, pp61.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

if nargin < 2; lbl = inputname(1); end                                          % the name of argument
y = x(:);
x1 = nanmin(y);                                                                 % minimum, ignoring nan values
x2 = nanmax(y);                                                                 % maximum
m = nanmean(y);                                                                 % mean
s = nanstd(y);                                                                  % standard deviation
n = length(y);
fprintf('----[ %s ]\nn   : %g\nmin : %g\nmean: %g\nmax : %g\nstd : %g\n\n',...  % displays statistics
    lbl,n,x1,m,x2,s);
