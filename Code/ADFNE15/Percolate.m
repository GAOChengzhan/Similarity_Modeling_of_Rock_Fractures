function f = Percolate(a,b)
% Percolate
% checks for percolation state
%
% Usage...:
% f = Percolate(a,b);
%
% Input...: a         (1),comparable
%           b         (1),comparable
% Output..: f         (1),boolean
%
% Examples:
%{
f = Percolate(a,b);
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

global Silent
f = (a == b);                                                                   % checks for percolation
if f && ~Silent
    fprintf(pad('Inlet-to-Outlet is Percolating.\n',55,'left'));                % displays information
end
