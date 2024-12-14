class Mago{
    const poderInnato // 1 al 10
    const artefactos = #{}
    const nombre
    var categoria // aprendiz, veterano, inmortal
    var property resistenciaMagica
    var property reservaEnergia

    method poder() = self.poderArtefactos() * poderInnato
    method poderArtefactos() = artefactos.map{artefacto => artefacto.poder(self)}.sum()
    method cantLetrasPar() = self.cantLetras() % 2 == 0
    method cantLetras() = nombre.size()

    method desafiarA(otroMago,valor){
        if(self.venceA(otroMago)){
            self.transferirEnergia(otroMago)
        }
    }

    method venceA(otroMago) = otroMago.esVencido(self.poder()) 

    method categoria(nuevaCategoria) { categoria = nuevaCategoria}
    method esVencido(poderEnemigo) = categoria.esVencido(poderEnemigo, resistenciaMagica)
    method energiaPerdida() = categoria.energiaAPerder()
    method perderEnergia() { self.perderEnergia(self.energiaPerdida()) }
    method perderEnergia(valor) { reservaEnergia -= valor }
    method ganarEnergia(valor) { reservaEnergia += valor }

    method transferirEnergia(otroMago) { otroMago.perderEnergia() self.ganarEnergia(otroMago.energiaPerdida())}
}
// ---- Gremios -----

object gremio{
    const miembros = #{}

    method poder() = self.poderMiembros().sum()
    method poderMiembros() = miembros.map{mago => mago.poder()}

    method reservaEnergia() = miembros.map({mago => mago.reservaEnergia()}).sum()
    method miembrosOrdenadosPorPoder() = miembros.sortedBy({a,b => a.poder() > b.poder()})
    method liderGremio() = self.miembrosOrdenadosPorPoder().head()
}

// ----- Categorias ---------

object aprendiz{
    method esVencido(poder, resistencia) = resistencia < poder
    method resistenciaAPerder(resistencia) = resistencia/2
}

object veterano{
    method esVencido(poder, resistencia) = resistencia * 1.5 <= poder
    method resistenciaAPerder(resistencia) = resistencia/4
}

object inmortal{
    method esVencido(poder, resistencia) = false
    method resistenciaAPerder(resistencia) = 0
}

// ----- Objetos Magicos ---------

class Artefacto{
    const poderBase

    method poder(mago) = poderBase
}

class Varita inherits Artefacto{
    override method poder(mago) = if(mago.cantLetrasPar()){ super(mago) + super(mago) *1.5}else{ super(mago) }
}

class Tunica inherits Artefacto{
    override method poder(mago) = super(mago) + mago.resistenciaMagica() * 2
}

class TunicaEpica inherits Tunica(){
    override method poder(mago) = super(mago) + 10
}

object amuleto inherits Artefacto(poderBase = 0){
    override method poder(mago) = 200
}

object ojota inherits Artefacto(poderBase = 0){
    override method poder(mago) = 10 * mago.cantLetras()
}

