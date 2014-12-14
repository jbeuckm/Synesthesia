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

Oscillator::Oscillator(int _sampleRate) {
    sampleRate = _sampleRate;
    
    position = 0;
}

void Oscillator::setFrequency(float f) {
    stepSize = f;
}

float Oscillator::getSample(float *waveTable) {

    position += stepSize;
    
    if (position >= (float)sampleRate) {
        position -= (float)sampleRate;
    }
//    printf("%d,", (int)position);
    return waveTable[(int)position];
}
