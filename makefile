CC=gcc-4.9

clean:		
	rm -f spacebodies
	rm -f *.o
	rm -rf output/
	rm -rf results/

prep: 		
	make clean
	mkdir output
	mkdir results

run:		
	# collDist, timeSteps, timeStep, plotStep, bodyCount, maxMass, maxPos, maxVel
	./spacebodies 0.01 2000000 0.001 100 10 20 30 5
	./spacebodies 0.01 2000000 0.001 100 20 20 30 5

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
	g++-4.9 -g -DFOOBUG -Wall spacebodies.cpp -std=c++11 -o spacebodies
	make run

parallel:	
	make prep
	g++-4.9 -O3 -Wall -fopenmp spacebodies.cpp -std=c++11 -o spacebodies
	make run

time_parallel:	
	make prep
	g++-4.9 -O3 -DSIMTIME -Wall -fopenmp spacebodies.cpp -std=c++11 -o spacebodies
	make run

debug_parallel:	
	make prep
	g++-4.9 -g -DFOOBUG -Wall -fopenmp spacebodies.cpp -std=c++11 -o spacebodies
	make run