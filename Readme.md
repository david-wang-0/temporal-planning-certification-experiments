# This Readme and artifact

This is the artifact for the paper: "Formally Verified Certification of Unsolvability of Temporal Planning Problems"

This `README` contains information regarding:
- The software used and how to build it from sources when necessary.
- The sources of code and programs used.

This artifact contains:
- An appendix to our paper.
- The grounded PDDL domains and instances used in our benchmarks in: : `sources/temporal-planning-certification/examples`
- The code for our verified encoder and instructions to build it in: `sources/temporal-planning-certification`

## We have taken some code from
The code to create PDDL instances is taken from and changed:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/

# Dependencies

## TAMER

TAMER was taken from:  https://es-static.fbk.eu/people/amicheli/resources/aaai22/

## nuXmv

nuXmv (Version 2.1.0 (November 29, 2024)) can be found here: https://nuxmv.fbk.eu/

## UPPAAL 

UPPAAL (Uppaal 5.0.0) can be found here: https://uppaal.org/

## OPTIC

Follow the instructions in: https://github.com/KavrakiLab/optic

## Grounder

OPTIC's grounder is used for our benchmarks. Unfortunately, we 

## Verified encoding from temporal planning to timed automata

Follow the instructions in `sources/temporal-planning-certifications` to make the code build

```sh
mv -t . sources/temporal-planning-certification/ML/out/plan_cert
```
