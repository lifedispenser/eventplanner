(function($){
  var PROP_NAME = "datepicker";
  var datepickerExtensions = {
    /* Attach the date picker to an input field. */
    _connectDatepicker: function(target, inst) {
      var input = $(target);
      inst.append = $([]);
      inst.trigger = $([]);
      if (input.hasClass(this.markerClassName)) {
        return;
      }
      this._attachments(input, inst);
      input.addClass(this.markerClassName);
      this._autoSize(inst);
      $.data(target, PROP_NAME, inst);
    //If disabled option is true, disable the datepicker once it has been attached to the input (see ticket #5665)
    if( inst.settings.disabled ) {
      this._disableDatepicker( target );
    }
  },
  _checkExternalClick: function(event) {
    if (!$.datepicker._curInst) {
      return;
    }
    var $target = $(event.target),
    inst = $.datepicker._getInst($target[0]);

    if ( ( ( $target[0].id !== $.datepicker._mainDivId &&
      $target.parents("#" + $.datepicker._mainDivId).length === 0 &&
      !$target.hasClass($.datepicker.markerClassName) &&
      !$target.closest("." + $.datepicker._triggerClass).length &&
      $.datepicker._datepickerShowing && !($.datepicker._inDialog && $.blockUI) ) ) ||
      ( $target.hasClass($.datepicker.markerClassName) && $.datepicker._curInst !== inst ) ) {
      $($.datepicker._curInst.input).trigger("datepickerclose");
  }
}

}
$.extend($.datepicker, datepickerExtensions);
})(jQuery);