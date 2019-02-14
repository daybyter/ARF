//+------------------------------------------------------------------+
//|                                                    ArrayList.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _ARRAYLIST_MQH_
#define _ARRAYLIST_MQH_

#include "..\..\Object.mqh"
//+------------------------------------------------------------------+
//| This class handles lists of a variable size.                                                                 |
//+------------------------------------------------------------------+
class ArrayList
  {

private:

   // Instance variables

/**
   * An array of data.
   */
   CObject          *_data[];

public:

   // Constructors

/**
   * Create an array list with the default capacity.
   */
                     ArrayList()
     {
      ArrayResize(_data,0);
     }

   // Methods

/**
* Add a new object at the end of the list.
*
* @param newElement The new element to add.
*/
   void add(CObject *newElement)
     {
      resizeCapacity(getCapacity()+1);
      _data[size()-1]=newElement;
     }

/**
* Add a new element at a given position.
*
* @param newElement The new element to add.
* @param index The position to use for the new element.
*/
   void add(CObject *newElement,int index)
     {
      if(index>=size())
        {
         resizeCapacity(index+1);
        }
      _data[index]=newElement;
     }

   //+-----------------------------------------------------+
   //| Try to compact this array by removing NULL pointers |
   //+-----------------------------------------------------+
   void compact()
     {
      int newLocation=0;
      int size=size();

      if(size==0)
         return;

      for(int i=0; i<size;++i)
        {
         if(_data[i]!=NULL)
           {
            _data[newLocation++]=_data[i];
           }
        }

      resizeCapacity(newLocation);
     }

/**
* Check, if this list contains a given elements.
*
* @param The element to check for.
*
* @return true, if the element in in the list.
*/
   bool contains(CObject *element)
     {
      return ( getIndex(element) != -1);
     }

   //+---------------------------------+
   //| Delete an element from the list |
   //+---------------------------------+
   void remove(int index)
     {
      if(_data[index]!=NULL)
         delete _data[index];

      _data[index]=NULL;
     }

/**
* Get the object at a given index of the list.
*
* @param index The index of the object.
*
* @return A pointer to the requested object or NULL.
*/
   CObject *get(int index)
     {
      return index < size() ? _data[index] : NULL;
     }

/**
* Get the current capacity of the list.
*
* @return The current capacity of the list.
*/
   int getCapacity()
     {
      return ArraySize(_data);
     }

/**
* Get the index of an element, if it is in this list.
*
* @return The index of the element, if it is in this list, or -1 if the element is not in the list.
*/
   int getIndex(CObject *element)
     {
      for(int pos=0; pos<size();++pos)
         if(get(pos)==element)
            return pos;

      return -1;
     }

/**
* Check, if this list has exceeded it's capacity.
*
* @return true, if this list has exceeded it's capacity.
*/
   bool isFull()
     {
      return size()==getCapacity();
     }

/**
* Set the capacity to a new size, but do not(!) any elements in the list.
* So the list cannot get smaller than size() !
*
* @param newCapacity The new capacity of the list.
*/
   void resizeCapacity(int newCapacity)
     {
      ArrayResize(_data,newCapacity);
     }

/**
     * Get the current number of elements in the list.
     *
     * @return The current number of elements in the list.
     */
   int size()
     {
      return getCapacity();
     }
  };
//+------------------------------------------------------------------+
#endif 
//+------------------------------------------------------------------+
