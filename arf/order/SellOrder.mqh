//+------------------------------------------------------------------+
//|                                                    SellOrder.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _SELLORDER_MQH_
#define _SELLORDER_MQH_

#include "Order.mqh"
//+--------------------------------------------------------+
//| This is just an convenience method to open a sell order |
//+--------------------------------------------------------+
class SellOrder : public Order
  {

private:

   // Instance variables

public:

   // Constructos

   //+-------------------------------------------------------------------+
   //| Create a new sell order with a relative stop loss and take profit |
   //+-------------------------------------------------------------------+
                     SellOrder(OrderList *ol,double vol,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL) : Order(ol,OP_SELL,vol,sl,tp,partialClosings,activePosition)
     {
     }

   // Methods
  };
#endif
//+------------------------------------------------------------------+
