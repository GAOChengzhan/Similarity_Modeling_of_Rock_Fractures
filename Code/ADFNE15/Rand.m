function out = Rand(varargin)
% Rand
% generates random numbers, see examples below
%
% Usage...:
% out = Rand(varargin);
%
% Input...: varargin  {'fun':e|f|a|d|l...,'ab':limits}
% Output..: out       any
%
% Examples:
%{
x = Rand(10,'fun','f','mu',45,'k',1,'ab',[0,90]);
x = Rand(10,'fun','f','mu',45,'k',0);
x = Rand(10,'fun',@rand,'ab',[0,1]);
x = Rand(10,'fun','e','mu',0.5,'ab',[0,1]);
ags = Rand(10,'fun','a','mu',10,'ab',[0,90]);
pts = Rand(10,'fun','d','d',0.1,'ab',[0,0,0;1,1,1]);
lns = Rand(10,'fun','l','ab',rand(3,2),'d',[0.03,0.01],'mu',[0,10]);
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

opt = Option(varargin,'fun',@rand,'ab',[0,1],'d',0.1,'mu',0,'k',0);             % default arguments
if isa(opt.fun,'function_handle')                                              	% random numbers [low..high]
    if numel(opt.in) == 1; opt.in = [opt.in,1]; end
    out = Scale(opt.fun(opt.in),0,1,opt.ab(1),opt.ab(2));                       % random numbers between a and b
else
    switch opt.fun                                                              % selects function
        case {'e','exp'}                                                        % random exponential, low bound
            L = expcdf(opt.ab(1),opt.mu);                                       % random exponential, high bound
            U = expcdf(opt.ab(2),opt.mu);
            if numel(opt.in) == 1; opt.in = [opt.in,1]; end
            out = expinv(L+(U-L).*rand(opt.in),opt.mu);                         % random numbers
        case {'f','fisher'}                                                     % random Fisher [0..360);
            if CData.Almost(opt.k,0,1e-6)                                       % if kappa almost zero
                if numel(opt.in) == 1; opt.in = [opt.in,1]; end
                out = Scale(rand(opt.in),0,1,0,360);                            % uniform random from [0..360)
            else
                ra = Convert('rad',opt.mu);                                     % to radian
                a = 1+sqrt((1+4*opt.k.^2));
                b = (a-sqrt(2*a))/(2*opt.k);
                r = (1+b^2)/(2*b);
                out = zeros(opt.in,1);
                for i = 1:opt.in
                    while true                                                  % infinite loop
                        u = rand(3,1);
                        z = cos(pi*u(1));
                        f = (1+r*z)/(r+z);
                        c = opt.k*(r-f);
                        if (u(2) < c*(2-c)) || ~(log(c)-log(u(2))+1-c < 0)
                            break;
                        end
                    end
                    out(i) = angle(exp(1i*(ra+sign(u(3)-0.5)*acos(f))));        % random Fisher
                end
                out = Angle(Convert('deg',out),360);                            % ensures [0..360)
                if opt.ab(2) == 90                                              % random dip angles [0..90]
                    fx = opt.mu-45;                                             % a fix
                    out = [];
                    while length(out) < opt.in                                  % until requested number
                        ags = fx+Scale(Rand(opt.in,'fun','f','mu',180,'k',...   % random Fisher
                            opt.k),0,360,0,90);
                        f = ((0 <= ags) & (ags <= 90));
                        out = [out;ags(f)];
                    end
                    out = out(1:opt.in);
                end
            end
        case {'a','ang'}                                                        % random angles separated by a
            da = opt.ab(2)-opt.ab(1);
            out = uniquetol(rand(int32(2*da/opt.mu),1)*da+opt.ab(1),opt.mu,...  % output (unique items)
                'ByRow',true,'DataScale',1);
        case {'d','dist'}                                                       % random points separated by d
            dim = numel(opt.ab(1,:));
            dd = opt.ab(2,:)-opt.ab(1,:);
            if isfield(opt,'in'); opt.d = (prod(dd)/opt.in)^(1/dim); end
            d = opt.d/(dim^0.5);
            out = opt.ab(1,:)+uniquetol(rand(int32(2*prod(dd./d)),dim).*dd,d,...  % output (unique items)
                'ByRow',true,'DataScale',1);
        case {'l','line'}                                                       % random lines in polygon
            ply = opt.ab;
            px = ply(:,1);
            py = ply(:,2);
            xx = [min(px),max(px)];
            yy = [min(py),max(py)];
            out = zeros(opt.in,4);
            [h,dh] = CData.Deal(opt.d);
            [ang,da] = CData.Deal(Convert('rad',opt.mu));
            i = 0;
            while i < opt.in
                x1 = Scale(rand,0,1,xx(1),xx(2));
                y1 = Scale(rand,0,1,yy(1),yy(2));
                rr = (2*rand(1,2)-1);
                [dx,dy] = pol2cart(ang+rr(1)*da,h+rr(2)*dh);
                x2 = x1+dx;
                y2 = y1+dy;
                if inpolygon([x1,x2],[y1,y2],px,py)                             % inpolygon test
                    i = i+1;
                    out(i,:) = [x1,y1,x2,y2];
                end
            end
    end
end
