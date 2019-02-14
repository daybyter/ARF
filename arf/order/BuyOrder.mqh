//+------------------------------------------------------------------+
//|                                                     buyOrder.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _BUYORDER_MQH_
#define _BUYORDER_MQH_

#include "Order.mqh"
//+--------------------------------------------------------+
//| This is just an convenience method to open a buy order |
//+--------------------------------------------------------+
class BuyOrder : public Order
  {

private:

   // Instance variables

public:

   // Constructos

   //+-------------------------------------------------------------------+
   //| Create a new buy order with a relative stop loss and take profit |
   //+-------------------------------------------------------------------+
                     BuyOrder(OrderList *ol,double vol,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL) : Order(ol,OP_BUY,vol,sl,tp,partialClosings,activePosition)
     {
     }

   // Methods
  };
#endif
//+------------------------------------------------------------------+
