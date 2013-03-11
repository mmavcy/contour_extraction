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
% Contour 1
ctr1 = load( 'init1.ctr' );%ctrx=[101:250];ctry(1:150)=100;ctr1=[ctrx',ctry'];
hold on; plot( ctr1(:,1), ctr1(:,2), 'r-', 'LineWidth', .2 );
% Contour 2
ctr2 =  load( 'init2.ctr' );%ctrx = [101:250]; ctry(1:150) = 89; ctr2 = [ctrx',ctry'];
hold on; plot( ctr2(:,1) , ctr2(:,2) , 'r-' , 'LineWidth' , .2 );
% Invert colours
im = 255 - im;


N = size(ctr1, 1); % pts on each contour
%M = 10; % pts per line perpendicular to contours
[intensities,X,Y] = searchspace(im,ctr1,ctr2,M); % Extract search space given init contours

lambda = 0.5 ; % weight on continuity vs intensity

pos = zeros(N,M,M);
score = zeros(N,M,M);

curr = zeros(M,2);
next = zeros(M,2);
eachprev = zeros(M,2);

% foreach column
for n = 2:(N-1)

    % foreach row in current column
    for mcurr = 1:M 
        curr(1:M,1) = mcurr;
        curr(1:M,2) = n;

        % foreach row in next column
        for mnext = 1:M
            
            next(1:M, 1) = mnext;
            next(1:M, 2) = n+1;

            % FORALL rows in previous column
            eachprev(1:M, 1) = 1:M;
            eachprev(1:M, 2) = n-1;
            
            % distances based on indices in intensity matrix
            path = next - 2*curr + eachprev;
            direct = next - eachprev;
            
            % continuity = path magnitude over direct magnitude
            % detect division with zero and warn
            denom = sum(direct'.^2);
            if any(0==denom),'division with zero',end;
            continuity = sum(path'.^2) ./ denom;

            % energies of current point forall previous-column points
            intensity = (1-lambda)*intensities(mcurr,n); % scalar
            energies = lambda*continuity' + intensity; % vector

            % possible total scores
            candidates = score(n-1,:,mcurr)' + energies;

            % choose the row from the previous column that minimizes the score
            [min_val, min_index] = min(candidates);

            % store it (given the row of the current column and the row of the next column)
            score(n,mcurr,mnext) = min_val;
            pos(n,mcurr,mnext) = min_index;
        end;
    end;
end;
 
%%%%%% Backtracking %%%%%%%%
% find the minimum value in column N-1 of the (3D) score matrix
% its row index (min_row) is the row to be plotted for column N-1
% the value in pos(N-1, min_row, min_height) is the row to be plotted for column N-2
% min_row for N-1 becomes the new min_height in N-2 to find the row for N-3

[min_val_per_height, min_row_per_height] = min(score(N-1,:,:));
[min_val, min_height] = min(min_val_per_height);
min_row = min_row_per_height(min_height);

contour = zeros(N-2, 2);

for n = N-1:-1:2
    contour(n-1,:) = [ X(min_row, n) , Y(min_row, n) ];
    
    temp = min_row;
    min_row = pos(n,min_row,min_height);
    min_height = temp;
end;

hold on; plot( contour(:,1) , contour(:,2)  , 'g-' , 'LineWidth' , .2 );

figure (2);imagesc (intensities);colormap ( gray );axis square
