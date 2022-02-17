unit GoodBeginingABC;
interface
uses GraphABC;
var
  i: byte;
///Крутая началка для программ с интенсивностью inte
procedure GoodBegining(inte:byte);
implementation
uses GraphABC;
///Крутая началка для программ с интенсивностью inte
procedure GoodBegining(inte: byte);
begin
  LockDrawing;
  i:= 0;
  window.load('images\secret1.bmp');
  Sleep(1000);
  window.load('images\secret.bmp');
  Sleep(50);
  window.load('images\secret1.bmp');
  Sleep(1000);
  window.load('images\secret.bmp');
  Sleep(50);
  window.load('images\secret2.bmp');
  Sleep(100);
  Rectangle(0,0,960,535);
  FloodFill(2,2,RGB(0,0,0));
  repeat
    Rectangle(-2,-2,962,537);
    FloodFill(2,2,RGB(i,i,i));
    i:= i + inte;
    Redraw;
  until(i = 255);
end;  
end.