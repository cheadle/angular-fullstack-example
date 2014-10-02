'use strict'

describe 'Controller: UserCtrl', ->

  # load the controller's module
  beforeEach module 'demoApp'

  UserCtrl = undefined
  scope = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
    $httpBackend = _$httpBackend_
    $httpBackend.expectGET('/api/users')

    scope = $rootScope.$new()
    UserCtrl = $controller 'UserCtrl',
      $scope: scope

  # it 'should attach a list of users to the scope', ->
  #   $httpBackend.flush()
  #   expect(scope.users.length).toBe 4