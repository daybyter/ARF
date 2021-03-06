//+------------------------------------------------------------------+
//|                                                    CSVLogger.mqh |
//|                                 Copyright 2018, Andreas Rueckert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| This class logs events in a CSV file                             |
//+------------------------------------------------------------------+
class CSVLogger
  {

private:

   // Instance variables

/**
   * the name of the logfile.
   */
   string            _filename;

public:

   // Constructors

/**
 * Create a new logger with a given filename.
 *  
 * @param filename The name of the logfile.
 */
                     CSVLogger(string filename)
     {
      _filename=filename;
     }

   // Methods

/**
* Log a string to this logfile.
*
* @param val The string to log.
*/
   void log(string val)
     {
      int logFileHandle;

      logFileHandle=FileOpen(_filename,FILE_CSV|FILE_SHARE_READ|FILE_READ|FILE_WRITE,';');  // Versuch ein File zu oeffnen, FILE_READ wird gebraucht fuer append!

      if(logFileHandle<1) // Falls das File nicht geoeffnet werden konnte
        {
         Print("Cannot open logfile ",_filename," for logging. Error: ",GetLastError());  // Gib nen Fehler aus
         return;
        }
      else if(logFileHandle>0) // Falls das File offen ist
        {
         FileSeek(logFileHandle,0,SEEK_END); // Springe ans Ende des Files
         FileWrite(logFileHandle,val);  // Schreib nur den Wert
         FileFlush(logFileHandle);  // Schreibt wirklich in die Datei
         FileClose(logFileHandle);  // Schließt die Datei wieder
                                    //Print("Wrote logfile entry: ",wert);
        }
     }

/**
     * Log a double value to the logfile.
     *
     * @param val The value to log.
     */
   void log(double val)
     {
      log(DoubleToStr(val));  // Use the string version to log the converted value.
     }

/**
     * Log an int value.
     *
     * @param val The value to log.
     */
   void log(int val)
     {
      log(IntegerToString(val));  // Use the string version to log the converted value.
     }
  };
//+------------------------------------------------------------------+
