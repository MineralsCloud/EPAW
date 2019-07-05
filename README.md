# `EPAW`: A code for evolutionary optimization of PAW datasets especially for high-pressure applications

[TOC]

## How to cite

The associated paper is published on [Computer Physics Communications](https://www.sciencedirect.com/science/article/pii/S0010465518301826).

Please cite this article as: Sarkar, Kanchan, N. A. W. Holzwarth, and Renata M. Wentzcovitch. "EPAW-1.0 code for evolutionary optimization of PAW datasets especially for high-pressure applications." *Computer Physics Communications* 233 (2018): 110-122.

## Quick start: installation

### Dependencies
- [`ATOMPAW`](http://users.wfu.edu/natalie/papers/pwpaw/man.html)
- [Quantum ESPRESSO](https://www.quantum-espresso.org)
- [Python](https://www.python.org)
- [`gnuplot`](http://www.gnuplot.info)
- at least 10*neos processors/cores, where neos is the number of volume points at which SCF calculations will be performed at each generation/iteration step using Quantum ESPRESSO.

There are two parent directories:
- `SOURCE`: having three subdirectories containing the source files and one script file `compile` to compile the source files.
- `EXAMPLE`: contains the necessary files to run the executables.

## Steps for preparing input files

1. 
   
   1. Go to directory `SOURCE`.
   
   2. Change the compiler (`ifort` or `gfortran`) according to preference in the file `compile`.
   
   3. Make the file `compile` readable, writable and executable with the following command:
   
      ```shell
      chmod 777 compile
      ```
   
   4. Run the file 'compile' with the following command:
   
      ```shell
      ./compile
      ```
      It will compile the fortran codes located in the subdirectories using `gfortran`/`ifort` compiler and create three executables: `EPAWsetup.exe`, `EPAWsetup.exe`, `EPAWopt.exe` and move them to the parent directory `SOURCE`. 
      
   5. Create a working folder/directory in which optimizations will be performed. 
   
   6. Set Your `$PATH` environment variable permanently using `.bashrc` or place the executables to the `EXAMPLE` directory.
   
   7. Copy all the contents of the `EXAMPLE` directory to your working directory.
   
2. Go to the working directory to execute following steps:

   1. open the file named as `APAW.sh`, replace the `atompaw` command (command to RUN `ATOMPAW` program), if required, according to your settings.
   
   2. edit the contents of the following files based on the system under consideration: `INPUT_FILES`, `IN_TARGET`, `INITIAL_ATOMPAW`, `IN_DUMMY`, `script.py`, `USER_INPUTS` as follows:
      
      1. `INPUT_FILES`: Contains names for the required/optional input files (We recommend not to change the names to avoid unnecessary complicacies.
      
         ```
         #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              INITIAL_ATOMPAW -MUST      #|File name for Initial standard PAW dataset generator
              IN_DUMMY        -MUST      #|File name for dummy indexes of standard PAW dataset generator
              IN_PARENT       -OPTIONAL  #|File name for Initial parent population
              IN_GAPRMTR      -OPTIONAL  #|File name for GAs parameters to start with
              IN_TARGET   -MUST/OPTIONAL #|File name for TARGET EoS 
         #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         ```
      
      2. `INITIAL_ATOMPAW`: The initial guess of `ATOMPAW` input file, we recommend use a standard library file (e.g., JTH data-set library) to start with. Here an example file for the atom Calcium is included.
      
      3. `IN_DUMMY`: Contains dummy indexes to recognize variables, parameters and keywords in the `INITIAL_ATOMPAW` file. This data needs careful preparation as follows. Here an example file for the atom Calcium is included:
      
         1. copy the `INITIAL_ATOMPAW` file to `IN_DUMMY`.
         
         2. put `0` for the keywords or for the entries in the `INPUT_DATASET` data that will not change in the course of optimization.
         
         3. put `7` for redundant lines in the `INPUT_DATASET` file.
         
         4. set `1`, `2`, `3`, `4` depending upon the number of iradial value entries in the `INPUT_DATASET` file (e.g., `rc`, `rshape`, `rvloc`, `rcore`)
         
            ```
            1 if rc
            2 if rc, rshape
            3 if rc, rshape, rvloc
            4 if rc, rshape, rvloc, rcore
            ```
         
         5. put `5` for energies for additional basis function.
         
         6. put `6` for matching radius for partial waves.
         
      4. `IN_PARENT`: Contains initial population of trial solution vector comprising of `rc`, `rshape`, `rvloc`, `rcore`, matching radii for pseudo and projector functions, reference energies for additional wave functions. i.e., a population of `npop` (10, for this version of the code) numbers different dataset. One with proficient expertise in `ATOMPAW` code should prepare this file otherwise choose not to provide any data and there should not be any `IN_PARENT` file. The code will extract the solution vector from the `INITIAL_ATOMPAW` file and replicate that `npop` times to start with.
      
      5. `IN_GAPRMTR`: Contains essential parameters to run genetic algorithms. Again to play with these settings one need some expertise in global optimization algorithms.
      
      6. `USER_INPUTS`: One can run the codes interactively, but we recommend to use this fil to avoid unnecessary complicacies.
         
       ```
       Put 0 for EoS; 1 for Delta optimization # This version of code supports only 0 
       Put 0 for scratch; 1 for predefined parent population
       Put Cardinality of parent population (e.g. 10) # This version of code supports 10
       Put Maximum allowed value for r_c >= r_{MT} (INPUT_DATASET)   MT= muffin-tin
       Put Minimum allowed value for r_c_ must be >=r_{MT}/2
       Put Minimum allowed value (other distance parameters)
       Put 1.00 for all of these if no preferenece for any pressure region. or e.g. P_ext=1.00d0,P_h=1.00d0,P_m=1.00d0,P_l=0.95
       Put tolerance limit for wf and PSwf < 10
       Put Number of volume points at which electronic structure calculations will be performed
       Put No. of PV data in < IN_TARGET > file = 400
       Put E0, V0, B0, B0p  guess for WIEN2k # although never used; 
       Put Vmin, Vmax     for WIEN2k  #      required only  if IN_ELAST file is used
       Put 0 for default; 1 for manual entry for rc constraints of each member of parent population # 0 is recommended; if 1 then put Rc max; Rc min; Rci min for each solution in the population
       ```
      
      7. `IN_TARGET`: Contains 400 (should be same as mentioned in the above `USER_INPUTS` file: line number 10) equally spaced EoS data (volume and pressure) of the reference that the optimization attempts to achieve. In this work, we take the `WIEN2k` results as our target reference. There are other two alternative file options: `EvsVRyBohr.dat` file containing volume and energy data obtained from all-electron calculations or `IN_ELAST` file containing equilibrium volume ($V_0$), Bulk modulus ($B_0$) and its derivative ($B'$) from the reference all electron calculation.
      
   3. Edit the file `makeEoSinputs.py` (with descriptive commentary) according to the system under consideration. Specially the following line numbers: line number `12`, `17`, `19`, `20`, (`20`, if `20`), `35-38`, `45` (adding more lnes here will change the following line numbers. so we recommend to change it at the end), `68-69` (according to the available system settings), `72-73`, `78` (uncomment when `ibrav=0`), `79` (comment when `79`), `80` (check ntyp, nspin), `81` (ecutwfc= kinetic energy cutoff (Ry) for wavefunctions, ecutrho= Kinetic energy cutoff (Ry) for charge density and potential), `82` (smearing), `87` (mixing_beta), `90` (Convergence threshold for selfconsistency), `91`, `101` (atomic Symbol), `106-110` (uncomment when ibrav=0), `113` (atomic Symbol), `132` (`0.78-1.06`, scale of contraction to expansion of equilibrium lattice constant according to the target all-electron reference calculation)

## Run the Fortran executables

1. Change the shell script `SETUP_FILES` as executable with `chmod 777 SETUP_FILES` and run the shell script. It will create necessary folders, run the first fortran executable `EPAWsetup.exe` in the folder `1_FORMAT_FILES` to format necessary files for the next stepsi and finally copy required files to the necessary folders. It will create the files: `PARAMETERS`, `CONSTRAINTS`, and if not present: `IN_GAPRMTR`, `IN_PARENT`, `IN_TARGET`.

2. The next step is to make diverse parents. In that case, this step will help to create a good initial populationi using the single string based code `CARMHC`.

   This step is necessary if one find difficulties in optimizing data-sets in the final step.
   
   Go to the directory `2_MAKE_PARENT/` and run the following command:
   ```shell
   ./EPAWmparent.exe < USER_INPUTS
   ```
   
   It will create the output files `log_ARCHV`, `log_EVOLFITNESS`, `log_EVOLINTNSTY`, `log_EVOLPROB`.
   `log_ARCHV` stores best npop number of solutions in terms of minimum area under the logarithmic derivative curves generated by all electron and PAW calculations for each angular momentum quantum number, while maintaining the constraints on the basis sets and logarithmic derivative curves. `log_EVOLFITNESS` stores the objetive values of the npop best string in each generation/iteration step. `log_EVOLINTNSTY`, `log_EVOLPROB` store the mutation intesity and mutation probability if restart is required. Besides these data show how the parameters varies and based on that one can set a better mutation intesity and mutation probability to start with.
   
   Copy `log_ARCHV` as `IN_PARENT` : `cp log_ARCHV IN_PARENT`
   
   Copy `IN_PARENT` to the directory `3_EOSOPTIMIZE` :  `cp IN_PARENT ../3_EOSOPTIMIZE/`
   
   Upto this point, everything is serial implementation. The final step requires access to multiple cores as mentioned earlier.
   
3. Go to the directory `3_EOSOPTIMIZE`

   1. run the python script `makeEoSinputs.py`: `python makeEoSinputs.py`. It will create directories (`pot$f`), subdirectories (`eos$e`), SCF input files and script files and a `maketmp` script. Edit the `maketmp` script according to the system settings. Each `pot$f` folder will have neos number of `eos$e` subfolder. Each `eos$e` subfolder contains one `scf.in` file. Manually check all the `scf.in` file for one arbitrary `pot$f` folder. If changes require, do it for all the `eos$e/scf.in` file and copy the contents of the `pot$f` folder to other `pot$f` folders. Specially check the location of the temporary file for Quantum ESPRESSO.
   
   2. open the file named as `scf_script.sh` and replace the following lines, if required, according to your settings.
   
      ```shell
      orig=0
      for j in `seq 1 10`; do # j is the dummy index for the number of data-sets in each iteration, i.e., cardinality of the GA population.
      	for i in `seq 1 15`; do # i is the dummy index for the number of volume points at which electronic structure calculations will be performed in each iteration/generation.
      		cd pot$j/eos$i/
      
              rm -r tmp
              ibrun -n 4 -o $orig pw.x -nk 2 -in scf.in >scf.out & # here and beneath 4 is the number of cores per SCF calculations.
              orig=`echo "$orig + 4" | bc`
              sleep 1
              cd ../../
      	done
      done
      wait
      # For the above setting we need at least 10*15*4=600 cores/processors in each iteration steps.
      # We recommend not to change the cardinality of the GA population, i.e., npop=10.
      # Now if one reduce the number of volume points at which electronic structure calculations will be performed to 7, and assign one core per job then the total number of required processors will be
      # 10*7*1=70
      # Therefore, according to the available system adjust the numbers.
      ```
   
      The rest of the part should be unaltered.
   
   3. change the number of nodes and tasks-per-node in the `jobscript` file. This is the final step: submission of the `jobscript`. It will create a `SUPERINDIVIDUAL` folder that will store the best data-set in each generation alongwith `O_ARCHV`, `O_EVOLFITNESS`, `O_SUPERINDV`. `O_ARCHV` stores best npop number of solutions in terms of minimum area under the EoS curves generated by refernce all electron approach and PAW calculations whereas `O_SUPERINDV` stores the best solution vector alongwith its objective value, `O_EVOLFITNESS` stores the objetive values of the npop best string in each generation/iteration step. 

## Check the goodness of the generated data-set 

```shell
chmod 777 Goodness.py
./Goodness.py
```



