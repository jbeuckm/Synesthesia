//
//  oscillator.h
//  Synesthesia
//
//  Created by joe on 12/12/14.
//
//

#ifndef Synesthesia_oscillator_h
#define Synesthesia_oscillator_h

class Oscillator {
    
public:
    float two_pi;

    Oscillator(int sampleRate = 44100);
    float * sinTable;
    
    
    float phaseStep;
    float currentPhase;
    
    void setFrequency(float f);
    float getStep(float *sin_table);
};

#endif
