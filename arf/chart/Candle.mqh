//+------------------------------------------------------------------+
//|                                                       Candle.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _CANDLE_MQH_
#define _CANDLE_MQH_

#include "..\..\Object.mqh"
//+--------------------------------------------------+
//| This class holds the methods for a single candle |
//+--------------------------------------------------+
class Candle : public CObject
  {

private:

   // Instance variables

/**
* The index of this candle.
*/
   int               _index;

public:

   // Constructors

   //+----------------------------------------+
   //| Create a new candle with a given index |
   //+----------------------------------------+
                     Candle(int index)
     {
      _index=index;
     }

   // Methods

   //+---------------------------------------+
   //| Return the close price of this candle |
   //+---------------------------------------+
   double close()
     {
      return Close[_index];
     }

   //+--------------------------------+
   //| Get the maximum of this candle |
   //+--------------------------------+
   double high()
     {
      return High[_index];
     }

   //+----------------------------------+
   //| Check, if this is a green candle |
   //+----------------------------------+
   bool isGreen()
     {
      return (Close[_index]>Open[_index]);
     }

   //+---------------------------------------------------------------------+
   //| Check, if this candle has been overrun by the the current ask price |
   //+---------------------------------------------------------------------+
   bool isOverrun(double tolerance=0.0)
     {
      return (High[_index] < (Ask-MathAbs(tolerance)));
     }

   //+--------------------------------+
   //| Check, if this is a red candle |
   //+--------------------------------+
   bool isRed()
     {
      return (Open[_index]>Close[_index]);
     }

   //+------------------------------------------------------------+
   //| Check, if this candle is underrun by the current bid price |
   //+------------------------------------------------------------+
   bool isUnderrun(double tolerance=0.0)
     {
      return (Low[_index] > (Bid+MathAbs(tolerance)));
     }

   //+--------------------------------+
   //| Get the minimum of this candle |
   //+--------------------------------+
   double low()
     {
      return Low[_index];
     }

   //+-------------------------------------+
   //| Return the open value of the candle |
   //+-------------------------------------+
   double open()
     {
      return Open[_index];
     }

   //+----------------------------------+
   //| Return the height of this candle |
   //+----------------------------------+
   double height()
     {
      return MathAbs(high()-low());
     }
  };
#endif
//+------------------------------------------------------------------+
