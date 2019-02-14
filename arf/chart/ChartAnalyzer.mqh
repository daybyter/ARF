//+------------------------------------------------------------------+
//|                                                ChartAnalyzer.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _CHARTANALYZER_MQH_
#define _CHARTANALYZER_MQH_


#include "Candle.mqh"
#include "..\datastruct\ArrayList.mqh"
//+------------------------------------------------------------------+
//| This class gives access to chart candles etc                     |
//+------------------------------------------------------------------+
class ChartAnalyzer
  {

private:

   // Instance variables

   //+----------------------+
   //| A buffer for candles |
   //+----------------------+
   ArrayList         _candleBuffer;

   //+--------------------------------------------+
   //| The time, the latest candle was created.   |
   //| We use this time to test for a new candle. |
   //+--------------------------------------------+
   datetime          _latestCandleTime;

public:

   // Constructors 

   //+------------------------------+
   //| Create a new chart analyzer. |
   //+------------------------------+
                     ChartAnalyzer()
     {
      _latestCandleTime=Time[0];  // Store the time of the latest candle, so we can detect newer candles
     }

   // Destructors

   //+------------------------------------------------+
   //| Clean the buffers, when this object is deleted |
   //+------------------------------------------------+
                    ~ChartAnalyzer()
     {
      int nCandles=_candleBuffer.size();
      for(int i=0; i<nCandles;++i)
        {
         Candle *curCandle=_candleBuffer.get(i);
         if(curCandle!=NULL)
            delete curCandle;
        }
     }

   // Methods

   //+-----------------------------------+
   //| Get the candle with a given index |
   //+-----------------------------------+
   Candle  *candle(int index)
     {
      Candle *result=_candleBuffer.get(index);

      if(result!=NULL) // Is this candle already in the buffer?
         return result;
      else
        {
         Candle *newCandle=new Candle(index);

         _candleBuffer.add(newCandle,index);

         return newCandle;
        }
     }

   //+-----------------------------------------------+
   //| Check, if there are new candles in this chart |
   //+-----------------------------------------------+
   bool hasNewCandle()
     {
      datetime newCandleTime=Time[0];           // Get the time of the current new candle
      if(newCandleTime!=_latestCandleTime)      // If it differs from the stored time, 
        {
         _latestCandleTime = newCandleTime;     // it is a new candle, so we store the new time.
         return true;                           // and return true to indicate a new candle.
        }
      return false;  // There is no new candle.
     }
  };
//+------------------------------+
//| Get the spread of this chart |
//+------------------------------+
double spread()
  {
   return (Ask-Bid);
  }

#endif
//+------------------------------------------------------------------+
