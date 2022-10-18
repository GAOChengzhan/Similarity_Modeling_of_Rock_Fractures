function [h,v,p] = Variogram(d,g,s,md,draw)
% Variogram
% computes and draws Variogram of data
%
% Usage...:
% [h,v,p] = Variogram(d,g,s,md,draw);
%
% Input...: d         distances
%           g         gammas
%           s         (1),variance
%           md        (1),minimum lag factor
%           draw      (1),boolean
% Output..: h         lags
%           v         variogram values
%           p         counts
%
% Examples:
%{
[h,v,p] = Variogram(d,g,v,3,true); % inputs from Variocloud
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
% Updated.: 2018-01-01

if size(d,2) > 1                                                                % d is points 'pts'
    [d,g,s] = Variocloud(d,g,[],false);                                         % g is variable, values
end                                                                             % otherwise d is distances, g gammas
if nargin < 5; draw = false; end                                                % defaults values
if (nargin < 4) || isnan(md); md = 3; end
if nargin < 3; s = 0; end
lag = md*min(d);                                                                % lag
hmd = 0.5*max(d);
k = floor(hmd/lag);                                                             % number of lags
lgs = ceil(d/lag);                                                              % maps distances to lags
h = zeros(k,1);                                                                 % initializes vectors, lags
p = zeros(k,1);                                                                 % ...counts
v = zeros(k,1);                                                                 % ...mean gamma
for i = 1:k
    f = (lgs == i);                                                             % selected lags (mapped distances)
    h(i) = mean(d(f));                                                          % mean distance
    p(i) = sum(f == 1);                                                         % count
    v(i) = mean(g(f));                                                          % mean gamma = variogram
end
if draw
    cla;                                                                        % clears current axis
    plot(h,v,'.');                                                              % plots as points
    hold on;
    plot([0,max(h)],[s,s],'r:');                                                % plots variance line
    xlabel('h'); ylabel('gamma'); axis square tight; box on;                    % labels, etc.
    title('Variogram'); Axes(0,'p',5);                                          % title, expands axes by 5%
end
