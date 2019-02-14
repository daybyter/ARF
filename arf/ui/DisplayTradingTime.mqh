//+------------------------------------------------------------------+
//|                                           DisplayTradingTime.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _DISPLAYTRADINGTIME_MQH_
#define _DISPLAYTRADINGTIME_MQH_

#include "DisplayElement.mqh"
//+---------------------------------------------------------+
//| This class displays, if there is currently trading time |
//| and trading is active                                   |
//+---------------------------------------------------------+
class DisplayTradingTime : public DisplayElement
  {

private:

   // Instance variables

public:

   // Constructors

   //+------------------------------------------------------+
   //| Create a new display if it is currently trading time |
   //+------------------------------------------------------+
                     DisplayTradingTime(int x,int y) : DisplayElement(x,y) { }

   // Methods

   //+------------------------------+
   //| Create the actual UI element |
   //+------------------------------+
   void create()
     {
      createBackground(CORNER_RIGHT_UPPER,getX(),getY(),210,28,Yellow,"TradingTimeBackground");

      if(ObjectCreate("TradingTime",OBJ_LABEL,0,0,0))
        {
         ObjectSetInteger(0,"TradingTime",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetText("TradingTime","Trading: no",16,"Verdana",White);
         ObjectSet("TradingTime",OBJPROP_XDISTANCE,getX()-6);
         ObjectSet("TradingTime",OBJPROP_YDISTANCE,getY()+2);
         ObjectSet("TradingTime",OBJPROP_BACK,false);

         rememberObject("TradingTime");
        }
     }

   //+----------------------------------+
   //| Update the trading time indicator |
   //+-----------------------------------+
   void update(bool isTradingTime)
     {
      ObjectSetText("TradingTime",isTradingTime ? "Trading: active" : "Trading: disabled",16,"Verdana",White);
      ObjectSetInteger(0,"TradingTimeBackground",OBJPROP_BGCOLOR,isTradingTime ? Green : Red);
     }
  };
#endif
//+------------------------------------------------------------------+
