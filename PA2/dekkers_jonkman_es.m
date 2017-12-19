function [xopt,fopt] = dekkers_jonkman_es(eval_budget)
    max_thickness = 10000;
    lambda = 100;
    layers = 30;
    pop_size = 50;
    recomb_rate = 0.75;
    mut_rate = 0.25;
    tau = 1/(sqrt(2*sqrt(layers)));
    tauprime = 1/(sqrt(2*layers));
    
    pop = rand(pop_size,layers).*max_thickness; % randomly initialize population
    sigmas = zeros(pop_size,layers); % initialize individual sigmas
    sigmas(1:pop_size,1:layers) = max_thickness/4;
    
    for i = 1:eval_budget/lambda
        i
        [offspring, newsigmas] = recombine(pop, sigmas, lambda, pop_size, layers, recomb_rate);
        [offspring, newsigmas] = mutate(offspring, newsigmas, lambda, mut_rate, tau, tauprime);
        fitnesses = zeros(1, lambda);
        tic
        for j = 1:lambda
            fitnesses(1,j) = str2num(optical(offspring(j,:)));
        end
        toc
        [pop,sigmas] = select(offspring, fitnesses, newsigmas, pop_size, layers);
        min(fitnesses)
    end
end

function [pop, sigmas] = select(offspring, fitnesses, newsigmas, pop_size, layers)
    [~,idx] = sort(fitnesses);
    bestidx = idx(1,1:pop_size);
    pop = offspring(bestidx,:);
    sigmas = newsigmas(bestidx,:);
end

function [offspring, newsigmas] = mutate(offspring, newsigmas, lambda, mut_rate, tau, tauprime)
    for i=1:lambda
        if rand() < mut_rate
            newsigmas(i,:) = newsigmas(i,:)*exp(tauprime*normrnd(0,1) + tau*normrnd(0,1));
            offspring(i,:) = offspring(i,:) + newsigmas(i,:) * normrnd(0,1);
        end
    end
end

function [offspring, newsigmas] = recombine(pop, sigmas, lambda, pop_size, layers, recomb_rate)
    offspring = zeros(lambda, layers);
    newsigmas = zeros(lambda, layers);
    for i=1:lambda
        par1 = randi([1,pop_size]);
        par2 = randi([1,pop_size]);
        while par1==par2
            par2 = randi([1,pop_size]);
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