import wollok.game.*
    
object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		reloj.iniciar()
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo+=0.1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
		game.removeTickEvent("gravedad")
	}
}

object cactus {
	 
	var position = self.posicionInicial()
	var velocidad = 250

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
		game.onTick(1,"condicionSiChoca", {
			if (self.chocar()){
			self.detener()
			}
		})
	}
	
	method mover(){
		position = position.left(1)
	}
	
	method chocar(){
		return position == dino.position()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
		reloj.detener()
	}
}

object suelo{
	
	var property position = game.origin().up(1)
	
	method image() = "suelo.png"
	
	method chocar(){}
}


object dino {
	var vivo = true
	var property position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	
	method saltar(){
		position = position.up(1.3)
	}
	
//	method subir(){
//		position = position.up(1)
//	}
	
	method bajar(){
		if (self.position().y() <= suelo.position().y())
		{
			position = suelo.position()
		}else{
			position = position.down(0.1)
		}
		
		
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
	
	
}


object configDino{
	
	method teclas()
	{
		keyboard.space().onPressDo{dino.saltar()}
	}
	
	method gravedad(){
		game.onTick(1, "gravedad", {=> dino.bajar()})
	}
}