function[xopt, fopt] = dekkers_jonkman_ga(n, eval_budget)
    crossover_rate = 0.1;
    
    pop_size = 20;
    population = zeros(pop_size, n);
    fitness = zeros(pop_size, 1);
    
    for i=1:pop_size
        population(i,:) = rand(n, 1) > 0.5;
        fitness(i) = labs(population(i,:));
    end    
    
    % Evolution loop %
    for i=1:1
        for j=1:pop_size
            mate1 = roulette_select(fitness);
            mate2 = roulette_select(fitness);
            [mate1, mate2] = crossover(mate1, mate2)
        end
        %population = new_population;
    end
end

function[mate1, mate2] = crossover(mate1, mate2)
    
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
