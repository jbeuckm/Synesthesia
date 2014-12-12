//
//  oscillator.cpp
//  Synesthesia
//
//  Created by joe on 12/12/14.
//
//

#include <stdio.h>
#include "oscillator.h"
#include <math.h>

Oscillator::Oscillator(int sampleRate) {

    two_pi = 2.0 * M_PI;
    
    // generate a 1hz sinus table
    sinTable = new float[sampleRate];
    float step = two_pi / sampleRate;
    for (int i=0; i<sampleRate; i++) {
        sinTable[i] = sin(i * step);
    }

}

void Oscillator::setFrequency(float f) {
    phaseStep = 2 * M_PI / f;
}

float Oscillator::getStep(float *sin_table) {
    currentPhase += phaseStep;
    if (currentPhase > two_pi) {
        currentPhase -= two_pi;
    }
    return sin_table[(int)currentPhase];
}
