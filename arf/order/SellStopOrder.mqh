//+------------------------------------------------------------------+
//|                                                SellStopOrder.mqh |
//|                                 Copyright 2019, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _SELLSTOPORDER_MQH_
#define _SELLSTOPORDER_MQH_

#include "Order.mqh"
//+--------------------------------------------------------------+
//| This is just an convenience method to open a sell stop order |
//+--------------------------------------------------------------+
class SellStopOrder : public Order
  {

private:

   // Instance variables

public:

   // Constructos

   //+------------------------------------------------------------------------+
   //| Create a new sell stop order with a relative stop loss and take profit |
   //+------------------------------------------------------------------------+
                     SellStopOrder(OrderList *ol,double price,double vol,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL) : Order(ol,OP_SELLSTOP,price,vol,sl,tp,partialClosings,activePosition)
     {
     }

   // Methods
  };
#endif
//+------------------------------------------------------------------+
