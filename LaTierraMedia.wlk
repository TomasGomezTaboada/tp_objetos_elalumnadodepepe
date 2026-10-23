class Guerrero{
  const property armas = []
  const property elementosUtiles = []
  var property vida

  method tienePocaVida(){ return vida < 10}
  method estaVivo() = vida > 0

  method poderArmas() = armas.sum({ arma => arma.poderOtorgado(self) })

  method cantidadDeArmas() = armas.size()
  method cantidadDeElementos() = elementosUtiles.size()
  method estaArmado() = !armas.isEmpty()

  method perderVida(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method huir(){
    self.perderVida(10)
  }

  method ganarVida(cantidad) {
    vida += cantidad
  }

  method valorOrigen() {
    return 10 * self.cantidadDeArmas()
  }

  method iniciarAtaque(adversario, tactica){
    tactica.usarTactica(self, adversario)
  }

  method atacar(adversario, danio){
    if (self.estaVivo())
    {
      adversario.recibirDanio(danio)
    }
    else{
      throw new Exception(message = "Guerrero sin vida para atacar")
    }
  }

  method recibirDanio(danio){
    self.perderVida(danio)
  }
}

class Hobbit inherits Guerrero{
  method poder() = self.vida() + self.cantidadDeElementos() * self.poderArmas()
}

class Enano inherits Guerrero{
  const property valorOrigen = 20
  var property factorDePoder

  method poder(){
    return self.vida() + self.factorDePoder() * self.poderArmas()
  }
}

class Elfo inherits Guerrero{
  const property valorOrigen = 25
  const destrezaBase = 2
  var property destrezaPropia

  method poder() = self.vida() + (destrezaBase + self.destrezaPropia()) * self.poderArmas()
}

class Maiar inherits Guerrero{
  const poderBasico = 15
  const poderBajoAmenaza = 300 
  method poder(){
    var factor = poderBasico

    if(self.tienePocaVida()){
      factor = poderBajoAmenaza
    }

    return self.vida() * factor + 2 * self.poderArmas()
  }
}

class Gollum inherits Hobbit{
  override method poder(){ 
    return super() / 2
}
}

class Humano inherits Guerrero{
  const property valorOrigen = 15
  const property limitadorDePoder

  method poder() = self.vida() + self.poderArmas() / self.limitadorDePoder()
}

class Hacha{
  var property largoMango
  var property pesoHoja

  method poderOtorgado(guerrero) { return largoMango * pesoHoja }
}

class Baculo{
  var property poderBase = 250

  method poderOtorgado(guerrero){
    var multiplicador = 1
  
    if(guerrero.tienePocaVida()){
      multiplicador = 2
    }

    return 400.min(poderBase * multiplicador)
  }
}

class Espada{
  var multiplicador

  method initialize() {
    self.setearMultiplicador(multiplicador)   // valida el valor con el que se creó
  }

  method setearMultiplicador(numero){
    if(numero<1 || numero>20){
      throw new Exception(message = "Multiplicador fuera de rango")
    }
    else{
      multiplicador = numero
    }
  }

  method poderOtorgado(guerrero){
    return multiplicador * guerrero.valorOrigen()
  }
}

class Daga inherits Espada{
  override method poderOtorgado(guerrero){ 
    return super(guerrero) / 2
}
}

object magiaElfica{
  method valorMagia(guerrero) = 25
}

object magiaEnana{
  method valorMagia(guerrero) = guerrero.vida()/2
}

class FlechaBronce{
  const poderBase = 100

  method poderOtorgado(fechaLustrado, fechaUso){
    if(fechaLustrado < fechaUso){
      throw new Exception(message = "La flecha se usó antes de su lustrado/creacion")
    }

    const tiempoDesdeLustrado = fechaLustrado - fechaUso

    return 0.max(poderBase - tiempoDesdeLustrado)
  }
}

class FlechaAluminio{
  var property poderBase = 50
}

class FlechaHierro{
  var property poderBase = 70
  var property estaOxidada = false
  method poder() = if (estaOxidada) poderBase/2 else poderBase
}

class CajaDeFlechas{
  const property flechas = []

  method flechasUtiles() = flechas.filter({ f => f.poder() > 50 })

  method poderOtorgado(guerrero) {
    const utiles = self.flechasUtiles()
    return utiles.sum({ f => f.poder() }) / utiles.size()
  }
}

// El gandalf como objeto/singleton, vestigio de la primera entrega.
object gandalfObjeto{
  var property vida = 100
  const armas = []
  
  method darArmas(nuevasArmas){
    armas.addAll(nuevasArmas)
  }

  method tienePocaVida() = vida < 10

  method poder() {
    var multiplicadorVida = if (self.tienePocaVida()) 200 else 15
    return (vida * multiplicadorVida) + (self.poderArmas() * 2)
  }
  method poderArmas() = armas.sum({ arma => arma.poderOtorgado(self) })

  method cantidadDeArmas() = armas.size()
  method estaArmado() = !armas.isEmpty()

  method perderVida(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method ganarVida(cantidad) {
    vida += cantidad
  }
}

/* Parte 2 */
class Grupo {
  const property miembros = []

  method integrantes() = miembros 
  method agregar(guerrero) { miembros.add(guerrero) }

  method totalDeElementos(nombre) = miembros.sum({ g => g.elementosUtiles().count({ e => e == nombre }) })
}

object sinRequerimiento{
  method cumple(viajeros) = true
}

class RequerimientoElemento{
  const property cantidadMinima
  const property nombreElemento

  method cumple(viajeros) =
    viajeros.sum ({ v => v.elementosUtiles().count({ e => e == nombreElemento }) }) >= cantidadMinima
}

class RequerimientoArmasMinimas{
  const property cantidadMinima

  method cumple(viajeros) =
    viajeros.any({ v => v.cantidadDeArmas() >= cantidadMinima })
  
}

class RequerimientoPoderMinimo{
  const property poderMinimo

  method cumple(viajeros) =
    viajeros.any({ v => v.poder() >= poderMinimo })
  
}

class RequerimientoVidaMinima{
  const property vidaMinima

  method cumple(viajeros) =
    viajeros.any({ v => v.vida() >= vidaMinima })
  
}
class Zona {
  var property requerimientoExtra = sinRequerimiento

  method puedePasar(grupo) {
    return self.cumpleCondicionPropia(grupo) && requerimientoExtra.cumple(grupo)
  }

  method pasar(viajeros) {
    if (!self.puedePasar(viajeros)) {
      throw new DomainException(message = "No se puede pasar")
    }
    viajeros.forEach({ g => self.aplicarEfecto(g) })
  }

  method cumpleCondicionPropia(grupo)
  method aplicarEfecto(guerrero)
}

class ZonaDePoder inherits Zona{
  const property poderExigido = 1500

  override method cumpleCondicionPropia(grupo) = grupo.all({ g => g.poder() > self.poderExigido() })

  override method aplicarEfecto(guerrero) {}
}

class Lebennin inherits ZonaDePoder{
  var property cantidadGuardias = 0

  override method poderExigido() = if (cantidadGuardias > 3) 1500 else 1000
}

class ZonaArmada inherits Zona{
  var property danioPorArma = 0

  override method cumpleCondicionPropia(grupo) = grupo.all({ g => g.estaArmado() })

  override method aplicarEfecto(guerrero) {
    guerrero.perderVida(danioPorArma * guerrero.cantidadDeArmas())

  }
} 

class Lossarnach inherits Zona{
  var property vidaGanadaPorArma = 2

  override method cumpleCondicionPropia(grupo) = true

  override method aplicarEfecto(guerrero) {
    guerrero.ganarVida(vidaGanadaPorArma * guerrero.cantidadDeArmas())
  }
}

class Camino{
  const property zonas = []

  method puedePasar(viajeros) = zonas.all({ z => z.puedePasar(viajeros) })

  method pasar(viajeros) {
    if (!self.puedePasar(viajeros)) {
      throw new DomainException(message = "No se puede pasar")
    }
    zonas.forEach({ z => z.pasar(viajeros) })
  }
}

class Region{
  const property camino

  method puedeAtravesar(viajeros) = camino.puedePasar(viajeros)

  method atravesar(viajeros) {
      camino.pasar(viajeros)
  }
}


object tomBombadil{
  method poder() = 10000000
  method cantidadDeArmas() = 100
  method estaArmado() = true
  method elementosUtiles() = []
  method perderVida(cantidad) {}
  method ganarVida(cantidad) {}
}

const lebennin = new Lebennin(cantidadGuardias = 2)
const minasDeTirith = new ZonaArmada(danioPorArma = 10)
const lossarnach = new Lossarnach()

const caminoDeGondor = new Camino(zonas = [lebennin, minasDeTirith])
const gondor = new Region(camino = caminoDeGondor)



// --- Parte 3 ---
// cada acción de ataque descuenta la vida del oponente en el 10% del poder calculado del atacante
object tacticaAgil{
  method usarTactica(guerrero, oponente){
      guerrero.atacar(oponente, (guerrero.poder() + 100) * 0.1)
      oponente.atacar(guerrero, (oponente.poder()) * 0.1)
  }
}

object tacticaResistencia{
  method usarTactica(guerrero, oponente){
    oponente.atacar(guerrero,(oponente.poder()/2) * 0.1)
    guerrero.atacar(oponente, guerrero.poder() * 0.1)
  }
}

class TacticaCaruso{
  const energia

  method usarTactica(guerrero, oponente){
    if(oponente.poder() < energia){
      guerrero.atacar(oponente, guerrero.poder() * 0.1)
    } 
    else{
      guerrero.huir()
    }
  }
}

object tacticaLaCuatroTresTres{
  method usarTactica(guerrero, oponente){
    guerrero.atacar(oponente, guerrero.poder()* 0.1 * 2)

    if(guerrero.vida() < 60){
      oponente.atacar(guerrero, oponente.poder()*0.1)
    }
  }
}