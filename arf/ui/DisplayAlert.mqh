//+------------------------------------------------------------------+
//|                                                 DisplayAlert.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict
#ifndef _DISPLAYALERT_MQH_
#define _DISPLAYALERT_MQH_

#include "DisplayElement.mqh"
//+------------------------------+
//| This class displays an alert |
//+------------------------------+
class DisplayAlert : public DisplayElement
  {
private:

   // Instance variables

   //+------------------------+
   //| The message to display |
   //+------------------------+
   string            _message;

public:

   // Constructors

   //+--------------------+
   //| Create a new alert |
   //+--------------------+
                     DisplayAlert(string message,int x,int y) : _message(message),DisplayElement(x,y) { }

   // Methods

   //+------------------------------+
   //| Create the actual UI element |
   //+------------------------------+
   void create()
     {
      // Check if the message contain of multiple lines
      string msgLine[1];
      int lines;
      if(StringFind(_message,"\n")>0)
        {
         lines=StringSplit(_message,'\n',msgLine);
        }
      else
        {
         msgLine[0]=_message;
         lines=1;
        }

      createBackground(CORNER_LEFT_UPPER,getX(),getY(),800,lines*40,Red);

      for(int curLine=0; curLine<lines;++curLine)
        {
         string objName="Message"+IntegerToString(curLine);

         if(ObjectCreate(objName,OBJ_LABEL,0,0,0))
           {
            ObjectSetInteger(0,objName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetText(objName,StringTrimLeft(StringTrimRight(msgLine[curLine])),24,"Verdana",White);
            ObjectSet(objName,OBJPROP_XDISTANCE,getX()+10);
            ObjectSet(objName,OBJPROP_YDISTANCE,getY()+curLine*32);
            ObjectSet(objName,OBJPROP_BACK,false);
            
            rememberObject(objName);
           }
        }
     }
  };
#endif
//+------------------------------------------------------------------+
