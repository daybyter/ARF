//+------------------------------------------------------------------+
//|                                               DisplayElement.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _DISPLAYELEMENT_MQH_
#define _DISPLAYELEMENT_MQH_

#include "..\..\Object.mqh"
#include "..\datastruct\ArrayList.mqh"
//+----------------------------------------------+
//| This is the base class of displayed elements |
//+----------------------------------------------+
class DisplayElement : public CObject
  {
private:

   // Instance variables

   //+------------------------------+
   //| The lit of displayed objects |
   //+------------------------------+
   string            _objectList[];

   //+-------------------------+
   //| The horizontal position |
   //+-------------------------+
   int               _x;

   //+-----------------------+
   //| The vertical position |
   //+-----------------------+
   int               _y;

public:

   // Constructors

   //+---------------------------------+
   //| Create a new element to display |
   //+---------------------------------+
                     DisplayElement(int x,int y) : _x(x),_y(y) { }

   // Destructors

   //+--------------------------------------------------+
   //| Remove all the displayed objects from the screen |
   //+--------------------------------------------------+
                    ~DisplayElement()
     {
      removeAllRememberedObjects();
     }

   // Methods

   //+----------------------------+
   //| Paint a colored background |
   //+----------------------------+
   void createBackground(int corner,int x,int y,int width,int height,int col,string objectName=NULL)
     {
      if(objectName==NULL) // If the user gave no object name
        {
         objectName="newObject";

         // Make the new object name unique, by adding a number
         int i=1;
         while(ObjectFind(0,objectName+IntegerToString(i))<0) // Check if such an object already exists.
            ++i;  // If so, increment the number

         objectName=objectName+IntegerToString(i);
        }

      if(ObjectCreate(0,objectName,OBJ_RECTANGLE_LABEL,0,0,0,0))
        {
         ObjectSetInteger(0,objectName,OBJPROP_CORNER,corner);
         ObjectSetInteger(0,objectName,OBJPROP_XSIZE,width);
         ObjectSetInteger(0,objectName,OBJPROP_YSIZE,height);
         ObjectSetInteger(0,objectName,OBJPROP_XDISTANCE,x);
         ObjectSetInteger(0,objectName,OBJPROP_YDISTANCE,y);
         ObjectSetInteger(0,objectName,OBJPROP_BGCOLOR,col);
         ObjectSet(objectName,OBJPROP_BACK,false);

         rememberObject(objectName);  // Store the name, so we can delete the object later
        }
     }

   //+--------------------------------------+
   //| Get the number of remembered objects |
   //+--------------------------------------+
   int getNumberOfRememberedObjects()
     {
      return ArraySize(_objectList);
     }

   //+-------------------------+
   //| Get a remembered object |
   //+-------------------------+
   string getRememberedObject(int index)
     {
      return _objectList[index];
     }

   //+----------------------+
   //| Get the x coordinate |
   //+----------------------+
   int getX()
     {
      return _x;
     }

   //+----------------------+
   //| Get the y coordinate |
   //+----------------------+
   int getY()
     {
      return _y;
     }

   //+--------------------------------------------+
   //| Add an object to the list of known objects |
   //+--------------------------------------------+
   void rememberObject(string name)
     {
      int currentSize=ArraySize(_objectList);
      ArrayResize(_objectList,currentSize+1);
      _objectList[currentSize]=name;
     }

   //+-----------------------------------------------+
   //| Remove all remembered objects from the screen |
   //+-----------------------------------------------+
   void removeAllRememberedObjects()
     {
      int nObjects=getNumberOfRememberedObjects();

      for(int i=0; i<nObjects;++i)
        {
         string oName=getRememberedObject(i);
         if(oName!=NULL)
            ObjectDelete(oName);
        }
     }

   //+--------------------------+
   //| Show or hide this object |
   //+--------------------------+
   void setVisibility(bool visible)
     {
      int nObjects=getNumberOfRememberedObjects();

      for(int i=0; i<nObjects;++i)
        {
         string oName=getRememberedObject(i);
         if(oName!=NULL)
            ObjectSet(oName,OBJPROP_TIMEFRAMES,visible ? _Period : OBJ_NO_PERIODS);
        }
     }
  };
#endif
//+------------------------------------------------------------------+
