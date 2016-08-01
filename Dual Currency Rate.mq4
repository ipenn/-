#property strict

//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DodgerBlue

input string InpSym = "EURUSDe";
input int InpPeriod = 14; 

double ExtBuffer[];

int OnInit(void)
{
   string short_name;
   IndicatorBuffers(1);
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtBuffer);
   short_name="Rate";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i,limit;
   
   double iopen141,iopen142,rate1,rate2;
   
   for(i=0; i<rates_total; i++)
   {  
      iopen141 = iOpen(Symbol(),0,i+InpPeriod);
      iopen142 = iOpen(InpSym,0,i+InpPeriod);
      if(iopen141 > 0 && iopen142 > 0)
      {
         rate1 = (iopen141 - MarketInfo(Symbol(),MODE_BID))/iopen141;
         rate2 = (iopen142 - MarketInfo(InpSym,MODE_BID))/iopen142;
      }
      
      if(rate1 - rate2 != -1)
      {
         ExtBuffer[i] = (1 - 1/(1 + rate1 - rate2))*100;
      }else{
         ExtBuffer[i] = ExtBuffer[i-1];
      }
   }
   
   
   
   return(rates_total);
   
}





