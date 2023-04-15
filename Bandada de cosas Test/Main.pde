int avatarNum = 7; //<>//
Particle[] particleArr;
float deltaTime = 0.04;
PVector posDest;
float flockDestinyOffset = 30;
color[] colorArr;

void setup()
{
  //size(2000, 2000, P3D);
  fullScreen(P3D);
  posDest = new PVector(width/2, height/2, 100.0);



  particleArr = new Particle[avatarNum];
  colorArr = new color[avatarNum];
  colorArr[0] = color(255, 0, 0); //Rojo
  colorArr[1] = color(0, 255, 0); //Verde
  colorArr[2] = color(0, 0, 255); //Azul
  colorArr[3] = color(255, 0, 255); //Morado
  colorArr[4] = color(255, 255, 0); //Amarillo
  colorArr[5] = color(0, 255, 255); //Azul Clarito
  colorArr[6] = color(255, 255, 255); //Blanco


  for (int i = 0; i < avatarNum; i++)
  {
    float randomKB = random(3, 10);
    float randomKD = random(3, 10);
    println(i + " ---- KB = " + randomKB + " y el KD = " + randomKD);
    particleArr[i] = new Particle(new PVector(random(1000), random(1000), random(1000)), new PVector(random(10, 20), random(10, 20), random(10, 20)), 0.7f, 30f, colorArr[i], randomKB, randomKD);
  }
}


void draw()
{
  background(50);

  if (FlockCenter().x - posDest.x <= flockDestinyOffset && FlockCenter().x - posDest.x >= -flockDestinyOffset)
  {
    //float distancia = FlockCenter().x - posDest.x;
    //println("X-- " + distancia + " esto es mas pequenyo o mas grande que esto " + flockDestinyOffset);
    if (FlockCenter().y - posDest.y <= flockDestinyOffset && FlockCenter().y - posDest.y >= -flockDestinyOffset)
    {
      //distancia = FlockCenter().y - posDest.y;
      //println("Y-- " +  distancia + " esto es mas pequenyo o mas grande que esto " + flockDestinyOffset);

      if (FlockCenter().y - posDest.y <= flockDestinyOffset && FlockCenter().y - posDest.y >= -flockDestinyOffset)
      {
        println("QUIERO SEXOOOOO");
        posDest = new PVector(random(0, width), random(0, height), 100);
        //distancia = FlockCenter().z - posDest.z;
        //println("Z-- " +  distancia + " esto es mas pequenyo o mas grande que esto " + flockDestinyOffset);
      }
    }
  }


  DrawDest(posDest);

  for (int i = 0; i < avatarNum; i++)
  {
    particleArr[i].Move(posDest);
    particleArr[i].Draw();
  }

  CameraBehaviour();
}


void DrawDest(PVector dir)
{
  strokeWeight(4);
  stroke(0);
  fill(255);
  pushMatrix();
  translate(dir.x, dir.y, dir.z);
  box(60);
  DrawScenari();
  popMatrix();
}

void DrawScenari()
{
  strokeWeight(1);
  stroke(255);
  for (int x=-2000; x<=2000; x+=50) {
    line( x, 100, -2000, x, 100, 2000 );
  }
  for (int z=-2000; z<=2000; z+=50) {
    line( -2000, 100, z, 2000, 100, z );
  }
}


PVector UnitaryVector(PVector start, PVector end)
{
  PVector result = new PVector();

  result.x = end.x - start.x;
  result.y = end.y - start.y;
  result.z = end.z - start.z;

  float mod = sqrt(result.x * result.x + result.y * result.y + result.z * result.z );

  result.x /= mod;
  result.y /= mod;
  result.z /= mod;


  return result;
}

PVector FlockCenter()
{
  PVector result;
  result = new PVector(0.0, 0.0, 0.0);

  for (int i = 0; i < avatarNum; i++)
  {
    result.x += particleArr[i].pos.x;
    result.y += particleArr[i].pos.y;
    result.z += particleArr[i].pos.z;
  }

  result.x /= avatarNum;
  result.y /= avatarNum;
  result.z /= avatarNum;


  return result;
}