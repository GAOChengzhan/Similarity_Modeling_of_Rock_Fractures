function y = Reshape(x,m,n)
% Reshape
% reshapes "x" into (m,n) column-wise
%
% Usage...:
% y = Reshape(x,m,n);
%
% Input...: x         any
%           m         (1),number
%           n         (1),number
% Output..: y         (m,n),any
%
% Examples:
%{
y = Reshape([1,2,3,4,5,6],2,3); % = [1,2,3; 4,5,6]
y = reshape([1,2,3,4,5,6],2,3); % = [1,3,5; 2,4,6] Matlab's function
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

y = reshape(x',n,m)';                                                           % correct shaping
