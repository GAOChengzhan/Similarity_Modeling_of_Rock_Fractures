function ray = Ray(ply)
% Ray
% creates rays from center of polygons to vertices, 2D|3D
%
% Usage...:
% rys = Ray(plys);
%
% Input...: ply       cell,polygons
% Output..: ray       cell,rays,lines
%
% Examples:
%{
ray = Ray([0,0;1,0;1,1]); % = {3 lines}
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

ply = Convert('cell',ply);                                                      % converts to cell if necessary
cts = Center(ply);                                                              % centers
ray = arrayfun(@(i)[repelem(cts(i,:),size(ply{i},1),1),ply{i}],...              % rays
    1:length(ply),'UniformOutput',false);
