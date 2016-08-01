#property copyright "Copyright 2016, www.moneywang.com"
#property link    "www.moneywang.com"


extern string s1 ="***************************";
extern string Suffix = "pro";
extern double V1 = 100;
extern double V2 = 100;
extern double V3 = 100;
extern double K1 = -100;
extern double K2 = -100;
extern double K3 = -100;
extern string Symbs = "GBPUSD|USDJPY|GBPJPY";

extern string s2 ="***************************";
extern double AmountPoint = 5;
extern double Lot = 1;
extern int Magicv = 201622;
extern int Magick = 201623;
extern int Slippage = 0;
extern int isOrder = 0;

int   font_size = 10 , openTime = 0;
color text_color = Lime;
string sym[3];
double price[6],Max=-1,Min=1;
int init() 
{
   EventSetMillisecondTimer(2);
   int li_0 = font_size + font_size / 2;
   ObjectCreate("PROFIT", OBJ_LABEL, 0, 0, 0);
   ObjectSet("PROFIT", OBJPROP_CORNER, 1);
   ObjectSet("PROFIT", OBJPROP_XDISTANCE, 5);
   ObjectSet("PROFIT", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
   ObjectCreate("Equity", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Equity", OBJPROP_CORNER, 1);
   ObjectSet("Equity", OBJPROP_XDISTANCE, 5);
   ObjectSet("Equity", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
   
   ObjectCreate("v", OBJ_LABEL, 0, 0, 0);
   ObjectSet("v", OBJPROP_CORNER, 1);
   ObjectSet("v", OBJPROP_XDISTANCE, 5);
   ObjectSet("v", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
   
   ObjectCreate("k", OBJ_LABEL, 0, 0, 0);
   ObjectSet("k", OBJPROP_CORNER, 1);
   ObjectSet("k", OBJPROP_XDISTANCE, 5);
   ObjectSet("k", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
   
   ObjectCreate("Max", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Max", OBJPROP_CORNER, 1);
   ObjectSet("Max", OBJPROP_XDISTANCE, 5);
   ObjectSet("Max", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
   
   ObjectCreate("Min", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Min", OBJPROP_CORNER, 1);
   ObjectSet("Min", OBJPROP_XDISTANCE, 5);
   ObjectSet("Min", OBJPROP_YDISTANCE, li_0);
   li_0 += font_size * 2;
      
   return (0);
}

int deinit() {
   //ObjectsDeleteAll(0);
   return (0);
}

int start()
{
   string Symcut=StringSubstr(Symbol(),0,6);
   sym[0]=StringSubstr(Symbs,0,6);
   sym[1]=StringSubstr(Symbs,7,6);
   sym[2]=StringSubstr(Symbs,14,6);
   
   int orderv;
   double Amountv;
   
   int orderk;
   double Amountk;
   
   for(int cpt=0;cpt<OrdersTotal();cpt++)
   {
      OrderSelect(cpt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()==Magicv)
      {
         orderv++;
         Amountv += OrderProfit() + OrderSwap() + OrderCommission();
      }
      
      if(OrderMagicNumber()==Magick)
      {
         orderk++;
         Amountk += OrderProfit() + OrderSwap() + OrderCommission();
      }
      
   }
   
   if(Amountv >= AmountPoint ){
      CloseOrder(Magicv);
      return 0;
   }
   
   if(Amountk >= AmountPoint ){
      CloseOrder(Magick);
      return 0;
   }
   
   getPrices();
   double v = price[1]*price[3] - price[4];//sell sell buy Big 
   double k = price[0]*price[2] - price[5];//buy buy sell Small
   
   if(Max < v)
   {
      Max = v;
   }
   
   if(Min > k)
   {
      Min = k;
   }
   
   string commt;
   double SL,TP;
   if( ((v > V1 && orderv == 0)) && isOrder == 1)
   {
      commt = "v:"+DoubleToStr(price[1],5)+"*"+DoubleToStr(price[3],5)+"-"+DoubleToStr(price[4],5)+"="+DoubleToStr(v,8);
      Print(commt);
      OrderSend(sym[0]+Suffix,OP_SELL,Lot,price[1],Slippage,SL,TP,"",Magicv,0,Red);
      OrderSend(sym[1]+Suffix,OP_SELL,Lot,price[3],Slippage,SL,TP,"",Magicv,0,Red);
      OrderSend(sym[2]+Suffix,OP_BUY,Lot,price[4],Slippage,SL,TP,"",Magicv,0,Blue);
      //OpenOrder("SELL", Lot, sym[0],Magicv);
      //OpenOrder("SELL", Lot, sym[1],Magicv);
      //OpenOrder("BUY", Lot, sym[2],Magicv);
      return 0;
   }

   if( ((k < K1 && orderk == 0)) && isOrder == 1)
   {
      commt = "k:"+DoubleToStr(price[0],5)+"*"+DoubleToStr(price[2],5)+"-"+DoubleToStr(price[5],5)+"="+DoubleToStr(k,8);
      Print(commt);
      OrderSend(sym[0]+Suffix,OP_BUY,Lot,price[0],Slippage,SL,TP,"",Magick,0,Blue);
      OrderSend(sym[1]+Suffix,OP_BUY,Lot,price[2],Slippage,SL,TP,"",Magick,0,Blue);
      OrderSend(sym[2]+Suffix,OP_SELL,Lot,price[5],Slippage,SL,TP,"",Magick,0,Red);
      //OpenOrder("BUY", Lot, sym[0],Magick);
      //OpenOrder("BUY", Lot, sym[1],Magick);
      //OpenOrder("SELL", Lot, sym[2],Magick);
      return 0;
   }

   
   if(v == 0 || k == 0)
   {
      //CloseOrder(Magicv);
      //CloseOrder(Magick);
      return 0;
   }
   
   
   
   ObjectSetText("PROFIT", StringConcatenate("PROFIT ", DoubleToStr(Amountv+Amountk, 2)), font_size, "Arial", text_color);
   ObjectSetText("Equity", StringConcatenate("Equity ", DoubleToStr(AccountEquity(), 2)), font_size, "Arial", text_color);
   ObjectSetText("v", StringConcatenate("v ", DoubleToStr(v,8)), font_size, "Arial", text_color);
   ObjectSetText("k", StringConcatenate("k ", DoubleToStr(k,8)), font_size, "Arial", text_color);
   ObjectSetText("Max", StringConcatenate("Max ", DoubleToStr(Max,8)), font_size, "Arial", text_color);   
   ObjectSetText("Min", StringConcatenate("Min ", DoubleToStr(Min,8)), font_size, "Arial", text_color);   
}


double getPriceEach(string sym = "" , int MODE = 0)
{
   return MarketInfo(sym+Suffix,MODE);
}

double getPrices()
{
   price[0] = getPriceEach(sym[0],MODE_ASK);
   price[1] = getPriceEach(sym[0],MODE_BID);
   
   price[2] = getPriceEach(sym[1],MODE_ASK);
   price[3] = getPriceEach(sym[1],MODE_BID);
   
   price[4] = getPriceEach(sym[2],MODE_ASK);
   price[5] = getPriceEach(sym[2],MODE_BID);
}



void OpenOrder(string ord,double LOT,string Sym,string Magic)
{
   return;
   
   if(isOrder == 0) return;
   double SL,TP;
   int error;
   if (ord=="BUY"){
      
      error = OrderSend(Sym+Suffix,OP_BUY,LOT,getPriceEach(Sym+Suffix,MODE_ASK),Slippage,SL,TP,"",Magic,0,Blue);
   }
   if (ord=="SELL"){
      error = OrderSend(Sym+Suffix,OP_SELL,LOT,getPriceEach(Sym+Suffix,MODE_BID),Slippage,SL,TP,"",Magic,0,Red);
   }
   if (error==-1) 
   {  
     int err=GetLastError();
      Print("Error OPENORDER",err);
   }
}

void CloseOrder(string Magic)
{
   double bid,ask;
   for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if (OrderMagicNumber() == Magic)
         {
            if (OrderType()==OP_BUY){
               bid = MarketInfo(OrderSymbol(),MODE_BID);
               OrderClose(OrderTicket(),OrderLots(),bid,Slippage,Blue);
            }
            if (OrderType()==OP_SELL){
               ask = MarketInfo(OrderSymbol(),MODE_ASK);
               OrderClose(OrderTicket(),OrderLots(),ask,Slippage,Red);
            }
         } 
      }
   }  
}
