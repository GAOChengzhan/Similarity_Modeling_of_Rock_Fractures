function [gxs,gds] = Group(xts,ids,n)
% Group
% groups intersection indices and points
%
% Usage...:
% [gxs,gds] = Group(xts,ids,n);
%
% Input...: xts       (m,4|6),intersection points
%           ids       (m,2),intersection indices
%           n         (1),number of fractures
% Output..: gxs       cell
%           gds       cell
%
% Examples:
%{
[gxs,gds] = Group(xts,ids,n);
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

gds = cell(n,1);                                                                % grouped indices
gxs = cell(n,1);                                                                % grouped points
for i = 1:size(ids,1)                                                           % loops over all intersection indices
    I = ids(i,1);                                                               % index 1
    J = ids(i,2);                                                               % index 2
    gds{I} = [gds{I},J];                                                        % updates grouped indices
    gds{J} = [gds{J},I];                                                        % updates grouped indices
    gxs{I} = [gxs{I};xts(i,:)];                                                 % updates grouped points
    gxs{J} = [gxs{J};xts(i,:)];                                                 % updates grouped points
end
