from random import randint, seed, choice
from os import mkdir
from itertools import combinations, product
import itertools
from collections import namedtuple
from jinja2 import Template
import pathlib
import math
from operator import itemgetter

PDDL_TEMPLATE = Template('''(define (problem {{problem_name}})
  (:domain crew-planning)
  (:objects
  {%- for o in objs %} 
    {{o.name}} - {{o.type}} 
  {%- endfor %}
  )

  (:init
  {%- for c in crew %}
    (currentday {{c.name}} {{days[0].name}})
    (done_sleep {{c.name}} {{days[0].name}})
    (available {{c.name}})
  {%- endfor %}

  {%- for i in range(0,days|length-1) %}
    (next {{days[i].name}} {{days[i+1].name}})
  {%- endfor %}
    (initiated {{days[1].name}})

  {%- for e in exercise_equipment %}
    (unused {{e.name}})
  {%- endfor %}
  )

  (:goal
    (and
  {%- for c in crew %}
    {%- for i in range(1,days|length-1) %}
      (done_sleep {{c.name}} {{days[i].name}})
    {%- endfor %}
  {%- endfor %}


      (initiated {{days[-1].name}})
    {% for t in rpcm_tasks %}
      (done_rpcm {{t.rpcm.name}} {{t.day.name}})
    {%- endfor %}

    {%- for t in mcs_tasks %}
      (mcs_finished {{t.medical_state.name}} {{t.day.name}})
    {%- endfor %}

    {% for t in payload_tasks %}
      -(payload_act_completed {{t.payload_act.name}} {{t.day.name}})
    {%- endfor %}
    )
  )
)
''')

PDDLObject = namedtuple('Object', ['name', 'type'])


MCSTask = namedtuple('MCSTask', ['medical_state', 'day'])
RPCMTask = namedtuple('RPCMTask', ['rpcm', 'day'])
PayloadActTask = namedtuple('PayloadActTask', ['payload_act', 'day'])


def mk_crew_members(n):
  return [PDDLObject(name=("c"+str(i)), type='CrewMember') for i in range(n)]

def mk_medical_states(n):
  return [PDDLObject(name=("mcs"+str(i)), type='MedicalState') for i in range(n)]

def mk_filter_states(n):
  return [PDDLObject(name=("filter"+str(i)), type='FilterState') for i in range(n)]

def mk_day(i):
  return PDDLObject(name=("day"+str(i)), type='Day')

def mk_days(m,n):
  return [mk_day(i) for i in range(m,n)]

def mk_rpcms(n):
  return [PDDLObject(name=("rpcm"+str(i)), type='RPCM') for i in range(n)]

def mk_payload_acts(n):
  return [PDDLObject(name=("pa"+str(i)), type='PayloadAct') for i in range(n)]

def mk_exercise_equipment(n):
  return [PDDLObject(name=("ee"+str(i)), type='ExerEquipment') for i in range(n)]



def make_rpcm_task(day, rpcm):
  return RPCMTask(day=day, rpcm=rpcm)

def make_mcs_task(day, mcs):
  return MCSTask(day=day, medical_state=mcs)

def make_payload_act_task(day, payload_act):
  return PayloadActTask(day=day, payload_act=payload_act)

def make_day_task_set(day_num, num_rpcms, num_mcs, num_payloads):
  rpcms = mk_rpcms(num_rpcms)
  mcs = mk_medical_states(num_mcs)
  pas = mk_payload_acts(num_payloads)

  day = mk_day(day_num)

  rpcm_tasks = [make_rpcm_task(day, r) for r in rpcms]
  mcs_tasks = [make_mcs_task(day, m) for m in mcs]
  pa_tasks = [make_payload_act_task(day, pa) for pa in pas]
  return (rpcm_tasks + mcs_tasks + pa_tasks, num_rpcms, num_mcs, num_payloads)

# add the remaining tasks
def make_tasks1(day_num, num_rpcms, max_cost):
  mcs_cost=1
  tasks = []
  if max_cost < 0:
    max_cost = 0 # otherwise get no tasks when the cost has been consumed
  
  # for num_mcs in range(0, max_cost+1):
  #   num_payloads=max_cost-num_mcs
  #   tasks.append(make_day_task_set(day_num, num_rpcms, num_mcs, num_payloads))
  return [make_day_task_set(day_num, num_rpcms, max_cost+1, 0)]

# cost here is roughly time/60 or 61
def make_tasks(day_num, crew_num, unsolvable=False):
  # a few variations of tasks for a day
  crew_capacity = 8
  rpcm_cost = 7

  tasks = []
  if unsolvable:
    # A crew member spends 600 minutes sleeping and 10 minutes post-sleeping.
    # The day lasts 960 minutes.
    # 120 minutes are spent exercising and with a meal.
    # 230 minutes left, which is three full hours of completing tasks.

    max_rpcms = 3*crew_num # these take 7 hours each
    max_cost = (crew_capacity + 12) * crew_num
    for num_rpcms in range(0, max_rpcms+1):
      tasks += make_tasks1(day_num, num_rpcms, max_cost- (num_rpcms*7))
  else:
    for num_rpcms in range(0, 1):
      tasks += make_tasks1(day_num, num_rpcms, 1)

  return tasks

def is_easy_task_set(crew_num, task_set):
  tasks, num_rpcms, num_mcs, num_payloads = task_set
  print ("crew: %d, rpcm: %d" % (crew_num, num_rpcms))
  return (crew_num <= num_rpcms)

def update_required_elements(task_sets):
  max_num_rpcms = max(task_sets, key=itemgetter(1))[1]
  max_num_mcs = max(task_sets, key=itemgetter(2))[2]
  max_num_payloads = max (task_sets, key=itemgetter(3))[3]
  return (task_sets, max_num_rpcms, max_num_mcs, max_num_payloads)

def make_all_tasks(crew_num, days, unsolvable_day):
  # some tasks are unsovable due to 
  # makes tasks and calculates the maximum of each number, so that the correct objects are declared
  days_tasks=[make_tasks(d, crew_num, (d == unsolvable_day)) for d in range(1,days+1)]
  # we have three lists of sets of tasks
  # we need to obtain all combinations
  sets_of_days = product(*days_tasks)
  # [((tasks, num_rpcms, num_mcs, num_payload), (tasks, ...), ...), ...]
  sets_of_days = [update_required_elements(tasks) for tasks in sets_of_days]
  # ([((tasks, ...), ...), ...], max_num...)
  return sets_of_days

# there should be very easy problems that 

def get_numeric_identifier(daily_tasks):
  # payload tasks are the hardest -- it makes sense to place their number first when identifying instances
  identifiers =\
    [num_payloads for tasks, num_rpcms, num_mcs, num_payloads in daily_tasks] +\
    [num_mcs for tasks, num_rpcms, num_mcs, num_payloads in daily_tasks] +\
    [num_rpcms for tasks, num_rpcms, num_mcs, num_payloads in daily_tasks]
  return identifiers

def main():
    seed(42)
    pathlib.Path("instances").mkdir(parents=True, exist_ok=True)
    max_crew_members=2
    max_days=1 

    for crew_mem in range(1, max_crew_members+1): # number of crew
      for num_days in range(1, max_days+1): # number of days
        for unsolvable_day in range(1, num_days+1): # the day that is unsolvable
            for tasks in make_all_tasks(crew_mem, num_days, unsolvable_day): 
              # one impossible assignment of tasks given the number of days and crew
              # we obtain the daily sets of tasks and the maximum number of each object needed (the tasks can reuse objects and the tasks are identifiable by object and day) 
              # the maximum number needed is sufficient to initialise the sets of objects
              daily, max_num_rpcms, max_num_mcs, max_num_payload = tasks
              nums = [crew_mem, num_days, unsolvable_day] + get_numeric_identifier(daily)

              daily_tasks = [tasks for tasks, num_rpcms, num_mcs, num_payloads in daily]

              tasks = list(itertools.chain(*daily_tasks))

              rpcm_tasks = [task for task in tasks if isinstance(task, RPCMTask)]
              mcs_tasks = [task for task in tasks if isinstance(task, MCSTask)]
              payload_tasks = [task for task in tasks if isinstance(task, PayloadActTask)]


              pname = "instance"
              [pname := pname + "_" + str(n) for n in nums] # instance_._._._._._.

              crew = mk_crew_members(crew_mem)
              days = mk_days(0,num_days+2) # need one extra day
              rpcms = mk_rpcms(max_num_rpcms)
              mcs = mk_medical_states(max_num_mcs)
              payloads = mk_payload_acts(max_num_payload)
              filters = mk_filter_states(0)
              exercise_equipment = mk_exercise_equipment(crew_mem)

              objs = crew + days + rpcms + mcs + payloads + filters + exercise_equipment

              txt = PDDL_TEMPLATE.render(problem_name=pname,
                                      objs=objs,
                                      crew=crew,
                                      exercise_equipment=exercise_equipment,
                                      days=days,
                                      rpcm_tasks=rpcm_tasks,
                                      mcs_tasks=mcs_tasks,
                                      payload_tasks=payload_tasks)
              with open("instances/%s.pddl" % pname, 'wt') as fh:
                  fh.write(txt)

# we want days, crew members, and some pseudo random assignment of tasks that is more than possible

if __name__ == '__main__':
    main()
