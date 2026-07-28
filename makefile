CC = iverilog
SIM = vvp
FLAGS = -g2012

DESIGN_DIR = src
TB_DIR = testbench

SRC = $(DESIGN_DIR)/atan_val.sv \
    $(DESIGN_DIR)/cordic_datapath.sv \
    $(DESIGN_DIR)/cordic_controller.sv \
    $(DESIGN_DIR)/cordic_top.sv

TB = $(TB_DIR)/cordic_top_tb.sv
OUT = cordic_sim.vvp

.PHONY: all compile run clean help

all: run

compile:
	$(CC) $(FLAGS) -o $(OUT) $(SRC) $(TB)

run: compile
	$(SIM) $(OUT)

clean:
	rm -f $(OUT) *.vcd

help:
	@echo "Available make targets:"
	@echo "  make          - Default target (compiles and runs the simulation)"
	@echo "  make all      - Compiles and runs the simulation"
	@echo "  make compile  - Compiles the SystemVerilog files into an executable"
	@echo "  make run      - Executes the compiled simulation"
	@echo "  make clean    - Removes the compiled executable and waveform files"
	@echo "  make help     - Displays this help message"