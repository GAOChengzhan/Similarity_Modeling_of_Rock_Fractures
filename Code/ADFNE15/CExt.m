classdef CExt
% CExt
% modified version of few functions from 'geom2d' and 'geom3d' packages
%
% License: read 'Ext_Licenses.pdf'#geom2d and geom3d
% intersectLineEdge  >> LineXEdge
% clipPolygon3dHP    >> ClipPolyHP
% isBelowPlane       >> isBelowPlane
% linePosition3d     >> linePosition3d
% planeNormal        >> planeNormal
% vectorCross3d      >> vectorCross3d
% intersectLinePlane >> LineXPlane
% createPlane        >> Plane
% normalizeVector3d  >> nvec3
% vectorNorm3d       >> vecn3
% clipEdge2          >> ClipLine
% projPointOnPlane   >> PointOnPlane
% isParallel         >> isParallel
% edgePosition       >> edgePosition
% intersectEdges     >> intersectEdges
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
    
    methods (Static)
        function pnt = LineXEdge(lin,edg)
            global Tolerance
            x0 =  lin(:,1); y0 =  lin(:,2);
            dx1 = lin(:,3); dy1 = lin(:,4);
            x1 =  edg(:,1); y1 =  edg(:,2);
            x2 = edg(:,3); y2 = edg(:,4);
            dx2 = x2-x1; dy2 = y2-y1;
            n1 = length(x0);
            n2 = length(x1);
            par = abs(dx1.*dy2-dx2.*dy1) < 1e-14;
            col = (abs((x1-x0).*dy1-(y1-y0).*dx1) < 1e-14) & par;
            xi(col) = Inf;
            yi(col) = Inf;
            xi(par & ~col) = NaN;
            yi(par & ~col) = NaN;
            i = ~par;
            if n1 == n2
                xi(i) = ((y1(i)-y0(i)).*dx1(i).*dx2(i)+x0(i).*dy1(i).*dx2(i)-x1(i)...
                    .*dy2(i).*dx1(i))./(dx2(i).*dy1(i)-dx1(i).*dy2(i));
                yi(i) = ((x1(i)-x0(i)).*dy1(i).*dy2(i)+y0(i).*dx1(i).*dy2(i)-y1(i)...
                    .*dx2(i).*dy1(i))./(dx1(i).*dy2(i)-dx2(i).*dy1(i));
            elseif n1 == 1
                xi(i) = ((y1(i)-y0).*dx1.*dx2(i)+x0.*dy1.*dx2(i)-x1(i).*dy2(i).*dx1)./...
                    (dx2(i).*dy1-dx1.*dy2(i));
                yi(i) = ((x1(i)-x0).*dy1.*dy2(i)+y0.*dx1.*dy2(i)-y1(i).*dx2(i).*dy1)./...
                    (dx1.*dy2(i)-dx2(i).*dy1);
            elseif n2 == 1
                xi(i) = ((y1-y0(i)).*dx1(i).*dx2+x0(i).*dy1(i).*dx2-x1(i).*dy2.*dx1(i))./...
                    (dx2.*dy1(i)-dx1(i).*dy2);
                yi(i) = ((x1-x0(i)).*dy1(i).*dy2+y0(i).*dx1(i).*dy2-y1(i).*dx2.*dy1(i))./...
                    (dx1(i).*dy2-dx2.*dy1(i));
            end
            pnt = [xi',yi'];
            out = find(~(Snap(pnt,edg,0) < Tolerance));
            pnt(out,:) = repmat([NaN,NaN],[length(out),1]);
        end
        
        function oly = ClipPolyHP(ply,pln)
            oly = zeros(0,3);
            if isempty(ply); return; end
            if sum(ply(end,:) == ply(1,:)) ~= 3; ply = [ply; ply(1,:)]; end
            b = CExt.isBelowPlane(ply,pln);
            if sum(b) == 0; return; end
            if sum(b) == length(b); oly = ply; return; end
            f = find(b ~= b([2:end 1]));
            lns = [ply(f,1),ply(f,2),ply(f,3),ply(f+1,1)-ply(f,1),ply(f+1,2)-...
                ply(f,2),ply(f+1,3)-ply(f,3)];
            lxp = CExt.LineXPlane(lns,pln);
            if b(1)
                oly = [ply(1:f(1),:); lxp; ply(f(2)+1:end,:)];
            else
                oly = [lxp(1,:); ply(f(1)+1:f(2),:); lxp(2,:)];
            end
            if sum(oly(end,:) == oly(1,:)) == 3; oly(end,:) = []; end
        end
        
        function below = isBelowPlane(point,varargin)
            if length(varargin)==1
                plane = varargin{1};
            elseif length(varargin)==2
                plane = CExt.Plane(varargin{1},varargin{2});
            end
            if size(point,1)==1
                point = repmat(point,[size(plane,1) 1]);
            end
            if size(plane,1)==1
                plane = repmat(plane,[size(point,1) 1]);
            end
            below = CExt.linePosition3d(point,[plane(:,1:3),...
                CExt.planeNormal(plane)]) <= 0;
        end
        
        function pos = linePosition3d(point,line)
            dp = bsxfun(@minus,point,line(:,1:3));
            vl = line(:,4:6);
            denom = sum(vl.^2,2);
            invalidLine = denom < eps;
            denom(invalidLine) = 1;
            pos = bsxfun(@rdivide,sum(bsxfun(@times,dp,vl),2),denom);
            pos(invalidLine) = 0;
        end
        
        function n = planeNormal(pln)
            m = size(pln);
            m(2) = 3;
            n = zeros(m);
            n(:) = CExt.vectorCross3d(pln(:,4:6,:),pln(:,7:9,:));
        end
        
        function c = vectorCross3d(a,b)
            sza = size(a);
            szb = size(b);
            switch sign(numel(sza) - numel(szb))
                case 1
                    c = zeros(sza);
                case -1
                    c = zeros(szb);
                otherwise
                    c = zeros(max(sza,szb));
            end
            c(:) =  bsxfun(@times,a(:,[2 3 1],:),b(:,[3 1 2],:))-...
                bsxfun(@times,b(:,[2 3 1],:),a(:,[3 1 2],:));
        end
        
        function pts = LineXPlane(lns,pln)
            n = bsxfun(@times,pln([5,6,4]),pln([9,7,8]))-...
                bsxfun(@times,pln([8,9,7]),pln([6,4,5]));
            dp = bsxfun(@minus,pln(1:3),lns(:,1:3));
            dn = sum(bsxfun(@times,n,lns(:,4:6)),2);
            t = sum(bsxfun(@times,n,dp),2) ./ dn;
            pts = bsxfun(@plus,lns(:,1:3),bsxfun(@times,[t,t,t],lns(:,4:6)));
            pts(abs(dn) < 1e-14,:) = NaN;
        end
        
        function pln = Plane(p0,var)
            n = CExt.nvec3(var);
            v0 = [1,0,0];
            inds = CExt.vecn3(cross(n,v0,2)) < 1e-14;
            v0(inds,:) = repmat([0,1,0],[sum(inds),1]);
            v1 = CExt.nvec3(cross(n,v0,2));
            v2 = -CExt.nvec3(cross(v1,n,2));
            pln = [p0,v1,v2];
        end
        
        function vn = nvec3(v)
            vn = bsxfun(@rdivide,v,sqrt(sum(v.^2,2)));
        end
        
        function n = vecn3(v)
            n = sqrt(sum(v.*v,2));
        end
        
        function [y,b] = ClipLine(x,bbx)
            [x1,y1,x2,y2] = CData.Deal(bbx);                                    % for convenience
            dx1 = [x1,y1,x2-x1,0];
            dx2 = [x1,y2,x2-x1,0];
            dy1 = [x1,y1,0,y2-y1];
            dy2 = [x2,y1,0,y2-y1];
            out1 = [x(:,1) < x1,x(:,1) > x2,x(:,2) < y1,x(:,2) > y2];
            out2 = [x(:,3) < x1,x(:,3) > x2,x(:,4) < y1,x(:,4) > y2];
            in = (sum(out1 | out2,2) == 0);
            inx = find(~(in | (sum(out1 & out2,2) > 0)));
            y = nan(size(x));
            y(in,:) = x(in,:);
            for i = 1:length(inx)
                lin = x(inx(i),:);
                pts  = [CExt.LineXEdge(dx1,lin);CExt.LineXEdge(dx2,lin);...
                    CExt.LineXEdge(dy1,lin);CExt.LineXEdge(dy2,lin);...
                    lin(1:2);lin(3:4)];
                pts  = pts(all(isfinite(pts),2),:);
                pts = sortrows(pts);
                cts = (pts(2:end,:)+pts(1:end-1,:))/2;
                in = find((cts(:,1) >= x1) & (cts(:,2) >= y1) &...
                    (cts(:,1) <= x2) & (cts(:,2) <= y2));
                if length(in) > 1
                    dv = pts(in+1,:)-pts(in,:);
                    len = hypot(dv(:,1),dv(:,2));
                    [~,I] = max(len);
                    in = in(I);
                end
                if length(in) == 1
                    if (lin(1) > lin(3)) || ((lin(1) == lin(3)) && ...
                            (lin(2) > lin(4)))
                        y(inx(i),:) = [pts(in+1,:),pts(in,:)];
                    else
                        y(inx(i),:) = [pts(in,:),pts(in+1,:)];
                    end
                end
            end
            b = ~all(isnan(y),2);                                               % mask for all items
            y = y(b,:);
        end
        
        function pnt = PointOnPlane(pnt,pln)
            m = size(pln);
            m(2) = 3;
            [ogs,nrm] = deal(zeros(m));
            ogs(:) = pln(:,1:3,:);
            nrm(:) = CExt.vectorCross3d(pln(:,4:6,:),pln(:,7:9,:));
            dp = bsxfun(@minus,ogs,pnt);
            t = bsxfun(@rdivide,sum(bsxfun(@times,nrm,dp),2),sum(nrm.^2,2));
            pnt = bsxfun(@plus,pnt,bsxfun(@times,t,nrm));
        end
        
        function point = intersectEdges(lin1,lin2)
            global Tolerance;
            tol = Tolerance;
            x0 = 0;
            y0 = 0;
            par = CExt.isParallel(lin1(3:4)-lin1(1:2),lin2(3:4)-lin2(1:2));
            col = abs((lin2(1)-lin1(1)).*(lin1(4)-lin1(2))- ...
                ((lin2(2)-lin1(2)).*(lin1(3)-lin1(1))) < tol) & par;
            x0(par & ~col) = NaN;
            y0(par & ~col) = NaN;
            if sum(col) > 0
                resCol = Inf*ones(size(col));
                t1 = CExt.edgePosition(lin2(col,1:2),lin1(col,:));
                t2 = CExt.edgePosition(lin2(col,3:4),lin1(col,:));
                if t1 > t2
                    tmp = t1;
                    t1 = t2;
                    t2 = tmp;
                end
                resCol(col(t2 < -tol)) = NaN;
                resCol(col(t1 > 1+tol)) = NaN;
                x0(col) = resCol(col);
                y0(col) = resCol(col);
                t = col(abs(t2) < tol);
                x0(t) = lin1(t,1);
                y0(t) = lin1(t,2);
                t = col(abs(t1-1) < tol);
                x0(t) = lin1(t,3);
                y0(t) = lin1(t,4);
            end
            i = find(~par);
            if sum(i) > 0
                x1 = lin1(i,1);
                y1 = lin1(i,2);
                dx1 = lin1(i,3)-x1;
                dy1 = lin1(i,4)-y1;
                x2 = lin2(i,1);
                y2 = lin2(i,2);
                dx2 = lin2(i,3)-x2;
                dy2 = lin2(i,4)-y2;
                delta = (dx2.*dy1-dx1.*dy2);
                x0(i) = ((y2-y1).*dx1.*dx2+x1.*dy1.*dx2-x2.*dy2.*dx1)./delta;
                y0(i) = ((x2-x1).*dy1.*dy2+y1.*dx1.*dy2-y2.*dx2.*dy1)./-delta;
                t1 = ((y0(i)-y1).*dy1+(x0(i)-x1).*dx1)./(dx1.*dx1+dy1.*dy1);
                t2 = ((y0(i)-y2).*dy2+(x0(i)-x2).*dx2)./(dx2.*dx2+dy2.*dy2);
                out = (t1 < -tol) | (t1 > 1+tol) | (t2 < -tol) | (t2 > 1+tol);
                x0(i(out)) = NaN;
                y0(i(out)) = NaN;
            end
            point = [x0,y0];
        end
        
        function pos = edgePosition(pnt,lin)
            nEdges = size(lin,1);
            nPoints = size(pnt,1);
            if nPoints == nEdges
                dxe = (lin(:,3)-lin(:,1))';
                dye = (lin(:,4)-lin(:,2))';
                dxp = pnt(:,1)-lin(:,1);
                dyp = pnt(:,2)-lin(:,2);
            else
                dxe = (lin(:,3)-lin(:,1))';
                dye = (lin(:,4)-lin(:,2))';
                dxp = bsxfun(@minus,pnt(:,1),lin(:,1)');
                dyp = bsxfun(@minus,pnt(:,2),lin(:,2)');
            end
            pos = (dxp.*dxe+dyp.*dye)./(dxe.*dxe+dye.*dye);
        end
        
        function b = isParallel(v1,v2)
            b = abs(v1(:,1).*v2(:,2)-v1(:,2).*v2(:,1)) < 1e-14;
        end
    end
end
