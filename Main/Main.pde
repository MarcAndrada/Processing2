int avatarNum = 7;
int collidersNum = 10;
Particle[] particleArr;
Particle leader;
CollisionObj[] collidersArr;
float deltaTime = 0.04;
PVector posDest;
float flockDestinyOffset = 30;

enum Solver{EULER, VERLET};
Solver currentSolver = Solver.EULER;
//SETUP FUNCTIONS
void setup()
{
  //size(2000, 2000, P3D);
  fullScreen(P3D);
  posDest = new PVector(random(1000), random(1000), random(1000));

  InitializeParticles();
  InitializeColliders();
}

void InitializeParticles()
{
  color[] colorArr;

  particleArr = new Particle[avatarNum];
  colorArr = new color[avatarNum];
  colorArr[0] = color(255, 0, 0); //Rojo
  colorArr[1] = color(0, 255, 0); //Verde
  colorArr[2] = color(0, 0, 255); //Azul
  colorArr[3] = color(255, 0, 255); //Morado
  colorArr[4] = color(255, 255, 0); //Amarillo
  colorArr[5] = color(0, 255, 255); //Azul Clarito
  colorArr[6] = color(255, 255, 255); //Blanco

  //Le seteamos los valores al lider
  particleArr[0] = new Particle(new PVector(random(1000), random(1000), random(1000)), new PVector(), 40, 3f, 60f, colorArr[0], 0.1f, 10);
  leader = particleArr[0];

  for (int i = 1; i < avatarNum; i++)
  {
    //Inicializamos las particulas que siguen al lider
    //Primero les generamos la fuerza de las intenciones de forma aleatoria
    float randomKB = random(4, 10);
    float randomKD = random(4, 10);
    println(i + " ---- KB = " + randomKB + " y el KD = " + randomKD);
    //Y creamos cada particula con sus valores
    particleArr[i] = new Particle(new PVector(random(1000), random(1000), random(1000)), new PVector(), random(70, 100), 0.7f, 30f, colorArr[i], randomKB, randomKD);
  }
}

void InitializeColliders()
{
  collidersArr = new CollisionObj[collidersNum];
  for (int i = 0; i < collidersNum; i++)
  {
    collidersArr[i] = new CollisionObj(new PVector(random(1000), random(1000), random(1000)), random(35, 80), color(random(255), random(255), random(255)));
  }
}



//UPDATE FUNCTIONS
void draw()
{
  background(50);

  CheckIfFlockIsInCenter();
  DrawDest(posDest);
  CollidersBehaviour();
  AvatarBehaviour();
  CameraBehaviour();
}

void CheckIfFlockIsInCenter()
{
  if (FlockCenter().x - posDest.x <= flockDestinyOffset && FlockCenter().x - posDest.x >= -flockDestinyOffset
    && FlockCenter().y - posDest.y <= flockDestinyOffset && FlockCenter().y - posDest.y >= -flockDestinyOffset
    && FlockCenter().z - posDest.z <= flockDestinyOffset && FlockCenter().z - posDest.z >= -flockDestinyOffset)
  {
    println("QUIERO SEXOOOOO");
    //Generar una nueva posicion para el destino
    posDest = new PVector(random(0, 1000), random(0, 1000), 100);
  }
}

void CollidersBehaviour()
{
  for (int i = 0; i < collidersNum; i++)
  {
    collidersArr[i].Draw();
  }
}

void AvatarBehaviour()
{
  for (int i = 0; i < avatarNum; i++)
  {
    if (i == 0)
    {
      particleArr[i].Move(posDest, collidersArr);
    } else
    {
      particleArr[i].Move(leader.pos, collidersArr);
    }

    particleArr[i].Draw();
  }
}

void DrawDest(PVector _dir)
{
  DrawScenari(_dir);
  strokeWeight(4);
  stroke(0);
  fill(255);
  pushMatrix();
  translate(_dir.x, _dir.y, _dir.z);
  box(60);
  popMatrix();
}

void DrawScenari(PVector _dir)
{
  strokeWeight(1);
  stroke(255);
  pushMatrix();
  translate(0, _dir.y, 0);

  for (int x=-2000; x<=2000; x+=50) {
    line( x, 100, -2000, x, 100, 2000 );
  }
  for (int z=-2000; z<=2000; z+=50) {
    line( -2000, 100, z, 2000, 100, z );
  }
  popMatrix();
}



//MATH FUNCTIONS
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



void keyPressed()
{
  

}

