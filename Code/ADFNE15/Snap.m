function varargout = Snap(pts,lns,tol)
% Snap
% snaps points "pts" to lines "lns"|returns distance of points from lines
%
% Usage...:
% varargout = Snap(pts,lns,tol);
%
% Input...: pts       (n,2|3),points
%           lns       (k,4|6),lines
%           tol       (1),tolerance
% Output..: varargout {points,mask|distances}
%
% Examples:
%{
pts = Snap(rand(1000,2),rand(2,4)); % 2d
pts = Snap(rand(1000,3),rand(2,6)); % 2d
d = Snap(rand(1000,2),rand(3,4),0); % 2d distances, = 1000x3
d = Snap(rand(1000,3),rand(3,6),0); % 3d distances, = 1000x3
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
if nargin < 3; tol = Tolerance; end                                             % default tolerance
k = size(pts,2);                                                                % determine 2D or 3D
lns = lns';
dx = (lns(k+1,:)-lns(1,:));                                                     % for convenience
dy = (lns(k+2,:)-lns(2,:));
if k == 2                                                                       % 2D case
    d = dx.*dx+dy.*dy;
else                                                                            % 3D case
    dz = (lns(k+3,:)-lns(3,:));
    d = dx.*dx+dy.*dy+dz.*dz;
end
f = (d < eps);
d(f) = 1;
ddx = bsxfun(@minus,pts(:,1),lns(1,:));
ddy = bsxfun(@minus,pts(:,2),lns(2,:));
if k == 2                                                                       % 2D case
    t = bsxfun(@rdivide,bsxfun(@times,ddx,dx)+bsxfun(@times,ddy,dy),d);
else                                                                            % 3D case
    ddz = bsxfun(@minus,pts(:,3),lns(3,:));
    t = bsxfun(@rdivide,bsxfun(@times,ddx,dx)+bsxfun(@times,ddy,dy)+...
        bsxfun(@times,ddz,dz),d);
end
t(:,f) = 0;
t(t < 0) = 0;
t(t > 1) = 1;
p = bsxfun(@times,t,dx);
q = bsxfun(@times,t,dy);
if k == 2                                                                       % 2D case
    d = hypot(p-ddx,q-ddy);
else                                                                            % 3D case
    r = bsxfun(@times,t,dz);
    d = sqrt((p-ddx).^2+(q-ddy).^2+(r-ddz).^2);
end
if tol == 0
    varargout = {d};                                                            % distances
else
    f = (d <= tol);                                                             % mask
    for i = 1:size(f,1)
        w = find(f(i,:));
        if isempty(w); continue; end
        w = w(1);
        if k == 2                                                               % 2D case
            pts(i,:) = [lns(1,w)+p(i,w),lns(2,w)+q(i,w)];
        else                                                                    % 3D case
            pts(i,:) = [lns(1,w)+p(i,w),lns(2,w)+q(i,w),lns(3,w)+r(i,w)];
        end
    end
    varargout = {pts,f};                                                        % snapped points, and mask
end
