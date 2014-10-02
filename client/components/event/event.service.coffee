'use strict'

angular.module 'demoApp'
.factory 'Event', ($resource) ->
  $resource 'api/events'