boolean camMovingForward = false;
boolean camMovingBack = false;
boolean camMovingLeft = false;
boolean camMovingRight = false;
boolean camMovingUp = false;
boolean camMovingDown = false;
boolean camRotatingUp = false;
boolean camRotatingDown = false;
boolean camRotatingLeft = false;
boolean camRotatingRight = false;

void CameraBehaviour() {

  //Variables de velocidad de movimiento y de rotacion de la cammara
  float camSpeed = 4, camRotSpeed = 0.01;

  PMatrix3D M = new PMatrix3D();

  //Segun el input que se este presionando moveremos la matriz creada anteriormente hacia esa direccion
  if (camMovingForward) {
    M.translate( 0, 0, camSpeed );
  }

  if (camMovingBack) {
    M.translate( 0, 0, -camSpeed );
  }

  if (camMovingLeft) {
    M.translate( camSpeed, 0, 0 );
  }

  if (camMovingRight) {
    M.translate( -camSpeed, 0, 0 );
  }
  if (camMovingDown) {
    M.translate( 0, camSpeed, 0 );
  }
  if (camMovingUp) {
    M.translate( 0, -camSpeed, 0 );
  }

  if (camRotatingUp) {
    M.rotateX(camRotSpeed);
  }
  if (camRotatingDown) {
    M.rotateX(-camRotSpeed);
  }
  if (camRotatingRight) {
    M.rotateY(camRotSpeed);
  }
  if (camRotatingLeft) {
    M.rotateY(-camRotSpeed);
  }

  // Creamos otra variable donde juntaremos el movimiento hecho con los inputs con la matriz de la camara
  PMatrix3D C = ((PGraphicsOpenGL)(g)).camera.get(); // Copiamos la matriz de la camara para editarla desde una variable
  C.preApply(M);

  //Invertimos la matriz para definir correctamente el vector de arriba (0,1,0)
  C.invert();

  float ex = C.m03;
  float ey = C.m13;
  float ez = C.m23;
  float cx = -C.m02 + ex;
  float cy = -C.m12 + ey;
  float cz = -C.m22 + ez;
  
  //Aplicamos los cambios en la camara
  camera( ex, ey, ez, cx, cy, cz, 0, 1, 0 );
}
