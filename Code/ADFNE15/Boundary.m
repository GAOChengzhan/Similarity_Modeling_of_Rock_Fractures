function vls = Boundary(pts,be,bv,p)
% Boundary
% returns interpolation for boundary elements, 2D|3D
%
% Usage...:
% vls = Boundary(pts,be,bv,p);
%
% Input...: pts       (n,2|3),points to be interpolated for
%           be        (k,4),boundary elements,lines
%           bv        (k),boundary values
%           p         (1),exponent for distance
% Output..: vls       (n),interpolation for points
%
% Examples:
%{
pts = rand(30,2); be = [0,0,0,1;1,0,1,1]; bv = [1,0]; p = 2;
vls = Boundary(pts,be,bv,p);
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

if nargin < 4; p = 1; end                                                       % default exponent = 1, linear
bv = bv(:)';                                                                    % 'bv' to be as [1,n] in size
if iscell(be)																	% TODO: for polygons
    vls = NaN;                                                                  % not implemented, yet
else
    d = (1./Snap(pts,be,0)).^p;                                                 % distance based weighting
    vls = sum(d.*bv,2)./sum(d,2);                                               % interpolation
end
