function pln = Plane(pts,normed)
% Plane
% returns the plane of points "pts",3D
%
% Usage...:
% pln = Plane(pts,normed);
%
% Input...: pts       (n,3),points
%           normed    (1),boolean
% Output..: pln       (9),plane
%
% Examples:
%{
pln = Plane(rand(3,3),true);
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

global Tolerance
if nargin < 2; normed = true; end                                               % default argument
n = size(pts,1);
assert(n > 2,'#points < 3');                                                    % cannot proceed with few points
if n > 3                                                                        % more than 3 points
    pts = Unique(pts,Tolerance);                                                % removes duplicates
    pts(3,:) = mean(pts,1);                                                     % make not co-planar
end
pln = [pts(1,:),pts(2,:)-pts(1,:),pts(3,:)-pts(1,:)];                           % plane of points
if normed
    a = Convert('norm',pln(4:6));                                               % normalizes vector
    nrm = Convert('norm',CExt.planeNormal(pln));                                % normalizes plane normal
    b = -Convert('norm',CExt.vectorCross3d(a,nrm));
    pln = [CExt.PointOnPlane(repmat([0,0,0],[size(pln,1),1]),[pln(1:3),a,b]),a,b];  % normalized plane
end
end
