function b = Isolated(lns,tol)
% Isolated
% tests lines "lns" for isolation, 2D|3D
%
% Usage...:
% b = Isolated(lns,tol);
%
% Input...: lns       (n,4|6),lines
%           tol       (1),tolerance
% Output..: b         (n),boolean
%
% Examples:
%{
b = Isolated(lns);
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
if nargin < 2; tol = Tolerance; end                                             % default tolerance
[n,k] = size(lns);
k = k/2;
p1s = lns(:,1:k);                                                               % first endpoint of lines
p2s = lns(:,k+1:end);                                                           % second endpoint of lines
pts = [p1s;p2s];
b = false(n,1);                                                                 % initializes mask 'b'
for i = 1:n
    b(i) = (Occurrence(p1s(i,:),pts,tol) <= 1) | ...                            % find frequency of points
        (Occurrence(p2s(i,:),pts,tol) <= 1);                                    % ...masks if isolated
end
