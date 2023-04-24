int avatarNum = 15;
int collidersNum = 10;
Particle[] particleArr;
Particle leader;
CollisionObj[] collidersArr;
float deltaTime = 0.04;
PVector posDest;
float flockDestinyOffset = 30;

boolean isVerlet = false;
//SETUP FUNCTIONS
void setup()
{
  fullScreen(P3D);
  posDest = new PVector(random(1000), random(1000), random(1000));

  InitializeParticles();
  InitializeColliders();
}

void InitializeParticles()
{
  particleArr = new Particle[avatarNum];


  //Le seteamos los valores al lider
  particleArr[0] = new Particle(new PVector(random(1000), random(1000), random(1000)), new PVector(), 5f, 60f, color(255, 0, 0), 0.1f, 10, true);
  leader = particleArr[0];

  for (int i = 1; i < avatarNum; i++)
  {
    //Inicializamos las particulas que siguen al lider
    //Primero les generamos la fuerza de las intenciones de forma aleatoria
    float randomKB = random(3, 10);
    float randomKD = random(3, 10);
    println(i + " ---- KB = " + randomKB + " y el KD = " + randomKD);
    //Y creamos cada particula con sus valores
    particleArr[i] = new Particle(new PVector(random(1000), random(1000), random(1000)), new PVector(), random(0.4f, 1.2f), 30f, color(random(255),random(255),random(255)), randomKB, randomKD, false);
  }
}

void InitializeColliders()
{
  //Inicializamos las colisiones que tendremos dandoles valores random
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
  DrawScenari(posDest);
  DrawDest(posDest);
  CollidersBehaviour();
  AvatarBehaviour();
  CameraBehaviour();
  DrawUI();
}

void CheckIfFlockIsInCenter()
{
  //Comprobamos que si la bandada esta dentro de un margen cerca del destino 
  if (FlockCenter().x - posDest.x <= flockDestinyOffset && FlockCenter().x - posDest.x >= -flockDestinyOffset
    && FlockCenter().y - posDest.y <= flockDestinyOffset && FlockCenter().y - posDest.y >= -flockDestinyOffset
    && FlockCenter().z - posDest.z <= flockDestinyOffset && FlockCenter().z - posDest.z >= -flockDestinyOffset)
  {
    //Generamos una nueva posicion para el destino
    posDest = new PVector(random(0, 1000), random(0, 1000), 100);
  }
}

void CollidersBehaviour()
{
  //Pintamos todos los colliders
  for (int i = 0; i < collidersNum; i++)
  {
    collidersArr[i].Draw();
  }
}

void AvatarBehaviour()
{
  for (int i = 0; i < avatarNum; i++)
  {
    //Primero comprobamos si es la particula lider o no
    //En caso de que lo sea haremos que su destino sea la posicion de destino
    //Si no hacemos que su destino sea el lider
    if (particleArr[i].isLeader)
    {
      particleArr[i].Move(posDest);
    } else
    {
      particleArr[i].Move(leader.pos);
    }

    //Dibujamos las particulas
    particleArr[i].Draw();
  }
}

void DrawDest(PVector _dir)
{
  //Definimos como se vera el destino
  strokeWeight(4);
  stroke(0);
  fill(255);
  //Hacemos un push en la matriz para volver atras despues de mover el objeto destino a su posicion
  pushMatrix();
  translate(_dir.x, _dir.y, _dir.z);
  box(60);
  //Hacemos el POP para volver hacia atras
  popMatrix();
}
void DrawScenari(PVector _dir)
{
  //Definimos como se vera el escenario
  strokeWeight(1);
  stroke(255);
    //Hacemos un push en la matriz para volver atras despues dibujar todo el mapa
  pushMatrix();
  //El escenario estara posicionado en funcion del destino
  translate(0, _dir.y, 0);
  //Entoces dibujaremos una cuadricula debajo del punto de destino
  //En este lo que haremos sera con un tamanyo maximo dibujaremos distintas lineas y las moveremos en x o z en cada itineracion del bucle
  for (int x=-2000; x<=2000; x+=50) {
    line( x, 100, -2000, x, 100, 2000 );
  }
  for (int z=-2000; z<=2000; z+=50) {
    line( -2000, 100, z, 2000, 100, z );
  }
  //Hacemos el POP para volver hacia atras
  popMatrix();
}
void DrawUI()
{
  //Dibujamos los textos con los Controles
  fill(255);
  text("Flecha : [ARRIBA],[ABAJO] : Mirar Arriba/Abajo", 10, 20);
  text("Flecha : [LEFT],[RIGHT] : Mirar Izquierda/Derecha", 10, 35);
  text("[W],[S] : Moverse Adelante/Atras", 10, 50);
  text("[A],[D] : Moverse Iquierda/Derecha", 10, 65 );
  text("[Q],[E] : Moverse Abajo/Arriba", 10, 80 );
  text("[V] : Cambiar el Solver", 10, 95);
  if (isVerlet)
  {
    text("Solver actual : Verlet", 10, 110);
  } else
  {
    text("Solver actual : Euler", 10, 110);
  }

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
  //Comprobamos la entrada de todos los inputs

  if ( key == 'w' ) {
    camMovingForward = true;
  }

  if ( key == 's' ) {
    camMovingBack = true;
  }

  if ( key == 'a' ) {
    camMovingLeft = true;
  }

  if ( key == 'd' ) {
    camMovingRight = true;
  }


  if ( key == 'e' ) {
    camMovingDown = true;
  }

  if ( key == 'q' ) {
    camMovingUp = true;
  }


  if ( keyCode == PConstants.UP ) {
    camRotatingUp = true;
  }

  if ( keyCode == PConstants.DOWN ) {
    camRotatingDown = true;
  }

  if ( keyCode == PConstants.RIGHT ) {
    camRotatingRight = true;
  }

  if ( keyCode == PConstants.LEFT ) {
    camRotatingLeft = true;
  }
}

void keyReleased()
{
  //Comprobamos cuando soltamos todos los inputs

  if ( key == 'w' ) {
    camMovingForward = false;
  }

  if ( key == 's' ) {
    camMovingBack = false;
  }

  if ( key == 'a' ) {
    camMovingLeft = false;
  }

  if ( key == 'd' ) {
    camMovingRight = false;
  }


  if ( key == 'e' ) {
    camMovingDown = false;
  }
  if ( key == 'q' ) {
    camMovingUp = false;
  }


  if ( keyCode == PConstants.UP ) {
    camRotatingUp = false;
  }

  if ( keyCode == PConstants.DOWN ) {
    camRotatingDown = false;
  }

  if ( keyCode == PConstants.RIGHT ) {
    camRotatingRight = false;
  }

  if ( keyCode == PConstants.LEFT ) {
    camRotatingLeft = false;
  }

  if (key == 'v')
  {
    if (isVerlet)
    {
      isVerlet = false;
      for (int i = 0; i < avatarNum; i++)
      {
        particleArr[i].KC = -200;
      }
    } 
    else
    {
      isVerlet = true;
      for (int i = 0; i < avatarNum; i++)
      {
        particleArr[i].verletLastPos = particleArr[i].pos;
        particleArr[i].KC = -100;
      }
    }
  }
}
