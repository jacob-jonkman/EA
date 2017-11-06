function [xopt, fopt] = dekkers_jonkman_ga(n, eval_budget)
    tic
     
    crossover_rate = 0.5;
    mutation_rate = 0.5;
    
    pop_size = 50;
    population = zeros(pop_size, n);
    fitness = zeros(pop_size, 1);
    
    for i=1:pop_size
        population(i,:) = rand(n, 1) > 0.5;
        fitness(i) = labs(population(i,:));
    end
    
    % Evolution loop %
    for i=1:eval_budget
        new_population = zeros(pop_size, n);
        new_fitnesses = zeros(pop_size, 1);
        j=1;
        while j <= pop_size
            % Apply roulette selection %
            candidate1 = population(roulette_select(fitness), :);
            candidate2 = population(roulette_select(fitness), :);
            
            % Apply crossover %
            [candidate1, candidate2] = crossover(candidate1, candidate2, crossover_rate, n);
            
            % Apply mutation to both candidates %
            candidate1 = mutation(candidate1, mutation_rate, n);
            candidate2 = mutation(candidate2, mutation_rate, n);
            
            % Add candidates to the new population %
            new_population(j,:) = candidate1;
            new_population(j+1,:) = candidate2;
            
            % Compute fitnesses of new candidates %
            new_fitnesses(j) = labs(candidate1);
            new_fitnesses(j+1) = labs(candidate2);
            
            j = j+2;
        end
             
        both_pops = [vertcat(fitness,new_fitnesses), vertcat(population, new_population)];
        both_pops = sortrows(both_pops);
        population = both_pops(pop_size+1:pop_size*2, 2:1+n);
        fitness = both_pops(pop_size+1:pop_size*2, 1);

        max(fitness)
    end
    toc
end

function [candidate] = mutation(candidate, mutation_rate, length)
    for i=1:length
        if rand(1) <= mutation_rate
            candidate(i) = ~candidate(i);
        end
    end
end

function [mate1, mate2] = crossover(mate1, mate2, crossover_rate, length)
    for i=1:length
        if rand(1) <= crossover_rate
            save = mate1;
            mate1 = [mate1(1:i), mate2(i+1:length)];
            mate2 = [mate2(1:i), save(i+1:length)];
        end
    end
end

function i = roulette_select(fitness)
    rand_num = rand() * sum(fitness);
    i = 0;
    summed = 0;
    while summed <= rand_num
        i = i + 1;
        summed = summed + fitness(i);        
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
