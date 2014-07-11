#= require jquery
#= require jquery_ujs
#= require_tree ./contracting/vendor
#= require ember
#= require ember-data
#= require_self
#= require contracting/store
#= require contracting/router
#= require_tree ./contracting/routes
#= require_tree ./contracting/models
#= require_tree ./contracting/controllers
#= require_tree ./contracting/views
#= require_tree ./contracting/helpers
#= require_tree ./contracting/components
#= require_tree ./contracting/templates

window.Contracting = Ember.Application.create()