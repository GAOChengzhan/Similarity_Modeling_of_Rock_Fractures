function varargout = Naned(lns)
% Naned
% prepares nan structured for lines "lns" for faster drawing
%
% Usage...:
% varargout = Naned(lns);
%
% Input...: lns       (n,4|6),lines
% Output..: varargout {...}
%
% Examples:
%{
[x,y] = Naned(rand(10,4));
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

[n,k] = size(lns);                                                              % size of lines
k = k/2;                                                                        % determines dimension
x = [lns(:,[1,k+1]),nan(n,1)]';                                                 % builds X coordinates (added nan)
y = [lns(:,[2,k+2]),nan(n,1)]';                                                 % builds Y coordinates
if k == 3                                                                       % 3d case
    z = [lns(:,[3,k+3]),nan(n,1)]';                                             % builds Z coordinates
    varargout = {x,y,z};                                                        % assigns to output
else
    varargout = {x,y};                                                          % assigns to output
end
