
## Code from
Most of the Python files are originally from: https://doi.org/10.6084/m9.figshare.12620582

- The code to create PDDL instances was inspired by a file from:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/

# Dependencies

## TAMER and nuXmv

- TAMER was taken from:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/
- nuXmv can be found here: https://nuxmv.fbk.eu/

## OPTIC

Follow the instructions in: https://github.com/KavrakiLab/optic


## Verified encoding from temporal planning to timed automata

Follow the instructions in `sources/temporal-planning-certifications` to make this build.

```sh
mv -t . sources/temporal-planning-certification/ML/out/plan_cert
```

## Muntac (certificate checker)

`sources/temporal-planning-certifications/Readme.md` contains instructions to install Isabelle and the 2025 Isabelle AFP as a component.

Once the AFP is added run the following to build the certificate checker:

```sh
isabelle build -e Munta_Certificate_Checker
mv -t . <path>/<to>/<afp>/thys/Munta_Certificate_Checker/muntac
```

# How to use

The makefile contains a few examples:
```
make benchmark_minimal_all
```

