function y = Not(x,ids)
% Not
% chooses from "x" any but at indices "ids"
%
% Usage...:
% y = Not(x,ids);
%
% Input...: x         any
%           ids       (n),indices
% Output..: y         any
%
% Examples:
%{
y = Not([1,0,4,3,2,1],[1,3]); % = [0,3,2,1]
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

f = true(1,length(x));                                                          % initializes mask
f(ids) = false;                                                                 % updates based on 'ids'
y = x(f);                                                                       % applies to 'x'
