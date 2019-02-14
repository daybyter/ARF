//+------------------------------------------------------------------+
//|                                                BuyLimitOrder.mqh |
//|                                 Copyright 2019, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _BUYLIMITORDER_MQH_
#define _BUYLIMITORDER_MQH_

#include "Order.mqh"
//+--------------------------------------------------------------+
//| This is just an convenience method to open a buy limit order |
//+--------------------------------------------------------------+
class BuyLimitOrder : public Order
  {

private:

   // Instance variables

public:

   // Constructos

   //+------------------------------------------------------------------------+
   //| Create a new buy limit order with a relative stop loss and take profit |
   //+------------------------------------------------------------------------+
                     BuyLimitOrder(OrderList *ol,double price,double vol,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL) : Order(ol,OP_BUYLIMIT,price,vol,sl,tp,partialClosings,activePosition)
     {
     }

   // Methods
  };
#endif
//+------------------------------------------------------------------+
