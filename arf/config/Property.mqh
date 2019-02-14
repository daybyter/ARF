//+------------------------------------------------------------------+
//|                                                     Property.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _PROPERTY_MQH_
#define _PROPERTY_MQH_

#include "..\..\Object.mqh"
//+------------------------------------------------------------------+
//| Objects of thie class hold a single property                     |
//+------------------------------------------------------------------+
class Property : public CObject
  {
private:

   // Instance variables

   //+---------------------------+
   //| The name of this property |
   //+---------------------------+
   string            _key;

   //+----------------------------+
   //| The value of this property |
   //+----------------------------+
   string            _value;

public:

   // Constructors

   //+--------------------------------------------------+
   //| Create a new property from a given key and value |
   //+--------------------------------------------------+
                     Property(string key,string value) : _key(key),_value(value)
     {
     }

   // Methods

   //+------------------------------+
   //| Get the key of this property |
   //+------------------------------+
   string getKey()
     {
      return _key;
     }

   //+--------------------------------+
   //| Get the value of this property |
   //+--------------------------------+
   string getValue()
     {
      return _value;
     }
  };
#endif
//+------------------------------------------------------------------+
