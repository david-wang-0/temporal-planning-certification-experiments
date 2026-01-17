TCHECKER_CERT=-b tck-covreach -b cert-conv -b muntac-cert-check


# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)
# popf3 also segfaults on some domains...

TAMER=-b tamer-ctp -b tamer-ftp
TAMER_GROUND=-b tamer-ctp-ground -b tamer-ftp-ground

PLANNERS=-b tfd -b optic -b popf3-ground -b nextflap 

MODEL_CHECKERS=-b tck-aLU -b nuxmv-ground -b nuxmv -b uppaal-ground -b uppaal

GROUNDING=-b grounder

VERIFIED_ENCODER=-b verified-encoder

MODEL_CONV=-b model-converter

PIPELINE=$(GROUNDING) $(VERIFIED_ENCODER) $(MODEL_CONV) $(TCHECKER_CERT)

BENCHMARKS=$(PIPELINE) $(TAMER) $(TAMER_GROUND) $(PLANNERS) $(MODEL_CHECKERS)

RESULTS=results.$(shell date +%s).csv

# time out and memory
TIMEOUT=900s
LONGER_TIMEOUT=1800s

MEMORY=56000000 # in kB. Should be 56 GB

MATCHCELLAR=pddl-domains/MatchCellar-impossible
SYNC=pddl-domains/sync-impossible
PAINTER=pddl-domains/painter-impossible
DRIVERLOG_1=pddl-domains/driverlog-1
DRIVERLOG_2=pddl-domains/driverlog-2
MAJSP_1=pddl-domains/majsp-impossible-1-1
MAJSP_2=pddl-domains/majsp-impossible-1-2

clean:
	rm $(RESULTS)
	rm $(TEMP_RESULTS)

create_painter_instances:
	cd $(PAINTER); python -m generator

create_driverlog_instances_1:
	cd $(DRIVERLOG_1); python -m generator

create_driverlog_instances_2:
	cd $(DRIVERLOG_2); python -m generator

create_majsp_instances_1:
	cd $(MAJSP_1); python -m generator

create_majsp_instances_2:
	cd $(MAJSP_2); python -m generator


create_instances: create_painter_instances create_driverlog_instances_1 create_driverlog_instances_2 create_majsp_instances_1 create_majsp_instances_2

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

benchmark_short_majsp: benchmark_short_driverlog_1 .WAIT benchmark_short_driverlog_2

benchmark_short_majsp_1: create_majsp_instances_1
	./run.sh -f short_majsp_1_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_1) $(BENCHMARKS)

benchmark_short_majsp_2: create_majsp_instances_1
	./run.sh -f short_majsp_2_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP_2) $(BENCHMARKS)
	
benchmark_short_majsp: benchmark_short_majsp_1 .WAIT benchmark_short_majsp_2

benchmark_short_all: benchmark_short_driverlog_1 benchmark_short_driverlog_2 benchmark_short_matchcellar benchmark_short_sync benchmark_short_painter benchmark_short_majsp_1 benchmark_short_majsp_2


benchmark_short_majsp_tamer:
	./run.sh -f short_majsp_tamer_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MAJSP) $(TAMER)

benchmark_short_matchcellar_tamer:
	./run.sh -f short_matchcellar_tamer_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(TAMER)

benchmark_short_sync_tamer:
	./run.sh -f short_sync_tamer_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p $(SYNC) $(TAMER)
