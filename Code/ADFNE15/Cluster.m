function c = Cluster(s)
% Cluster
% builds clusters from "s" based on common elements
%
% Usage...:
% c = Cluster(s);
%
% Input...: s         cell,indices
% Output..: c         cell,clusters
%
% Examples:
%{
c = Cluster([1,2;3,5;2,9]); % = {[1,2,9],[3,5]}
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

Ticot('Clustering');                                                            % initializes timing
if isempty(s); c = {}; return; end                                              % returns if input is empty
if ~iscell(s); s = num2cell(s,2); end                                           % converts to cell
while true                                                                      % infinite loop
    m = length(s);                                                              % finds size of current 's'
    united = false(m,1);                                                        % nothing is clustered yet
    c = cell(m,1);                                                              % initializes the output
    u = 0;                                                                      % counter
    for i = 1:m-1
        if united(i); continue; end                                             % go to the next if united
        p = s{i};
        for j = i+1:m                                                           % skips known items
            q = s{j};
            com = intersect(p,q);                                               % finds common elements
            if ~isempty(com)                                                    % if something is in common
                p = union(p,q);                                                 % unite them
                s{i} = p;                                                       % updates 's'
                united(j) = true;                                               % marks united
            end
        end
        u = u+1;
        c{u} = p;                                                               % updates 'c'
    end
    if ~united(m)                                                               % if not united
        u = u+1;
        c{u} = s{m};                                                            % copy the last item
    end
    c = c(1:u);                                                                 % masks out empty cells
    if any(united)                                                              % if there was a progress 
        s = c;
    else                                                                        % all are united, i.e., clustered
        c = s;
        break                                                                   % exits the loop
    end
end
Ticot;                                                                          % ends timing
