#Makefile for UVM Testbench - Extended with multiple tests

SIMULATOR = Questa
FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../wr_agt_top +incdir+../rd_agt_top
SVTB2 = ../test/test_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 

# default batch run command
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                  								!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.  						!"
	@echo "! sv_cmp    	=>  Create library and compile the code.           						!"
	@echo "! run_test	=>  clean, compile & run the simulation for first test (test1).				!" 
	@echo "! run_cover_test => clean, compile & run the simulation for second test (test2).				!" 
	@echo "! view_wave1 =>  To view the waveform of ram_signle_addr_test	    						!" 
	@echo "! regress    =>  clean, compile and run all testcases in batch mode.		    				!"
	@echo "! report     =>  To merge coverage reports for all testcases and  convert to html format.			!"
	@echo "! cov        =>  To open merged coverage report in html format.							!"
	@echo =============================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_cover_test : run_cover_test_$(SIMULATOR)
view_wave1 : view_wave1_$(SIMULATOR)
regress : regress_$(SIMULATOR)
report : report_$(SIMULATOR)
cov : cov_$(SIMULATOR)

# ----------------------------- Mentor Questa -------------------------------#

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) 	

run_test_Questa: sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1

run_cover_test_Questa: sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=cover_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2
	
view_wave1_Questa:
	vsim -view wave_file1.wlf
	
report_Questa:
	vcover merge mem_cov mem_cov1 mem_cov2
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress_Questa: clean_Questa run_test_Questa run_cover_test_Questa report_Questa cov_Questa

cov_Questa:
	firefox covhtmlreport/index.html&
	
clean_Questa:
	rm -rf transcript* *log* fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear

# ----------------------------- Synopsys VCS (unchanged) -------------------------------#

sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb  -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB2) $(SVTB1)
		      
run_test_VCS:	clean  sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave1.fsdb -cm_dir ./mem_cov1 +ntb_random_seed_automatic +UVM_TESTNAME=test 
	urg -dir mem_cov1.vdb -format both -report urgReport1
	
run_cover_test_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave2.fsdb -cm_dir ./mem_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=cover_test
	urg -dir mem_cov2.vdb -format both -report urgReport2

view_wave1_VCS: 
	verdi -ssf wave1.fsdb
	
report_VCS:
	urg -dir mem_cov1.vdb mem_cov2.vdb -dbname merged_dir/merged_test -format both -report urgReport

regress_VCS: clean_VCS sv_cmp_VCS run_test_VCS run_cover_test_VCS report_VCS

cov_VCS:
	verdi -cov -covdir merged_dir.vdb

clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h urgReport* *.fsdb novas* verdi*
	clear
