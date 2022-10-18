function lns = Pointline(pts,ids)
% Pointline
% creates lines from points "pts" based on indices "ids"
%
% Usage...:
% lns = Pointline(pts,ids);
%
% Input...: pts       (n,2|3),points
%           ids       (k,2),indices
% Output..: lns       (k,4|6),lines
%
% Examples:
%{
lns = Pointline(rand(5,2),[1,2;2,3;1,4]); % = 3 lines
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

n = size(ids,1);
lns = zeros(n,size(pts,2)*2);                                                   % initializes lines
for i = 1:n
    lns(i,:) = Reshape(pts(ids(i,:),:),1,[]);                                   % updates lines
end
