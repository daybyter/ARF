//+------------------------------------------------------------------+
//|                                                DisplayProfit.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _DISPLAYPROFIT_MQH_
#define _DISPLAYPROFIT_MQH_

#include "DisplayElement.mqh"
//+----------------------------------------+
//| This class displays the current profit |
//+----------------------------------------+
class DisplayProfit : public DisplayElement
  {
private:

   // Instance variables

public:

   // Constructors

                     DisplayProfit(int x,int y) : DisplayElement(x,y) {}

   // Methods

   //+------------------------------+
   //| Create the actual UI element |
   //+------------------------------+
   void create()
     {
      createBackground(CORNER_RIGHT_UPPER,getX(),getY(),210,28,Blue,"ProfitBackground");

      string profitObjName="Profit";
      if(ObjectCreate(profitObjName,OBJ_LABEL,0,0,0))
        {
         ObjectSetInteger(0,profitObjName,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetText(profitObjName,"Profit:",16,"Verdana",White);
         ObjectSet(profitObjName,OBJPROP_XDISTANCE,getX()-6);
         ObjectSet(profitObjName,OBJPROP_YDISTANCE,getY()+2);
         ObjectSet(profitObjName,OBJPROP_BACK,false);

         rememberObject(profitObjName);
        }

      string amountObjName="Amount";
      if(ObjectCreate(amountObjName,OBJ_LABEL,0,0,0))
        {
         ObjectSetInteger(0,amountObjName,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetText(amountObjName,"0",16,"Verdana",White);
         ObjectSet(amountObjName,OBJPROP_XDISTANCE,getX()-80);
         ObjectSet(amountObjName,OBJPROP_YDISTANCE,getY()+2);
         ObjectSet(amountObjName,OBJPROP_BACK,false);

         rememberObject(amountObjName);
        }
     }

   //+--------------------------+
   //| Update the profit amount |
   //+--------------------------+
   void update(double newProfit)
     {
      ObjectSetText("Amount",DoubleToString(newProfit,_Digits),16,"Verdana",White);
      ObjectSetInteger(0,"ProfitBackground",OBJPROP_BGCOLOR,newProfit<0 ? Red : Green);
     }
  };
#endif
//+------------------------------------------------------------------+
