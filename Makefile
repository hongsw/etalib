REBAR?=./rebar

all: build


clean:
	$(REBAR) clean  -C ./rebar0.config
	rm -rf logs
	rm -rf .eunit
	rm -f test/*.beam


distclean: clean
	git clean -fxd


devmarker:
	touch .etalib.dev


depends: clean devmarker
	# cd ./include/ta-lib/ && ./configure && make && make install &&
	@if test ! -d ./deps/proper; then \
		$(REBAR) get-deps; \
	fi

build: depends
	$(REBAR) compile -C ./rebar0.config


etap: test/etap.beam test/util.beam
	prove test/*.t


eunit:
	$(REBAR) eunit skip_deps=true  -C ./rebar0.config


check: build etap eunit


%.beam: %.erl
	erlc -o test/ $<


.PHONY: all clean distclean depends build etap eunit check
