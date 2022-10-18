function k = Occurrence(pts,rts,tol)
% Occurrence
% finds occurrence of points "pts" in set of points "rts", nD
%
% Usage...:
% k = Occurrence(pts,rts,tol);
%
% Input...: pts       (m,?),points,candidates
%           rts       (n,?),points,source
%           tol       (1),tolerance of distance
% Output..: k         (m),occurrence number for each point in pts
%
% Examples:
%{
n = 1000;
pts = rand(n,3);
f = randi(10,1,100);
i = randi(n,1,100);
j = repelem(i,f);
rts = pts(j,:);
k = Occurrence(rts,rts);
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
n = size(pts,1);
k = zeros(n,1);
tol = tol*tol;                                                                  % for speed
for i = 1:n                                                                     % loops over all points
    %k(i) = sum(all(sum((rts-pts(i,:)).^2,2) <= tol,2));                        % tests for closeness, MatlabR2017
    k(i) = sum(all(sum((bsxfun(@minus,rts,pts(i,:))).^2,2) <= tol,2));          % tests for closeness, MatlabR2015
end
