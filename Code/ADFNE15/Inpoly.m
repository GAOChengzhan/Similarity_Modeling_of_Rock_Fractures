function o = Inpoly(pts,ply,tol)
% Inpoly
% tests if points 'pts' are inside polygon 'ply', 2D|3D
%
% Usage...:
% o = Inpoly(pts,ply,tol);
%
% Input...: pts       (n,2|3),points
%           ply       (k,2|3),polygon
%           tol       (1),tolerance
% Output..: o         (n),boolean
%
% Examples:
%{
o = Inpoly(rand(100,2),rand(3,2)); % 2d case
o = Inpoly(rand(100,3),rand(3,3),0.2); % 3d case
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
if nargin < 3; tol = Tolerance; end                                             % default distance tolerance
[n,k] = size(pts);
if k == 3                                                                       % 3d points
    pln = Plane(ply);                                                           % plane of polygon
    c = (abs(sum(bsxfun(@times,Convert('norm',cross(pln(4:6),pln(7:9),2)),...   % selects points close to plane
        bsxfun(@minus,pln(1:3),pts)),2)) <= tol);                               % ...than tol
else
    c = true(n,1);                                                              % all points
end
d = Snap(pts(c,:),Polyline(ply),0);                                             % distances from polygon's edges
o = any(d <= tol,2);                                                            % selects points close to edges
b = c;                                                                          
b(c) = o;                                                                       % updates 'b'
c(c) = ~o;                                                                      % updates 'c'
pts = pts(c,:);                                                                 % points to be tested by inpolygon
if k == 3                                                                       % if 3d
    n = size(pts,1);
    pjs = Project([pts;ply],pln);                                               % projects all onto plane of points
    pts = pjs(1:n,:);                                                           % 2d points
    ply = pjs(n+1:end,:);                                                       % 2d polygon
end
[in,on] = inpolygon(pts(:,1),pts(:,2),ply(:,1),ply(:,2));                       % inside polygon test
c(c) = (in | on);                                                               % updates 'c' with inside or on
o = (b | c);                                                                    % final results
