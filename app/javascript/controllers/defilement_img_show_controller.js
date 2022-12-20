import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="defilement-img-show"
export default class extends Controller {
  static targets = ["img", "btnLeft", "btnRight"]
  static values = {
    nphotos: Number
  }
  connect() {
    console.log('hello from img show')
    console.log("nphotos: ", this.nphotosValue)
    // console.log("img: ", this.imgTargets)
    // console.log("btn-left: ", this.btnLeftTargets[0])
    // console.log("btn with queryuselector: ", document.querySelector('#button'))
    // this.btnLeftTargets[0].disabled = true
    if(this.nphotosValue > 2){
      this.index = 1
      // this.btnLeftTargets[0].disabled = true
      this.switchMoreImg()
      this.showCurrentImg()
      // console.log("Im here!!!!!")
    } else {
      this.index = 0
      this.switchMainImg()
    }
    // console.log('nphotos: ', this.nphotosValue)
  }

  // ------- Just 2 pictures ---------

  switch(){
    if (this.index == 0){
      this.index = 1
    } else {
      this.index = 0
    }
    this.switchMainImg()
    console.log("switched!!!")
    console.log("imgTargets", this.imgTargets[this.index])
  }

  switchMainImg(){
    this.imgTargets.forEach((element, index) =>{
      if (index == this.index){
        element.classList.add("btn-img-big")
        element.classList.remove("btn-img-small")
      } else {
        element.classList.add("btn-img-small")
        element.classList.remove("btn-img-big")
      }
    })
  }


  // ------- More than 2 pictures -------------

  next(){
    if (this.index < this.nphotosValue - 2)
    {
      console.log("next if")
      this.index++
      this.btnRightTargets[0].disabled = false
      this.btnLeftTargets[0].disabled = false
    } else {
      console.log("next else")
      this.index++
      this.btnRightTargets[0].disabled = true
      // this.btnRightTargets[0].hidden = true
    }
    this.showCurrentImg()
    this.switchMoreImg()
    // console.log(this.index)
  }

  previous(){
    if (this.index > 1)
    {
      console.log("previeous if")
      this.index--
      this.btnLeftTargets[0].disabled = false
      this.btnRightTargets[0].disabled = false
      // this.btnLeftTargets[0].hidden = false
    }
    else {
      this.index--
      this.btnLeftTargets[0].disabled = true
      console.log("previeous else")
      // this.btnLeftTargets[0].hidden = true
    }
    this.showCurrentImg()
    this.switchMoreImg()
    // console.log(this.index)
  }

  showCurrentImg() {
    console.log("index: ", this.index)
    // console.log("index -1: ", this.index - 1)
    // console.log("index + 1: ", this.index + 1)
    // this.imgTargets.forEach((element, index) => {
    //   if ( (index < this.index - 1) || (index > this.index + 1) ) {
    //     element.hidden 
    //   }
    // })

    this.imgTargets.forEach((element, index) => {
      element.hidden = ( (index < this.index - 1) || (index > this.index + 1) )
    })
    
    // this.imgTargets.forEach((element, index) => {
    //   if (index !== this.index) { 
    //     element.hidden = true
    //   } else {
    //     element.hidden = false
    //   }
    // })
    // this.imgTargets.forEach((element, index) => {
    //   element.hidden = index !== this.index
    // })
  }

  switchMoreImg(){
    this.imgTargets.forEach((element, index) =>{
      if (index == this.index){
        element.classList.add("btn-img-big")
        element.classList.remove("btn-img-small")
      } else {
        element.classList.add("btn-img-small")
        element.classList.remove("btn-img-big")
      } 
    })
  }
}
