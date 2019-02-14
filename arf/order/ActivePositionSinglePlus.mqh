//+------------------------------------------------------------------+
//|                                    ActivePositionPyramidPlus.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ACTIVEPOSITIONSINGLEPLUS_MQH_
#define _ACTIVEPOSITIONSINGLEPLUS_MQH_

#include "ActivePosition.mqh"
//+--------------------------------------------------------+
//| A class to optimize profit, once an order is in profit |
//+--------------------------------------------------------+
class ActivePositionSinglePlus : public ActivePosition
  {
private:

   // Instance variables

   //+------------------------------------------------------+
   //| A flag to tell, if a child order was already created |
   //+------------------------------------------------------+
   bool              _childOrderCreated;

   //| Check, if the price came back to SL -1
   bool              _signal_1;

public:

   // Constructors

   //+------------------------------+
   //| Create a new active position |
   //+------------------------------+
                     ActivePositionSinglePlus() : ActivePosition(),_childOrderCreated(false),_signal_1(false)
     {
     }

   // Methods

   bool updatePosition()
     {
      if(getOrder()!=NULL && !_childOrderCreated) // Check if this order has not created a child order, but is enough in profit to create one
        {
         if(!_signal_1)
           {
            if(MathAbs(getOrder().getProfit())>(getOrder().getTrailingStopLossDistance()-6)) // Check, if the order has created enough profit, so the stop loss passed the initial price and add some tolerance for slippage!!!
              {
               _signal_1=true;
               //Print("Active position signal 1 received");
              }
           }
         else
           {
            if((getOrder().getType()==OP_BUY && (Ask<(getOrder().getCurrentStopLoss()+15)))
               || (getOrder().getType()==OP_SELL && (Bid>(getOrder().getCurrentStopLoss()-15))))
              {
               //Print("Start to create child order");
               Order *ord=getOrder();
               OrderList *ol=ord.getOrderList();
               //string slString=(ord.getType()==OP_BUY ? "-" : "+")+IntegerToString((int)MathAbs(ord.getInitialStopLoss()-ord.getInitialPrice()));
               string slString=ord.getType()==OP_BUY
                               ? "-"+DoubleToString(NormalizeDouble(MathAbs(Ask-getOrder().getCurrentStopLoss()),_Digits))
                               : "+"+DoubleToString(NormalizeDouble(MathAbs(getOrder().getCurrentStopLoss()-Bid),_Digits));
               Print("SL String is: ",slString);
               string tpString=(ord.getType()==OP_BUY ? "+" : "-")+"500"; //IntegerToString((int)MathAbs(ord.getInitialTakeProfit()-ord.getInitialPrice()));
               Print("TP string is: ",tpString);
               //Print("Partial close string is: ",ord.getPartialCloseString());
               Order *newOrder=new Order(ol
                                         ,ord.getType()
                                         ,1.0
                                         ,slString
                                         ,tpString
                                         ,"" /*ord.getPartialCloseString() */
                                         ,NULL);
               newOrder.setActivePosition(NULL);  // No further child orders
               ol.add(newOrder,true);
               _childOrderCreated=true;
               _signal_1=false;
              }
           }
        }
      return            true;
     }
  };
#endif
//+------------------------------------------------------------------+
