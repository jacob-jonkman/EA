function [xopt, fopt] = dekkers_jonkman_ga(n, eval_budget)
	tic

    plotting = true;
    
	% Set crossover and mutation rate %
	crossover_rate = 0.75;
	mutation_rate = 0.08;

	% Initialize population %
	pop_size = 50;
	population = zeros(pop_size, n); % declare pop_size solution vectors of length n
	fitness = zeros(pop_size, 1); % declare pop_size fitness values
	for i=1:pop_size
		population(i,:) = rand(n, 1) > 0.5; % randomly initialize solution i
		fitness(i) = labs(population(i,:)); % calculate fitness for solution i
    end
    i=0;
    evaluations = 0;
	% Evolution loop %
	while evaluations < eval_budget
		i = i+1
        new_population = zeros(pop_size, n); % declare new population (children)
		new_fitness = zeros(pop_size, 1); % declare new population fitness values
		j=1;
		while j <= pop_size
			% Select two candidates using roulette wheel selection
			candidate1 = population(roulette_select(fitness), :);
			candidate2 = population(roulette_select(fitness), :);

			% Apply crossover
			[candidate1, candidate2] = crossover(candidate1, candidate2, crossover_rate, n);

			% Apply mutation to both candidates
			candidate1 = mutation(candidate1, mutation_rate, n);
			candidate2 = mutation(candidate2, mutation_rate, n);

			% Add candidates to the new population
			new_population(j,:) = candidate1;
			new_population(j+1,:) = candidate2;

			% Compute fitnesses of new candidates
			new_fitness(j) = labs(candidate1);
			new_fitness(j+1) = labs(candidate2);

			j = j+2;
            evaluations = evaluations+2;
        end

		% Merge parent and children population, with their fitnesses. 
		% Sort based on fitness values, in ascending order
		both_pops = [vertcat(fitness, new_fitness), vertcat(population, new_population)];
		both_pops = sortrows(both_pops);

		% The last half of the population contains the candidates with the
		% highest fitnesses, so keep those candidates for the next
		% iteration
		population = both_pops(pop_size+1:pop_size*2, 2:1+n);
		fitness = both_pops(pop_size+1:pop_size*2, 1);

		% Find values of the best candidates
		fopt = fitness(pop_size);
		xopt = population(pop_size,:);

		% Statistics maintenance and plotting
		if plotting
			subplot(2, 1, 1)
			histf(i+1:i+1) = fopt;
			plot(histf(1:i+1))
			subplot(2,1,2)
			bar([1:n], xopt)
			xlim([1 n])
			drawnow();
		end
	end
	toc

	fopt = fitness(pop_size);
	xopt = population(pop_size,:);
end

function [candidate] = mutation(candidate, mutation_rate, len)
% Applies mutation to a solution vector and returns it
% Input:
%	candidate: solution vector of length n
%	mutation_rate: probability of mutation occurrence (bit flip)
%	len: solution vector length (n)
	for i=1:len
		if rand(1) <= mutation_rate
			candidate(i) = ~candidate(i);
		end
	end
end

function [mate1, mate2] = crossover(mate1, mate2, crossover_rate, len)
% Applies uniform crossover to two solution vectors and returns them
% Input:
%	mate1: solution vector of length n
%	mate2: solution vector of length n
%	crossover_rate: probability of crossover occurrence
%	len: solution vector length (n)
	for i=1:len
		if rand(1) <= crossover_rate
			temp = mate1;
			mate1 = [mate1(1:i), mate2(i+1:len)];
			mate2 = [mate2(1:i), temp(i+1:len)];
		end
	end
end

function i = roulette_select(fitness)
% Returns solution i as a result of proportional selection
% Input:
%	fitness: pop_size fitness values calculated from the population of solutions
	rand_num = rand() * sum(fitness);
	i = 0;
	summation = 0;
	while summation <= rand_num
		i = i + 1;
		summation = summation + fitness(i);        
	end
end

function f = labs(x)
% Autocorrelation of binary sequences
% Input:
% 	x : 1-d row binary vector
	n = length(x);
	y = x .* 2 - 1;
	E = zeros(1, n-1);
	for k = 1:n-1
		E(k) = (sum(y(1:n-k) .* y(1+k:n))).^2;
	end
	f = n^2 / (2 * sum(E));
end
