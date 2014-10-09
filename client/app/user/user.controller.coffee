'use strict'

angular.module 'demoApp'
.controller 'UserCtrl', ($scope, User, Event) ->
  $scope.users = []
  $scope.chartOptions =
    animation: false
    bezierCurve: false
    pointDot: false
    scaleGridLineColor: 'rgba(0,0,0,0)'
    scaleLineColor: 'rgba(0,0,0,0)'
    scaleShowGridLines: false
    scaleShowLabels: false
    showTooltips: false

  # load users
  User.query().$promise.then (users) ->
    _.each users, (user) ->
      user.chart =
        labels: []
        datasets: [{data:[], fillColor:'rgba(0,0,0,0)', strokeColor:'rgba(0,0,0,1)'}]
    $scope.users = users


  # load events
  Event.query().$promise.then (events) ->
    # get dates. assume same date range for all users
    min = _.min events, (e) -> Date.parse e.time
    max = _.max events, (e) -> Date.parse e.time
    from = new Date min.time
    to   = new Date max.time
    $scope.from = (from.getUTCMonth()+1) + '/' + from.getUTCDate()
    $scope.to = (to.getUTCMonth()+1) + '/' + to.getUTCDate()

    # update users
    _.each $scope.users, (user) ->
      # get impressions
      user.impressions = _.where events, (e) ->
        e.user_id == user.id && e.type == 'impression'
      # get conversions
      user.conversions = _.where events, (e) ->
        e.user_id == user.id && e.type == 'conversion'
      # get revenues
      revenues = _.pluck user.conversions, 'revenue'
      user.revenue = _.reduce revenues, (a,b) -> a + b
      # get chart data
      conversionsPerDay = _.groupBy user.conversions, (conversion) ->
        conversion.time.slice 0,10
      # build user chart
      _.each conversionsPerDay, (conversion) ->
        user.chart.datasets[0].data.push conversion.length
        user.chart.labels.push ''


