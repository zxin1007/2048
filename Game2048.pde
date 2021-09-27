// Zixin Zou, Xuan Jiang
import ddf.minim.*;
AudioPlayer [] player;
Minim  minim;//audio context
int [][] t = new int[4][4]; //the tile
int x,y; //random x and y of the flower
PImage logo,arrow; //image of a arrow and logo in the front page
Flowers [] fs = new Flowers [100]; // store the flowers
ArrayList <Integer> xs = new ArrayList <Integer>(); //store the x postion of flower
ArrayList <Integer> ys = new ArrayList <Integer>(); //store the y postion of flower
int blockSize= 100, score=0, space=20, spaceLeft=14,die,win; 
float xPos= 0; // x postion of 4x4 tile, will change in the loop
float yPos= 0; // y postion of 4x4 tile, will change in the loop
PFont font,font2,font3, font4; //different fonts
int pos2=0, pos0=-100, pos4=-200, pos8=1000; // inintal postion of the number 2,0,4,8 of the front page
int h,w1,w2; //the h represen height, w1 and w2 represent two width, which is use to see if the the number 2,0,4,8's postion reaches this postion or not.
int phase=1; // intial phase 1 which is the front page.
int currentSong;
boolean cursor,rule; //
void setup(){
  size(700,700); 
  frameRate(20);
  surface.setTitle("2048");
  inital(); //intital two block spwaned
  logo = loadImage("2048logo.png"); 
  arrow = loadImage("arrow.png");
  font= createFont("Superclarendon-Regular",200);
  font4=createFont("DFWaWaTC-W5",50);
  font2=createFont("STYuanti-TC-Bold",30);
  font3=createFont("TimesNewRomanPS-ItalicMT",30);
  h=height/2-100; //height of title number 0 and 4
  w1=width/2-240; //width of title number 2
  w2=width/2+125; //width of title number 8
  for (int i=0;i<fs.length; i++){  //intailizing the flower array
    x = (int)random(0,width*4);
    y = (int)random(-500,-1000);
    while (xs.contains(x)&&ys.contains(y)){
      x = (int)random(0,width*4);
      y = (int)random(-500,-1000);
    } 
      xs.add(x);
      ys.add(y); 
      fs[i]= new Flowers(xs.get(i),ys.get(i));
  }
  spaceLeft=14; //total of 16 space, two already spawned, so 14 left
  player=new AudioPlayer[4]; //4 song in total
  minim = new Minim(this);
  currentSong=(int)random(0,player.length); // randomize the start song
  player[0] = minim.loadFile("Blue Bird.mp3");
  player[1] = minim.loadFile("Tales of the Red Cliff.mp3");
  player[2] = minim.loadFile("Way_Back_Home.mp3");
  player[3] = minim.loadFile("Remember.mp3");
  player[currentSong].play();
}

void draw (){
  /*
     check if the current song is playing or not, if not playing, pause and then rewind the song. make the current song to next song by increment by 1.
     check if current song exceed the number of Player array or not.
     if it does exceed, make currunt song equal 0 which the first song of the Player array.
     else play the current song.
  */
  if (!player[currentSong].isPlaying()){
    player[currentSong].pause();
    player[currentSong].rewind();
    currentSong += 1;
    if (currentSong>player.length-1){
      currentSong=0;
      player[currentSong].play();
    }else {
     player[currentSong].play();
   }
  }
  /*
  phase 1 is the front page. it inclde a blue background, how to play hovering button when the mouse is in certain postion.
  Also the cursor effect of the play button when mouse is on certain position, it will change.
  */
  if (phase==1){
    frontPage ();
    textFont(font4);
    fill(0);
    textSize(18);
    text("How To Play",width/2-60,height/2+40); //front page
    image(logo,width/2+90,height/2-40,60,60);
    image(arrow,width/2-40,height/2+20,200,60);
    // if the mouse is in the postion of this, there rule will appear
    if (mouseX > width/2+90 && mouseX < width/2+90+60 && mouseY > height/2-40 && mouseY< height/2-40+60) {
      pos2=w1;
      pos0=h;
      pos4=h;
      pos8=w2;
      rule=true;
    } else{
      rule=false;
    }
    // if the mouse is in the postion of this, there will be a cursor
    if (mouseX > width/2-70 && mouseX < width/2-70+150 && mouseY > height/2+100 && mouseY< height/2+100+80) { 
      cursor=true; 
    } else {
      cursor=false; 
    }
    if (cursor){  //cursor of play button
      button();
    } else {
      unButton(); //undo the effect
    }
    if (rule==true){ 
      direction(); //appearing rule
    }
  } 
  /*
    phase 2 will be the game 2048
    with the score, restart button, time, and the board with tiles.
    in the nested loop the 4x4 block would be shown, and when the number is merged into correspoding numbers, it will appear differently.
    number 0 will not be shown.
    there will be spaceCount and determination of the availability of tile merge according to player entered direction, 
    if statement to check if the game end or win. There is an extra numbers comment out, if you want to continue playing after you reach 2048, you can make it into code
  */
  if (phase==2){
    noStroke();
    background (#666666);
    fill(238, 228, 218, 90);
    rect(100,100,width-200,height-200);
    fill(0);
    textFont(font3);
    text ("Score: "+score, 50,60);
    text(hour()+" "+minute()+" "+second(),width/2+200,height-20);
    if (mouseX > width/2+190&& mouseX < width/2+190+110 && mouseY > 20 && mouseY< 60){ //restart button
      fill(125);
      rect(width/2+195,15,110,40);
      fill(0);
      text("Restart",width/2+205,45);
      fill(#FF4500);
      triangle(width/2+255,60,width/2+245,70,width/2+265,70);
    } else{
      fill(125);
      rect(width/2+190,20,110,40);
      fill(0);
      text("Restart",width/2+200,50);
      triangle(width/2+250,65,width/2+240,75,width/2+260,75);
    }
    for (int y=0; y<t.length; y++){
      for (int x=0; x<t[y].length; x++){
         float xPos=(space+blockSize)*(x+1);
         float yPos=(space+blockSize)*(y+1);
          show (xPos,yPos,blockSize,blockSize,color(#b1afb2));
          if (t[y][x]==2){
            show (xPos,yPos,blockSize,blockSize,color(#EEE4DA));
            showText(t[y][x],xPos,yPos);
          } else if (t[y][x]==4){
            show (xPos,yPos,blockSize,blockSize,color(#F2B179));
            showText(t[y][x],xPos,yPos);
          } else if (t[y][x]==8){
            show (xPos,yPos,blockSize,blockSize,color(#F59563));
            showText(t[y][x],xPos+5,yPos);
          } else if (t[y][x]==16){
            show (xPos,yPos,blockSize,blockSize,color(#F67C5F));
            showText(t[y][x],xPos,yPos);
          } else if (t[y][x]==32){
            show (xPos,yPos,blockSize,blockSize,color(#F65E3B));
            showText(t[y][x],xPos-4,yPos);
          } else if (t[y][x]==64){
            show (xPos,yPos,blockSize,blockSize,color(#EDCF72));
            showText(t[y][x],xPos-5,yPos);
          } else if (t[y][x]==128){
            show (xPos,yPos,blockSize,blockSize,color(#EDCC61));
            showText(t[y][x],xPos-10,yPos);
          } else if (t[y][x]==256){
            show (xPos,yPos,blockSize,blockSize,color(#EDC850));
            showText(t[y][x],xPos-10,yPos);
          } else if (t[y][x]==512){
            show (xPos,yPos,blockSize,blockSize,color(#EDC53F));
            showText(t[y][x],xPos-9,yPos);
          } else if (t[y][x]==1024){
            show (xPos,yPos,blockSize,blockSize,color(#EDC22E));
            showText(t[y][x],xPos-18,yPos);
          } else if (t[y][x]==2048){
            show (xPos,yPos,blockSize,blockSize,color(#EDC24F));
            showText(t[y][x],xPos-22,yPos);
            win=1;
          } 
          /*else if (t[y][x]==4096){
            show (xPos,yPos,blockSize,blockSize,color(#57d5a8));
            showText(t[y][x],xPos-32,yPos);
          } else if (t[y][x]==8192){
            show (xPos,yPos,blockSize,blockSize,color(#00a37a));
            showText(t[y][x],xPos-18,yPos);
          } else if (t[y][x]==16384){
            show (xPos,yPos,blockSize,blockSize,color(#008a30));
            showText(t[y][x],xPos-26,yPos);
          }
          */
      }
    } 
    spaceCount();
    if (spaceLeft==0){ // if there is no more space
        gameOver(); //check if there is mergeable
        if (die==1){ //if no, game over
          fill(0);
          textFont(font3);
          textSize(50);
          text("GAME OVER",width/2-140,height/2);
        }
    }
    if (win==1){ //if the number 2048 is reached, you win
      fill(0);
      textFont(font3);
      textSize(50);
      text(" YOU WIN!",width/2-130,height/2);
    }
  }
}
// when start is hit, it will reset the board into intital two tiles.
void restart(){
    for (int y=0;y<t.length;y++){
      for (int x=0;x<t.length;x++){
        t[y][x]=0;
      }
    }
    inital(); //intital two block spwan
    score=0;
}

//front page's rule, if the player hovering over the logo the following would show
void direction(){
  fill(#c8e8f4);
  stroke(125);
  rect(-1,height/2+100,width+1,height);
  fill(0);
  textFont(font3);
  textSize(40);
  text("How To Play",width/2-100,height/2+150);
  stroke(0);
  line(width/2-110,height/2+155,width/2+110,height/2+155);
  textSize(25);
  text("Use the ↑ ↓ ← → key or wsad key to move the tiles. Tiles with\nthe same number merge into one.\n\nAdd them up to reach 2048!",50,height/2+200);
  //text("Tiles with the same number merge into one.\n\nAdd them up to reach 2048!",50,height/2+230);
}

//check the space left
void spaceCount(){
  int count=0;
  for (int y=0; y<t.length; y++){
     for (int x=0; x<t.length; x++){
        if (t[y][x]==0){
          count++;
        }
     }
  }
  spaceLeft=count;  
}

//the aniamtion of the title 2048
void frontPage (){
  background(#c8e8f4);
  for (int i=0;i<fs.length; i++){
    fs[i].show();
    fs[i].move();
  } 
    textFont(font);
    fill(#FEF593);
    text("2",pos2,height/2-100);
    fill(#F67C5F);
    text("0",width/2-125,pos0);
    fill(#FFC370);
    text("4",width/2,pos4);
    fill(#F2B179);
    text("8",pos8,height/2-95);
    
    if (pos2<w1){
      pos2+=8;
    }
    if (pos0<h){
      pos0+=8;
    }
    if (pos4<h){
      pos4+=8;
    }
    if (pos8>w2){
      pos8-=8;
    }
 
}

//cursor effect of play button
void button (){
    strokeWeight(3);
    stroke(#d3b7d8);
    fill(#e4dbf9);
    rect(width/2-65,height/2+95,150,80);
    fill(#ae6642);
    textSize(50);
    text("Play",width/2-35,height/2+150);
}
//original play button
void unButton (){
    strokeWeight(2);
    stroke(#ccd3d9);
    fill(#e4dbf9);
    rect(width/2-70,height/2+100,150,80);
    fill(0);
    textSize(50);
    text("Play",width/2-40,height/2+155);
  
}
//intial two tile spawn randomly
void inital(){
  int randomX = (int)random(0,4);
  int randomY = (int)random(0,4);
  t[randomY][randomX] = random(0,6)<2.5? 2:4; 
  randomX = (int)random(0,4);
  randomY = (int)random(0,4);
  while (t[randomY][randomX]!=0){
    randomX = (int)random(0,4);
    randomY = (int)random(0,4);
  }
  t[randomY][randomX] = random(0,6)<2.5? 2:4; 
}


void mouseClicked (){
  if (mouseX > width/2-70&& mouseX < width/2-70+150 && mouseY > height/2+100 && mouseY< height/2+100+80) { //play button
    phase=2;
  }
  
  if (mouseX > width/2+190&& mouseX < width/2+190+110 && mouseY > 20 && mouseY< 60){ //restart button
     restart();
   }
}

void keyPressed(){
  int y=keyCode==UP||key=='w'||key=='W'? -1: (keyCode==DOWN||key=='s'||key=='S'? 1:0); // check if the UP/w/W key pressed then y equals -1, else check DOWN/s/S key pressed then y equals 1, otherwise 0
  int x=keyCode==LEFT||key=='a'||key=='A'? -1: (keyCode==RIGHT||key=='d'||key=='D'? 1:0); // check if the LEFT/a/A key pressed then x equals -1, else check RIGHT/d/D key pressed then x equals 1, otherwise 0
    if (spaceLeft>=0 && die==0){
       if (d(y,x)==1){ // check the position is mergeable, if it does, then merge and then add the new tile
          int [][] temp = move (y,x); 
          if (temp!=null){
             t=temp;
           }
           add();
       }
    } 
} 

// check the position is mergeable, return 1 if mergeable and 0 otherwise
int d(int y, int x){
  if (verticalDetermine(y)==1 || horiDetermine(x)==1){
    return 1;
  } else {
    return 0; 
  } 
}

// check if th game is over not. if no more tile can be merged and space left is 0, then the die will be 1 which is the end of game.
void gameOver(){
   die=1;
   for (int y=0; y<t.length; y++){
       for (int k=0; k<t.length-1; k++){
          if (t[y][k]==t[y][k+1] && t[y][k]!=0){
              die=0;
            }
         }
      }
       
       for (int x=0; x<t.length; x++){
         for (int k=0; k<t.length-1; k++){
            if (t[k][x]==t[k+1][x] && t[k][x]!=0){
               die=0;
             } 
         }
       }
}

//check horizontally if the tile can be mergeable by row, parameter -1 means UP, and 1 means DOWN
int horiDetermine(int xPos){
  if (xPos!=0){
    if (xPos==-1){
      for (int y=0; y<t.length; y++){
         for (int k=0; k<t.length-1; k++){
            if (t[y][k]==t[y][k+1] && t[y][k]!=0){
               return 1;
            } else if (t[y][k]==0 && t[y][k+1]!=0){
               return 1;
            }
         }
       }
       
       for (int y=0; y<t.length; y++){
           for (int k=0; k<t.length-2; k++){
              if (t[y][k]!=0 && t[y][k+2]!=0 && t[y][k+1]==0){
                 return 1;
               } else if (t[y][k]==0 && t[y][k+1]==0 && t[y][k+2]!=0){
                 return 1;
               }
           }
       }
    } else if (xPos==1){
      for (int y=t.length-1; y>=0; y--){
         for (int k=t.length-1; k>0; k--){
            if (t[y][k]==t[y][k-1] && t[y][k]!=0){
               return 1;
            } else if (t[y][k]==0 && t[y][k-1]!=0){
               return 1;
            }
         }
       }
       
       for (int y=t.length-1; y>=0; y--){
           for (int k=t.length-1; k>1; k--){
              if (t[y][k]!=0 && t[y][k-2]!=0 && t[y][k-1]==0){
                 return 1;
               } else if (t[y][k]==0 && t[y][k-1]==0 && t[y][k-2]!=0){
                 return 1;
               }
           }
       }
      
    }
  }
  return 0;
}

//check verically if the tile can be merge by column, parameter -1 means LEFT, and 1 means RIGHT
int verticalDetermine(int yPos){
  if (yPos!=0){
    if (yPos==-1){
      for (int x=0; x<t.length; x++){
         for (int k=0; k<t.length-1; k++){
            if (t[k][x]==t[k+1][x] && t[k][x]!=0){
               return 1;
             } else if (t[k][x]==0 && t[k+1][x]!=0){
               return 1;
             }
         }
       }
       
       for (int x=0; x<t.length; x++){
         for (int k=0; k<t.length-2; k++){
            if (t[k][x]!=0 && t[k+2][x]!=0 && t[k+1][x]==0){
               return 1;
             } else if (t[k][x]==0 && t[k+1][x]==0 && t[k+2][x]!=0){
               return 1;
             }
         }
       }
       
    } else if (yPos==1){
      for (int x=t.length-1; x>=0; x--){
         for (int k=t.length-1; k>0; k--){
            if (t[k][x]==t[k-1][x] && t[k][x]!=0){
               return 1;
             } else if (t[k][x]==0 && t[k-1][x]!=0){
               return 1;
             }
         }
       }
       
       for (int x=t.length-1; x>=0; x--){
         for (int k=t.length-1; k>1; k--){
            if (t[k][x]!=0 && t[k-2][x]!=0 && t[k-1][x]==0){
               return 1;
             } else if (t[k][x]==0 && t[k-1][x]==0 && t[k-2][x]!=0){
               return 1;
             }
         }
       }
       
    }
  }
  return 0;
}

/*this move will merge the number if they were the same by three condition 
  1. if the distance of tile is 2 which mean one tile is in between the target merge tiles, if this in between tile is emtpy, merge the two target tile
  2. if the distance of tile is 3 which mean two tile is in between the target merge tiles, if this in between tiles is emtpy, merge the two target tile
  3. if the distance of tile is 1 which mean no tile is in between the target merge tiles, merge the two target tile
  then make all the tiles into the extreme position according to the player pressed the key. ex: when down is hit, all the tile would going down, no space between tiles
  The condition and the final move will be same for the UP, DOWN, LEFT, and RIGHT
*/
int [][] move(int yPos, int xPos){
   int [][] temp = new int [4][4]; 
   for (int y1=0; y1<t.length; y1++){
      for (int x1=0; x1<t.length; x1++){
          temp[y1][x1]=t[y1][x1];
      }
   }
   if (xPos!=0||yPos!=0){
      if (yPos==-1){
         for (int z=0; z<4; z++){
            for (int a=0;a<temp.length-1;a++){
              for (int tempK=a+1; tempK<t.length; tempK++){
               if (temp[a][z]==temp[tempK][z] && temp[a][z]!=0){
                 if (tempK-a==2 && temp[a+1][z]==0){
                      temp[a][z]*=2;
                      temp[tempK][z]=0;
                      score+=temp[a][z];
                   } else if (tempK-a==3 && (temp[a+1][z]==0 && temp[a+2][z]==0)){
                      temp[a][z]*=2;
                      temp[tempK][z]=0;
                      score+=temp[a][z];
                   } else if (tempK-a==1){
                      temp[a][z]*=2;
                      temp[tempK][z]=0;
                      score+=temp[a][z];
                   }
               }
            } 
         }
       }
         for (int z=0; z<4; z++){
           for (int a=0;a<temp.length;a++){
             for (int tempK=0; tempK<t.length-1; tempK++){
                 if (temp[tempK][z]==0){
                     temp[tempK][z]=temp[tempK+1][z];
                     temp[tempK+1][z]=0;
                   }
              } 
           }
         }
         
      } else if (xPos==-1){
         for (int z=0; z<4; z++){
            for (int a=0; a<temp.length-1; a++){
               for (int tempK=a+1; tempK<temp.length; tempK++){
                 if (temp[z][a]==temp[z][tempK] && temp[z][a]!=0){
                   if (tempK-a==2 && temp[z][a+1]==0){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   } else if (tempK-a==3 && (temp[z][a+1]==0 && temp[z][a+2]==0)){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   }   else if (tempK-a==1){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   }
                 } 
               }
             }
           }
           for (int z=0; z<4; z++){
             for (int a=0;a<temp.length;a++){
                for (int tempK=0; tempK<t.length-1; tempK++){
                  if (temp[z][tempK]==0){
                     temp[z][tempK]=temp[z][tempK+1];
                     temp[z][tempK+1]=0;
                  }
               }
            }
          }
      }else if (yPos==1){
         for (int z=0; z<4; z++){
            for (int a=t.length-1; a>0; a--){
               for (int tempK=a-1; tempK>=0; tempK--){
                 if (temp[a][z]==temp[tempK][z] && temp[a][z]!=0){
                   if (a-tempK==2 && temp[a-1][z]==0){
                        temp[a][z]*=2;
                        temp[tempK][z]=0;
                        score+=temp[a][z];
                     } else if (a-tempK==3 && (temp[a-1][z]==0 && temp[a-2][z]==0)){
                        temp[a][z]*=2;
                        temp[tempK][z]=0;
                        score+=temp[a][z];
                     } else if (a-tempK==1){
                        temp[a][z]*=2;
                        temp[tempK][z]=0;
                        score+=temp[a][z];
                     }
                 }
               }
           }
         }
         
         for (int z=0; z<4; z++){
           for (int a=t.length; a>0; a--){
             for (int tempK=t.length-1; tempK>0; tempK--){
                 if (temp[tempK][z]==0){
                     temp[tempK][z]=temp[tempK-1][z];
                     temp[tempK-1][z]=0;
                   }
              } 
           }
         }

      } else if (xPos==1){
         for (int z=0; z<4; z++){
            for (int a=temp.length-1; a>0; a--){
               for (int tempK=a-1; tempK>=0; tempK--){
                 if (temp[z][a]==temp[z][tempK] && temp[z][a]!=0){
                    if (a-tempK==2 && temp[z][a-1]==0){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   } else if (a-tempK==3 && (temp[z][a-1]==0 && temp[z][a-2]==0)){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   } else if (a-tempK==1){
                      temp[z][a]*=2;
                      temp[z][tempK]=0;
                      score+=temp[z][a];
                   }
                 } 
               }
             }
          }
          
          for (int z=0; z<4; z++){
             for (int a=t.length; a>0; a--){
                for (int tempK=t.length-1; tempK>0; tempK--){
                  if (temp[z][tempK]==0){
                     temp[z][tempK]=temp[z][tempK-1];
                     temp[z][tempK-1]=0;
                  }
               }
            }
          }
          
      }
   }
   return temp;
}

/*
  two ArrayList, one will store the y position of the tile with 0, and one will store x postion of it.
  then randomly choose the postion of Array, and make the value of that position into new tile with random 2 or 4. 
  SpaceLeft would be decrement by 1 because one added
*/
void add (){
      ArrayList<Integer> r1 = new ArrayList <Integer>();
      ArrayList<Integer> r2 = new ArrayList <Integer>();
      for (int y=0; y<t.length; y++){
        for (int x=0; x<t.length; x++){
          if (t[y][x]==0){
            r1.add(x);
            r2.add(y);
          }
        }
      }
      
      int random = (int)random(0,r1.size());
      int xLoc= r1.get(random);
      int yLoc= r2.get(random);
      t[yLoc][xLoc] = random(0,6)<3.5? 2:4; 
      spaceLeft-=1;
}

// this will shown the number the tile
void showText(int num,float xPos,float yPos){
    fill(0);
    textFont(font2);
    text (num,xPos+40,yPos+65);
}

// this will shown the rectangle of the the tile
void show (float x, float y, float c, float d, color col){
  fill(col);
  rect(x,y,c,d,7);
}
