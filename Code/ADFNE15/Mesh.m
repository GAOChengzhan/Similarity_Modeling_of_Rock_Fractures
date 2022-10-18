function pip = Mesh(lns,r,pre,mdl)
% Mesh
% generates mesh conditioned to lines "lns", and distance 'r', 2D
%
% Usage...:
% pip = Mesh(lns,r,pre,mdl);
%
% Input...: lns       (n,4),lines
%           r         (1)
%           pre       if true, split lines at intersections
%           mdl       string,model,{r|s}
% Output..: pip       (?,4)
%
% Examples:
%{
msh = Mesh(rand(3,4),0.03,false,'r');
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

error('not included at this time!, see Preface in the book.');
