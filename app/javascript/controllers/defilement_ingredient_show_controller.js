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
    this.element.querySelector('.btn-top').style.display = 'none'
   
    if (this.totalHeightCards + 70 < this.height) {
      this.element.querySelector('.btn-top').remove()
      this.element.querySelector('.btn-bottom').remove()
      this.element.querySelector('.list-ingredients').style.height = `${this.height}px`
    } else {
      this.element.querySelector('.list-ingredients').style.height = `${this.height - 90}px`
    }
  }

  up(){

    if ((this.position > this.firstCardHeight * 2) && (this.totalHeightCards > this.listIngredient + this.lastCardHeight)) {
      this.position -= 200
      this.element.querySelector('.btn-bottom').style.display = 'block'
    } else {
      this.position = 0
      this.element.querySelector('.btn-top').style.display = 'none'
      this.element.querySelector('.btn-bottom').style.display = 'block'
      
    }
    this.cardsTargets[0].scrollTo({
      top: this.position,
      left: 0,
      behavior: 'smooth'
    });
  }

  down(){

    this.allCardNode = this.element.querySelectorAll('.list-ingredients > .card-ingredient');
    this.firstCardHeight = this.allCardNode[0].offsetHeight;
    this.lastCardHeight = this.allCardNode[this.allCardNode.length - 1].offsetHeight;
   
    this.totalHeightCards = 0
    this.allCardNode.forEach((node) => this.totalHeightCards += node.offsetHeight)

    this.listIngredient = this.element.querySelector('.list-ingredients').offsetHeight

    if ((this.position < this.totalHeightCards - this.lastCardHeight * 4) && (this.totalHeightCards > this.listIngredient + this.lastCardHeight)) {
      this.position += 200
      this.element.querySelector('.btn-top').style.display = 'block'
      this.cardsTargets[0].scrollTo({
        top: this.position,
        left: 0,
        behavior: 'smooth'
      });
    } else {
      this.cardsTargets[0].scrollTo({
        top: this.totalHeightCards,
        left: 0,
        behavior: 'smooth'
      });
      this.position = this.totalHeightCards - this.listIngredient
      this.element.querySelector('.btn-bottom').style.display = 'none'
      this.element.querySelector('.btn-top').style.display = 'block'
    }
  }
}
