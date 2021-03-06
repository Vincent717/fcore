# General project-wide tasks

srcdir=lib
testdir=testsuite

.PHONY : compiler
compiler : dependencies runtime
	$${CABAL=cabal}  install

.PHONY : smt
smt : dependencies runtime
	$${CABAL=cabal}  install -f Z3

.PHONY : test
test : whitespace_test dependencies runtime
	$${CABAL=cabal} configure --enable-tests && $${CABAL=cabal} build && $${CABAL=cabal} test

.PHONY : test2
test2 : whitespace_test dependencies runtime
	make parsers
	runhaskell -i$(srcdir):lib/services:lib/typeCheck:lib/simplify $(testdir)/FileLoad.hs

.PHONY : whitespace_test
whitespace_test :
	ruby $(testdir)/whitespace_check.rb

.PHONY : dependencies
dependencies : 
	$${CABAL=cabal} install --only-dependencies --enable-tests

.PHONY : runtime
runtime :
	cd runtime && ant && cd ..

.PHONY : parsers
parsers :
	cd $(srcdir) && make && cd ..

.PHONY : guard
guard :
	cabal install hspec
	gem install guard-haskell

.PHONY : clean
clean :
	rm -rf dist
	rm -f *.class *.jar Main.java
	rm -f $(testdir)/tests/run-pass/*.java
	cd lib; make clean
	cd runtime; ant clean
