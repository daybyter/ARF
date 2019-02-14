//+------------------------------------------------------------------+
//|                                                       Neuron.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _NEURON_MQH_
#define _NEURON_MQH_

#include "..\datastruct\ArrayList.mqh"
//+---------------------------------------------------------------------+
//| This class contains the data of a single neuron                     |
//|                                                                     |
//| @see: https://dzone.com/articles/designing-a-neural-network-in-java |
//+---------------------------------------------------------------------+
class Neuron
  {

private:

   // Instance variables

   //+--------------------+
   //| The list of inputs |
   //+--------------------+
   ArrayList         _inputs;

   //+---------------------+
   //| The list of outputs |
   //+---------------------+
   ArrayList         _outputs;

public:

   // Constructors

   // Methods

   //+-------------------------------------+
   //| Calculate the output of this neuron |
   //+-------------------------------------+
   double calcOutput()
     {
      double sum=0.0;
      int nInputs=_inputs.size();  // The number of inputs

      for(int i=0; i<nInputs;++i)
        {
         sum+=_inputs.get(i).calcOutput();
        }
      sum/=nInputs;  // Normalize input

      return sum;
     }

  };
//+------------------------------------------------------------------+
#endif
