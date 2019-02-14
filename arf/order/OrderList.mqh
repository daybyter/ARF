//+------------------------------------------------------------------+
//|                                                    OrderList.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ORDERLIST_MQH_
#define _ORDERLIST_MQH_

#include "..\datastruct\ArrayList.mqh"
#include "Order.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderList
  {

private:

   // Instance variables

   //+--------------------------+
   //| This is a list of orders |
   //+--------------------------+
   ArrayList         _orders;

   //+---------------------------------------------+
   //| The profit of all closed and removed orders |
   //+---------------------------------------------+
   double            _closedProfit;

   //+----------------------------------------------+
   //| The magic number for the orders of this list |
   //+----------------------------------------------+
   int               _magicNumber;

public:

   // Constructors

   //+--------------------------------------------------------------+
   //| Create a new list of orders                                  |
   //|                                                              |
   //| @param magicNum The magic number for the orders in this list |
   //+--------------------------------------------------------------+
                     OrderList(int magicNum) : _magicNumber(magicNum)
     {
      _closedProfit=0.0;
     }

   // Destructors

/**
* Clean the order buffer when the list is destroyed.
*/
                    ~OrderList()
     {
      int nOrders=_orders.size();

      if(nOrders>0)
        {
         for(int i=0; i<nOrders;++i)
           {
            Order *curOrder=_orders.get(i);

            if(curOrder!=NULL)
               delete curOrder;
           }
        }
     }

   // Methods

   //+-----------------------------------------------------------------------------+
   //| Add a new order to the list of orders                                       |
   //|                                                                             |
   //| @param newOrder The new order to add                                        |
   //| @param deleteIfDead If this flag is set, the order is deleted if it is dead |
   //+-----------------------------------------------------------------------------+
   void add(Order *newOrder,bool deleteIfDead)
     {
      // Check, if this is actually an order object,
      // that is or was at least open (for a short moment maybe?)
      if((CheckPointer(newOrder)!=POINTER_INVALID) && (newOrder.isOpen() || (newOrder.getProfit()!=0)))
        {
         _orders.add((CObject *)newOrder);
        }
      else
        {
         if(deleteIfDead && (CheckPointer(newOrder)!=POINTER_INVALID))
           {
            delete newOrder;
           }
        }
     }

/**
* Try to close all open positions.
*
* @return true, if all the positions were successfully closed. False otherwise.
*/
   bool closeAllPositions()
     {
      bool result=true;

      if(_orders.size()==0)
         return true;

      for(int i=0; i<_orders.size();++i)
        {
         Order *curOrder=get(i);

         if(curOrder!=NULL && !curOrder.closePosition())
            result=false;
        }

      return result;
     }

/**
     * Get the order with a given index from the list.
     *
     * @param index The index of the order.
     *
     * @return A pointer to the order at the given index or NULL.
     */
   Order *get(int index)
     {
      return _orders.get(index);
     }

   //+------------------------------------------------------+
   //| Get the magic number for orders in this list         |
   //|                                                      |
   //| @return The magic number for the orders in this list |
   //+------------------------------------------------------+
   int getMagicNumber()
     {
      return _magicNumber;
     }

   //+----------------------------------------------------+
   //| Get the total profit of all the orders in the list |
   //+----------------------------------------------------+
   double getProfit()
     {
      double result=_closedProfit;

      if(_orders.size()>0)
        {
         for(int i=0; i<_orders.size();++i)
           {
            if(CheckPointer(get(1))!=POINTER_INVALID)
              {
               Order *ord=get(i);
               if(!ord.isClosed())
                 {
                  result+=ord.getProfit();
                 }
              }
           }
        }
      return result;
     }

   //+------------------------------------+
   //| Check, if this order list is empty |
   //+------------------------------------+
   bool isEmpty()
     {
      return size()==0;
     }

   //+------------------------+
   //| Set a new magic number |
   //+------------------------+
   void setMagicNumber(int magicNum)
     {
      _magicNumber=magicNum;
     }

/**
* Get the number of orders in this list.
*
* @return The number of orders in this list.
*/
   int size()
     {
      return _orders.size();
     }

/**
     * Update all order in the list.
     */
   void updateOrders()
     {
      int nOrders=size();           // Cache the size of the orderlist
      bool compactingRequired=false;  // Check, if the order list should be compacted

      if(nOrders==0)
         return;

      for(int i=0; i<nOrders;++i) // Loop over all the orders
        {
         if(CheckPointer(get(i))!=POINTER_INVALID) // If the order is not yet deleted
           {
            get(i).update();        // and update each of them

            if(get(i).isClosed())
              {
               Order *ord=_orders.get(i);
               _closedProfit+=ord.getProfit();
               _orders.remove(i);
               compactingRequired=true;
               Print("Order ",i," is closed and therefore removed");
              }
           }
         else
           {
            _orders.remove(i);
            compactingRequired=true;
            Print("Remove order: ",i);
           }
        }
      if(compactingRequired)
         _orders.compact();  // Resize the list, so empty orders are removed
     }
  };
//+------------------------------------------------------------------+
#endif
//+------------------------------------------------------------------+
