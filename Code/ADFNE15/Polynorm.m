function nrm = Polynorm(ply)
% Polynorm
% computes normals to polygons, 3D
%
% Usage...:
% nrm = Polynorm(ply);
%
% Input...: ply       cell,polygons
% Output..: nrm       (?,3),normals
%
% Examples:
%{
nrm = Polynorm(Field(DFN('dim',3),'Poly'));
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

nrm = cell2mat(cellfun(@(ply)cross(ply(2,:)-ply(1,:),ply(3,:)-ply(1,:)),ply,... % polygons' normals
    'UniformOutput',false));
