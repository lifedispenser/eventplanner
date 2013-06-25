$.widget( "ui.sortable", $.ui.sortable, {
  _mouseDrag: function(event) {
    var i, item, itemElement, intersection,
    o = this.options,
    scrolled = false;
    this.position = this._generatePosition(event);
    this.positionAbs = this._convertPositionTo("absolute");

    if (!this.lastPositionAbs) {
      this.lastPositionAbs = this.positionAbs;
    }

    if(this.options.scroll) {
      if(this.scrollParent[0] !== document && this.scrollParent[0].tagName !== "HTML") {

        if((this.overflowOffset.top + this.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity) {
          this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
        } else if(event.pageY - this.overflowOffset.top < o.scrollSensitivity) {
          this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;
        }

        if((this.overflowOffset.left + this.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity) {
          this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
        } else if(event.pageX - this.overflowOffset.left < o.scrollSensitivity) {
          this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;
        }

      } else {

        if(event.pageY - $(document).scrollTop() < o.scrollSensitivity) {
          scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
        } else if($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity) {
          scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);
        }

        if(event.pageX - $(document).scrollLeft() < o.scrollSensitivity) {
          scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
        } else if($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity) {
          scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);
        }

      }

      if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour) {
        $.ui.ddmanager.prepareOffsets(this, event);
      }
    }

    this.positionAbs = this._convertPositionTo("absolute");

    if(!this.options.axis || this.options.axis !== "y") {
      this.helper[0].style.left = this.position.left+"px";
    }
    if(!this.options.axis || this.options.axis !== "x") {
      this.helper[0].style.top = this.position.top+"px";
    }

    for (i = this.items.length - 1; i >= 0; i--) {

      item = this.items[i];
      itemElement = item.item[0];
      intersection = this._intersectsWithPointer(item);
      if (!intersection) {
        continue;
      }

      if (item.instance !== this.currentContainer) {
        continue;
      }

      if (itemElement !== this.currentItem[0] &&
        this.placeholder[intersection === 1 ? "next" : "prev"]()[0] !== itemElement &&
        !$.contains(this.placeholder[0], itemElement) &&
        (this.options.type === "semi-dynamic" ? !$.contains(this.element[0], itemElement) : true)
        ) {

        this.direction = intersection === 1 ? "down" : "up";

        if (this.options.tolerance === "pointer" || this._intersectsWithSides(item)) {
          this._rearrange(event, item);
        } else {
          break;
        }

        this._trigger("change", event, this._uiHash());
        break;
      }
    }
    /* FAILED trying to make indent through dragging
    if(event.pageX > 60) {

      if(this.currentItem.prev().length > 0 ) { 
        $(event.target).parent().trigger("indent")
      }
    }
    if(event.pageX < 50) {
      $(event.target).parent().trigger("indent")
    } */

  this._contactContainers(event);

  if($.ui.ddmanager) {
    $.ui.ddmanager.drag(this, event);
  }

  this._trigger("sort", event, this._uiHash());

  this.lastPositionAbs = this.positionAbs;
  return false;

},

});