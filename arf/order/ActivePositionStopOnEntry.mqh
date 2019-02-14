//+------------------------------------------------------------------+
//|                                    ActivePositionPyramidPlus.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ACTIVEPOSITIONSTOPONENTRY_MQH_
#define _ACTIVEPOSITIONSTOPONENTRY_MQH_

#include "ActivePosition.mqh"
//+---------------------------------------+
//| A class to move the stop to the entry |
//+---------------------------------------+
class ActivePositionStopOnEntry : public ActivePosition
  {
private:

   // Instance variables

public:

   // Constructors

   //+------------------------------+
   //| Create a new active position |
   //+------------------------------+
                     ActivePositionStopOnEntry() : ActivePosition()
     {
     }

   // Methods

   bool updatePosition()
     {
      getOrder().updatePartialSales();

      if(getOrder()!=NULL && getOrder().getCurrentStopLoss()==getOrder().getInitialStopLoss()) // Check, if we have an order and the stop was not moved yet
        {
         if(getOrder().isMarketOrder())
            getOrder().updateMarketOrder();

         if(getOrder().isPendingOrder())
            getOrder().updatePendingOrder();
        }
      return            true;
     }
  };
#endif
//+------------------------------------------------------------------+
