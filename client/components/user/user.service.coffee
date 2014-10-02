'use strict'

angular.module 'demoApp'
.factory 'User', ($resource) ->
  $resource 'api/users'