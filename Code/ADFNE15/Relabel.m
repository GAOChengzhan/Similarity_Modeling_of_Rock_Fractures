function Ra = Relabel(La)
% Relabel
% updates labels based on frequencies
%
% Usage...:
% Ra = Relabel(La);
%
% Input...: La        (n),labels
% Output..: Ra        (n),updated labels
%
% Examples:
%{
Ra = Relabel([1,1,-1,2,2,-2,1,2,3]); % = [2,2,-1,3,3,-2,2,3,1]
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

k = max(La);                                                                    % highest label
frq = zeros(k,1,'int32');
for i = 1:k                                                                     % frequency of each label
    frq(i) = sum(La == i);
end
[~,idx] = sort(frq);                                                            % sorts based on their frequencies
Ra = La;                                                                        % initializes
for i = 1:k                                                                     % loops over all labels
    Ra(La == idx(i)) = i;                                                       % applies relabeling
end
