function [ots,msk] = Project(pts,pln)
% Project
% returns projection of points 'pts' on plane 'pln', reduces dimension
%
% Usage...:
% [ots,msk] = Project(pts,pln);
%
% Input...: pts       (n,3),points
%           pln       (9),plane
% Output..: ots       (n,2),projected points
%           msk       filtered dimensions
%
% Examples:
%{
ots = Project(rand(10,3),[0,0,0,1,0,0,0,1,0]);
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

vec = @(v)sqrt(sum(v.*v,2));                                                    % vector length function
if nargin < 2                                                                   % removes less important dimension
    [~,dim] = min(max(pts)-min(pts)); 											
    msk = true(size(pts,2),1);
    msk(dim) = false;
    ots = pts(:,msk);
else                                                                            % 3D to 2D projection
    p0 = pln(1:3);
    d1 = pln(4:6);
    d2 = pln(7:9);
    n = size(pts,1);
    if n == 1                                                                   % only one point
        s = dot(bsxfun(@minus,pts,p0),d1,2)./vec(d1);
        t = dot(bsxfun(@minus,pts,p0),d2,2)./vec(d2);
    else                                                                        % many points
        d1 = d1/vec(d1);
        d2 = d2/vec(d2);
        f = ones(n,1);
        s = dot(bsxfun(@minus,pts,p0),d1(f,:),2);
        t = dot(bsxfun(@minus,pts,p0),d2(f,:),2);
    end
    ots = [s,t];
    msk = NaN;                                                                  % not applicable
end
