var burninApp;

(function() {
  "use strict";

  burninApp = {
    init: function() {
      var self = this ;

      self.modalOpened    = false;
      self.modalElement   = $(".modal");
      self.modalBGElement = $(".bg-modal");
      self.closeModalBtn  = $(".close-modal");
      self.newFormMessage = $("form#new_message");
      self.messagesList   = $(".messages-list");
      
      self.closeModalBtn.on("click", function(ev) { 
        ev.preventDefault();
        self.toggleModal();
      });

      $(document).on('keydown' , function(ev) {

        var specialKeys     = [ev.altKey, ev.ctrlKey , ev.shiftKey, ev.metaKey]   ,
            canToggleModal  =  $.grep(specialKeys, function(v) { return v == true}).length == 0
        if((!self.modalOpened && canToggleModal) || (ev.keyCode == 27 && self.modalOpened)) {
          self.toggleModal();
        }
      })

      self.waitForNewMessage();
    },

    toggleModal: function(callback) {
      var self = this;

      self.modalBGElement.fadeToggle("fast" , function(){
        self.modalElement.fadeToggle('fast' , function() {
          self.modalOpened = !self.modalOpened;
          if(callback != undefined && typeof callback == 'function') callback.call(self)
        });
      })
    },

    waitForNewMessage: function() {
      var self = this;
      self.newFormMessage.on("submit" , function(ev) {
        ev.preventDefault();
        var _f = this , 
             form = $(_f) , 
             action = form.attr('action') , 
             data = $.param(form.serializeArray().concat({'name':'html', 'value': true}))

        $.post(action , data , function(data) {
          
          alert((data && data.success ? 'Mensagem adicionada com sucesso.' : 'Algum erro aconteceu =/'));

          if(data && data.success)  {
            _f.reset();
            console.log(data);
            self.appendHTML("<li>" + data.html + "</li>");
          }
        }, 'json')
      })
    },

    appendHTML: function(html) {
      var element = $(html);
      var element = this.messagesList.append(element);
      
      this.toggleModal(function() {
        $('html, body').animate({
            // this is the current object in toggle modal callback
            scrollTop: $("li:last-child" , this.messagesList).offset().top
        }, 1000);
      });
    }
  }

  burninApp.init();

})();