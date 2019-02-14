//+------------------------------------------------------------------+
//|                                               ActivePosition.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ACTIVEPOSITION_MQH_
#define _ACTIVEPOSITION_MQH_

#include "..\..\Object.mqh"
//#include "Order.mqh"

// Forward declaration to avoid recursive include
class Order;
//+---------------------------------------------------+
//| This class is the base class for active positions |
//+---------------------------------------------------+
class ActivePosition : public CObject
  {
private:

   // Instance variables

   //+-------------------------------------+
   //| The hosting order, that is modified |
   //+-------------------------------------+
   Order            *_order;

public:

   // Constructors

   //+-----------------------------------------------------------------------+
   //| Create an active order without a specific order (should be set later) |
   //+-----------------------------------------------------------------------+
                     ActivePosition() : _order(NULL)
     {
     }

   //+----------------------------------------+
   //|Create a position modifier for an order |
   //+----------------------------------------+
                     ActivePosition(Order *order) : _order(order)
     {
     }

   // Methods

   //+------------------------------------------+
   //| Get the order, that opened this position |
   //+------------------------------------------+
   Order *getOrder()
     {
      return _order;
     }

   //+----------------------------------------+
   //| Set the order for this active position |
   //+----------------------------------------+
   void setOrder(Order *ord)
     {
      _order=ord;
     }

   //+------------------------------+
   //| Update the existion position |
   //+------------------------------+
   virtual bool      updatePosition() { return true; }
  };
#endif
//+------------------------------------------------------------------+
