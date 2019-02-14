//+------------------------------------------------------------------+
//|                                                 BuyStopOrder.mqh |
//|                                 Copyright 2019, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _BUYSTOPORDER_MQH_
#define _BUYSTOPORDER_MQH_

#include "Order.mqh"
//+-------------------------------------------------------------+
//| This is just an convenience method to open a buy stop order |
//+-------------------------------------------------------------+
class BuyStopOrder : public Order
  {

private:

   // Instance variables

public:

   // Constructos

   //+-----------------------------------------------------------------------+
   //| Create a new buy stop order with a relative stop loss and take profit |
   //+-----------------------------------------------------------------------+
                     BuyStopOrder(OrderList *ol,double price,double vol,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL) : Order(ol,OP_BUYSTOP,price,vol,sl,tp,partialClosings,activePosition)
     {
     }

   // Methods
  };
#endif
//+------------------------------------------------------------------+
