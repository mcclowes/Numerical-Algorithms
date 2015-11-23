CC=gcc-4.9

clean:		
	rm -f spacebodies
	rm -f *.o
	rm -rf output/

prep: 		
	make clean
	mkdir output

run:		
	./spacebodies

all:
	make serial

serial:		
	make prep
	g++-4.9 -O3 -Wall spacebodies.cpp -o spacebodies
	make run

debug_serial:		
	make prep
	g++-4.9 -g -Wall spacebodies.cpp -o spacebodies
	make run

parallel:	
	make prep
	g++-4.9 -O3 -Wall -fopenmp spacebodies.cpp -o spacebodies 
	make run

debug_parallel:	
	make prep
	g++-4.9 -g -Wall -fopenmp spacebodies.cpp -o spacebodies 
	make run