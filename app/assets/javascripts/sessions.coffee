# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace "/"

$(document).on 'turbolinks:load', ->
  $('form[data-remote]').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('p').remove()
  $('form[data-remote]').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    setTimeout redirect, 1000
  $('form[data-remote]').on 'ajax:error', ->
    $(this).children('fieldset').addClass 'form-group has-danger'
    $(this).find(':submit').before('<p class="text-danger">Email or password is incorrect</p>')
