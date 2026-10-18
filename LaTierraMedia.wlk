class Guerrero{
  const property armas = []
  const property elementosUtiles = []
  var property vida

  method tienePocaVida(){ return vida < 10}

  method poderArmas() = armas.sum({ arma => arma.poderOtorgado(self) })

  method cantidadDeArmas() = armas.size()
  method cantidadDeElementos() = elementosUtiles.size()
  method estaArmado() = !armas.isEmpty()

  method perderVida(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method ganarVida(cantidad) {
    vida += cantidad
  }

  method valorOrigen() {
    return 10 * self.cantidadDeArmas()
  }
}

class Hobbit inherits Guerrero{
  method poder() = self.vida() + self.cantidadDeElementos() * self.poderArmas()
}

class Enano inherits Guerrero{
  var property valorOrigen = 20
  var property factorDePoder

  method poder(){
    return self.vida() + self.factorDePoder() * self.poderArmas()
  }
}

class Elfo inherits Guerrero{
  var property valorOrigen = 25
  const destrezaBase = 2
  const property destrezaPropia

  method poder() = self.vida() + (destrezaBase * self.destrezaPropia()) * self.poderArmas() 
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
  var property valorOrigen = 15
  const property limitadorDePoder

  method poder() = self.vida() + self.poderArmas() / self.limitadorDePoder()
}

object daga{
  method poderOtorgado(espada, guerrero) { return espada.poderOtorgado(guerrero) / 2  }
}

class Hacha{
  var property largoMango
  var property pesoHoja

  method poderOtorgado() { return largoMango * pesoHoja }
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
  var property multiplicador

  method poderOtorgado(guerrero){
    return multiplicador * guerrero.valorOrigen()
  }
}

object magiaElfica{
  method valorMagia(guerrero) = 25
}

object magiaEnana{
  method valorMagia(guerrero) = guerrero.vida()/2
}

class FlechaBronce{
  const dia
  const mes
  const anio
  const poderBase = 100

  method poderOtorgado(fechaLustrado){
    const tiempoDesdeLustrado = calendar.today() - fechaLustrado

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

object gandalf{
  var property vida = 100
  const property armas = []
  
  method tienePocaVida() = vida < 10

  method poder() {
    const multiplicadorVida = if (self.tienePocaVida()) 200 else 15
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
object lebennin{
  var property cantidadGuardias = 0
  method poderRequerido() = if (cantidadGuardias > 3) 1500 else 1000
  method puedePasar(viajero) = viajero.poder() > self.poderRequerido()
  method pasar(viajero) {}
}

object minasDeTirith{
  method puedePasar(viajero) = viajero.estaArmado()
  method pasar(viajero) {
    viajero.perderVida(10*viajero.cantidadDeArmas())
  }
}

object lossarnach{
  method puedePasar(viajero) = true
  method pasar(viajero){
    viajero.ganarVida(2*viajero.cantidadDeArmas())
  }
}

class Camino{
  const property zonas = []
  method puedePasar(viajero) = zonas.all({ z => z.puedePasar(viajero) })
  method pasar(viajero) {
    zonas.forEach({ z => z.pasar(viajero) })
  }
}

object tomBombadil{
  method poder() = 2000
  method cantidadDeArmas() = 100
  method estaArmado() = true
  method perderVida(cantidad) {}
  method ganarVida(cantidad) {}
}

const gondor = new Camino(zonas = [lebennin, minasDeTirith])
