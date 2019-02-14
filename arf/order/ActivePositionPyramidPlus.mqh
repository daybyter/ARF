//+------------------------------------------------------------------+
//|                                    ActivePositionPyramidPlus.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ACTIVEPOSITIONPYRAMIDPLUS_MQH_
#define _ACTIVEPOSITIONPYRAMIDPLUS_MQH_

#include "ActivePosition.mqh"
//+--------------------------------------------------------+
//| A class to optimize profit, once an order is in profit |
//+--------------------------------------------------------+
class ActivePositionPyramidPlus : public ActivePosition
  {
private:

   // Instance variables

   //+------------------------------------------------------+
   //| A flag to tell, if a child order was already created |
   //+------------------------------------------------------+
   bool              _childOrderCreated;

public:

   // Constructors

   //+------------------------------+
   //| Create a new active position |
   //+------------------------------+
                     ActivePositionPyramidPlus() : ActivePosition()
     {
      _childOrderCreated=false;
     }

   // Methods

   bool updatePosition()
     {
      if(getOrder()!=NULL
         &&((getOrder().isMarketOrder() && getOrder().updatePartialSales() && getOrder().updateMarketOrder())
         || (getOrder().isPendingOrder() && getOrder().updatePendingOrder())))
        {
         // Check if this order has not created a child order, but is enough in profit to create one
         if(!_childOrderCreated /* && orderList.size()<maxOrders */)
           {
            // Check, if the order has created enough profit, so the stop loss passed the initial price
            // Add some tolerance for slippage!!!
            if(MathAbs(getOrder().getProfit())>5+MathAbs(getOrder().getOpenPrice()-getOrder().getInitialStopLoss()))
              {
               //Print("Start to create child order");
               Order *ord=getOrder();
               OrderList *ol=ord.getOrderList();
               string slString=(ord.getType()==OP_BUY ? "-" : "+")+IntegerToString((int)MathAbs(ord.getInitialStopLoss()-ord.getOpenPrice()));
               //Print("SL String is: ",slString);
               string tpString=(ord.getType()==OP_BUY ? "+" : "-")+IntegerToString((int)MathAbs(ord.getInitialTakeProfit()-ord.getOpenPrice()));
               //Print("TP string is: ",tpString);
               //Print("Partial close string is: ",ord.getPartialCloseString());
               Order *newOrder=new Order(ol
                                         ,ord.getType()
                                         ,ord.getInitialVolume()
                                         ,slString,tpString
                                         ,ord.getPartialCloseString()
                                         ,NULL);
               newOrder.setActivePosition(new ActivePositionPyramidPlus());

               ol.add(newOrder,true);
               _childOrderCreated=true;

               //Print("Active position created new order!");
              }
            else
              {
               //Print("Order not profitable enough to create child order ",MathAbs(getOrder().getProfit()));
               //Print("Must be: ",MathAbs(getOrder().getInitialPrice()-getOrder().getInitialStopLoss()));
              }
           }
        }
      return true;
     }
  };
#endif
//+------------------------------------------------------------------+
