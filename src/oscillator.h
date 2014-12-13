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
    Oscillator(int sampleRate = 44100);

    static float two_pi;
    static float *sinTable;
    
    
    float phaseStep;
    float currentPhase;
    
    void setFrequency(float f);
    float getStep();
};

#endif
