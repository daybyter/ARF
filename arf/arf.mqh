//+------------------------------------------------------------------+
//|                                                          arf.mqh |
//|   Copyright 2018, Andreas Rueckert,Markus Roeschlein,Tobias Lang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Andreas Rueckert"
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#include "chart\Candle.mqh"
#include "chart\ChartAnalyzer.mqh"
#include "config\ConfigFile.mqh"
#include "config\Property.mqh"
#include "config\Properties.mqh"
#include "logging\CSVLogger.mqh"
#include "order\ActivePosition.mqh"
#include "order\ActivePositionPyramidPlus.mqh"
#include "order\ActivePositionSinglePlus.mqh"
#include "order\ActivePositionStopOnEntry.mqh"
#include "order\BuyLimitOrder.mqh"
#include "order\BuyOrder.mqh"
#include "order\BuyStopOrder.mqh"
#include "order\Order.mqh"
#include "order\SellLimitOrder.mqh"
#include "order\SellOrder.mqh"
#include "order\SellStopOrder.mqh"
#include "order\OrderList.mqh"
#include "time\TradingTime.mqh"
#include "ui\DisplayAlert.mqh"
#include "ui\DisplayProfit.mqh"
#include "ui\DisplayTradingTime.mqh"

string ARF_VERSION="0.1.2";  // The current version of the framework
