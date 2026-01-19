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

15MIN=900s
8GMEM=8000000

30MIN=1800s
50GMEM=50000000 # in kB. Should be 56 GB

MATCHCELLAR=pddl-domains/MatchCellar-impossible

MATCHCELLAR_1=$(MATCHCELLAR)/MatchCellar-impossible-1
MATCHCELLAR_2=$(MATCHCELLAR)/MatchCellar-impossible-2
MATCHCELLAR_3=$(MATCHCELLAR)/MatchCellar-impossible-3
MATCHCELLAR_4=$(MATCHCELLAR)/MatchCellar-impossible-4
MATCHCELLAR_5=$(MATCHCELLAR)/MatchCellar-impossible-5
MATCHCELLAR_6=$(MATCHCELLAR)/MatchCellar-impossible-6

MAJSP=pddl-domains/majsp-impossible-1

MAJSP_1=$(MAJSP)/majsp-impossible-1-1
MAJSP_2=$(MAJSP)/majsp-impossible-1-2
MAJSP_3=$(MAJSP)/majsp-impossible-1-3
MAJSP_4=$(MAJSP)/majsp-impossible-1-4
MAJSP_5=$(MAJSP)/majsp-impossible-1-5
MAJSP_6=$(MAJSP)/majsp-impossible-1-6

PAINTER=pddl-domains/painter-impossible

PAINTER_1=$(PAINTER)/painter-impossible-1
PAINTER_2=$(PAINTER)/painter-impossible-2
PAINTER_3=$(PAINTER)/painter-impossible-3
PAINTER_4=$(PAINTER)/painter-impossible-4
PAINTER_5=$(PAINTER)/painter-impossible-5
PAINTER_6=$(PAINTER)/painter-impossible-6


SYNC=pddl-domains/sync-impossible

SYNC_1=$(SYNC)/sync-impossible-1
SYNC_2=$(SYNC)/sync-impossible-2
SYNC_3=$(SYNC)/sync-impossible-3
SYNC_4=$(SYNC)/sync-impossible-4
SYNC_5=$(SYNC)/sync-impossible-5
SYNC_6=$(SYNC)/sync-impossible-6


DRIVERLOG=pddl-domains/driverlog
DRIVERLOG_1=$(DRIVERLOG)/driverlog-1
DRIVERLOG_2=$(DRIVERLOG)/driverlog-2
DRIVERLOG_3=$(DRIVERLOG)/driverlog-3
DRIVERLOG_4=$(DRIVERLOG)/driverlog-4
DRIVERLOG_5=$(DRIVERLOG)/driverlog-5
DRIVERLOG_6=$(DRIVERLOG)/driverlog-6


clean:
	rm $(wildcard $(MAJSP)/majsp-impossible-1*/instances/instance_*.pddl)
	rm $(wildcard $(PAINTER)/painter-impossible-*/instances/instance_*.pddl)
	rm $(wildcard $(SYNC)/sync-impossible-*/instances/instance_*.pddl)
	rm $(wildcard $(DRIVERLOG)/driverlog-*/instances/instance_*.pddl)

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

# to refactor generator
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

create_sync_instances: 
	cd $(SYNC); python -m generator

create_driverlog_instances:
	cd $(DRIVERLOG); python -m generator

create_instances: create_painter_instances create_majsp_instances create_sync_instances create_driverlog_instances


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


benchmark_minimal_matchcellar_1:
	./run.sh -f minimal_matchcellar_1_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_1) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar_2:
	./run.sh -f minimal_matchcellar_2_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_2) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar_3:
	./run.sh -f minimal_matchcellar_3_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_3) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar_4:
	./run.sh -f minimal_matchcellar_4_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_4) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar_5:
	./run.sh -f minimal_matchcellar_5_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_5) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar_6:
	./run.sh -f minimal_matchcellar_6_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(MATCHCELLAR_6) $(MINIMAL_BENCHMARKS)

benchmark_minimal_matchcellar: benchmark_minimal_matchcellar_1 benchmark_minimal_matchcellar_2 benchmark_minimal_matchcellar_3 benchmark_minimal_matchcellar_4 benchmark_minimal_matchcellar_5 benchmark_minimal_matchcellar_6


benchmark_minimal_sync_1: create_sync_instances
	./run.sh -f minimal_sync_1_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_1) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync_2: create_sync_instances
	./run.sh -f minimal_sync_2_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_2) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync_3: create_sync_instances
	./run.sh -f minimal_sync_3_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_3) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync_4: create_sync_instances
	./run.sh -f minimal_sync_4_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_4) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync_5: create_sync_instances
	./run.sh -f minimal_sync_5_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_5) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync_6: create_sync_instances
	./run.sh -f minimal_sync_6_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(SYNC_6) $(MINIMAL_BENCHMARKS)

benchmark_minimal_sync: benchmark_minimal_sync_1 benchmark_minimal_sync_2 benchmark_minimal_sync_3 benchmark_minimal_sync_4 benchmark_minimal_sync_5 benchmark_minimal_sync_6


benchmark_minimal_driverlog_1: create_driverlog_instances
	./run.sh -f minimal_driverlog_1_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_1) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog_2: create_driverlog_instances
	./run.sh -f minimal_driverlog_2_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_2) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog_3: create_driverlog_instances
	./run.sh -f minimal_driverlog_3_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_3) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog_4: create_driverlog_instances
	./run.sh -f minimal_driverlog_4_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_4) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog_5: create_driverlog_instances
	./run.sh -f minimal_driverlog_5_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_5) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog_6: create_driverlog_instances
	./run.sh -f minimal_driverlog_6_$(RESULTS) -t $(15MIN) -m $(8GMEM) -p $(DRIVERLOG_6) $(MINIMAL_BENCHMARKS)

benchmark_minimal_driverlog: benchmark_minimal_driverlog_1 benchmark_minimal_driverlog_2 benchmark_minimal_driverlog_3 benchmark_minimal_driverlog_4 benchmark_minimal_driverlog_5 benchmark_minimal_driverlog_6


benchmark_longer_painter_1: create_painter_instances_1
	./run.sh -f longer_painter_1_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_1) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter_2: create_painter_instances_2
	./run.sh -f longer_painter_2_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_2) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter_3: create_painter_instances_3
	./run.sh -f longer_painter_3_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_3) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter_4: create_painter_instances_4
	./run.sh -f longer_painter_4_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_4) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter_5: create_painter_instances_5
	./run.sh -f longer_painter_5_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_5) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter_6: create_painter_instances_6
	./run.sh -f longer_painter_6_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(PAINTER_6) $(MINIMAL_BENCHMARKS)

benchmark_longer_painter: benchmark_longer_painter_1 benchmark_longer_painter_2 benchmark_longer_painter_3 benchmark_longer_painter_4 benchmark_longer_painter_5 benchmark_longer_painter_6


benchmark_longer_majsp_1: create_majsp_instances_1
	./run.sh -f longer_majsp_1_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_1) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp_2: create_majsp_instances_2
	./run.sh -f longer_majsp_2_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_2) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp_3: create_majsp_instances_3
	./run.sh -f longer_majsp_3_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_3) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp_4: create_majsp_instances_4
	./run.sh -f longer_majsp_4_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_4) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp_5: create_majsp_instances_5
	./run.sh -f longer_majsp_5_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_5) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp_6: create_majsp_instances_6
	./run.sh -f longer_majsp_6_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MAJSP_6) $(MINIMAL_BENCHMARKS)

benchmark_longer_majsp: benchmark_longer_majsp_1 benchmark_longer_majsp_2 benchmark_longer_majsp_3 benchmark_longer_majsp_4 benchmark_longer_majsp_5 benchmark_longer_majsp_6


benchmark_longer_matchcellar_1:
	./run.sh -f longer_matchcellar_1_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_1) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar_2:
	./run.sh -f longer_matchcellar_2_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_2) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar_3:
	./run.sh -f longer_matchcellar_3_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_3) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar_4:
	./run.sh -f longer_matchcellar_4_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_4) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar_5:
	./run.sh -f longer_matchcellar_5_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_5) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar_6:
	./run.sh -f longer_matchcellar_6_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(MATCHCELLAR_6) $(MINIMAL_BENCHMARKS)

benchmark_longer_matchcellar: benchmark_longer_matchcellar_1 benchmark_longer_matchcellar_2 benchmark_longer_matchcellar_3 benchmark_longer_matchcellar_4 benchmark_longer_matchcellar_5 benchmark_longer_matchcellar_6


benchmark_longer_sync_1: create_sync_instances
	./run.sh -f longer_sync_1_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_1) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync_2: create_sync_instances
	./run.sh -f longer_sync_2_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_2) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync_3: create_sync_instances
	./run.sh -f longer_sync_3_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_3) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync_4: create_sync_instances
	./run.sh -f longer_sync_4_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_4) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync_5: create_sync_instances
	./run.sh -f longer_sync_5_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_5) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync_6: create_sync_instances
	./run.sh -f longer_sync_6_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(SYNC_6) $(MINIMAL_BENCHMARKS)

benchmark_longer_sync: benchmark_longer_sync_1 benchmark_longer_sync_2 benchmark_longer_sync_3 benchmark_longer_sync_4 benchmark_longer_sync_5 benchmark_longer_sync_6


benchmark_longer_driverlog_1: create_driverlog_instances
	./run.sh -f longer_driverlog_1_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_1) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog_2: create_driverlog_instances
	./run.sh -f longer_driverlog_2_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_2) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog_3: create_driverlog_instances
	./run.sh -f longer_driverlog_3_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_3) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog_4: create_driverlog_instances
	./run.sh -f longer_driverlog_4_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_4) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog_5: create_driverlog_instances
	./run.sh -f longer_driverlog_5_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_5) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog_6: create_driverlog_instances
	./run.sh -f longer_driverlog_6_$(RESULTS) -t $(30MIN) -m $(50GMEM) -p $(DRIVERLOG_6) $(MINIMAL_BENCHMARKS)

benchmark_longer_driverlog: benchmark_longer_driverlog_1 benchmark_longer_driverlog_2 benchmark_longer_driverlog_3 benchmark_longer_driverlog_4 benchmark_longer_driverlog_5 benchmark_longer_driverlog_6

benchmark_minimal_all: benchmark_minimal_majsp benchmark_minimal_matchcellar benchmark_minimal_painter benchmark_minimal_painter