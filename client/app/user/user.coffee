'use strict'

angular.module 'demoApp'
.config ($stateProvider) ->
  $stateProvider.state 'user',
    url: '/'
    templateUrl: 'app/user/user.html'
    controller: 'UserCtrl'
