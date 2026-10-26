OPENSCAD ?= openscad
PYTHON ?= python3
BUILD := build

SOURCES := $(wildcard vehicle/*.scad controller/*.scad test/*.scad)
PREVIEWS := $(filter %/assembly_preview.scad,$(SOURCES))
PRINTABLE := $(filter-out $(PREVIEWS),$(SOURCES))

STL := $(PRINTABLE:%.scad=$(BUILD)/%.stl)
PNG := $(SOURCES:%.scad=$(BUILD)/%.png)

CAMERA := --camera=0,0,0,55,0,25,0 --viewall --autocenter --imgsize=1200,900 --colorscheme=Tomorrow

.PHONY: all stl png pcb clean

all: stl png

stl: $(STL)

png: $(PNG)

$(BUILD)/%.stl: %.scad
	@mkdir -p $(@D)
	$(OPENSCAD) -d $@.d -o $@ $<

# Assembly previews use preview mode, so colors and % ghosts stay visible.
$(BUILD)/%.png: %.scad
	@mkdir -p $(@D)
	$(OPENSCAD) -d $@.d $(if $(filter $<,$(PREVIEWS)),,--render) $(CAMERA) -o $@ $<

pcb:
	$(PYTHON) tools/brd2scad.py ../eagle/ir_remote_controlled_veh.brd pcb_vehicle lib/pcb_vehicle.scad
	$(PYTHON) tools/brd2scad.py ../eagle/remote_controller.brd pcb_controller lib/pcb_controller.scad

clean:
	rm -rf $(BUILD)

-include $(wildcard $(BUILD)/*/*.d)
