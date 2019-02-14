//+------------------------------------------------------------------+
//|                                             NeuronConnection.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#ifndef _NEURONCONNECTION_MQH_
#define _NEURONCONNECTION_MQH_

#include "Neuron.mqh"
//+---------------------------------------------------------------------+
//| Instances of this class connect 2 neurons                           |
//|                                                                     |
//| @see: https://dzone.com/articles/designing-a-neural-network-in-java |
//+---------------------------------------------------------------------+
class NeuronConnection
  {

private:

   // Instance variables

   //+-------------------------------------+
   //| This is the input for the connecton |
   //+-------------------------------------+
   Neuron            _fromNeuron;

   //+--------------------------------------+
   //| This is the output of the connection |
   //+--------------------------------------+
   Neuron            _toNeuron;

   //+------------------------------+
   //| The weight of the connection |
   //+------------------------------+
   double            _weight;

public:

   // Constructors

   //+----------------------------------------------+
   //| Create a new connection with a random weight |
   //+----------------------------------------------+
                     NeuronConnection(Neuron fromNeuron,Neuron toNeuron)
     {
      _fromNeuron=fromNeuron;
      _toNeuron=toNeuron;
      _weight=(double)rand()/327767.0;
     }

   //+---------------------------------------------+
   //| Create a new connection with a given weight |
   //+---------------------------------------------+
                     NeuronConnection(Neuron fromNeuron,Neuron toNeuron,double weight)
     {
      _fromNeuron=fromNeuron;
      _toNeuron=toNeuron;
      _weight=weight;
     }

   // Methods

   //+-----------------------------------+
   //| Get the weight of this connection |
   //+-----------------------------------+
   double getWeight()
     {
      return _weight;
     }

   //+-------------------------------------+
   //|Set a new weight for this connection |
   //+-------------------------------------+
   void setWeight(double weight)
     {
      _weight=weight;
     }
  };
#endif
//+------------------------------------------------------------------+
