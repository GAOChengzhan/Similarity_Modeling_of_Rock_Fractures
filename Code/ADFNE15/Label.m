function La = Label(c,n)
% Label
% returns labels for clusters "c" based on number "n"
%
% Usage...:
% La = Label(c,n);
%
% Input...: c         cell,clusters
%           n         (1)
% Output..: La        labels
%
% Examples:
%{
La = Label(c,n);
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

La = zeros(n,1);
for i = 1:length(c)
    La(c{i}) = i;                                                               % assigns labels
end
f = (La == 0);                                                                  % isolated fractures
La(f) = -(1:sum(f));                                                            % assigns individual labels
