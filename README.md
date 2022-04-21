# Genetic Programming Toolbox for MATLAB

A framework for building genetic programming (GP) models.

The framework contains:
- The representation of genetic programs (parse trees)
- Genetic operators including natural selection, reproduction, and mutation
- An easy-to-use programming framework to build and train your GP models
- A template system to specify the nodes allowed for each type.
- A genetic algorithm optimization framework (you can choose not to use GP).

## What is Genetic Programming?

Genetic programming (GP) is an extension of genetic algorithms. GP encodes the parameters into a parse tree rather than a chromosome, which is normally represented as a string. A parse tree is a representation of a string's syntactic structure as described by some context-free grammar. It starts from a population of randomly generated programs, then tries to fit for a particular task by applying genetic operators iteratively over a number of generations. Finally, the optimization algorithm returns the best model in the population.

## Getting Started

1. Clone the project into your project
    
    ```bash
    git clone https://github.com/RapDoodle/Genetic-Programming-MATLAB.git ./gp
    ```

1. Add the toolbox to your MATLAB path

    ```matlab
    addpath(genpath('./gp'));
    ```

1. Start codeing.

## Documentation and Examples

You can find more documentation and examples in the [documentation folder](./docs).

### Table of Contents
1. [Introduction](./docs/1.%20Intoduction.md).
1. Components
    1. [Node](./docs/2.1%20Node.md)
    1. [Variable](./docs/2.2%20Variable.md)
    1. [Signal](./docs/2.3%20Signal.md)
    1. [Template](./docs/2.4%20Template.md)
    1. [GAMember](./docs/2.5%20GAMember.md)
    1. [GPMember](./docs/2.6%20GPMember.md)
    1. [GAModel](./docs/2.7%20GAModel.md)
    1. [GPModel](./docs/2.8%20GPModel.md)
1. Examples
    1. [Genetic programming based trading bot]()
        - [Project page]()

Note: The development documentation is not available at the moment. But the code does contain an extensive amount of comments.

## License

This project is licensed under the MIT license. Copyright (c) 2022 Bohui WU.