function b = Filter(ids,k)
% Filter
% masks out indices "ids" based on cardinality compared to k
%
% Usage...:
% b = Filter(ids,k);
%
% Input...: ids       indices
%           k         (1),frequency
% Output..: b         boolean,mask
%
% Examples:
%{
b = Filter(dfn.dfn.xID,2);
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

if nargin < 2; k = 2; end                                  						% default frequency
ids = ids(:);                                              				        % vector format
u = unique(ids);                                                                % unique indices
b = u(histc(ids,u) >= k);                                                       % mask
