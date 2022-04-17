# Genetic Programming Toolbox for MATLAB

A framework for building genetic programming (GP) models.

The framework contains:
- The representation of genetic programs (parse trees)
- Genetic operators including natural selection, reproduction, and mutation
- An easy-to-use programming framework to build and train your GP models
- A template system to specify the nodes allowed for each type.

## What is Genetic Programming?

Genetic programming (GP) is an extension of genetic algorithms. GP encodes the parameters into a parse tree rather than a chromosome, which is normally represented as a string. A parse tree is a representation of a string's syntactic structure as described by some context-free grammar. It starts from a population of randomly generated programs, then tries to fit for a particular task by applying genetic operators iteratively over a number of generations. Finally, the optimization algorithm returns the best model in the population.

## Getting Started

1. Clone the project into your project
    
    ```bash
    git clone https://github.com/RapDoodle/Genetic-Programming-MATLAB.git ./gp
    ```

1. Add the toolbox to your MATLAB path

    ```matlab
    addpath('./gp');
    ```

1. Start programming.

## Documentation and Examples

You can find more documentation and examples in the [documentation folder](tree/main/model).

## License

This project is licensed under the MIT license. Copyright (c) 2022 Bohui WU.