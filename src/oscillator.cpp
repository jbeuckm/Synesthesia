//
//  oscillator.cpp
//  Synesthesia
//
//  Created by joe on 12/12/14.
//
//

#include <stdio.h>
#include <stdlib.h>
#include "oscillator.h"
#include <math.h>

float Oscillator::two_pi = 2.0 * M_PI;

float *Oscillator::sinTable = (float *)malloc(41000 * sizeof(float));


Oscillator::Oscillator(int sampleRate) {
    
    float step = Oscillator::two_pi / (float)sampleRate;

    for (int i=0; i<sampleRate; i++) {
        Oscillator::sinTable[i] = sin(i * step);
    }
    
}

void Oscillator::setFrequency(float f) {
    phaseStep = 2 * M_PI / f;
}

float Oscillator::getStep() {
    currentPhase += phaseStep;
    if (currentPhase > two_pi) {
        currentPhase -= two_pi;
    }
    return Oscillator::sinTable[(int)currentPhase];
}
