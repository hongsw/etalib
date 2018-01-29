REBAR?=./rebar

all: build


clean:
	$(REBAR) clean
	rm -rf logs
	rm -rf .eunit
	rm -f test/*.beam


distclean: clean
	git clean -fxd


devmarker:
	touch .etalib.dev


depends: clean devmarker
	# @if test ! -d ./deps/proper; then \
	# 	cd ./include/ta-lib/ && make \
	# fi
	# @if test ! -f ./include/ta-lib/Makefile; then \
	# 	cd ./include/ta-lib/ && ./configure && make \
	# fi
	# @if test ! -f ./include/ta-lib/Makefile; then \
	# 	cd ./include/ta-lib/ && make \
	# fi
	@if test ! -d ./priv/libta_lib.a; then \
		cd ./include/ta-lib/configure; \
		make -C  ./include/ta-lib/; \
	fi
	cp ./include/ta-lib/src/.libs/libta_lib.a ./priv/
	@if test ! -d ./deps/proper; then \
		$(REBAR) get-deps; \
	fi

build: depends
	$(REBAR) compile


etap: test/etap.beam test/util.beam
	prove test/*.t


eunit:
	$(REBAR) eunit skip_deps=true


check: build etap eunit


%.beam: %.erl
	erlc -o test/ $<


.PHONY: all clean distclean depends build etap eunit check
