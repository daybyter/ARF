//+------------------------------------------------------------------+
//|                                                   ConfigFile.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

#ifndef _CONFIGFILE_MQH_
#define _CONFIGFILE_MQH_

#include "..\..\Object.mqh"
#include "Properties.mqh"
//+-----------------------------------------+
//| This class loads a file with properties |
//+-----------------------------------------+
class ConfigFile
  {

private:

   // Instance variables

   //+-------------------------------+
   //| The name of the property file |
   //+-------------------------------+
   string            _filename;

   //+---------------------+
   //| The read properties |
   //+---------------------+
   Properties        _properties;

public:

   // Constructors

   //+---------------------------------------------------+
   //| Create a config file with a auto-created filename |
   //+---------------------------------------------------+
                     ConfigFile() : _filename(getDefaultConfigName())
     {
     }

   //+--------------------------------------------+
   //| Create a config file from a given filename |
   //+--------------------------------------------+
                     ConfigFile(string filename) : _filename(filename)
     {
     }

   // Methods

   //+-----------------------------------+
   //| Check, if this config file exists |
   //+-----------------------------------+
   bool exists()
     {
      return FileIsExist(_filename);
     }

   //+--------------------------------------------------------------------------------------------------------+
   //| Create a default name for the config file from the EA name, the broker name, the symbol and the period |
   //+--------------------------------------------------------------------------------------------------------+
   string getDefaultConfigName()
     {
      string eaName=WindowExpertName();
      StringReplace(eaName," ","_");
      StringReplace(eaName,".","_");

      string brokerName=AccountCompany();
      StringReplace(brokerName," ","_");

      string filePath="arf\\config\\";

      string symbolName=_Symbol;
      StringReplace(symbolName,".","_");

      return filePath+eaName+"_"+brokerName+"_"+symbolName+"_"+IntegerToString(_Period)+".config";
     }

   //+-------------------------------------+
   //| Get the filename of the config file |
   //+-------------------------------------+
   string getFilename()
     {
      return _filename;
     }

   //+------------------------------------------+
   //| Get the properties, once they are loaded |
   //+------------------------------------------+
   Properties *getProperties()
     {
      return &_properties;
     }

   //+----------------------------+
   //| Try to load the properties |
   //+----------------------------+
   bool load()
     {
      int fhandle=FileOpen(_filename,FILE_READ|FILE_ANSI|FILE_TXT);

      if(fhandle==INVALID_HANDLE)
        {
         Print("Cannot open config file ",_filename);
         return false;
        }

      string curLine;  // The current input line
      string lineTokens[];

      while(!FileIsEnding(fhandle))
        {
         curLine=FileReadString(fhandle);
         Print(curLine);  // Just for debugging

         curLine=StringTrimLeft(StringTrimRight(curLine));  // Remove whitespaces

         if(2!=StringSplit(curLine,'=',lineTokens)) // Split the line
           {
            Print("Error on config file: ",curLine);
            FileClose(fhandle);
            return false;
           }
         else  // Add the line to the properties
           {
            _properties.add(lineTokens[0],lineTokens[1]);
           }
        }
      FileClose(fhandle);

      return true;
     }
  };

#endif
//+------------------------------------------------------------------+
