class Nave {
  var velocidad
  var direccion = 0
  var combustible

  method acelerar(cantidad) {velocidad = 100000.min(velocidad + cantidad)} 
  method desacelerar(cantidad) {velocidad = 0.max(velocidad - cantidad)}
  method irHaciaElSol() {direccion = 10}
  method escaparDelSol() {direccion = -10}
  method ponerseParaleloAlSol() {direccion = 0}
  method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1)}
  method alejarseUnPocoDelSol() {direccion = -10.max(direccion - 1)}

  method prepararViaje() {self.cargarCombustible(30000);self.acelerar(5000)}

  method cargarCombustible(cantidad) {combustible += cantidad}
  method descargarCombustible(cantidad) {combustible -= cantidad}

  method estaTranquila() = combustible >= 4000 and velocidad < 12000

  method recibirAmenaza()

  method tenerPocaActividad()
  method estaDeRelajo() = self.estaTranquila() and self.tenerPocaActividad()
}

class NaveBaliza inherits Nave {
  var colorBaliza
  var cambioDeColor = false

  method colorBaliza() = colorBaliza
  method cambiarColorDeBaliza(colorNuevo) {
    colorBaliza = colorNuevo;
    cambioDeColor = true
    }

  override method prepararViaje() {
    super();
    self.cambiarColorDeBaliza("verde");
    self.ponerseParaleloAlSol()}

  override method estaTranquila() = super() and colorBaliza != "rojo"

  override method recibirAmenaza() {
    self.irHaciaElSol();
    self.cambiarColorDeBaliza("rojo")}

  override method tenerPocaActividad() = !cambioDeColor
}

class NavePasajeros inherits Nave {
  const pasajeros = []
  var racionesComida
  var racionesBebida
  var racionesDeComidaServidas = 0

  method cantidadPasajeros() = pasajeros.size()
  method cargarComida(cantidad) {racionesComida += cantidad}
  method descargarComida(cantidad) {
    racionesComida -= cantidad;
    racionesDeComidaServidas += cantidad
  }
  method cargarBebida(cantidad) {racionesBebida += cantidad}
  method descargarBebida(cantidad) {racionesBebida -= cantidad}

  override method prepararViaje() {
    super();
    self.cargarComida(4 * self.cantidadPasajeros());
    self.cargarBebida(6 * self.cantidadPasajeros());
    self.acercarseUnPocoAlSol()}

  override method recibirAmenaza() {
  self.acelerar(velocidad);
  self.descargarComida(self.cantidadPasajeros());
  self.descargarBebida(self.cantidadPasajeros() * 2)
  }

  override method tenerPocaActividad() = racionesDeComidaServidas >= 50
}

class NaveCombate inherits Nave {
  var visible
  var misilesDesplegados
  const mensajes = []

  method ponerseInvisible() {visible = false}
  method ponerseVisible() {visible = true}
  method estaInvisible() = !visible

  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(mensaje) {mensajes.add(mensaje)}
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = mensajes.first()
  method ultimoMensajeEmitido() = mensajes.last()
  method esEscueta() = mensajes.any({m => m.length() > 30})
  method emitioMensaje() = mensajes.size() > 0 

  override method prepararViaje() {
    super();
    self.ponerseVisible();
    self.replegarMisiles();
    self.acelerar(15000);
    self.emitirMensaje("Saliendo en misión")}

  override method estaTranquila() = super() and !misilesDesplegados

  override method recibirAmenaza() {
    self.acercarseUnPocoAlSol();
    self.acercarseUnPocoAlSol();
    self.emitirMensaje("Amenaza recibida")
  }

  override method tenerPocaActividad() = true
}

class NaveHospital inherits NavePasajeros {
  var tieneQuirofanosPreparados

  method tienePreparadoLosQuirofanos() = tieneQuirofanosPreparados

  method prepararQuirofanos() {tieneQuirofanosPreparados = true}
  method desprepararQuirofanos() {tieneQuirofanosPreparados = false}

  override method estaTranquila() = super() and !self.tienePreparadoLosQuirofanos()

  override method recibirAmenaza() {
    super();
    self.prepararQuirofanos()
    }
}

class NaveCombateSilenciosa inherits NaveCombate {
  override method estaTranquila() = super() and !self.estaInvisible()

  override method recibirAmenaza() {
    super();
    self.desplegarMisiles();
    self.ponerseInvisible()
  }
}