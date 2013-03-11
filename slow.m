% Read in a png file into a Matlab matrix and invert colour
im = imread( 'tongue.png' );
% Convert the image to have values in the range 0 - 1
im = double(im);
imax = max( max(im) );
imin = min( min(im) );
im = (im - imin) / (imax - imin);
% Display the image
figure(1);
imagesc(im);
colormap(gray);
axis square;
% Load contour 1
ctr1 = load( 'init1.ctr' );
hold on; plot( ctr1(:,1) , ctr1(:,2) , 'r+-' , 'LineWidth' , .2 );
% Load contour 2
ctr2 = load( 'init2.ctr' );
hold on; plot( ctr2(:,1) , ctr2(:,2) , 'r+-' , 'LineWidth' , .2 );

%invert colours
im = 255 - im;

%search space extraction
N = size(ctr1, 1); % pts on each contour
%M = 50; % pts per line perpendicular to contours
areas = M+1; % distance between contours implicitely split into M+1 areas

intensity = zeros(M,N);
X = zeros(M,N);
Y = zeros(M,N);

for m = 1 : M
    ctr = round( m/areas * ctr1 + (areas-m)/areas * ctr2 );
    %hold on; plot( ctr(:,1) , ctr(:,2) , 'g+-' , 'LineWidth' , .2 );
    for n = 1 : N
        pt = ctr(n,:);
        X(m,n) = pt(1);
        Y(m,n) = pt(2);
        intensity(m,n) = im(pt(2),pt(1));
    end;
end;


l = 0.5 ; % weight on continuity vs intensity
pos = zeros(N,M,M);
score = zeros(N,M,M);

for n = 2:(N-1)
    for mcurr = 1:M
        curr = [n,mcurr];
        for mnext = 1:M
            next = [n+1,mnext];
            candidate = zeros(M,1);
            for mprev = 1:M
                prev = [n-1,mprev];
                %continuity = ((mnext-2*mcurr+mprev)^2)/((mnext-mprev)^2);
                path = next - 2*curr + prev;
                direct = next - prev;
                continuity = (path * path') / (direct * direct');
                energy = l*continuity + (1-l)*intensity(mcurr,n);
                candidate(mprev) = score(n-1,mprev,mcurr) + energy;
            end;
            [min_val, min_index] = min(candidate);
            score(n,mcurr,mnext) = min_val;
            pos(n,mcurr,mnext) = min_index;
        end;
    end;
end;


%backtracking
% find the minimum value in column N-1 of the (3D) score matrix
% its height index (min_index) is the row to be plotted for column N
% its row index (min_row) is the row to be plotted for column N-1
% pos(N-1, min_row, min_index) is the row to be plotted for column N-2
% the height index at which to find the row for N-3 is the previous value of min_row

%init based on penultimate column of score
[min_val_per_index, min_row_per_index] = min(score(N-1,:,:));
[min_val, min_index] = min(min_val_per_index);

%locate min on penultimate column
min_row = min_row_per_index(min_index);

contour = zeros(N-2, 2);
for n = N-1:-1:2
    contour(n-1,:) = [ X(min_row, n) , Y(min_row, n) ];
    
    temp = min_row;
    min_row = pos(n,min_row,min_index);
	min_index = temp;
end;

hold on; plot( contour(:,1) , contour(:,2)  , 'g+-' , 'LineWidth' , .2 );

figure (2);imagesc (intensity);colormap ( gray );axis square

