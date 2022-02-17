uses GraphABC;

var
  time, dt: real;

var
  OffsetX, offsetY: integer;

var
  ot: boolean := false;

var
  pic: array[1..10]of Picture;
  put: array[1..10]of string:= ('images\textures\Air.png', 'images\textures\Grass_Block.png', 'images\textures\Dirt.png', 'images\textures\Stone.png', 'images\textures\Player.png', 'images\textures\Magma.png', 'images\textures\p.jpg', 'images\textures\u.png', 'images\textures\y.png', 'images\textures\Magma2.png');

var
  sou := new System.Media.SoundPlayer('sounds\u.wav');

var
  size := 48;

var
  levelFile: Text;

var
  tilemap: array of string := ('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

procedure LevelCreate(level: integer);
begin
  Assign(levelFile, 'levels/level1/level.txt');
  Reset(levelFile);
  for var i: integer := 1 to 31 do
    tilemap[i] := ReadString(levelFile);
end;

procedure NewLevel;
begin
  LevelCreate(1);
end;

procedure Draw;
begin
  pic[7].draw(0, 0);
  for var i := 0 to tilemap.Length - 1 do
  begin
    for var j := 1 to tilemap[i].length do
    begin
      case tilemap[i][j] of
        'g': pic[2].Draw(j * 48 - OffsetX, i * 48 - offsetY);
        'd': pic[3].Draw(j * 48 - OffsetX, i * 48 - offsetY);
        's': pic[4].Draw(j * 48 - OffsetX, i * 48 - offsetY);
        'm': pic[6].Draw(j * 48 - OffsetX, i * 48 - offsetY);
        'n': pic[1].Draw(j * 48 - OffsetX, i * 48 - OffsetY);
        'u': pic[8].Draw(j * 48 - OffsetX, i * 48 - OffsetY);
        'y': pic[9].Draw(j * 48 - OffsetX, i * 48 - OffsetY);
        '>': pic[10].Draw(j * 48 - OffsetX, i * 48 - OffsetY);
      end;
      
    end;
  end;
end;

type
  Player = class
  public
    x, y, dx, dy: real;
    w, h: integer;
    speed := 12;
    onground: boolean;
    cl: color;
    name: string;
    
    constructor(x, y, w, h: integer; cl: color; name: string);
    begin
      self.x := x;
      self.y := y;
      self.w := w;
      self.h := h;
      self.cl := cl;
      self.name := name;
      onkeydown += keydown;
    end;
    
    procedure keydown(key: integer);
    begin
      case key of
        vk_space, VK_Up, VK_W: if onground then begin onground := false; dy := -20 end;
        114: begin
          if ot then
            ot:= false
          else
            ot:= true
        end;
        27: saveWindow('Фоточка.png');
      end;
    end;
    
    procedure col(x1, y1, dir: integer);
    begin
      if (x + w > x1) and (x < x1 + size) and (y + h > y1) and (y < y1 + size) then begin
        if (dir = 1) and (dx > 0) then begin x := x1 - w; end;
        if (dir = 1) and (dx < 0) then begin x := x1 + size; end;
        if (dir = 0) and (dy > 0) then begin y := y1 - h; dy := 0; onground := true end;
        if (dir = 0) and (dy < 0) then begin y := y1 + size; dy := 0; end;
      end;
    end;
    
    procedure colision(dir: integer);
    begin
      for var i := round(y) div 48 to round(y + h) div 48 do
      begin
        for var j := round(x) div 48 to round(x + w) div 48 do
        begin
          if (i > 0) and (i < tilemap.Length) and (j > 0) and (j < tilemap[i].Length - 1) then begin
            if (tilemap[i][j] = 'g') or (tilemap[i][j] = 's') or (tilemap[i][j] = 'd') or (tilemap[i][j] = 'n') or (tilemap[i][j] = 'u') or (tilemap[i][j] = 'y') then 
              col(j * 48, i * 48, dir);
            if (tilemap[i][j] = 'm') and (y > (Trunc((i -1) * size) div size * size + size div 4) - 1) then begin
              col(j * 48, i * 48, dir);
              sou.Stop;
              x := 340;
              sou.Play;
            end;
            if (tilemap[i][j] = '>') and (y > (Trunc((i -1) * size) div size * size + size div 2) - 1) then begin
              col(j * 48, i * 48, dir);
              sou.Stop;
              x:= 340;
              sou.Play;
            end;
          end;
        end;
      end;
    end;
    
    procedure Update;
    begin
      dy += 2.35 * time;
      
      x += dx * time;
      colision(1);
      y += dy * time;
      colision(0);
      pic[5].Draw(round(x - offsetX), round(y - offsetY));
      dx := speed;
    end;
  end;

var
  p: player;

procedure intialise;
begin
  sou.Play();
  NewLevel;
  for var i:integer:= 1 to 10 do begin
    pic[i]:= Picture.Create(put[i]);
    pic[i].load(put[i]);
  end;  
  p := new Player(100, 1000, 48, 48, clred, 'Yorik');
  p.x := 330;
end;

procedure Update;
begin
  lockdrawing;
  while true do
  begin
    window.Clear(RGB(198, 255, 253));
    if(offsetY > 1500) then window.Clear(clblack);
    if(offsetY > 2500) then begin p.y := 600; p.x := 200; end;
    
    time := milliseconds - dt;
    dt := milliseconds;
    time /= 60;
    
    offsetX := round(p.x - window.Width / 2 + p.w / 2);
    offsetY := round(p.y - window.Height / 2 + p.h / 2);
    Draw;
    
    if ot then begin
      if (p.y > (Trunc(p.y) div size * size + size div 4)) or p.onground = true then
        TextOut(50, 50, 'canKill: Yes')
      else
        TextOUT(50, 50, 'canKill: No');
      TextOut(50, 70, $'x: {p.x}');
      TextOut(50, 90, $'y: {p.y}');
      TextOut(50, 110, $'onground: {p.onground}');
      TextOut(50, 130, $'speed: {p.speed}');
      TextOut(50, 150, $'dx: {p.dx}');
      TextOut(50, 170, $'dy: {p.dy}');
      SetPenColor(clRed);
      Line(500, 0, 500, 228 + (1248 - Trunc(p.y)));
      Line(0, 228 + (1248 - Trunc(p.y)), 500, 228 + (1248 - Trunc(p.y)));
      SetPenColor(clBlue);
      Line(520, 0, 520, 240 + (1248 - Trunc(p.y)));
      Line(0, 240 + (1248 - Trunc(p.y)), 520, 240 + (1248 - Trunc(p.y)));
      SetPenColor(clYellow);
      Line(Trunc(p.x) - OffsetX, 0, Trunc(p.x) - OffsetX, 480);
      Line(0, Trunc(p.y) - offsetY, 640, Trunc(p.y) - offsetY);
      Line(Trunc(p.x) - OffsetX + 48, 0, Trunc(p.x) - OffsetX + 48, 480);
      Line(0, Trunc(p.y) - offsetY + 48, 640, Trunc(p.y) - offsetY + 48);
      
      SetPixel(Trunc(p.x) + 48, Trunc(p.y) + 48, clRed);
      pic[6].load('images\textures\MagmaO.png');
      pic[10].load('images\textures\Magma2O.png');
    end else begin
      pic[6].load('images\textures\Magma.png');
      pic[10].load('images\textures\Magma2.png');
    end;
    p.Update;
    
    redraw;
  end;
end;


begin
  intialise;
  Update;
end.