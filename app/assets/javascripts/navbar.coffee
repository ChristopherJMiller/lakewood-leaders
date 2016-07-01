redirect = () ->
  window.location.replace window.location.href

$(document).ready ->
  $('#navbar_logout').parent().on 'ajax:success', ->
    setTimeout redirect, 250
  $('#navbar_logout').parent().on 'ajax:error', ->
    alert 'An error has occured, are you connected to the internet?'

  $('#navbar_login').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('p').remove()
  $('#navbar_login').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    setTimeout redirect, 1000
  $('#navbar_login').on 'ajax:error', ->
    console.log(xhr.responseJSON.error)
    $(this).children('fieldset').addClass 'form-group has-danger'
    $(this).find(':submit').before('<p class="text-danger">Email or password is incorrect</p>')
