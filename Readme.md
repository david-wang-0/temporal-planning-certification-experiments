
## Code from
Most of the Python files are originally from: https://doi.org/10.6084/m9.figshare.12620582

- The code to create PDDL instances was inspired by a file from:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/

# Dependencies

## Python 3

Get from https://www.python.org/downloads/

## TAMER and nuXmv

- TAMER was taken from:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/
- nuXmv can be found here: https://nuxmv.fbk.eu/

Please place the executables into this project's root directory.

## Timing and shell
### GNU time
The benchmarks use [GNU time](https://www.gnu.org/software/time/). 
Many shells have a `time` command, but make sure GNU time is used.
It is more powerful, because it can measure memory usage (RSS).

### bash
[GNU bash](https://www.gnu.org/software/bash/) is needed to run benchmarks.

They will run with `zsh`, provided you have `bash` installed.

## NextFLAP

The following will make it build:
```sh
cd sources/nextFLAP
make all
cd ../..
mv -t . sources/nextFLAP/nextflap
```

## POPF2/3
The following will make it build:
```sh
cd sources/popf2
./build
cd ../..
mv -t . sources/popf2/compile/popf2/popf3-clp  
```

## OPTIC

The instructions in `sources/optic` will make this build.

```sh
mv -t . sources/optic/build/src/optic/optic-clp
```

## Temporal Fast Downward

```sh
cd sources/tfd
./build
```

Please do not move any files

## Verified encoding from temporal planning to timed automata

The instructions in `sources/temporal-planning-certifications` will make this build.

Please place the `plan_cert` executable into this project's root directory.

## Muntac (certificate checker)

`sources/temporal-planning-certifications/Readme.md` contains instructions to install Isabelle and the 2025 Isabelle AFP as a component.

Once the AFP is added run the following to build the certificate checker:

```sh
isabelle build -d . -be Munta_Certificate_Checker
```

`sources/temporal-planning-certifications/lib/afp-2025/thys/Munta_Certificate_Checker` 

