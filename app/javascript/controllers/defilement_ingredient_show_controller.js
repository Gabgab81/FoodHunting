import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="defilement-ingredient-show"
export default class extends Controller {
  static targets = ["cards"]
  static values = {
    ningredients: Number
  }
  connect() {
    this.height = this.element.querySelector('.info-meal').offsetHeight
    this.position = 0
    this.allCardNode = this.element.querySelectorAll('.list-ingredients > .card-ingredient');
    this.totalHeightCards = 0
    this.allCardNode.forEach((node) => this.totalHeightCards += node.offsetHeight)

    if (this.totalHeightCards + 70 < this.height) {
      this.element.querySelector('.btn-top').remove()
      this.element.querySelector('.btn-bottom').remove()
      this.element.querySelector('.list-ingredients').style.height = `${this.height}px`
    } else {
      this.element.querySelector('.list-ingredients').style.height = `${this.height - 200}px`
    }
  }

  up(){
    this.position > 200 ? this.position -= 200 : this.position = 0
    console.log('position:', this.position )
    this.cardsTargets[0].scrollTo({
      top: this.position,
      left: 0,
      behavior: 'smooth'
    });
  }

  down(){
    this.position < this.height - 200 ? this.position += 200 : this.position = this.height
    console.log('position:', this.position )
    this.cardsTargets[0].scrollTo({
      top: this.position,
      left: 0,
      behavior: 'smooth'
    });
  }
}
