#property strict

//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DodgerBlue

input string InpSym="EURUSDe";

double ExtBuffer[];

int OnInit(void)
{
   string short_name;
   IndicatorBuffers(1);
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtBuffer);
   short_name="Spead";
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
   
   ExtBuffer[0]=Close[0] - iClose(InpSym,0,0);
   for(i=1; i<rates_total; i++)
   {
      ExtBuffer[i] = Close[i] - iClose(InpSym,0,i);
   }
   //Print(DoubleToStr(ExtBuffer[1],5));
   //Print(DoubleToStr(iClose(InpSym,0,1),5));
   
   return(rates_total);
   
}





