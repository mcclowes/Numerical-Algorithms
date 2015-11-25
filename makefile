CC=g++-4.9

clean:		
	rm -f spacebodies
	rm -f spacebodiesS
	rm -f spacebodiesP
	rm -f *.o
	rm -rf output/
	rm -rf results/

prep: 		
	make clean
	mkdir output
	mkdir results

run:		
	# collDist, timeSteps, timeStep, plotStep, bodyCount, maxMass, density, maxVel
	./spacebodies 0.1 1000000 0.001 100 50 13 2 25
	#./spacebodies 0.1 1000000 0.001 100 50 13 2 5

run_default:		
	./spacebodies

all:
	make prep
	g++-4.9 -O3 -Wall spacebodies.cpp -std=c++11 -o spacebodies
	make run_default

serial:		
	make prep
	g++-4.9 -O3 -Wall spacebodies.cpp -std=c++11 -o spacebodies
	make run

time_serial:		
	make prep
	g++-4.9 -O3 -DSIMTIME -Wall spacebodies.cpp -std=c++11 -o spacebodies
	make run

debug_serial:		
	make prep
	g++-4.9 -O3 -DFOOBUG -Wall spacebodies.cpp -std=c++11 -o spacebodies
	make run

parallel:	
	make prep
	g++-4.9 -O3 -Wall -fopenmp -DPAR spacebodies.cpp -std=c++11 -o spacebodies
	make run

time_parallel:	
	make prep
	g++-4.9 -O3 -DSIMTIME -Wall -fopenmp -DPAR spacebodies.cpp -std=c++11 -o spacebodies
	make run

debug_parallel:	
	make prep
	g++-4.9 -g -DFOOBUG -Wall -fopenmp -DPAR spacebodies.cpp -std=c++11 -o spacebodies
	make run

test:
	make prep
	g++-4.9 -O3 -DSIMTIME -Wall spacebodies.cpp -std=c++11 -o spacebodiesS
	g++-4.9 -O3 -DSIMTIME -Wall -fopenmp -DPAR spacebodies.cpp -std=c++11 -o spacebodiesP
	./spacebodiesS 0.1 1000000 0.001 100 25 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 50 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 100 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 150 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 200 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 250 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 500 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 625 13 2 5
	./spacebodiesS 0.1 1000000 0.001 100 750 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 25 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 50 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 100 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 150 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 200 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 250 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 500 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 625 13 2 5
	./spacebodiesP 0.1 1000000 0.001 100 750 13 2 5
