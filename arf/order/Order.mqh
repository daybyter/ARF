//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ORDER_MQH_
#define _ORDER_MQH_

#include "ActivePosition.mqh"
//#include "OrderList.mqh"
#include "..\..\Object.mqh"
#include "..\datastruct\ArrayList.mqh"

// Forward declaration to avoid recursive include
class OrderList;
//+-----------------------------------------------------+
//| This class holds the info on a single partial close |
//+-----------------------------------------------------+
class PartialClose : public CObject
  {

private:

   // Instance variables

/**
* The profit of the price in points.
*/
   double            _profit;

/**
* The volume to sell.
*/
   double            _volume;

public:

   // Constructors

/**
* Create a new partial sale
*/
                     PartialClose(double profit,double vol)
     {
      _profit=profit;
      _volume=vol;
     }

   // Methods

/**
* Get the profit, that is reqired for this sale.
*
* @return The profit, that is required for this sale.
*/
   double getProfit()
     {
      return _profit;
     }

/**
* Get the volume of this partial close.
*
* @return The volumenof this partial close.
*/
   double getVolume()
     {
      return _volume;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PartialCloseList
  {

private:

   // Instance variables

/**
* The list of negative sale points.
*/
   ArrayList         _negSales;

/**
* The list of positive sale points.
*/
   ArrayList         _posSales;

/**
* The number of sales already done.
*/
   int               _negSalesDone;
   int               _posSalesDone;

public:

   // Constructors

   // Destructors

                    ~PartialCloseList()
     {
      for(int i=0; i<_posSales.size();++i)
        {
         if(_posSales.get(i)!=NULL)
            delete _posSales.get(i);
        }
      for(int i=0; i<_negSales.size();++i)
        {
         if(_negSales.get(i)!=NULL)
            delete _negSales.get(i);
        }
     }

/**
* The list of partial closings.
*/
                     PartialCloseList()
     {
      _posSalesDone=_negSalesDone=0;
     }

   // Methods

/**
* Add another selling point.
*
* @param sale The partial closing.
*/
   void addSale(PartialClose *sale)
     {
      if(sale.getProfit()>0)
        {
         int pos;
         for(pos=0; pos<_posSales.size();++pos)
            if(((PartialClose *)_posSales.get(pos)).getProfit()>sale.getProfit())
               break;

         _posSales.add(sale,pos);
        }
      else
        {
         int pos;
         for(pos=0; pos<_negSales.size();++pos)
            if(((PartialClose *)_negSales.get(pos)).getProfit()<sale.getProfit())
               break;

         _negSales.add(sale,pos);
        }
     }

/**
* Get the next partial closing to do, or NULL, if there is no partial closing to do.
*
* @return The next partial close to do, or NULL.
*/
   PartialClose *getPartialCloseToDo(double profit)
     {
      if(profit>0)
        {
         if(_posSalesDone==_posSales.size()) // Are all the sales done?
            return NULL;

         PartialClose *nextSale=_posSales.get(_posSalesDone);  // Get the next potential sale.

         return nextSale.getProfit() <= profit ? nextSale : NULL;
        }
      else if(profit<0)
        {
         if(_negSalesDone==_negSales.size()) // Are all the sales done?
            return NULL;

         PartialClose *nextSale=_negSales.get(_negSalesDone);  // Get the next potential sale.

         return nextSale.getProfit() >= profit ? nextSale : NULL;
        }
      else
        {
         return NULL;
        }
     }

/**
* A partial close was executed.
*
* @param close The executed closing.
*/
   void partialClosingDone(PartialClose *close)
     {
      int pos=_posSales.getIndex(close);

      if((pos!=-1) && (pos>=_posSalesDone))
        {
         _posSalesDone=pos+1;
         return;
        }

      pos=_negSales.getIndex(close);

      if((pos!=-1) && (pos>=_negSalesDone))
        {
         _negSalesDone=pos+1;
         return;
        }
     }
  };
//+------------------------------------------------------------------+
//| This class holds the info on an order.                           |
//+------------------------------------------------------------------+
class Order : public CObject
  {

private:

   // Instance variables

/**
* An optional class, controlling the position on every update.
*/
   ActivePosition   *_activePosition;

/**
* Timestamp, when the order was created.
*/
   datetime          _created;

   //+------------------------------+
   //| The partial close description |
   //+------------------------------+
   string            _partialCloseString;

/**
* The initial price of the order.
*/
   double            _initialPrice;

/**
* The stop loss when the order was opened.
*/
   double            _initialStopLoss;

/**
* The initial take profit.
*/
   double            _initialTakeProfit;

/**
* This initial size of the order.
*/
   double            _initialVolume;

/**
* The ID of the last error.
*/
   int               _lastError;

/**
* The number of order tickets, that this order had.
*/
   int               _nOrderTickets;

/**
* A pointer to the order list.
*/
   OrderList        *_orderList;

/**
* The list of order tickets of this order.
*/
   int               _orderTickets[10];

/**
* A list of partial closings or NULL.
*/
   PartialCloseList *_partialClosings;

   //+-------------------+
   //| The traded symbol |
   //+-------------------+
   string            _symbol;

   //+-----------------------------+
   //| The trailing price distance |
   //|++++++++++++++++++++++++++++++
   double            _trailingPriceDistance;

   //+---------------------------------------------------------+
   //| This flag activates a trailing price for pending orders |
   //+---------------------------------------------------------+
   bool              _trailingPriceFlag;

/**
   * The distance, when the SL is adjusted. So when the SL is
   * <_trailingSLTrigger> points off the target, the SL is reset.
   */
   double            _trailingSLTrigger;

   //+----------------------------------------------------------+
   //| Flag to indicate, if this order has a trailing stop loss |
   //+----------------------------------------------------------+
   bool              _trailingStopLossFlag;

   //+----------------------------------------------------------+
   //| The tolerance, when the trailing stop loss is readjusted |
   //+----------------------------------------------------------+
   double            _trailingStopLossTolerance;

/**
* Type of the order (buy, sell etc).
*/
   int               _type;

public:

   // Constructors

   //+--------------------+
   //| Create a new order |
   //+--------------------+
                     Order(OrderList *ol,string symbol,int type,double initialVolume,double initialPrice,double initialStopLoss,double initialTakeProfit,ActivePosition *activePosition=NULL)
     {
      constructor(ol,symbol,type,initialVolume,initialPrice,initialStopLoss,initialTakeProfit,activePosition);
     }

                     Order(OrderList *ol,int type,double initialVolume,double initialPrice,double initialStopLoss,double initialTakeProfit,ActivePosition *activePosition=NULL)
     {
      constructor(ol,_Symbol,type,initialVolume,initialPrice,initialStopLoss,initialTakeProfit,activePosition);
     }

                     Order(OrderList *ol,int type,double initialPrice,double initialVolume,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL)
     {
      _orderList=ol;
      _symbol=_Symbol;
      _type=type;
      _initialVolume=initialVolume;
      _trailingPriceFlag=false;
      _initialPrice=initialPrice;
      if(_type == OP_BUYLIMIT) _trailingPriceDistance=Ask-_initialPrice;
      if(_type == OP_SELLLIMIT) _trailingPriceDistance=_initialPrice-Bid;
      _trailingStopLossTolerance=10.0;
      parseStopLoss(sl);
      _partialClosings=NULL;
      _partialCloseString=partialClosings;
      parseTakeProfit(tp);
      parsePartialClosings(partialClosings);
      _nOrderTickets=0;  // This order has no tickets yet.
      setActivePosition(activePosition);
      _created=datetime();
      _lastError=openPosition() ? -1 : GetLastError();
     }

                     Order(OrderList *ol,int type,double initialVolume,string sl,string tp,string partialClosings,ActivePosition *activePosition=NULL)
     {
      _orderList=ol;
      _symbol=_Symbol;
      _type=type;
      _initialVolume=initialVolume;
      _trailingPriceFlag=false;
      _initialPrice=type==OP_BUY ? Ask : Bid;
      _trailingStopLossTolerance=10.0;
      parseStopLoss(sl);
      _partialClosings=NULL;
      _partialCloseString=partialClosings;
      parseTakeProfit(tp);
      parsePartialClosings(partialClosings);
      _nOrderTickets=0;  // This order has no tickets yet.
      setActivePosition(activePosition);
      _created=datetime();
      _lastError=openPosition() ? -1 : GetLastError();
     }

   //+------------------------------------------------------------------------------------------+
   //| this is a dummy constructor, since mql doesn't support recursive calling of constructors |
   //+------------------------------------------------------------------------------------------+
   void constructor(OrderList *ol,string symbol,int type,double initialVolume,double initialPrice,double initialStopLoss,double initialTakeProfit,ActivePosition *activePosition)
     {
      _orderList=ol;
      _symbol=symbol;
      _type=type;
      _initialVolume=initialVolume;
      _trailingPriceFlag=false;
      _initialPrice=initialPrice;
      _initialStopLoss=initialStopLoss;
      _initialTakeProfit=initialTakeProfit;
      _partialCloseString="";
      _partialClosings=NULL;
      _trailingStopLossFlag=false;
      _trailingStopLossTolerance=10.0;
      _nOrderTickets=0;  // This order has no tickets yet.
      setActivePosition(activePosition);
      _created=datetime();
      _lastError=openPosition() ? -1 : GetLastError();
     }

   // Destructors

   //+---------------------------------------+
   //| Delete an order an free the resources |
   //+---------------------------------------+
                    ~Order()
     {
      if(_partialClosings!=NULL)
         delete _partialClosings;

      if(_orderList!=NULL)
         delete _orderList;

      if(_activePosition!=NULL)
         delete _activePosition;
     }

   // Methods

/**
* Add a new order ticket to this order.
*
* @param ticket The new ticket for this order.
*/
   void addOrderTicket(int ticket)
     {
      //Print("Adding order ticket ",ticket);
      int numberOfOrderTickets=getNumberOfOrderTickets();

      if(ArraySize(_orderTickets)==numberOfOrderTickets) // Order ticket array capacity exceeded?
        {
         ArrayResize(_orderTickets,ArraySize(_orderTickets)+10);
        }
      _orderTickets[_nOrderTickets]=ticket;
      ++_nOrderTickets;
     }

   //+-----------------+
   //| Close the order |
   //+-----------------+
   bool closePosition(double vol=-1)
     {
      int maxOrder=-1;

      if(vol==-1)
         vol=getCurrentVolume();
      else
        {
         double curVolume=getCurrentVolume();

         if(vol>curVolume)
            vol=curVolume;

         // If it's a partial close, store the latest order number
         for(int i=0; i<OrdersTotal();++i)
            if(OrderSelect(i,SELECT_BY_POS) && OrderTicket()>maxOrder)
               maxOrder=OrderTicket();
        }

      if(getLastOrderTicket()==-1)
         return false;


      for(int attempts=0; attempts<3;++attempts)
        {
         if(OrderClose(getLastOrderTicket(),vol,_type==OP_BUY ? Bid : Ask,3,_type==OP_BUY ? Green : Red))
           {
            // Update the order tickets and add the order ticket after the last one.
            if(maxOrder!=-1)
              {
               // The following is code is robust, but suboptimal, since the new order ticket should be maxOrder+1
               for(int i=0; i<OrdersTotal();++i)
                 {
                  if(OrderSelect(i,SELECT_BY_POS) && OrderTicket()>maxOrder)
                    {
                     addOrderTicket(OrderTicket());
                     break;;
                    }
                 }
              }
            return true;
           }
        }
      return false;
     }

   //+----------------------------+
   //| Get the current order type |
   //+----------------------------+
   int getCurrentOrderType()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {  // Try to select the order
         return -1;
        }
      return OrderType();
     }

   //+----------------------------+
   //| Get the current price |
   //+----------------------------+
   double getCurrentPrice()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {  // Try to select the order
         return -1;
        }
      return OrderOpenPrice();
     }

/**
   * Get the current stop loss of this order.
   *
   * @return The current stop loss of the order or -1 in case of an error.
   */
   double getCurrentStopLoss()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {
         return -1;  // Selecting the order failed
        }

      return OrderStopLoss();  // Get the current stop loss of this order.
     }

/**
* Get the current take profit of this order.
*
* @return The current take profit of this order.
*/
   double getCurrentTakeProfit()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {
         return -1;  // Selecting the order failed
        }

      return OrderTakeProfit();
     }

   //+-------------------------------------+
   //| Get the current volume of the order |
   //+-------------------------------------+
   double getCurrentVolume()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {
         return -1;  // Selecting the order failed
        }

      return OrderLots();
     }

   //+-------------------------------------+
   //| Get the initial price of this order |
   //+-------------------------------------+
   double getInitialPrice()
     {
      return _initialPrice;
     }

   //+-----------------------------------------+
   //| Get the initial stop loss of this order |
   //+-----------------------------------------+
   double getInitialStopLoss()
     {
      return _initialStopLoss;
     }

   //+-----------------------------------------------+
   //| Get the initial take profit of this order     |
   //|                                               |
   //| @return The initial take profit of this order |
   //+-----------------------------------------------+
   double getInitialTakeProfit()
     {
      return _initialTakeProfit;
     }

   //+--------------------------------------+
   //| Get the initial volume of this order |
   //+--------------------------------------+
   double getInitialVolume()
     {
      return _initialVolume;
     }

   //+-----------------------------------------------------------+
   //| Get the ID of the last error or -1, if there was no error |
   //+-----------------------------------------------------------+
   int getLastError()
     {
      return _lastError;
     }

/**
* Get the last order tickets, that this order had.
*
* @return The last order ticket, that this order had.
*/
   int getLastOrderTicket()
     {
      return _nOrderTickets < 1 ? -1 : _orderTickets[_nOrderTickets-1];
     }

   //+----------------------------------------------------------+
   //| Get the number of order tickets, that this order had     |
   //|                                                          |
   //| @return The number of order tickets, that this order had |
   //+----------------------------------------------------------+
   int getNumberOfOrderTickets()
     {
      return _nOrderTickets;
     }

   //+------------------------------------------------------------------+
   //| Get the price, at which the order was opened. This price differs |
   //| from the initial price because of the slippage at order open!    |
   //+------------------------------------------------------------------+
   double getOpenPrice()
     {
      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {
         return -1;  // Selecting the order failed
        }

      return OrderOpenPrice();
     }

   //+-----------------------------------------------+
   //| Get the order list, this order belongs to     |
   //|                                               |
   //| @return The order list, this order belongs to |
   //+-----------------------------------------------+
   OrderList *getOrderList()
     {
      return _orderList;
     }

   //+---------------------------------------+
   //| Get a past order ticket of this order |
   //+---------------------------------------+
   int getOrderTicket(int i)
     {
      return _orderTickets[i];
     }

   //+------------------------------------------------+
   //| Get the string describing the partial closings |
   //+------------------------------------------------+
   string getPartialCloseString()
     {
      return _partialCloseString;
     }

   //+----------------------------------------+
   //| Get the distance of the trailing price |
   //+----------------------------------------+
   double getPriceDistance()
     {
      return _trailingPriceDistance;
     }

/**
* Get the profit (or loss) of this order.
*
* @return The profit or loss of this order or -1000000000, if it can't be computed.
*/
   double getProfit()
     {
      double prof=0;
      int nTickets=getNumberOfOrderTickets();

      for(int i=0; i<nTickets;++i)
        {
         if(_orderTickets[i]==-1)
            continue;

         if(OrderSelect(_orderTickets[i],SELECT_BY_TICKET,MODE_HISTORY))
            prof+=OrderProfit();
         else if(OrderSelect(_orderTickets[i],SELECT_BY_TICKET))
            prof+=OrderProfit();
        }
      return prof;
     }

/**
* Get the distance of the trailing SL.
*
* @return The distance (absolute value!) of the stop loss.
*/
   double getTrailingStopLossDistance()
     {
      return MathAbs(_initialPrice - _initialStopLoss);
     }

   //+----------------------------+
   //| Get the type of this order |
   //+----------------------------+
   int getType()
     {
      return _type;
     }

   //+-----------------------------------------------------------+
   //| Check, if this order has a trailing price (pending order) |
   //+-----------------------------------------------------------+
   bool hasTrailingPrice()
     {
      return _trailingPriceFlag;
     }

   //+-----------------------------------------------+
   //| Check, if this order has a trailing stop loss |
   //+-----------------------------------------------+
   bool hasTrailingStopLoss()
     {
      return _trailingStopLossFlag;
     }

   //+---------------------------------+
   //| Check, if this order is closed. |
   //+---------------------------------+
   bool isClosed()
     {
      if(getLastOrderTicket()==-1)
        {
         return true;
        }

      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {
         Print("Error: cannot select order from traded orders ",getLastOrderTicket());
         return false;
        }
      else
        {
         return(OrderCloseTime()!=0);  // If the order is closed, there must be a close time
        }
     }

   //+--------------------------------------------------+
   //| Check, if this order is currently a market order |
   //+--------------------------------------------------+
   bool isMarketOrder()
     {
      int currentOrderType=getCurrentOrderType();

      return currentOrderType==OP_BUY || currentOrderType==OP_SELL;
     }

   //+------------------------------+
   //| Check, if this order is open |
   //+------------------------------+
   bool isOpen()
     {
      return getLastOrderTicket()!=-1 && !isClosed();
     }

   //+----------------------------------------------------+
   //| Check, if this order is currently a pending order |
   //+---------------------------------------------------+
   bool isPendingOrder()
     {
      int currentOrderType=getCurrentOrderType();

      return currentOrderType==OP_BUYLIMIT || currentOrderType==OP_SELLLIMIT || currentOrderType==OP_BUYSTOP || currentOrderType==OP_SELLSTOP;
     }

   //+--------------------------------------+
   //| Try to open this order as a position |
   //+--------------------------------------+
   bool openPosition()
     {
      //Print("openPosition called!");
      for(int attempts=0; attempts<3;++attempts)
        {
         int newOrderID;

         Print("open order type ",_type," price ",_initialPrice," sl ",_initialStopLoss," tp ",_initialTakeProfit);

         if((newOrderID=OrderSend(_symbol,_type,_initialVolume,_initialPrice,3,_initialStopLoss,_initialTakeProfit,NULL,getOrderList().getMagicNumber(),0,_type==OP_BUY ? Green : Red))!=-1)
           {
            addOrderTicket(newOrderID);
            //Print("New order ticket is ",newOrderID);
            return true;
           }
         else
           {
            int lastErrorCode=GetLastError();
            Print("Cannot open new order. Error code is ",lastErrorCode);
            switch(lastErrorCode)
              {
               case 130:
                  Print("Type is ",_type==OP_BUY?"buy":"sell");
                  Print("Price is ",_initialPrice);
                  Print("Stop loss is ",_initialStopLoss);
                  Print("Minimum stop loss is ",MarketInfo(_Symbol,MODE_STOPLEVEL));
                  Print("Take profit is ",_initialTakeProfit);
                  break;
              }
            return false;
           }
        }
      return false;
     }

   //+--------------------------------------+
   //| Parse a string with partial closings |
   //+--------------------------------------+
   void parsePartialClosings(string closingString)
     {
      closingString=StringTrimLeft(StringTrimRight(closingString));

      if(closingString=="")
         return;

      string closings[];

      StringSplit(closingString,',',closings);

      int nClosings=ArraySize(closings);
      for(int i=0; i<nClosings;++i)
        {
         string saleSpecs[];

         int nTokens=StringSplit(closings[i],':',saleSpecs);

         if(nTokens==2)
           {
            double sellPosMultiplier=1.0;  // This is a multiplier, in case the sell pos is given as a percentage of the takeProfit

                                           // Check, if the sell pos was given as a percentage of the takeProfit
            saleSpecs[0]=StringTrimLeft(StringTrimRight(saleSpecs[0]));
            int sellPosLen=StringLen(saleSpecs[0]);
            if(sellPosLen>0)
              {
               if(StringGetCharacter(saleSpecs[0],sellPosLen-1)=='%')
                 {
                  saleSpecs[0]=StringSubstr(saleSpecs[0],0,sellPosLen-1);  // Remove the '%' character
                                                                           //sellPosMultiplier=0.01*MathAbs(getInitialTakeProfit()-getInitialPrice());
                  sellPosMultiplier=0.01*getTrailingStopLossDistance();
                 }
              }

            double volumeMultiplier=1.0;

            // Check, if the volume is given as a percentage of the initial volume
            saleSpecs[1]=StringTrimLeft(StringTrimRight(saleSpecs[1]));
            int volumeLen=StringLen(saleSpecs[1]);
            if(volumeLen>0 && StringGetCharacter(saleSpecs[1],volumeLen-1)=='%')
              {
               saleSpecs[1]=StringSubstr(saleSpecs[1],0,volumeLen-1);
               volumeMultiplier=0.01*_initialVolume;
              }

            double volumeLots=volumeMultiplier*StringToDouble(saleSpecs[1]);

            double step=MarketInfo(_Symbol,MODE_LOTSTEP);
            volumeLots=(int)MathRound(volumeLots/step)*step;
            if( volumeLots > MarketInfo(_Symbol,MODE_MAXLOT)) volumeLots=MarketInfo(_Symbol,MODE_MAXLOT);
            if( volumeLots < MarketInfo(_Symbol,MODE_MINLOT)) volumeLots=MarketInfo(_Symbol,MODE_MINLOT);

            if(_partialClosings==NULL)
               _partialClosings=new PartialCloseList();

            // ToDo: more error checking!!!
            Print("Add new partial closing: ",volumeLots," at ",sellPosMultiplier*StringToDouble(saleSpecs[0]));
            _partialClosings.addSale(new PartialClose(sellPosMultiplier*StringToDouble(saleSpecs[0]),volumeLots));
           }
         else
           {
            Print("Error: invalid partial closing: ",closings[i]);
           }
        }
     }

   //+--------------------------+
   //| Parse a stop loss string |
   //+--------------------------+
   void parseStopLoss(string sl)
     {
      sl=StringTrimLeft(StringTrimRight(sl));

      if(sl=="")
        {
         _initialStopLoss=-1;
         return;
        }

      // Check, if a tolerance is added as a second argument
      int tolerancePos=StringFind(sl,",");
      if(tolerancePos!=-1)
        {
         string tokens[];
         StringSplit(sl,',',tokens);
         sl=tokens[0];  // This is just the signed stop loss.
         _trailingStopLossTolerance=NormalizeDouble(StringToDouble(tokens[1]),Digits);
         if(_trailingStopLossTolerance<0)
           {
            Print("Error: illegal stop loss tolderance in settings: ",sl);
            _trailingStopLossTolerance=0;
           }
        }

      ushort sign=StringGetCharacter(sl,0);
      if(sign=='+' || sign=='-')
        {
         _trailingStopLossFlag=true;
         _initialStopLoss=NormalizeDouble(_initialPrice+StrToDouble(sl),Digits);
         //Print("Set trailing SL to: ",_initialStopLoss);
        }
      else
        {
         _trailingStopLossFlag=false;
         _initialStopLoss=StrToDouble(sl);
        }
     }

   //+----------------------------+
   //| Parse a take profit string |
   //+----------------------------+
   void parseTakeProfit(string tp)
     {
      tp=StringTrimLeft(StringTrimRight(tp));

      if(tp=="")
        {
         _initialTakeProfit=-1;
         return;
        }

      ushort sign=StringGetCharacter(tp,0);
      if(sign=='+' || sign=='-')
        {
         _initialTakeProfit=NormalizeDouble(_initialPrice+StrToDouble(tp),Digits);
        }
      else
        {
         _initialTakeProfit=StrToDouble(tp);
        }
     }

   //+--------------------------------------------+
   //| Round a volume to a market compliant value |
   //+--------------------------------------------+
   double roundLots(double volumeLots)
     {
      double step=MarketInfo(_Symbol,MODE_LOTSTEP);
      volumeLots=(int)MathRound(volumeLots/step)*step;
      if( volumeLots > MarketInfo(_Symbol,MODE_MAXLOT)) return MarketInfo(_Symbol,MODE_MAXLOT);
      if( volumeLots < MarketInfo(_Symbol,MODE_MINLOT)) return MarketInfo(_Symbol,MODE_MINLOT);

      return volume;
     }

   //+---------------------------------------+
   //| Set an active position for this order |
   //+---------------------------------------+
   void setActivePosition(ActivePosition *ap)
     {
      _activePosition=ap;
      if(_activePosition!=NULL)
         _activePosition.setOrder(GetPointer(this));
     }

   //+-------------------------------------------+
   //| Activate or deactivate the trailing price |
   //+-------------------------------------------+
   void setTrailingPrice(bool active)
     {
      _trailingPriceFlag=active;
     }

   //+-------------------------------+
   //| Update the data of this order |
   //+-------------------------------+
   bool update()
     {
      if(_activePosition!=NULL)
         return _activePosition.updatePosition();
      else
        {
         if( isMarketOrder()) return updateMarketOrder() && updatePartialSales();
         if( isPendingOrder()) return updatePendingOrder();
        }
      return true;
     }

/**
* Do partial closings, if they are due.
*/
   bool updatePartialSales()
     {
      if(_partialClosings==NULL)
         return true;  // Nothing to sell...

      double currentProfit=getProfit();

      PartialClose *currentClose;

      while(( currentClose=_partialClosings.getPartialCloseToDo(currentProfit))!=NULL)
        {
         //Print("Check next partial sale");
         if(isClosed())
            return true;

         if(!closePosition(currentClose.getVolume()))
            return false;
         else
            _partialClosings.partialClosingDone(currentClose);
        }

      return true;
     }

   //+------------------------+
   //| Update a pending order |
   //+------------------------+
   bool updatePendingOrder()
     {
      if(!hasTrailingPrice())
         return true;

      int orderType=getCurrentOrderType();

      if(orderType==OP_BUYLIMIT || orderType==OP_SELLSTOP)
        {
         double currentPriceDistance=Ask-getCurrentPrice();
         double priceOffset=currentPriceDistance-getPriceDistance();
         if(priceOffset>5)
           {
            double newPrice=getCurrentPrice()+priceOffset;
            double newSL=getCurrentStopLoss()+priceOffset;
            double newTP=getCurrentTakeProfit()+priceOffset;

            int attempts;
            for(attempts=0; attempts<3 && !OrderModify(OrderTicket(),newPrice,newSL,newTP,0,Blue);++attempts)
              {
               Print("Error: cannot modify order to update trailing price");  // ToDo: log this in a CSV file?
              }
            return (attempts<3);
           }
        }

      if(orderType==OP_SELLLIMIT || orderType==OP_BUYSTOP)
        {
         double currentPriceDistance=getCurrentPrice()-Bid;
         double priceOffset=currentPriceDistance-getPriceDistance();
         if(priceOffset>5)
           {
            double newPrice=getCurrentPrice()-priceOffset;
            double newSL=getCurrentStopLoss()-priceOffset;
            double newTP=getCurrentTakeProfit()-priceOffset;

            int attempts;
            for(attempts=0; attempts<3 && !OrderModify(OrderTicket(),newPrice,newSL,newTP,0,Red);++attempts)
              {
               Print("Error: cannot modify order to update trailing price");  // ToDo: log this in a CSV file?
              }
            return (attempts<3);
           }
        }

      return true;
     }
   //+--------------------------------------------------------------------------+
   //| Try to update the trailing stop loss of this order                       |
   //|                                                                          |
   //| @return true, if the stop loss was successfully updated. False otherwise |
   //+--------------------------------------------------------------------------+
   bool updateMarketOrder()
     {
      if(!hasTrailingStopLoss())
        {  // Has this order a trailing SL?
         return true;  // No => error
        }

      if(getNumberOfOrderTickets()<1)
        {                  // Check, if this order was opened
         return false;     // Nope => error!
        }

      if(!OrderSelect(getLastOrderTicket(),SELECT_BY_TICKET))
        {  // Try to select the order
         return false;
        }

      if(OrderType()==OP_BUY)
        {
         if((Ask-OrderStopLoss())>(getTrailingStopLossDistance()+_trailingStopLossTolerance))
           {
            double newStopLoss=NormalizeDouble(Ask-getTrailingStopLossDistance(),Digits);
            int attempts;
            for(attempts=0; attempts<3 && !OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0,Blue);++attempts)
              {
               Print("Error: cannot modify order to update trailing stop loss");  // ToDo: log this in a CSV file?
              }
            return (attempts<3);
           }
         return true;
        }

      if(OrderType()==OP_SELL)
        {
         if((OrderStopLoss()-Bid)>(getTrailingStopLossDistance()+_trailingStopLossTolerance))
           {
            double newStopLoss=NormalizeDouble(Bid+getTrailingStopLossDistance(),Digits);
            int attempts;
            for(attempts=0; attempts<3 && !OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0,Red);++attempts)
              {
               Print("Error: cannot modify order to update trailing stop loss");
              }
            return (attempts<3);
           }
         return true;
        }

      return false;  // Unknown order type?
     }
  };
//+------------------------------------------------------------------+
#endif
//+------------------------------------------------------------------+
