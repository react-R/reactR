ifeq ($(OS),Windows_NT)
BABEL=$(shell npm.cmd bin)/babel.cmd
BROWSERIFY=$(shell npm.cmd bin)/browserify.cmd
else
BABEL=$(shell npm bin)/babel
BROWSERIFY=$(shell npm bin)/browserify
endif

MODULES=$(addprefix ./srcjs/,sparklineswidget.js)
BUILT_MODULES=$(MODULES:./srcjs/%=./build/%)

LIBDIR=./inst/htmlwidgets

.PHONY: all clean

all: $(LIBDIR)/sparklineswidget.js

clean:
	rm -rf build

build/%.js: srcjs/%.js
	@mkdir -p build
	$(BABEL) --source-maps inline --presets env,react $^ -o $@

# Trick browserify
node_modules/react.js:
	echo "module.exports=window.React" > node_modules/react.js

# Trick browserify
node_modules/react-dom.js:
	echo "module.exports=window.ReactDOM" > node_modules/react-dom.js

$(LIBDIR)/sparklineswidget.js: node_modules/react.js node_modules/react-dom.js build/sparklineswidget.js
	$(BROWSERIFY) --debug $(BUILT_MODULES:%=-r %) $^ -o $@
