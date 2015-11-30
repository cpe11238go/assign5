//State
final int START = 0;
final int PLAY  = 1;
final int WIN   = 2;
final int LOSE  = 3;
int NowState = START;

//Player
float PlayerX;
float PlayerY;
float PlayerSpeed = 5;
boolean upPressed    = false;
boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;
int PlayerHp = 20;
int Score =0;

//Background 
float BGX1 = 0;
float BGX2 = 0;
float BGSpeed = 3;

//Emeny
int enemyCount = 8;
int enemyState = 0;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int[] EnemyAlive = {1,1,1,1,1,1,1,1};

//Treasure
float TreasureX = 0;
float TreasureY = 0;

//Shoot
int shootnum = 0;
float[] shootX = {0,0,0,0,0};
float[] shootY = {0,0,0,0,0};

//Picture
PImage start1,start2;
PImage bg1,bg2;
PImage fighter;
PImage enemy;
PImage hp;
PImage treasure;
PImage end1,end2;
PImage shoot;

void setup () 
{
  //Picture Load
  start1    = loadImage("img/start1.png");
  start2    = loadImage("img/start2.png");
  bg1       = loadImage("img/bg1.png");
  bg2       = loadImage("img/bg2.png");
  fighter   = loadImage("img/fighter.png");
  enemy     = loadImage("img/enemy.png");
  hp        = loadImage("img/hp.png");
  treasure  = loadImage("img/treasure.png");
  end1      = loadImage("img/end1.png");
  end2      = loadImage("img/end2.png");
  shoot      = loadImage("img/shoot.png");
  
  //Interface
  size(640, 480) ;
  image(start1,0,0);
}

void draw() 
{
  switch (NowState)
  {
    case START:
      if(mouseX>205 && mouseX<460 && mouseY>375 && mouseY<415)
      {
        image(start1,0,0);
        if(mousePressed)            
        {
          Reset();
        }
      }
      else
        image(start2,0,0);
      break;
    case PLAY:
      //Background 
      image(bg1,BGX1,0);
      image(bg2,BGX2,0);
      BGX1 += BGSpeed;
      BGX2 += BGSpeed;
      if(BGX1>width)
        BGX1 = 0-width;
      if(BGX2>width)
        BGX2 = 0-width;
      scoreChange(Score);
        
      //Player HP
      colorMode(RGB);
      fill(255,0,0);
      switch (PlayerHp)
      {
        case 100:
        {
          rect(5,5,200,23);
          break;
        }
        case 90:
        {
          rect(5,5,180,23);
          break;
        }
        case 80:
        {
          rect(5,5,160,23);
          break;
        }
        case 70:
        {
          rect(5,5,140,23);
          break;
        }
        case 60:
        {
          rect(5,5,120,23);
          break;
        }
        case 50:
        {
          rect(5,5,100,23);
          break;
        }
        case 40:
        {
          rect(5,5,80,23);
          break;
        }
        case 30:
        {
          rect(5,5,60,23);
          break;
        }
        case 20:
        {
          rect(5,5,40,23);
          break;
        }
        case 10:
        {
          rect(5,5,20,23);
          break;
        }
      }
      image(hp,0,0);
      
      //Player move
      if (upPressed) 
        PlayerY -= PlayerSpeed;
      if (downPressed) 
        PlayerY += PlayerSpeed;
      if (leftPressed) 
        PlayerX -= PlayerSpeed;
      if (rightPressed) 
        PlayerX += PlayerSpeed;
      
      // boundary detection
      if(PlayerX>width-50)
        PlayerX=width-50;
      if(PlayerX<0)
        PlayerX=0;
      if(PlayerY>height-50)
        PlayerY=height-50;
      if(PlayerY<0)
        PlayerY=0;
      
      //Player Location
      image(fighter,PlayerX,PlayerY);
        
      //Enemy
      for(int i=0; i<enemyCount; ++i)
      {  
        if(enemyX[i] != -1 || enemyY[i] != -1)
        {
          if(EnemyAlive[i] ==1)
            image(enemy, enemyX[i], enemyY[i]);
          
          //enemy move
          enemyX[i]+=5;
          
          //Collision (shoot and Enemy)
          for(int j=0;j<5;j++)
            if(isHit(shootX[j],shootY[j],shoot.width,shoot.height,enemyX[i],enemyY[i],enemy.width,enemy.height) && EnemyAlive[i] ==1)
            {              
              EnemyAlive[i] = 0;
              shootX[j] = shootX[shootnum-1];
              shootY[j] = shootY[shootnum-1];
              shootX[shootnum-1] = 2*width;
              shootY[shootnum-1] = 2*height;
              shootnum--;
              Score += 20;
            } 
            
          //Collision (Player and Enemy)
          if(isHit(PlayerX,PlayerY,fighter.width,fighter.height,enemyX[i],enemyY[i],enemy.width,enemy.height) && EnemyAlive[i] ==1)
            {
              PlayerHp = PlayerHp-20;
              EnemyAlive[i] = 0;
            }
        }
      }
      
      //Enemy boundary detection
      if(enemyState%3!=2)
        while(enemyX[4]>width)
        {
          enemyState +=1;
          addEnemy(enemyState%3);
          for(int i=0; i<EnemyAlive.length; i++)
            EnemyAlive[i] = 1;
        }  
      else
        while(enemyX[7]>width)
        {
          enemyState +=1;
          addEnemy(enemyState%3);
          for(int i=0; i<EnemyAlive.length; i++)
            EnemyAlive[i] = 1;
        }          
  
      //Treasure
      image(treasure,TreasureX,TreasureY);
      
      //Collision (Player and Treasure)
       if(isHit(PlayerX,PlayerY,fighter.width,fighter.height,TreasureX,TreasureY,treasure.width,treasure.height))
      {
        if(PlayerHp<100)
            PlayerHp = PlayerHp+10;
          TreasureX = random(width-50);
          TreasureY = random(height-50);
      }  
      
      //shoot
      if(shootnum >0)   
        for(int i=0;i<shootnum;i++)
        {      
            image(shoot,shootX[i],shootY[i]);
            shootX[i]-=5;      
            int minDist = closestEnemy((int)PlayerX,(int)PlayerY);
            if(PlayerX>enemyX[minDist])
            {
              if(shootY[i]>enemyY[minDist])
                shootY[i]--;
              if(shootY[i]<enemyY[minDist])
                shootY[i]++;
            }
        }               
  
      //GAMEOVER
      if(PlayerHp <= 0)
        NowState = LOSE;
      break;
    case WIN:
      //It's no way to win.  So sad.
      break;
    case LOSE:
      if(mouseX>205 && mouseX<440 && mouseY>305 && mouseY<350)
      {
        image(end1,0,0);
        if(mousePressed)            
        {
          Reset();
        }
      }
      else
        image(end2,0,0);
      break;
      
  }
}

void addEnemy(int type)
{  
  for(int i=0; i<enemyCount;++i)
  {
    enemyX[i] = -1;
    enemyY[i] = -1;
  }
  switch (type)
  {
    case 0:
      addStraightEnemy();
      break;
    case 1:
      addSlopeEnemy();
      break;
    case 2:
      addDiamondEnemy();
      break;
  }
}

void addStraightEnemy()
{
  float t = random(height - enemy.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i)
  {
    enemyX[i] = (i+1)*-80;
    enemyY[i] = h;
  }
}

void addSlopeEnemy()
{
  float t = random(height - enemy.height * 5);
  int h = int(t);
  for(int i=0; i<5; ++i)
  {
    enemyX[i] = (i+1)*-80;
    enemyY[i] = h + i * 40;
  }
}

void addDiamondEnemy()
{
  float t = random( enemy.height * 3 ,height - enemy.height * 3);
  int h = int(t);
  int x_axis = 1;
  for(int i=0; i<8; ++i)
  {
    if (i == 0 || i == 7)
    {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h;
      x_axis++;
    }
    else if (i == 1 || i == 5)
    {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 1 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 1 * 40;
      i++;
      x_axis++;    
    }
    else
    {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 2 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
}

void Reset()
{
  //Reset Player 
  PlayerHp = 20;
  PlayerX = width - 50;
  PlayerY = height/2;
  
  //Reset Background 
  BGX2 = 0-width;
  BGX1 = 0;
  
  //Reset Enemy 
  addEnemy(0);
  for(int i=0; i<EnemyAlive.length; i++)
    EnemyAlive[i] = 1;
  
  //Reset Treasure 
  TreasureX = random(width-50);
  TreasureY = random(height-50);
  
  //Reset shoot
  shootnum = 0;
  for(int i=0; i<5; i++)
  {
    shootX[i] = 2*width;
    shootY[i] = 2*height;
  }
  
  Score = 0;
  NowState = PLAY;
}

void scoreChange(int value)
{
  PFont x;
  x = createFont("Arial",24);
  textFont(x,30);
  textAlign(CENTER);
  fill(255);
  text("Score:"+value,75,height-20);
}

boolean isHit(float ax,float ay,float aw,float ah,float bx,float by,float bw,float bh)
{
  if(ay+ah>=by && by+bh>ay && ax+aw>bx && bx+bw>ax)
    return true;
  else
    return false;
}

int closestEnemy(int x,int y)
{
  float minDist = width+height;
  float[] Dist = new float[enemyCount];
  for(int i=0; i<enemyCount; ++i)
  {  
    Dist[i] = width+height;
    if(enemyX[i] != -1 || enemyY[i] != -1)
    {
      if(EnemyAlive[i] ==1)
      {
        Dist[i] = dist(x,y,enemyX[i],enemyY[i]);
      }
    }
    if(Dist[i]<minDist)
      minDist = Dist[i];
  }
  for(int i=0; i<enemyCount; ++i)
  {
    if(Dist[i]==minDist)
      return i;
  }
  return -1;
}
void keyPressed()
{
   if (key == CODED) 
   { 
    switch (keyCode) 
    {
      case UP:
        upPressed    = true;
        break;
      case DOWN:
        downPressed  = true;
        break;
      case LEFT:
        leftPressed  = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
  
  //shoot
  if(NowState == PLAY)
    if(keyCode == ' ')    
      if(shootnum <5)
      {
        shootnum++;                       
          shootX[shootnum-1] = PlayerX-40;
          shootY[shootnum-1] = PlayerY+10;         
      }
      
  //shoot boundary detection
  for(int i=0;i<5;i++)
  {
    if(shootX[i]<0)
    {
      shootX[i] = shootX[shootnum-1];
      shootY[i] = shootY[shootnum-1];
      shootX[shootnum-1] = 2*width;
      shootY[shootnum-1] = 2*height;
      shootnum--;
    }
  }
}

void keyReleased()
{
   if (key == CODED) 
   {
      switch (keyCode) 
      {
        case UP:
          upPressed    = false;
          break;
        case DOWN:
          downPressed  = false;
          break;
        case LEFT:
          leftPressed  = false;
          break;
        case RIGHT:
          rightPressed = false;
          break;
    }
  }
}
