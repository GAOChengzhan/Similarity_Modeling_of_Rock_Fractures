function info = Info(in)
% Info
% returns information about "in": polygons,lines 2D|3D
%
% Usage...:
% info = Info(in);
%
% Input...: in        cell:polygons,(n,4|6):lines
% Output..: info      centers,lengths,orientations
%
% Examples:
%{
info = Info(Field(DFN,'Line'));
info = Info(Field(DFN('dim',3),'Poly'));
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
% Updated.: 2017-12-29

info.n = size(in,1);                                                            % size of input
info.Center = Center(in);                                                       % center (centroid) points
info.Length = Length(in);                                                       % lengths (sizes)
out = Orientation(in);                                                          % orientations
if iscell(in)                                                                   % 3d polygons
    info.Dip = [out.Dip]';                                                      % dip angles [0..90]
    info.Dir = [out.Dir]';                                                      % dip direction angles [0..360)
else                                                                            % 2d lines
    info.Angle = [out.Angle]';                                                  % direction angles [0..360)
end
