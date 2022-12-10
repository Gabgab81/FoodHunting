import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="defilement-card"
export default class extends Controller {
  static targets = ['cards']

  
  connect() {
    console.log('def card')
    console.log(this.cardsTargets[0])
    console.log(this.cardsTargets[0].offsetWidth)
    console.log(this.cardsTargets[0].clientWidth)
    console.log(this.cardsTargets[0].scrollWidth)
    // console.log(this.element)
    this.x = 0
    this.xmax = this.cardsTargets[0].scrollWidth - this.cardsTargets[0].clientWidth
  }

  next(){
    // console.log('next')
    (this.x + 150) > this.xmax ? this.x = this.xmax : this.x += 150
    // this.x += 50
    console.log('x:', this.x )
    this.cardsTargets[0].scrollTo({
      top: 0,
      left: this.x,
      behavior: 'smooth'
    });
  }

  previous(){
    // console.log('previous')
    (this.x - 150) < 0 ? this.x = 0 : this.x -= 150
    // this.x -= 50
    this.cardsTargets[0].scrollTo({
      top: 0,
      left: this.x,
      behavior: 'smooth'
    });
  }
}
