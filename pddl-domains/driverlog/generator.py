from random import randint, seed, choice
from os import mkdir
from itertools import combinations
from collections import namedtuple
from jinja2 import Template
import pathlib

PDDL_TEMPLATE = Template('''(define (problem {{problem_name}})
  (:domain driverlog)
  (:objects
  {% for d in drivers %} {{d.name}} {%- endfor %} - driver
  
  {% for t in trucks %} {{t.name}} {%- endfor %} - truck

  {% for l in locations %} {{l.name}} {%- endfor %} - location
  )

  (:init
    {% for path in footpaths %}
      (path {{path.l1.name}} {{path.l2.name}})
      (path {{path.l2.name}} {{path.l1.name}})
    {%- endfor %}
    {% for path in links %}
      (link {{path.l1.name}} {{path.l2.name}})
      (link {{path.l2.name}} {{path.l1.name}})
    {%- endfor %}
    {% for l in starting_locs %}
      (loc {{l.locatable.name}} {{l.location.name}})
    {%- endfor %}
  )

  (:goal
    (and
    {%- for l in ending_locs %}
      (loc {{l.locatable.name}} {{l.location.name}})
    {%- endfor %}
    )
  )
)
''')

Robot = namedtuple('Robot', ['name', 'dur_c1', 'dur_c2', 'dur_d'])

Driver = namedtuple('Driver', ['name'])
Truck = namedtuple('Truck', ['name'])
Location = namedtuple('Location', ['name'])

Path = namedtuple('Path', ['l1', 'l2'])

Loc = namedtuple('Loc', ['locatable', 'location'])

def mk_starting_locations(n):
    return [Location(name=("s%d" % i)) for i in range(n)]

def mk_ending_locations(n):
    return [Location(name=("e%d" % i)) for i in range(n)]

def mk_drivers(n):
    return [Driver(name=("d%d" % i)) for i in range(n)]

def mk_trucks(n):
    return [Truck(name=("t%d" % i)) for i in range(n)]

def mk_path(l1, l2):
    return Path(l1=l1, l2=l2)

def mk_scc(locs):
    return [mk_path(l1, l2) for l1, l2 in combinations(locs, 2)]

def mk_loc(locatable, location):
    return Loc(locatable=locatable, location=location)

def rand_locs(locatables, locations):
    return [mk_loc(locatable, choice(locations)) for locatable in locatables]

def main():
    seed(42)
    pathlib.Path("instances\").mkdir(parents=True, exist_ok=True)
    for nt in range(1, 4):
        for nd in range(1, 4):
            for ns in range(1, 4):
                for ne in range(1, 4):
                    
                    pname = "instance_%d_%d_%d_%d" % (nt, nd, ns, ne)

                    trucks = mk_trucks(nt)
                    drivers = mk_drivers(nd)
                    starting_locations = mk_starting_locations(ns)
                    ending_locations = mk_ending_locations(ne)
                    locations = starting_locations + ending_locations

                    starting_scc = mk_scc(starting_locations)
                    ending_scc = mk_scc(ending_locations)

                    footpaths = starting_scc + ending_scc

                    roads = starting_scc + ending_scc + [mk_path(choice(starting_locations), choice(ending_locations))]

                    starting_locs = rand_locs(drivers + trucks, starting_locations)
                    ending_locs = rand_locs(drivers, starting_locations) + rand_locs(trucks, ending_locations)

                    txt = PDDL_TEMPLATE.render(drivers=drivers,
                                            trucks=trucks,
                                            locations=locations,
                                            starting_locs=starting_locs,
                                            ending_locs=ending_locs,
                                            footpaths=footpaths,
                                            links=roads,
                                            problem_name=pname)
                    with open("instances/%s.pddl" % pname, 'wt') as fh:
                        fh.write(txt)


if __name__ == '__main__':
    main()
