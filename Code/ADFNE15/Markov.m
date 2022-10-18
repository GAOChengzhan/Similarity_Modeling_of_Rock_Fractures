function cs = Markov(P,cs,n)
% Markov
% generates Markov chain
%
% Usage...:
% cs = Markov(P,cs,n);
%
% Input...: P         (m,n),probabilities for states
%           cs        (1),current state=[1..m]
%           n         (1),number of iterations
% Output..: cs        (n),states
%
% Examples:
%{
s = Markov([0.3,0.5;0.1,0.3;0.6,0.2],1,40);
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

x = rand;                                                                       % uniform random number
p = [0,cumsum(P(cs(end),:)),1];
for cs = 1:numel(p)-1
    if ((p(cs) <= x) && (x < p(cs+1))); break; end                              % Markov selection
end
if n > 1
    cs = [cs,Markov(P,cs,n-1)];                                                 % recursive call
end
