object pepita{
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

class Guerrero{
  
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
  var property magiaEspada

  method poderOtorgado(guerrero){
    if (self.magiaEspada() == "elfica")
    {
      return 10*25
    }
    else{
      return 10*guerrero.vida() / 2
    }
  }
}

class FlechaBronce{
  const dia
  const mes
  const anio
  const property fechaLustrado = new Date(day = dia, month = mes, year = anio)

  const poderBase = 100

  method poderOtorgado(){
    const tiempoDesdeLustrado = calendar.today() - self.fechaLustrado()

    return 0.max(poderBase - tiempoDesdeLustrado)
  }
}