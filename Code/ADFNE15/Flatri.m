function y = Flatri(x,k)
% Flatri
% returns lower triangle of matrix "x" flattened
%
% Usage...:
% y = Flatri(x,k);
%
% Input...: x         (m,n)
%           k         (1),default=-1
% Output..: y         any
%
% Examples:
%{
y = Flatri(Reshape(1:16,[],4))'; % = [5,9,13,10,14,15]'
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

if nargin < 2; k = -1; end                                                      % default shift
f = tril(true(size(x)),k);                                                      % lower triangle of matrix
x = x(f);                                                                       % filtered input
y = x(:);                                                                       % flattened
