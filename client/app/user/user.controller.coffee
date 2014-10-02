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
    # load events
    Event.query().$promise.then (events) ->
      # modify users and add to $rootScope
      _.each users, (user) ->
        # get impressions
        user.impressions = _.where events, (e) ->
          e.user_id == user.id && e.type == 'impression'
        # get conversions
        user.conversions = _.where events, (e) ->
          e.user_id == user.id && e.type == 'conversion'
        # get revenues
        revenues = _.pluck user.conversions, 'revenue'
        user.revenue = _.reduce revenues, (a,b) -> a + b
        # set chart
        user.chart =
          labels: []
          datasets: [{data:[], fillColor:'rgba(0,0,0,0)', strokeColor:'rgba(0,0,0,1)'}]
        # get chart data
        conversionsPerDay = _.groupBy user.conversions, (conversion) ->
          conversion.time.slice 0,10
        # build user chart
        _.each conversionsPerDay, (conversion) ->
          user.chart.datasets[0].data.push conversion.length
          user.chart.labels.push ''
        # get dates
        dates = _.map(_.sortBy(user.conversions, 'time'), 'time')
        start = new Date dates[0].slice(0,10)
        end   = new Date dates[dates.length-1].slice(0,10)
        user.from = (start.getUTCMonth()+1) + '/' + start.getUTCDate()
        user.to = (end.getUTCMonth()+1) + '/' + end.getUTCDate()
        # user ready
        $scope.users.push user
      # users loaded
      $scope.loaded = true


