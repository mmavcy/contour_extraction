function [intensities,X,Y] = searchspace(im,ctr1,ctr2,M)

N = size(ctr1, 1); % pts on each contour
areas = M+1;% distance between contours implicitely split into M+1 areas

intensities = zeros(M,N);
X = zeros(M,N);
Y = zeros(M,N);

for m = 1 : M
    ctr = round( m/areas * ctr1 + (areas-m)/areas * ctr2 );
    for n = 1 : N
        pt = ctr(n,:);
        X(m,n) = pt(1);
        Y(m,n) = pt(2);
        intensities(m,n) = im(pt(2),pt(1));
    end;
end;
