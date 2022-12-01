import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="defilement-img"
export default class extends Controller {
  static targets = ["img", "dot"]
  static values = {
    nphotos: Number
  }
  connect() {
    this.index = 0
    this.showCurrentImg()
    this.showCurrentDot()
    if (this.nphotos > 5) { this.nphotos = 5 }
  }

  next(){
    if (this.index < this.nphotosValue - 1)
    {
      this.index++
    }
    else {
      this.index = 0
    }
    this.showCurrentImg()
    this.showCurrentDot()
  }
  previous(){
    if (this.index > 0)
    {
      this.index--
    }
    else {
      this.index = this.nphotosValue - 1
    }
    this.showCurrentImg()
    this.showCurrentDot()
  }
  showCurrentImg() {
    this.imgTargets.forEach((element, index) => {
      element.hidden = index !== this.index
    })
  }
  showCurrentDot() {
    this.dotTargets.forEach((element, index) => {
      index == this.index? element.classList.add("red") : element.classList.remove("red")
    })
  }
}
