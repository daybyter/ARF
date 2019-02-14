//+------------------------------------------------------------------+
//|                                                   Properties.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict


#include "..\..\Object.mqh"
#include "Property.mqh"
//+------------------------------------------------------------------+
//| Objects of this class hold a list of property objects            |
//+------------------------------------------------------------------+
class Properties : public CObject
  {

private:

   // Instance variables

   //+-------------------------------------------------------------+
   //| The list of available properties                            |
   //| This should be a real hashmap, but I did not write that yet |
   //| Since the properties are most likely only read once, it's   |
   //| not that performance-critical, so...                        |
   //+-------------------------------------------------------------+
   ArrayList         _properties;

public:

   // Constructors

   //+-----------------------------------------------------------+
   //| Delete all the Property objects, once the list is deleted |
   //+-----------------------------------------------------------+
                    ~Properties()
     {
      int nProperties=_properties.size();
      for(int i=0; i<nProperties;++i)
        {
         if(CheckPointer(_properties.get(i)))
           {
            Property *curProp=(Property *)_properties.get(i);
            if(curProp!=NULL)
               delete curProp;
           }
        }
     }

   // Methods

   //+----------------------------------------------+
   //| Add a new property to the list of properties |
   //+----------------------------------------------+
   void add(string key,string value)
     {
      _properties.add(new Property(key,value));
     }

   //+----------------------------------------------+
   //| Get the property with the given name or NULL |
   //+----------------------------------------------+
   Property *get(string name)
     {
      int nProperties=_properties.size();
      for(int i=0; i<nProperties;++i)
        {
         if(CheckPointer(_properties.get(i)))
           {
            Property *curProp=(Property *)_properties.get(i);
            if(curProp!=NULL && curProp.getKey()==name)
               return curProp;
           }

        }
      return NULL;  // No property with the given name found
     }

   //+------------------------------------+
   //| Get a property value as a datetime |
   //+------------------------------------+
   datetime getDatetime(string name)
     {
      return StrToTime(getString(name));
     }

   //+----------------------------------+
   //| Get a property value as a double |
   //+----------------------------------+
   double getDouble(string name)
     {
      return StringToDouble(getString(name));
     }

   //+------------------------------------+
   //| Get a property value as an integer |
   //+------------------------------------+
   int getInteger(string name)
     {
      return (int)StringToInteger(getString(name));
     }

   //+----------------------------+
   //| Get a property as a string |
   //+----------------------------+
   string getString(string name)
     {
      Property *prop=get(name);

      return prop != NULL ?prop.getValue() : "";
     }

   //+-------------------------------------------------+
   //| Check, if the property with a given name exists |
   //+-------------------------------------------------+
   bool propertyExists(string name)
     {
      int nProperties=_properties.size();  // The number of known properties
      for(int i=0; i<nProperties;++i)
        {
         if(CheckPointer(_properties.get(i))!=POINTER_INVALID)
           {
            Property *prop=_properties.get(i);
            if(prop.getKey()==name)
               return true;
           }
         else
            Print("Property is NULL");
        }
      return false;
     }

   //+----------------------------------------------------------------------+
   //| Set a datetime variable, if the property exists in the property file |
   //+----------------------------------------------------------------------+
   bool setDatetime(datetime &var,string propname)
     {
      if(propertyExists(propname))
        {
         var=getDatetime(propname);
         return true;
        }
      return false;
     }

   //+--------------------------------------------------------------------+
   //| Set a double variable, if the property exists in the property file |
   //+--------------------------------------------------------------------+
   bool setDouble(double &var,string propname)
     {
      if(propertyExists(propname))
        {
         var=getDouble(propname);
         return true;
        }
      return false;
     }
   //+----------------------------------------------------------------------+
   //| Set an integer variable, if the property exists in the property file |
   //+----------------------------------------------------------------------+
   bool setInteger(int &var,string propname)
     {
      if(propertyExists(propname))
        {
         var=getInteger(propname);
         return true;
        }
      return false;
     }
   //+--------------------------------------------------------------------+
   //| Set a string variable, if the property exists in the property file |
   //+--------------------------------------------------------------------+
   bool setString(string &var,string propname)
     {
      if(propertyExists(propname))
        {
         var=getString(propname);
         return true;
        }
      return false;
     }
  };
//+------------------------------------------------------------------+
