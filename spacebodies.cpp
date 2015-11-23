// pvxf29

#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

#include <math.h>
#include <omp.h> // OpenMP Parallelisation
#include <stdlib.h> // Rand()

// Space Body initialisation values
#define BODY_COUNT 10           // Seed K Space Body instances
#define MAX_MASS 20             // Seed bodies with mass 0 to K
#define MAX_POS 50              // Seed bodies with position vectors of value 0 to K
#define MAX_VEL 5               // Seed bodies with velocity vectors of value 0 to K

// Simulation variables
#define COLL_DIST 0.1           // Collision distance
#define TIME_STEPS 2000000      // No. steps
#define TIME_STEP 0.001        // Step size
#define PLOT_STEP 100           // Plot every K steps

// -------------------- 3D vector struct and vector handling methods --------------------------- //

typedef struct {
	double x, y, z;
} Vec3;

Vec3 addVec( Vec3 a, Vec3 b ) {
	return (Vec3){ a.x + b.x, a.y + b.y, a.z + b.z };
}

Vec3 subVec( Vec3 a, Vec3 b ) {
	return (Vec3){ a.x - b.x, a.y - b.y, a.z - b.z };
}

Vec3 multVec( Vec3 a, double k ) {
	return (Vec3){ k * a.x, k * a.y, k * a.z };
}

inline double dotVec( Vec3 a, Vec3 b ) {
	return a.x * b.x + a.y * b.y + a.z * b.z;
}

inline double magVec( Vec3 a ) {
	return sqrt( dotVec( a, a ) );
}

// -------------------- Space Body struct and methods --------------------------- //

typedef struct SpaceBody {
	double mass;
	Vec3 pos, vel, force;
	struct SpaceBody* collided; //Pointer to a body this body has collided with
} SpaceBody;

SpaceBody createSpaceBody( double mass, Vec3 pos, Vec3 vel ) {
    SpaceBody p;
    p.mass = mass;
    p.pos = pos;
    p.vel = vel;
    p.force = (Vec3){};
    p.collided = NULL;

    return p;
}

SpaceBody resolveCollision( SpaceBody a, SpaceBody b ) {
    SpaceBody p;
    p.mass = a.mass + b.mass;
    p.pos = multVec( addVec( a.pos, b.pos ), 0.5 ); // Position is halfway between the two bodies
    p.vel = multVec( addVec( multVec( a.vel, a.mass ), multVec( b.vel, b.mass ) ), 1.0 / p.mass);
    p.force = (Vec3){};

    return p;
}

std::vector<SpaceBody> spacebodies;

// -------------------- Main functions --------------------------- //

// Create CSV with space body positions at each timestep
void printCSVFile(int counter) {
	std::stringstream filename;
	filename << "output/result-" << counter <<  ".csv";
	std::ofstream out( filename.str().c_str() );

	out << "x, y, z" << std::endl;

	for ( int i = 0; i < BODY_COUNT; i++ ) {
        out << spacebodies[i].pos.x
            << ","
            << spacebodies[i].pos.y
            << ","
            << spacebodies[i].pos.z
            << std::endl;
    }
}

// Update all bodies
void updateBody() {
    // Check for collisions
    //Parallelise?
    /*for (int i = 0; i < BODY_COUNT; i++) {
        for (int j = 0; j < BODY_COUNT; j++) {
            double distance = magVec( subVec( spacebodies[i].pos, spacebodies[j].pos ) );

            spacebodies[i].force = (Vec3){};

            if ( (i != j) && (spacebodies[j].collided == NULL) ) {
                spacebodies[i].force = addVec(
                    spacebodies[i].force, multVec(
                        subVec( spacebodies[j].pos, spacebodies[i].pos ),
                        //spacebodies[j].mass / distance / distance / distance
                        spacebodies[j].mass / (distance * distance * distance)
                    )
                );
            }

            //check for collision
            if ( (i < BODY_COUNT - 1) && (j > i + 1) && (distance < COLL_DIST) && (spacebodies[j].collided == NULL) ) { // If collided and not pointer
                printf( "Collision: %d, %d\n", i, j );
                spacebodies[i] = resolveCollision( spacebodies[i], spacebodies[j] );
                spacebodies[j].collided = &spacebodies[i];
            }
        }
    }*/

    for (int i = 0; i < BODY_COUNT - 1; i++) {
        for (int j = i + 1; j < BODY_COUNT; j++) {
            double distance = magVec( subVec( spacebodies[i].pos, spacebodies[j].pos ) );

            //check for collision
            if ( (distance < COLL_DIST) && (spacebodies[j].collided == NULL) ) {
                //printf( "Collision: %d , %d\n", i, j );
                spacebodies[i] = resolveCollision( spacebodies[i], spacebodies[j] );
                spacebodies[j].collided = &spacebodies[i];
            }
        }
    }

    // Update forces
    #pragma omp parallel for
    for ( int i = 0; i < BODY_COUNT; i++ ) {
        spacebodies[i].force = (Vec3){};

        for ( int j = 0; j < BODY_COUNT; j++ ) {
            // Ignore self and collided spacebodies
            if ( (i != j) && (spacebodies[j].collided == NULL) ) {
                double distance = magVec( subVec( spacebodies[i].pos, spacebodies[j].pos ) );

                spacebodies[i].force = addVec(
                    spacebodies[i].force, multVec(
                        subVec( spacebodies[j].pos, spacebodies[i].pos ),
                        //spacebodies[j].mass / distance / distance / distance
                        spacebodies[j].mass / (distance * distance * distance)
                    )
                );
            }
        }
    }

    // Calculate position and velocity
    #pragma omp parallel for
    for (int i = 0; i < BODY_COUNT; i++) {
        if ( spacebodies[i].collided != NULL ) {
            // In the event the particle is part of a collided pair
            spacebodies[i].pos = (*spacebodies[i].collided).pos;
        } else {
            // Otherwise calculate the vector stuff
            spacebodies[i].pos = addVec( spacebodies[i].pos, multVec( spacebodies[i].vel, TIME_STEP ) );
            spacebodies[i].vel = addVec( spacebodies[i].vel, multVec( spacebodies[i].force, TIME_STEP ) );
        }
    }

}

int main() {
    //#pragma omp parallel for //Worth parallelising?
    for (int i=0; i < BODY_COUNT; i++) { //Seed K many space bodies
        spacebodies.push_back( 
            createSpaceBody(   (double)(rand() % MAX_MASS ), //Body mass
                (Vec3){ //Body position
                    (double)( rand() % MAX_POS ),
                    (double)( rand() % MAX_POS ),
                    (double)( rand() % MAX_POS )}, 
                (Vec3){ //Body velocity
                    (double)( rand() % MAX_VEL - (MAX_VEL / 2) ),
                    (double)( rand() % MAX_VEL - (MAX_VEL / 2) ),
                    (double)( rand() % MAX_VEL - (MAX_VEL / 2) )
                    //0.0, 0.0, 0.0 //Start static
                } ) );
    }

    // Print starting pos 
	printCSVFile(0); // Please switch off all IO if you do performance tests.

	clock_t t1, t2;
	t1 = clock();

	for (int i=0; i < TIME_STEPS; i++) {
		updateBody();

		if (i % PLOT_STEP == 0) { //Check for plot
			printCSVFile(i / PLOT_STEP + 1); // Please switch off all IO if you do performance tests.
		}
	}

	t2 = clock();
	std::cout << "Simulation took " << ((float)t2-(float)t1)/1000.0 << "ms" << std::endl; //Output time taken

	return 0;
}
