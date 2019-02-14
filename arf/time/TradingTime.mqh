//+------------------------------------------------------------------+
//|                                                    TradeTime.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradingTime
  {

private:

/**
* Array of trading times (i.e. "12:30-17:00")
*/
   string            _tradingTimes[];

/**
* An array of times, when we exit the market. No new orders are opened, when existing orders are closed.
*/
   string            _exitTimes[];

public:

   // Constructors

   //+----------------------------------+
   //| Create a new trade time checker. |
   //+----------------------------------+
                     TradingTime()
     {
     }

   //+-----------------------------------+
   //| Create a new trading time checker |
   //+-----------------------------------+
                     TradingTime(string tradingTimeString)
     {
      addTradingTimes(tradingTimeString);
     }

   //+-----------------------------------+
   //| Create a new trading time checker |
   //+-----------------------------------+
                     TradingTime(string tradingTimeString,string exitTimeString)
     {
      addTradingTimes(tradingTimeString);
      addExitTimes(exitTimeString);
     }

   // Methods

private:

   //+----------------------------------------------------------------------------------+
   //| Add a time zone or a list of colon-separated timezones to an array of timezones. |
   //+----------------------------------------------------------------------------------+
   void addTimes(string &timesArray[],string timeString)
     {

      if(timeString=="") // Check, if the argument is just empty
         return;

      // Check, if the string with time zones contains multiple time zones
      if(StringFind(timeString,",")!=-1)
        {  // If there is a colon in the time zones string
         string timeZones[];  // Buffer for the split time zones
         int nTimeZones=StringSplit(timeString,',',timeZones);  // Split the string into several timezones.
         for(int i=0; i<nTimeZones;++i)
            addTimes(timesArray,timeZones[i]);
        }
      else  // This is just a single timezone.
        {
         int currentArraySize=ArraySize(timesArray);  // Get the current size of the array.

         ArrayResize(timesArray,currentArraySize+1); // Increase the array size by 1

         timesArray[currentArraySize]=timeString;  // Set the string as the last element of the array.
        }
     }

public:

   //+---------------------------------+
   //| Add one or multiple exit times. |
   //+---------------------------------+     
   void addExitTimes(string timeString)
     {
      addTimes(_exitTimes,timeString);
     }

   //+------------------------------------+
   //| Add one or multiple trading times. |
   //+------------------------------------+     
   void addTradingTimes(string timeString)
     {
      addTimes(_tradingTimes,timeString);
     }

   //+-------------------+
   //| Check Time Zone   |
   //+-------------------+
   bool checkTimeZone(string p_TimeZone)
     {
      int Now=TimeHour(TimeLocal())*60+TimeMinute(TimeLocal());      /// Current Time in Minutes
      int StartHour;    /// Start Hour
      int StartMinute;    /// Start Minutes
      int EndHour;    /// Stop  Hour
      int EndMinute;    /// Stop  Minutes

      if(StringLen(p_TimeZone)==0)
        {
         return false;
        }

      SplitTimeZone(p_TimeZone,StartHour,StartMinute,EndHour,EndMinute);

      int StartTime = StartHour*60 + StartMinute;  /// Start time in minutes
      int EndTime   = EndHour  *60 + EndMinute;    /// Stop  time in minutes

      return(Now>=StartTime) && (Now<=EndTime); /// if Current time between Start and Stop time
     }
   //-----------------------------------------------------------------------------------
   /// Check Time Zones
   //-----------------------------------------------------------------------------------
   bool checkTimeZones(string  &timezones[])
     {
      for(int i=0; i<ArraySize(timezones);++i)
        {
         if(checkTimeZone(timezones[i]))
           {
            return true;
           }
        }
      return false;
     }
   //+------------------------------------------------------------------+
   //| Get the hour of a string.                                        |
   //+------------------------------------------------------------------+
   int getHour(string Str)
     {
      int Pos=StringFind(Str,":");
      return StrToInteger( Pos==-1 ? Str : StringSubstr(Str,0,Pos));
     }
   //+------------------------------------------------------------------+
   //| Get the minute from a string.                                    |
   //+------------------------------------------------------------------+
   int getMinute(string Str)
     {
      int Pos=StringFind(Str,":");
      return StrToInteger( Pos==-1 ? "" : StringSubstr(Str,Pos+1));
     }

   //+---------------------------------------+
   //| Check, if we are in an exit time now. |
   //+---------------------------------------+
   bool isExitTime()
     {
      return checkTimeZones( _exitTimes);
     }

   //+------------------------------------------------------------------+
   //| Check, if now is a trading time.                                 |
   //+------------------------------------------------------------------+
   bool isTradingTime()
     {
      return checkTimeZones( _tradingTimes);
     }

   //+------------------------------------------------------------------+
   //| Split time zone to StartHour, StartMinute and EndHour, EndMinute |
   //+------------------------------------------------------------------+
   void SplitTimeZone(string timeZone,int &startHourp,int &startMinutep,int &endHourp,int &endMinutep)
     {
      int delimiterPos=StringFind(timeZone,"-");

      if(delimiterPos==-1)
         return;

      string startString = StringSubstr(timeZone, 0, delimiterPos);    /// Extract Start time
      string endString   = StringSubstr(timeZone, delimiterPos+1);     /// Extract Stop  time

      startHourp=getHour(startString);
      startMinutep=getMinute(startString);
      endHourp=getHour(endString);
      endMinutep=getMinute(endString);
     }
   //+------------------------------------------------------------------+
  };
//+------------------------------------------------------------------+
