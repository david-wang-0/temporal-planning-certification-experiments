TCHECKER_CERT=-b tck-covreach -b cert-conv -b muntac-cert-check


# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)
# popf3 also segfaults on some domains...

TAMER=-b tamer-ctp -b tamer-ftp
TAMER_GROUND=-b tamer-ctp-ground -b tamer-ftp-ground

PLANNERS=-b tfd -b optic -b popf3-ground -b nextflap 

MODEL_CHECKERS=-b tck-aLU -b nuxmv -b uppaal

MODEL_CHECKERS2=-b nuxmv -b uppaal

MODEL_CHECKERS2_GROUND=-b nuxmv-ground -b uppaal-ground 

GROUNDING=-b grounder

VERIFIED_ENCODER=-b verified-encoder

MODEL_CONV=-b model-converter

PIPELINE=$(GROUNDING) $(VERIFIED_ENCODER) $(MODEL_CONV) $(TCHECKER_CERT)

BENCHMARKS=$(PIPELINE) $(TAMER) $(TAMER_GROUND) $(PLANNERS) $(MODEL_CHECKERS) $(MODEL_CHECKERS2_GROUND)

RESULTS=results.$(shell date +%s).csv

MINIMAL_BENCHMARKS=$(PIPELINE) $(TAMER_GROUND) $(MODEL_CHECKERS2_GROUND) -b optic


# time out and memory
TIMEOUT=20s
LONGER_TIMEOUT=1800s

MEMORY=56000000 # in kB. Should be 56 GB

MATCHCELLAR=pddl-domains/MatchCellar-impossible
SYNC=pddl-domains/sync-impossible
PAINTER=pddl-domains/painter-impossible
DRIVERLOG_1=pddl-domains/driverlog-1
DRIVERLOG_2=pddl-domains/driverlog-2
DRIVERLOG_3=pddl-domains/driverlog-3
DRIVERLOG_4=pddl-domains/driverlog-4
DRIVERLOG_5=pddl-domains/driverlog-5
DRIVERLOG_6=pddl-domains/driverlog-6

MAJSP_1=pddl-domains/majsp-impossible-1-1
MAJSP_2=pddl-domains/majsp-impossible-1-2
MAJSP_3=pddl-domains/majsp-impossible-1-3
MAJSP_4=pddl-domains/majsp-impossible-1-4
MAJSP_5=pddl-domains/majsp-impossible-1-5
MAJSP_6=pddl-domains/majsp-impossible-1-6

PAINTER_1=pddl-domains/painter-impossible-1
PAINTER_2=pddl-domains/painter-impossible-2
PAINTER_3=pddl-domains/painter-impossible-3
PAINTER_4=pddl-domains/painter-impossible-4
PAINTER_5=pddl-domains/painter-impossible-5
PAINTER_6=pddl-domains/painter-impossible-6

PAINTER_DIRS := $(wildcard pddl-domains/painter-impossible-*)
MAJSP_DIRS := $(wildcard pddl-domains/majsp-impossible-1-*)

15MIN=900s
8GMEM=8000000

clean:
	rm $(wildcard pddl-domains/majsp-impossible-1-*/instances/instance_*.pddl)
	rm $(wildcard pddl-domains/painter-impossible-*/instances/instance_*.pddl)


create_driverlog_instances_1:
	cd $(DRIVERLOG_1); python -m generator

create_driverlog_instances_2:
	cd $(DRIVERLOG_2); python -m generator

create_majsp_instances_1:
	cd $(MAJSP_1); python -m generator

create_majsp_instances_2:
	cd $(MAJSP_2); python -m generator

create_majsp_instances_3:
	cd $(MAJSP_3); python -m generator

create_majsp_instances_4:
	cd $(MAJSP_4); python -m generator

create_majsp_instances_5:
	cd $(MAJSP_5); python -m generator

create_majsp_instances_6:
	cd $(MAJSP_6); python -m generator

create_majsp_instances: create_majsp_instances_1 create_majsp_instances_2 create_majsp_instances_3 create_majsp_instances_4 create_majsp_instances_5 create_majsp_instances_6

create_painter_instances_1:
	cd $(PAINTER_1); python -m generator

create_painter_instances_2:
	cd $(PAINTER_2); python -m generator

create_painter_instances_3:
	cd $(PAINTER_3); python -m generator

create_painter_instances_4:
	cd $(PAINTER_4); python -m generator

create_painter_instances_5:
	cd $(PAINTER_5); python -m generator

create_painter_instances_6:
	cd $(PAINTER_6); python -m generator

create_painter_instances: create_painter_instances_1 create_painter_instances_2 create_painter_instances_3 create_painter_instances_4 create_painter_instances_5 create_painter_instances_6

create_instances: create_painter_instances create_driverlog_instances_1 create_driverlog_instances_2 create_majsp_instances

benchmark_longer_matchcellar:
	./run.sh -f longer_MatchCellar_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(BENCHMARKS)

benchmark_longer_sync:
	./run.sh -f longer_sync_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(SYNC) $(BENCHMARKS)

benchmark_longer_painter: create_painter_instances
	./run.sh -f longer_painter_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(PAINTER) $(BENCHMARKS)

benchmark_longer_driverlog_1: create_driverlog_instances_1
	./run.sh -f longer_driverlog_1_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG_1) $(BENCHMARKS)

benchmark_longer_driverlog_2: create_driverlog_instances_2
	./run.sh -f longer_driverlog_2_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG_2) $(BENCHMARKS)

benchmark_longer_majsp: benchmark_longer_driverlog_1 .WAIT benchmark_longer_driverlog_2

benchmark_longer_majsp_1: create_majsp_instances_1
	./run.sh -f longer_majsp_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MAJSP_1) $(BENCHMARKS)

benchmark_longer_majsp_2: create_majsp_instances_1
	./run.sh -f longer_majsp_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MAJSP_2) $(BENCHMARKS)

benchmark_longer_majsp: benchmark_longer_majsp_1 .WAIT benchmark_longer_majsp_2
	
benchmark_longer_all: benchmark_longer_driverlog_1 benchmark_longer_driverlog_2 benchmark_longer_matchcellar benchmark_longer_sync benchmark_longer_painter benchmark_longer_majsp_1 benchmark_longer_majsp_2




benchmark_short_matchcellar:
	./run.sh -f short_MatchCellar_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(BENCHMARKS)

benchmark_short_sync:
	./run.sh -f short_sync_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(SYNC) $(BENCHMARKS)

benchmark_short_painter: create_painter_instances
	./run.sh -f short_painter_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(PAINTER) $(BENCHMARKS)

benchmark_short_driverlog_1: create_driverlog_instances_1
	./run.sh -f short_driverlog_1_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG_1) $(BENCHMARKS)

benchmark_short_driverlog_2: create_driverlog_instances_2
	./run.sh -f short_driverlog_2_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG_2) $(BENCHMARKS)

benchmark_short_driverlog: benchmark_short_driverlog_1 .WAIT benchmark_short_driverlog_2

benchmark_short_majsp_1: create_majsp_instances_1
	./run.sh -f short_majsp_1_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_1) $(BENCHMARKS)

benchmark_short_majsp_2: create_majsp_instances_2
	./run.sh -f short_majsp_2_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_2) $(BENCHMARKS)
	
benchmark_short_majsp: benchmark_short_majsp_1 .WAIT benchmark_short_majsp_2

benchmark_short_all: benchmark_short_driverlog_1 benchmark_short_driverlog_2 benchmark_short_matchcellar benchmark_short_sync benchmark_short_painter benchmark_short_majsp_1 benchmark_short_majsp_2

# benchmark_short_majsp_tamer_etc: create_majsp_instances_1 create_majsp_instances_2
# 	./run.sh -f short_majsp_1_tamer_etc_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_1) $(TAMER) $(TAMER_GROUND) $(MODEL_CHECKERS2_GROUND)
# 	./run.sh -f short_majsp_2_tamer_etc_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_2) $(TAMER) $(TAMER_GROUND) $(MODEL_CHECKERS2_GROUND)

# benchmark_short_matchcellar_tamer_etc:
# 	./run.sh -f short_matchcellar_tamer_etc_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(TAMER) $(MODEL_CHECKERS2) $(MODEL_CHECKERS2_GROUND)

# benchmark_short_sync_tamer_etc:
# 	./run.sh -f short_sync_tamer_etc_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(SYNC) $(TAMER) $(TAMER_GROUND) $(MODEL_CHECKERS2_GROUND)

# benchmarks_1234: benchmark_short_matchcellar_tamer_etc .WAIT benchmark_short_sync_tamer_etc .WAIT benchmark_short_majsp .WAIT benchmark_short_painter


benchmark_minimal_painter_1: create_painter_instances_1
	./run.sh -f minimal_painter_1_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_1) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter_2: create_painter_instances_2
	./run.sh -f minimal_painter_2_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_2) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter_3: create_painter_instances_3
	./run.sh -f minimal_painter_3_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_3) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter_4: create_painter_instances_4
	./run.sh -f minimal_painter_4_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_4) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter_5: create_painter_instances_5
	./run.sh -f minimal_painter_5_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_5) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter_6: create_painter_instances_6
	./run.sh -f minimal_painter_6_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(PAINTER_6) $(MINIMAL_BENCHMARKS)

benchmark_minimal_painter: benchmark_minimal_painter_1 benchmark_minimal_painter_2 benchmark_minimal_painter_3 benchmark_minimal_painter_4 benchmark_minimal_painter_5 benchmark_minimal_painter_6

benchmark_minimal_majsp_1: create_majsp_instances_1
	./run.sh -f minimal_majsp_1_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_1) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp_2: create_majsp_instances_2
	./run.sh -f minimal_majsp_2_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_2) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp_3: create_majsp_instances_3
	./run.sh -f minimal_majsp_3_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_3) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp_4: create_majsp_instances_4
	./run.sh -f minimal_majsp_4_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_4) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp_5: create_majsp_instances_5
	./run.sh -f minimal_majsp_5_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_5) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp_6: create_majsp_instances_6
	./run.sh -f minimal_majsp_6_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MAJSP_6) $(MINIMAL_BENCHMARKS)

benchmark_minimal_majsp: benchmark_minimal_majsp_1 benchmark_minimal_majsp_2 benchmark_minimal_majsp_3 benchmark_minimal_majsp_4 benchmark_minimal_majsp_5 benchmark_minimal_majsp_6

