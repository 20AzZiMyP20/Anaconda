program MySuperPuperSnake_e_e_e;
uses crt;

label start;
type direction = (up, down, left, right, stop);
const WIDTH = 100; HEIGHT = 30; ScreenWidth = 160; ScreenHeight = 60;
var  x, y: integer;
    screen: UnicodeString;
    tailx: array[0..100] of integer;
    taily: array[0..100] of integer;
    fruitx, fruity: integer;
    tailn: integer;
    score: integer;

procedure replace(x, y: integer; c: char);
var prevx, prevy: integer;
begin
    prevx := WhereX;
    prevy := WhereY;

    GotoXY(x, y);
    write(#8, c);
    GotoXY(prevx, prevy);
end;

procedure createBox;
var x, y: integer;
begin
    TextColor(LightGray);
    Window((ScreenWidth div 2) - (WIDTH div 2), (ScreenHeight div 2) - (HEIGHT div 2 + 2), (ScreenWidth div 2) + (WIDTH div 2), (ScreenHeight div 2) + (HEIGHT div 2) - 1);
    for y := 1 to HEIGHT do begin
        for x := 1 to WIDTH do begin
            if (x = 1) or (x = WIDTH) or (y = 3) or (y = HEIGHT) then begin
                GotoXY(x, y);
                write('#');
            end;
            if (y = 1) then begin
                GotoXY(x, y);
                write('=');
            end;
        end;
    end;
    GotoXY(3, 2);
    TextColor(White);
    write('SCORE: ');
end;

procedure spawnFruit(x, y: integer);
begin
    fruitx := x;
    fruity := y;
    TextColor(Red);
    replace(x, y, '@');
end;

procedure drawSnake(x, y: integer);
var i: integer;
begin
    tailx[0] := x;
    taily[0] := y;

    GotoXY(tailx[tailn], taily[tailn]);
    write(#8, ' ');

    for i := tailn downto 1 do begin
        tailx[i] := tailx[i-1];
        taily[i] := taily[i-1];
        TextColor(Green);
        replace(tailx[i], taily[i], '*');
    end;

    GotoXY(tailx[0], taily[0]);
    write(#8, 'O');
end;

procedure drawScore;
var prevx, prevy: integer;
begin
    prevx := WhereX;
    prevy := WhereY;

    GotoXY(10, 2);
    TextColor(Red);
    write(score);
    GotoXY(prevx, prevy);
end;

procedure gameOver;
var x, y: integer;
    key: char;
begin
    y := (HEIGHT - 2) div 2 - 3;
    x := WIDTH div 2 - 26;
    GotoXY(x, y);
    TextColor(Red);
    write('  _____                         ____                 '); GotoXY(x,y + 1);
    write(' / ____|                       / __ \                '); GotoXY(x,y + 2);
    write('| |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __ '); GotoXY(x,y + 3);
    write('| | |_ |/ _` |  _ ` _ \ / _ \ | |  | \ \ / / _ \  __|'); GotoXY(x,y + 4);
    write('| |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |   '); GotoXY(x,y + 5);
    write(' \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|   ');
    while true do begin
        if KeyPressed then key := ReadKey;
        case key of 
            #32 : Halt(0);
            #12 : Halt(0);
            #27 : Halt(0);
        end;
    end;
end;

procedure hitDetection;
var i: integer;
begin
    for i := 4 to tailn do begin
        if ((tailx[i] = tailx[0]) and (taily[i] = taily[0])) then gameOver;
    end;
end;

procedure draw;
var key: char;
    value: direction;
    i: integer;
begin
    tailn := 2;
    value := stop;
    spawnFruit(random(WIDTH - 1) + 1, random(HEIGHT - 2) + 1 + 2);
    score := 0;
    drawScore;

    while true do begin
        case value of
            up : if (WhereY - 1 = 3) then gameOver else GotoXY(WhereX, WhereY - 1);
            down : if (WhereY + 1 = HEIGHT) then gameOver else GotoXY(WhereX, WhereY + 1);
            left : if (WhereX - 1 = 2) then gameOver else GotoXY(WhereX - 1, WhereY);
            right : if (WhereX + 1 = WIDTH + 1) then gameOver else GotoXY(WhereX + 1, WhereY);
        else GotoXY(WhereX, WhereY)
        end;

        drawSnake(WhereX, WhereY);
        if (tailx[0] = fruitx) and (taily[0] = fruity) then begin 
            replace(fruitx, fruity, ' ');
            spawnFruit(random(WIDTH - 1) + 1, random(HEIGHT - 2) + 1 + 2);
            score := score + 100;
            tailn := tailn + 1;
            drawScore;
        end;

        hitDetection;
        
        delay(100);
        if KeyPressed then key := ReadKey;
        case key of 
            #119 : value := up;
            #115 : value := down;
            #100 : value := right;
            #97 : value := left;
        end;
    end;
end;


begin;
    clrscr;
    createBox;
    start:
    GotoXY(WIDTH div 2, HEIGHT div 2 + 2);
    draw;
end.
