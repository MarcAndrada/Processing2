class Particle //<>//
{
  PVector pos;
  PVector vel;

  float weight;
  float size;

  // KB de acercamiento a la bandada
  float KB;
  // KD de acercamiento a la meta
  float KD;
  // KC separacion de las colisiones
  float KC;
  // Fuerza constante del damping
  float dampingForce;
  color color_p;

  //Variable auxiliar para el solver de verlet
  PVector verletLastPos;

  boolean isLeader;


  Particle(PVector _pos, PVector _velocity, float _weight, float _size, color _color, float _KB, float _KD, boolean _isLeader)
  {
    //Le ponemos sus valores a cada cosa
    pos =_pos;
    vel = _velocity;
    weight = _weight;
    size = _size;
    color_p = _color;
    verletLastPos = pos;
    isLeader = _isLeader;

    // Priodidades de la bandada de pajaros. Cuanto mas cerca de 1, mayor priodidad tendra
    KB = _KB; // Priodidad de seguir a la bandada
    KD = _KD; // Prioridad de seguir al objetivo
    KC = -200; // Prioridad de evitar colisiones
    dampingForce = 0.2f; //Fuerza de rozamiento
  }

  void Move(PVector _destPos)
  {
    //Dependiendo del solver nos moveremos con uno u otro
    if (!isVerlet)
    {
      EulerSolver(_destPos);
    } else {
      VerletSolver(_destPos);
    }
  }

  void EulerSolver(PVector _destPos)
  {
    PVector strenght = new PVector(0.0, 0.0, 0.0);
    PVector accel = new PVector(0.0, 0.0, 0.0);
    PVector dest = new PVector(0.0, 0.0, 0.0);
    //Flock es bandada
    PVector flock = new PVector(0.0, 0.0, 0.0);
    //El objeto con el que colisiona
    PVector collisionObject = CheckCollision();

    dest = UnitaryVector(pos, _destPos);
    flock = UnitaryVector(pos, FlockCenter());
    //Definimos un nuevo vector para no sobreescibir el anterior vector con el valor del vector unitario
    PVector unitaryCollObj = UnitaryVector(pos, collisionObject);

    //En caso de que el vector inicial fuera un Vector 0
    if (collisionObject.x == 0 && collisionObject.y == 0 && collisionObject.z == 0)
    {
      //Haremos que el vector unitario tambien lo sea 
      //(utilizando la funcion de unitaryVector con un vector 0 me seguia dando valores y funcionaba mal el comportamiento)
      unitaryCollObj = new PVector(0, 0, 0);
    }

    //Aplicamos la fuerza teniendo en cuenta la constante del destino, la de la bandada y la de la colision
    strenght.x = KD * dest.x + KB * flock.x + KC * unitaryCollObj.x;
    strenght.y = KD * dest.y + KB * flock.y + KC * unitaryCollObj.y;
    strenght.z = KD * dest.z + KB * flock.z + KC * unitaryCollObj.z;

    //Aplicamos la friccion (damping)
    strenght.x += -dampingForce * vel.x;
    strenght.y += -dampingForce * vel.y;
    strenght.z += -dampingForce * vel.z;


    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;
    accel.z = strenght.z/weight;

    //Utilizamos la formula de Euler
    vel.x += accel.x * deltaTime;
    vel.y += accel.y * deltaTime;
    vel.z += accel.z * deltaTime;

    pos.x = pos.x + vel.x * deltaTime;
    pos.y = pos.y + vel.y * deltaTime;
    pos.z = pos.z + vel.z * deltaTime;
  }

  void VerletSolver(PVector _destPos)
  {
    PVector strenght = new PVector(0.0, 0.0, 0.0);
    PVector accel = new PVector(0.0, 0.0, 0.0);
    PVector dest = new PVector(0.0, 0.0, 0.0);
    //Flock es bandada
    PVector flock = new PVector(0.0, 0.0, 0.0);
    //El objeto con el que colisiona
    PVector collisionObject = CheckCollision();

    dest = UnitaryVector(pos, _destPos);
    flock = UnitaryVector(pos, FlockCenter());
    //Definimos un nuevo vector para no sobreescibir el anterior vector con el valor del vector unitario
    PVector unitaryCollObj = UnitaryVector(pos, collisionObject);

    //En caso de que el vector inicial fuera un Vector 0
    if (collisionObject.x == 0 && collisionObject.y == 0 && collisionObject.z == 0)
    {
      //En caso de que el vector inicial fuera un Vector 0

      unitaryCollObj = new PVector(0, 0, 0);
    }

    //Aplicamos la fuerza teniendo en cuenta la constante del destino, la de la bandada y la de la colision
    strenght.x = KD * dest.x + KB * flock.x + KC * unitaryCollObj.x;
    strenght.y = KD * dest.y + KB * flock.y + KC * unitaryCollObj.y;
    strenght.z = KD * dest.z + KB * flock.z + KC * unitaryCollObj.z;

    //Aplicamos la friccion (damping)
    //En el solver de verlet al no tener la velocidad utilizo la acceleracion multiplicada por 2
    strenght.x += -dampingForce * accel.x * 2;
    strenght.y += -dampingForce * accel.y * 2;
    strenght.z += -dampingForce * accel.z * 2;

    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;
    accel.z = strenght.z/weight;


    PVector lastPos = new PVector(0, 0, 0);
    lastPos = pos;
    //Hacemos la formula del solver de verlet que es, pos = pos*2 - verletLastPos + _accel * (deltaTime * deltaTime (delta al cuadrado))
    pos = new PVector(pos.x * 2 - verletLastPos.x + accel.x * (deltaTime * deltaTime) // Esta es la X
      , pos.y * 2 - verletLastPos.y + accel.y * (deltaTime * deltaTime) // Esta la Y
      , pos.z * 2 - verletLastPos.z + accel.z * (deltaTime * deltaTime)); // Esta es la Z

    verletLastPos = lastPos; //<>//
  }

  PVector CheckCollision()
  {
    //Aqui definiremos las colisiones, en caso de que sea el lider solo colisionara con los obstaculos, todos las demas particulas colisionaran contra ellos
      
    if (!isLeader)
    {
      for(int i = 0; i < particleArr.length; i++)
      {
        
        if (particleArr[i] != this && isColliding(particleArr[i].pos, particleArr[i].size)) //Si esta chocando con algo y no somos nosotros mismos
        {
          //Devolverle la posicion de el objeto encontrado
          return particleArr[i].pos;
        }
      }
    }


    //Comprobamos la colision con los obstaculos
    for (int i = 0; i < collidersArr.length; i++)
    {
      if (isColliding(collidersArr[i].pos, collidersArr[i].size)) //Si esta chocando con algo
      {
        //Devolverle la posicion de el objeto encontrado
        return collidersArr[i].pos;
      }
    }



    //Si no esta tocando nada devuelve un Vector 0
    return new PVector(0, 0, 0);
  }

  boolean isColliding(PVector _p, float _s)
  {
    //Si la distancia es menor a la suma de sus radios estan colisionando
    if (Distance(_p) < size + _s )
    {
      return true;
    }

    return false;
  }

  float Distance(PVector _pos)
  {
    //Calculamos y devolvemos la distancia entre puntos
    PVector distance = new PVector(pos.x - _pos.x, pos.y - _pos.y, pos.z - _pos.z);

    return sqrt(distance.x * distance.x + distance.y * distance.y + distance.z * distance.z);
  }

  void Draw()
  {
    pushMatrix();
    fill(color_p);
    noStroke();
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }
}
