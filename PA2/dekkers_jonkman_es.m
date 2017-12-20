function [xopt,fopt] = dekkers_jonkman_es(eval_budget)
	fileID  = fopen('tests/mean.txt', 'a');
	max_thickness = 10000; % search space [0,10000] nm
	
	mu = 50; % parent population size
	lambda = 100; % offspring population size
	layers = 30; % number of layers in multilayered system
	
	recomb_rate = 0.75; % recombination probability
	mut_rate = 0.25; % mutation probability
	tau = 1/(sqrt(2*sqrt(layers))); % local learning rate (Schwefel) 
	tauprime = 1/(sqrt(2*layers)); % global learning rate (Schwefel)
	
	pop = rand(mu,layers).*max_thickness; % randomly initialize population
	
	sigmas = zeros(mu,layers); % initialize individual sigmas
	sigmas(1:mu,1:layers) = max_thickness/4; % 1/4th of the search space size
	
	fitnesses = zeros(1, lambda); % initialize fitnesses

	% reproduction cycle
	for i = 1:eval_budget/lambda
		[offspring, newsigmas] = recombine(pop, sigmas, lambda, mu, layers, recomb_rate);
		[offspring, newsigmas] = mutate(offspring, newsigmas, lambda, mut_rate, tau, tauprime);

		% determine fitness of offspring
		for j = 1:lambda
			fitnesses(1,j) = str2num(optical(offspring(j,:)));
		end

		% select individuals for new population
		[pop,sigmas] = select(offspring, fitnesses, newsigmas, mu, layers);
		fopt = min(fitnesses)
		fprintf(fileID, '%5.4f,', fopt);
	end
	fprintf(fileID, '\n');
	[~,idx] = sort(fitnesses);
	xopt = pop(idx(1,1));
	fopt = fitnesses(idx(1,1));
end

% Applies selection to a solution vector
function [pop, sigmas] = select(offspring, fitnesses, newsigmas, mu, layers)
	[~,idx] = sort(fitnesses);
	bestidx = idx(1,1:mu);
	pop = offspring(bestidx,:);
	sigmas = newsigmas(bestidx,:);
end

% Applies mutation to a solution vector
function [offspring, newsigmas] = mutate(offspring, newsigmas, lambda, mut_rate, tau, tauprime)
	for i=1:lambda
		if rand() < mut_rate
			newsigmas(i,:) = newsigmas(i,:) * exp(tauprime * randn + tau * randn);
			offspring(i,:) = offspring(i,:) + newsigmas(i,:) * randn;
		end
	end
end

% Applies recombination to two solution vectors
function [offspring, newsigmas] = recombine(pop, sigmas, lambda, mu, layers, recomb_rate)
	offspring = zeros(lambda, layers);
	newsigmas = zeros(lambda, layers);
	for i=1:lambda
		par1 = randi([1,mu]);
		par2 = randi([1,mu]);
		while par1==par2
			par2 = randi([1,mu]);
		end
		for j=1:layers
			if rand() <= recomb_rate
				offspring(i,j) = pop(par1,j);
				newsigmas(i,j) = sigmas(par1,j);
			else
				offspring(i,j) = pop(par2,j);
				newsigmas(i,j) = sigmas(par2,j);
			end
		end
	end
end