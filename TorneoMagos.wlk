class Mago{
    const poderInnato // 1 al 10
    const artefactos = #{}
    const nombre
    var property categoria // aprendiz, veterano, inmortal
    var property resistenciaMagica
    var property reservaEnergia

    method poder() = self.poderArtefactos() * poderInnato // poder total de mago
    method poderArtefactos() = artefactos.map{artefacto => artefacto.poder(self)}.sum()
    method cantLetrasPar() = self.cantLetras() % 2 == 0
    method cantLetras() = nombre.size()

    method desafiarA(otroMago){
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

    method transferirEnergia(enemigo) { enemigo.perderEnergia() self.ganarEnergia(enemigo.energiaPerdida())}
}
// ---- Gremios -----

class Gremio{
    const miembros = #{}

    method poder() = self.poderMiembros().sum()
    method poderMiembros() = miembros.map{mago => mago.poder()}

    method reservaEnergia() = miembros.map({mago => mago.reservaEnergia()}).sum()
    method resistenciaMagica() = miembros.map{mago => mago.resistenciaMagica()}.sum()
    method miembrosOrdenadosPorPoder() = miembros.sortedBy({a,b => a.poder() > b.poder()})
    method liderGremio() = self.miembrosOrdenadosPorPoder().head()
    method resistenciaLider() = self.liderGremio().resistenciaMagica()
    method esVencido(poderEnemigo) = poderEnemigo > (self.resistenciaMagica() + self.resistenciaLider())

    method perderEnergia() { // no lo aclaran del todo bien pero asumo que cada mago del gremio pierde energia
        miembros.forEach({mago => mago.perderEnergia()})
    }

    method energiaPerdida() = miembros.map{mago => mago.energiaPerdida()}.sum()
    method venceA(enemigo) = enemigo.esVencido(self.poder())

    method desafiarA(enemigo){
        if(self.venceA(enemigo)){
            self.liderGremio().transferirEnergia(enemigo)
        }
    }

    override method initialize(){
        super()
        if(miembros.size() < 2){self.error("tiene q haber 2 miembros o mas")}
    }
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

const tunica1 = new Tunica (poderBase = 100)
const mago1 = new Mago (poderInnato = 8, artefactos = #{amuleto, ojota, tunica1}, nombre="jorge", categoria = aprendiz, resistenciaMagica = 50, reservaEnergia = 10)
const mago2 = new Mago (poderInnato = 9, artefactos = #{amuleto}, nombre="matias", categoria = veterano, resistenciaMagica = 30, reservaEnergia = 50)
const gremio1 = new Gremio(miembros = #{mago1, mago2})// creacion de gremio, falla si hay menos de 2 magos
const gremio2 = new Gremio(miembros = #{mago3, mago4})

const mago3 = new Mago (poderInnato = 9, artefactos = #{amuleto}, nombre="matias", categoria = veterano, resistenciaMagica = 300, reservaEnergia = 50)
const mago4 = new Mago (poderInnato = 9, artefactos = #{amuleto}, nombre="matias", categoria = veterano, resistenciaMagica = 300, reservaEnergia = 50)

const gremio3 = new Gremio(miembros = #{gremio2, mago2})

// si los miembros llegaran a estar compuestos por gremios y magos, habria que cambiar la logica ya que segun mi modelo, me devolveria
// que el lider de un gremio es el gremio, en lugar del lider de dicho gremio. Para arreglar esto se podria validar que el lider del gremio sea un mago
// y si no lo es buscar el lider de su gremio hasta que el resultado sea un mago.
