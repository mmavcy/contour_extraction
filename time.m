runs = 3;
sumMs = zeros(1,10);
sumT = zeros(1,10);
for r = 1:runs
	r
	Ms = 10:10:100;
	T = zeros(size(Ms));
	for M = Ms
		%tic;script;t=toc;
		tic;script;t=toc;
		T(M/10) = t;
	end;
	sumMs = sumMs + Ms
	sumT = sumT + T
end;
avgMs = sumMs ./ runs;
avgT = sumT ./ runs;

figure(3); 
plot(avgMs, avgT, 'g+-', 'LineWidth' , .2);
xlabel('M');
ylabel('Time (seconds)');
